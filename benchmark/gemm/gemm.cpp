#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <iostream>
#include "mpi.h"
#ifdef USE_KML
  #include "kblas.h"
#else
  #include <cblas.h>
#endif
using namespace std;

void randMat(int rows, int cols, float *&Mat) {
  Mat = new float[rows * cols];
  for (int i = 0; i < rows; i++)
    for (int j = 0; j < cols; j++)
      Mat[i * cols + j] = 1.0;
}

void openmp_sgemm(int m, int n, int k, float *&leftMat, float *&rightMat,
                  float *&resultMat) {
  // rightMat is transposed
#pragma omp parallel for
  for (int row = 0; row < m; row++) {
    for (int col = 0; col < k; col++) {
      resultMat[row * k + col] = 0.0;
      for (int i = 0; i < n; i++) {
        resultMat[row * k + col] +=
            leftMat[row * n + i] * rightMat[col * n + i];
      }
    }
  }
  return;
}

void blas_sgemm(int m, int n, int k, float *&leftMat, float *&rightMat,
                float *&resultMat) {
  cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasTrans, m, k, n, 1.0, leftMat,
    n, rightMat, n, 0.0, resultMat, k);
}

void mpi_sgemm(int m, int n, int k, float *&leftMat, float *&rightMat,
               float *&resultMat, int rank, int worldsize, bool blas) {
  int rowBlock = sqrt(worldsize);
  if (rowBlock * rowBlock > worldsize)
    rowBlock -= 1;
  int colBlock = rowBlock;

  int rowStride = m / rowBlock;
  int colStride = k / colBlock;

  worldsize = rowBlock * colBlock; // we abandom some processes.
  // so best set process to a square number.

  float *res;

  if (rank == 0) {
    float *buf = new float[k * n];
    // transpose right Mat
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < k; c++) {
        buf[c * n + r] = rightMat[r * k + c];
      }
    }

    for (int r = 0; r < k; r++) {
      for (int c = 0; c < n; c++) {
        rightMat[r * n + c] = buf[r * n + c];
      }
    }

    MPI_Request sendRequest[2 * worldsize];
    MPI_Status status[2 * worldsize];
    for (int rowB = 0; rowB < rowBlock; rowB++) {
      for (int colB = 0; colB < colBlock; colB++) {
        rowStride = (rowB == rowBlock - 1) ? m - (rowBlock - 1) * (m / rowBlock)
                                           : m / rowBlock;
        colStride = (colB == colBlock - 1) ? k - (colBlock - 1) * (k / colBlock)
                                           : k / colBlock;
        int sendto = rowB * colBlock + colB;
        if (sendto == 0)
          continue;
        MPI_Isend(&leftMat[rowB * (m / rowBlock) * n], rowStride * n, MPI_FLOAT,
                  sendto, 0, MPI_COMM_WORLD, &sendRequest[sendto]);
        MPI_Isend(&rightMat[colB * (k / colBlock) * n], colStride * n,
                  MPI_FLOAT, sendto, 1, MPI_COMM_WORLD,
                  &sendRequest[sendto + worldsize]);
      }
    }
    for (int rowB = 0; rowB < rowBlock; rowB++) {
      for (int colB = 0; colB < colBlock; colB++) {
        int recvfrom = rowB * colBlock + colB;
        if (recvfrom == 0)
          continue;
        MPI_Wait(&sendRequest[recvfrom], &status[recvfrom]);
        MPI_Wait(&sendRequest[recvfrom + worldsize],
                 &status[recvfrom + worldsize]);
      }
    }
    res = new float[(m / rowBlock) * (k / colBlock)];
  } else {
    if (rank < worldsize) {
      MPI_Status status[2];
      rowStride = ((rank / colBlock) == rowBlock - 1)
                      ? m - (rowBlock - 1) * (m / rowBlock)
                      : m / rowBlock;
      colStride = ((rank % colBlock) == colBlock - 1)
                      ? k - (colBlock - 1) * (k / colBlock)
                      : k / colBlock;
      if (rank != 0) {
        leftMat = new float[rowStride * n];
        rightMat = new float[colStride * n];
      }
      if (rank != 0) {
        MPI_Recv(leftMat, rowStride * n, MPI_FLOAT, 0, 0, MPI_COMM_WORLD,
                 &status[0]);
        MPI_Recv(rightMat, colStride * n, MPI_FLOAT, 0, 1, MPI_COMM_WORLD,
                 &status[1]);
      }
      res = new float[rowStride * colStride];
    }
  }
  MPI_Barrier(MPI_COMM_WORLD);

  if (rank < worldsize) {
    rowStride = ((rank / colBlock) == rowBlock - 1)
                    ? m - (rowBlock - 1) * (m / rowBlock)
                    : m / rowBlock;
    colStride = ((rank % colBlock) == colBlock - 1)
                    ? k - (colBlock - 1) * (k / colBlock)
                    : k / colBlock;
    if (!blas)
      openmp_sgemm(rowStride, n, colStride, leftMat, rightMat, res);
    else
      blas_sgemm(rowStride, n, colStride, leftMat, rightMat, res);
  }
  MPI_Barrier(MPI_COMM_WORLD);

  if (rank == 0) {
    MPI_Status status;
    float *buf = new float[(m - (rowBlock - 1) * (m / rowBlock)) *
                           (k - (colBlock - 1) * (k / colBlock))];
    float *temp_res;
    for (int rowB = 0; rowB < rowBlock; rowB++) {
      for (int colB = 0; colB < colBlock; colB++) {
        rowStride = (rowB == rowBlock - 1) ? m - (rowBlock - 1) * (m / rowBlock)
                                           : m / rowBlock;
        colStride = (colB == colBlock - 1) ? k - (colBlock - 1) * (k / colBlock)
                                           : k / colBlock;
        int recvfrom = rowB * colBlock + colB;
        if (recvfrom != 0) {
          temp_res = buf;
          MPI_Recv(temp_res, rowStride * colStride, MPI_FLOAT, recvfrom, 0,
                   MPI_COMM_WORLD, &status);
        } else {
          temp_res = res;
        }
        for (int r = 0; r < rowStride; r++)
          for (int c = 0; c < colStride; c++)
            resultMat[rowB * (m / rowBlock) * k + colB * (k / colBlock) +
                      r * k + c] = temp_res[r * colStride + c];
      }
    }
  } else {
    rowStride = ((rank / colBlock) == rowBlock - 1)
                    ? m - (rowBlock - 1) * (m / rowBlock)
                    : m / rowBlock;
    colStride = ((rank % colBlock) == colBlock - 1)
                    ? k - (colBlock - 1) * (k / colBlock)
                    : k / colBlock;
    if (rank < worldsize)
      MPI_Send(res, rowStride * colStride, MPI_FLOAT, 0, 0, MPI_COMM_WORLD);
  }
  MPI_Barrier(MPI_COMM_WORLD);

  return;
}

int main(int argc, char *argv[]) {
  if (argc != 5) {
    cout << "Usage: " << argv[0] << " M N K use-blas\n";
    exit(-1);
  }

  int rank;
  int worldSize;
  MPI_Init(&argc, &argv);

  MPI_Comm_size(MPI_COMM_WORLD, &worldSize);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  int m = atoi(argv[1]);
  int n = atoi(argv[2]);
  int k = atoi(argv[3]);
  int blas = atoi(argv[4]);

  float *leftMat, *rightMat, *resMat;

  struct timeval start, stop;
  if (rank == 0) {
    randMat(m, n, leftMat);
    randMat(n, k, rightMat);
    randMat(m, k, resMat);
  }
  gettimeofday(&start, NULL);
  mpi_sgemm(m, n, k, leftMat, rightMat, resMat, rank, worldSize, blas);
  gettimeofday(&stop, NULL);
  if (rank == 0) {
    cout << "mpi matmul: "
         << (stop.tv_sec - start.tv_sec) * 1000.0 +
                (stop.tv_usec - start.tv_usec) / 1000.0
         << " ms" << endl;

    for (int i = 0; i < m; i++) {
      for (int j = 0; j < k; j++)
        if (int(resMat[i * k + j]) != n) {
          cout << resMat[i * k + j] << "error\n";
          exit(-1);
        }
    }
  }
  MPI_Finalize();
}
