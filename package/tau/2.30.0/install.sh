#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
# install PDT
tar -zxvf ${JARVIS_DOWNLOAD}/pdt.tgz
cd pdtoolkit-3.25.1/
./configure -GNU -prefix=$1/PDT
make -j install
# install TAU, using tau with external package
tar -zxvf ${JARVIS_DOWNLOAD}/tau-2.30.0.tar.gz
cd tau-2.30.0/
./configure -openmp -bfd=download -unwind=download -mpi -pdt=$1/PDT/ -pdt_c++=g++ -mpi
export PATH=$1/tau-2.30.0/arm64_linux/bin:$PATH

#usage: mpirun --allow-run-as-root -np 128 -x OMP_NUM_THREADS=1 --mca btl ^openib  tau_exec  vasp_std
#pprof
