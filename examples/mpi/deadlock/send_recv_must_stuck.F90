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
  ! 进程0的第一条接收语句A能否完成取决于进程1的第二条发送语句D，即A依赖于D，从执行次序上可以明显地看出，进程0向进程1发送消息的语句C的执行又依赖于它前面的接收语句A的完成，即C依赖于A；同时，进程1的第一条接收语句B能否完成取决于进程0的第二条发送语句C的执行，即B依赖于C，从执行次序上可以明显地看出，向进程0发送消息的语句D的执行又依赖于B的完成，故有A依赖于D，而D又依赖于B，B依赖于C，C依赖于A，形成了一个环，进程0和进程1相互等待，彼此都无法执行下去，必然导致死锁
  IF (rank.EQ.0) THEN
    CALL MPI_RECV(recvbuf, count, MPI_REAL, 1, tag, MPI_COMM_WORLD, status, ierr)
    CALL MPI_SEND(sendbuf, count, MPI_REAL, 1, tag, MPI_COMM_WORLD, ierr)
  ELSE IF( rank .EQ. 1) THEN
    CALL MPI_RECV(recvbuf, count, MPI_REAL, 0, tag, MPI_COMM_WORLD, status, ierr)
    CALL MPI_SEND(sendbuf, count, MPI_REAL, 0, tag, MPI_COMM_WORLD, ierr)
  END IF
  print *, 'Process', rank, 'of', size, 'is running'
 
  call MPI_FINALIZE(ierr)
end program main
