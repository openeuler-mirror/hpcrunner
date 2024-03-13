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
  ! 由于进程0或进程1的发送需要系统提供缓冲区（在MPI的四种通信模式中有详细的解释），如果系统缓冲区不足，则进程0或进程1的发送将无法完成，相应的，进程1和进程0的接收也无法正确完成。显然对于需要相互交换数据的进程，直接将两个发送语句写在前面也是不安全的。说明：当进程0发送的消息长度超过缓冲区大小时，要等到全部消息发送完成函数才能返回，在这种情况下，A的完成依赖于D的成功接收，而D的调用依赖于B的完成，B发送消息要等到C成功接收，而C的调用依赖于A的完成，从而造成彼此依赖，陷入死锁。
  IF (rank.EQ.0) THEN
    CALL MPI_SEND(sendbuf, count, MPI_REAL, 1, tag, MPI_COMM_WORLD, ierr)
    CALL MPI_RECV(recvbuf, count, MPI_REAL, 1, tag, MPI_COMM_WORLD, status, ierr)
  ELSE IF( rank .EQ. 1) THEN
    CALL MPI_SEND(sendbuf, count, MPI_REAL, 0, tag, MPI_COMM_WORLD, ierr)
    CALL MPI_RECV(recvbuf, count, MPI_REAL, 0, tag, MPI_COMM_WORLD, status, ierr)
  END IF
  print *, 'Process', rank, 'of', size, 'is running'
 
  call MPI_FINALIZE(ierr)
end program main
