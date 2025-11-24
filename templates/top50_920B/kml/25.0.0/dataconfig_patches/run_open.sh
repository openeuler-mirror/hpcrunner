#!/bin/bash
source ./env.sh
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
ulimit -s unlimited

{ time  -p mpirun -np 16 --allow-run-as-root --map-by ppr:4:numa:pe=8 -x OMP_PROC_BIND=close -x OMP_PLACES=cores -x KML_BLAS_THREAD_TYPE=OMP -x KML_BLAS_NOT_USE_HBM=1 -x OMP_NUM_THREADS=8 -x UCX_TLS=sm ./kscalapack_pdgetrf_cpp_open -nb 512 -grid 1x16 -size 120000 ; } 2>&1 | tee tee_kscalapack_pdgetrf_cpp_open.xlog

