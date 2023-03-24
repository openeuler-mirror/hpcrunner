program main
  use mpi
  implicit none
 
  integer :: nprocs, rank, ierr
 
  call MPI_INIT(ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, nprocs, ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
 
  print *, 'Process', rank, 'of', nprocs, 'is running'
 
  call MPI_FINALIZE(ierr)
end program main
