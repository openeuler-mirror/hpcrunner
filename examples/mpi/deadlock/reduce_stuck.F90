program mpi_example
  use mpi
  implicit none

  integer :: rank, comm_size, i, j,ierr
  integer, parameter :: BUFFER_SIZE = 100
  real, allocatable :: data(:)

  ! Initialize MPI environment
  call MPI_Init(ierr)
  call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
  call MPI_Comm_size(MPI_COMM_WORLD, comm_size, ierr)

  allocate(data(BUFFER_SIZE)) ! 为 data 数组分配内存
  ! 初始化 data 数组
  data = 0.0
  ! 大量点对点消息可能造成死锁: https://zhuanlan.zhihu.com/p/431147881
  if (rank == 0) then
    ! Master rank
    do i = 1, BUFFER_SIZE
      do j = 1, comm_size-1
        call MPI_Recv(data(i), 1, MPI_FLOAT, j, i, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
      end do
    end do

    ! Aggregate data from other ranks
    do i = 1, BUFFER_SIZE
      do j = 1, comm_size-1
        data(i) = data(i) + data(i + (j-1)*BUFFER_SIZE)
      end do
    end do

    ! Send aggregated data back to other ranks
    do i = 1, BUFFER_SIZE
      do j = 1, comm_size-1
        call MPI_Send(data(i), 1, MPI_FLOAT, j, i, MPI_COMM_WORLD, ierr)
      end do
    end do
  else
    ! Other ranks
    do i = 1, BUFFER_SIZE
      call MPI_Send(data(i), 1, MPI_FLOAT, 0, i, MPI_COMM_WORLD, ierr)
    end do

    ! Receive aggregated data from master rank
    do i = 1, BUFFER_SIZE
      call MPI_Recv(data(i), 1, MPI_FLOAT, 0, i, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
    end do
  end if
  deallocate(data) ! 释放 data 数组的内存
  print *, 'Process', rank, 'is finished'
  ! Finalize MPI environment
  call MPI_Finalize(ierr)

end program mpi_example
