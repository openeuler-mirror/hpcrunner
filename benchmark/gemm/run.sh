flags="**************"
armRun(){
    mpi_cmd="mpirun --allow-run-as-root -x OMP_NUM_THREADS=4 -mca btl ^vader,tcp,openib,uct  -np 16"
    echo "${flags}benching openblas gemm, best 405ms${flags}"
    make
    ${mpi_cmd} ./gemm 4024 4024 4024 1
    echo "${flags}benching kml gemm, best 216ms${flags}"
    make gemm-kml
    ${mpi_cmd} ./gemm-kml 4024 4024 4024 1
    echo "${flags}benching MPI perf, best 1855ms${flags}"
    ${mpi_cmd} ./gemm 4024 4024 4024 0
}

x86Run(){
    mpi_cmd="mpirun -genv OMP_NUM_THREADS=4  -n 16"
    echo "${flags}benching openblas gemm, best 405ms${flags}"
    make
    ${mpi_cmd} ./gemm 4024 4024 4024 1
    echo "${flags}benching MKL gemm, best 216ms${flags}"
    make gemm-MKL
    ${mpi_cmd} ./gemm-mkl 4024 4024 4024 1
    echo "${flags}benching MPI perf, best 1855ms${flags}"
    ${mpi_cmd} ./gemm 4024 4024 4024 0
}
# check Arch
if [ x$(arch) = xaarch64 ];then
    armRun
else
    x86Run
fi