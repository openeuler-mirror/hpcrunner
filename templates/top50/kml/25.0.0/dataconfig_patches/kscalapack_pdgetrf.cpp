#include "mpi.h"
#include <algorithm>
#include <cassert>
#include <fstream>
#include <iostream>
#include <omp.h>
#include <sstream>
#include <stdio.h>
#include <string.h>
#include <string>

extern "C" void blacs_get_(int *, int *, int *);
extern "C" void blacs_gridinit_(int *, char *, int *, int *);
extern "C" void blacs_gridinfo_(int *, int *, int *, int *, int *);
extern "C" void descinit_(int *, int *, int *, int *, int *, int *, int *, int *, int *, int *);
extern "C" void blacs_gridexit_(int *);
extern "C" int numroc_(int *, int *, int *, int *, int *);
extern "C" void pdgetrf_(const int *, const int *, double *, const int *, const int *, int *, int *, int *);
using namespace std;
// 计算GFLOPS
double compute_gflops(double time, int n)
{
    // 对于LU分解，大约需要(2/3)*n^3次浮点运算
    double ops = (2.0 / 3.0) * n * n * n;
    return (ops / time) / 1e9; // 转换为GFLOPS
}

void parse_args(int argc, char *argv[], int &n, int &nb, int &nprow, int &npcol)
{
    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];

        if (arg == "-nb" && i + 1 < argc) {
            std::istringstream buffer(argv[++i]);
            buffer >> nb;
        } else if (arg == "-grid" && i + 1 < argc) {
            std::string gridStr = argv[++i];
            size_t xPos = gridStr.find('x');
            if (xPos != std::string::npos) {
                nprow = std::stoi(gridStr.substr(0, xPos));
                npcol = std::stoi(gridStr.substr(xPos + 1));
            } else {
                std::cerr << "Invalid grid format: " << gridStr << "\n";
                exit(-1);
            }
        } else if (arg == "-size" && i + 1 < argc) {
            std::istringstream buffer(argv[++i]);
            buffer >> n;
        }
    }
}

int main(int argc, char *argv[])
{
    // 初始化MPI环境
    MPI_Init(&argc, &argv);

    // 默认参数
    int n = 1000;  // 矩阵规模
    int nb = 64;   // 分块大小
    int nprow = 4; // 线程网格行数
    int npcol = 4; // 线程网格列数
    
    // 解析命令行参数
    parse_args(argc, argv, n, nb, nprow, npcol);
    
    int myrank_mpi, nprocs_mpi;
    MPI_Comm_rank(MPI_COMM_WORLD, &myrank_mpi);
    MPI_Comm_size(MPI_COMM_WORLD, &nprocs_mpi);

    // 验证进程数量是否匹配
    if (nprow * npcol != nprocs_mpi) {
        if (myrank_mpi == 0) {
            std::cerr << "Error: The product of nprow and npcol must equal the number of processes.\n";
        }
        MPI_Finalize();
        return -1;
    }

    // 初始化BLACS
    int ictxt, myrow, mycol;
    int izero = 0, ione = 1;
    char R = 'R';
    blacs_get_(&izero, &izero, &ictxt);
    blacs_gridinit_(&ictxt, &R, &nprow, &npcol);
    blacs_gridinfo_(&ictxt, &nprow, &npcol, &myrow, &mycol);

    // 计算局部矩阵尺寸
    int mpA = numroc_(&n, &nb, &myrow, &izero, &nprow);
    int nqA = numroc_(&n, &nb, &mycol, &izero, &npcol);

    // 分配内存
    double *A;
    A = (double *)calloc(mpA * nqA, sizeof(double));
    if (A == NULL) {
        printf("Error of memory allocation A on proc %dx%d\n", myrow, mycol);
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    // 初始化矩阵
    int k = 0;
    for (int j = 0; j < nqA; j++) {                   // local col
        int l_j = j / nb;                             // which block
        int x_j = j % nb;                             // where within that block
        int J = (l_j * npcol + mycol) * nb + x_j;     // global col
        for (int i = 0; i < mpA; i++) {               // local row
            int l_i = i / nb;                         // which block
            int x_i = i % nb;                         // where within that block
            int I = (l_i * nprow + myrow) * nb + x_i; // global row
            assert(I < n);
            assert(J < n);
            if (I == J) {
                A[k] = (double)j / nqA + (double)i / mpA + n;
            } else {
                A[k] = (double)j / nqA + i + j + 1;
            }
            k++;
        }
    }

    // 创建描述符
    int descA[9];
    int info = 0;
    int* ipiv = (int *)calloc(mpA + nb, sizeof(int));
    int lddA = (mpA > 0) ? mpA : 1;
    descinit_(descA, &n, &n, &nb, &nb, &izero, &izero, &ictxt, &lddA, &info);
    if (info != 0) {
        printf("Error in descinit, info = %d\n", info);
        MPI_Abort(MPI_COMM_WORLD, info);
    }

    // 开始计时
    double start_time = MPI_Wtime();

    // 执行pdgetrf_
    pdgetrf_(&n, &n, A, &ione, &ione, descA, ipiv, &info);

    // 结束计时
    double end_time = MPI_Wtime();
    double elapsed_time = end_time - start_time;

    // 计算GFLOPS
    double gflops = compute_gflops(elapsed_time, n);
    // 收集所有进程的时间
    double total_elapsed_time;
    MPI_Reduce(&elapsed_time, &total_elapsed_time, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);

    if (myrank_mpi == 0) {
        double total_gflops = compute_gflops(total_elapsed_time, n);
        printf("Matrix size: %dx%d, Process grid: %dx%d\n", n, n, nprow, npcol);
        printf("Time taken: %lf seconds\n", total_elapsed_time);
        printf("Total Performance: %lf GFLOPS\n", total_gflops);
    }

    free(A);
    blacs_gridexit_(&ictxt);
    MPI_Finalize();
    return 0;
}

