#include "mpi.h"
#include <stdio.h>

int main(int argc, char *argv[])
{
    int rank, size, i, buf[1];
    MPI_Status status;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if (rank==0) {
        /*主进程不断接收从各个进程发送过来的消息*/
        for(i=0; i<5*(size-1); i++)
        {
            MPI_Recv(buf, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
            printf("Msg=%d from %d with tag %d\n",buf[0], status.MPI_SOURCE, status.MPI_TAG);
        }
    }
    else {
        /*其他进程向主进程发送消息*/
        for(i=0; i<5; i++)
        {
            buf[0] = rank+i;
            MPI_Send(buf, 1, MPI_INT, 0, i, MPI_COMM_WORLD);
        }
    }
    MPI_Finalize();
}