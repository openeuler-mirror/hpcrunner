#include <stdio.h>
#include "mpi.h"

int main(int argc, char *argv[])
{
    int rank, value, size;
    MPI_Status status;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank); /*当前进程在MPI_COMM_WORLD这个通信组下面 编号是多少*/
    MPI_Comm_size(MPI_COMM_WORLD, &size); /*MPI_COMM_WORLD这个通信组下面 有多少个进程*/
    do {
        if (rank==0) {
            fprintf(stderr, "\nPlease give new value=");
            scanf("%d",&value);
            fprintf(stderr, "%d read <-<- (%d)\n",rank,value);
            /*必须至少有两个进程的时候 才能进行数据传递*/
            if (size>1) {
                MPI_Send(&value, 1, MPI_INT, rank+1, 0, MPI_COMM_WORLD);
                fprintf(stderr, "%d send (%d)->-> %d\n", rank,value,rank+1);
            }
        }
        else {
            MPI_Recv(&value, 1, MPI_INT, rank-1, 0, MPI_COMM_WORLD, &status);
            fprintf(stderr, "%d receive(%d)<-<- %d\n",rank, value, rank-1);
            if (rank<size-1) {
                MPI_Send(&value, 1, MPI_INT, rank+1, 0, MPI_COMM_WORLD);
                fprintf(stderr, "%d send (%d)->-> %d\n", rank, value, rank+1);
            }
        }
        MPI_Barrier(MPI_COMM_WORLD);
    }while(value>=0);
    MPI_Finalize();
}