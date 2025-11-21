#!/bin/bash
source ./env.sh 
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
ulimit -s unlimited

echo "start ..."
sleep 5
{ time  mpirun -np 16 --allow-run-as-root --map-by ppr:4:numa:PE=8 -x OMP_PROC_BIND=close -x OMP_PLACES=cores -x KML_BLAS_THREAD_TYPE=OMP  -x OMP_NUM_THREADS=8 -x UCX_TLS=sm  -x PATH -x LD_LIBRARY_PATH ./kscalapack_pdgetrf_cpp_kml -nb 512 -grid 1x16 -size 120000;} 2>&1 | tee tee_kscalapack_pdgetrf_cpp_kml.txt

