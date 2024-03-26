program main
  use mpi
  implicit none

  integer :: rank, size, tag, ierr, status(MPI_STATUS_SIZE)
  real :: sendbuf(100), recvbuf(100)
  integer :: count
  tag = 1
  count = 100
  call MPI_INIT(ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  ! C的完成只需要A完成，而A的完成只要有对应的D存在，则不需要系统提供缓冲区也可以进行，这里恰恰满足这样的条件，因此A总能够完成，因此D也一定能完成。当A和D完成后，B的完成只需要相应的C，不需要缓冲区也能完成，因此B和C也一定能完成，所以说这样的通信形式是安全的。显然A和C，D和B同时互换，从原理上说和这种情况是一样的，因此也是安全的。
  IF (rank.EQ.0) THEN
    CALL MPI_SEND(sendbuf, count, MPI_REAL, 1, tag, MPI_COMM_WORLD, ierr)
    CALL MPI_RECV(recvbuf, count, MPI_REAL, 1, tag, MPI_COMM_WORLD, status, ierr)
  ELSE IF( rank .EQ. 1) THEN
    CALL MPI_RECV(recvbuf, count, MPI_REAL, 0, tag, MPI_COMM_WORLD, status, ierr)
    CALL MPI_SEND(sendbuf, count, MPI_REAL, 0, tag, MPI_COMM_WORLD, ierr)
  END IF
  print *, 'Process', rank, 'of', size, 'is running'
 
  call MPI_FINALIZE(ierr)
end program main
