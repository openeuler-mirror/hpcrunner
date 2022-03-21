#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define COLS 1000
#define ROWS 1000
#define FLOAT_T float

FLOAT_T *getFinput(int scale)
{
  FLOAT_T *input;
  if ((input = (FLOAT_T *)malloc(sizeof(FLOAT_T) * scale)) == NULL)
  {
    fprintf(stderr, "Out of Memory!!\n");
    exit(1);
  }
  for (int i = 0; i < scale; i++)
  {
    input[i] = ((FLOAT_T)rand() / (FLOAT_T)RAND_MAX) - 0.5;
  }
  return input;
}

FLOAT_T **get2Darr(int M, int N)
{
  FLOAT_T **input;
  input = (FLOAT_T **)malloc(M * sizeof(FLOAT_T *));
  for (int i = 0; i < M; i++)
  {
    input[i] = (FLOAT_T *)malloc(N * sizeof(FLOAT_T));
  }
  return input;
}

void gramSchmidt_gpu(FLOAT_T **Q)
{
    int cols = COLS;
    #pragma omp target data map(Q[0:ROWS][0:cols])
    for(int k=0; k < cols; k++)
    {
        double tmp = 0.0;
        #pragma omp target map(tofrom: tmp)
        #pragma omp parallel for reduction(+:tmp)
        for(int i=0; i < ROWS; i++)
            tmp += (Q[i][k] * Q[i][k]);
        tmp = 1/sqrt(tmp);
        #pragma omp target
        #pragma omp parallel for
        for(int i=0; i < ROWS; i++)
            Q[i][k] *= tmp;
    }
}

int main()
{
    FLOAT_T **Q = get2Darr(ROWS, COLS);
    gramSchmidt_gpu(Q);
    return 1;
}
