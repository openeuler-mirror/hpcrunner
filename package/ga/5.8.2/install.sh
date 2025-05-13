#!/bin/bash
set -x
set -e
ga_version=5.8.2
. ${DOWNLOAD_TOOL} -u https://github.com/GlobalArrays/ga/releases/download/v5.8.2/ga-5.8.2.tar.gz

cd ${JARVIS_TMP}
rm -rf ga-${ga_version}
tar -zxvf ${JARVIS_DOWNLOAD}/ga-5.8.2.tar.gz -C .
cd ga-${ga_version}/
#ScaLAPACK可选项，且编译时已使能BLAS+LAPACK
#Infiniband可选项
./configure --prefix=$1 --enable-i8 --enable-cxx --with-scalapack=${ScaLAPACK_PATH} --with-openib=${Infiniband_PATH} CC=mpicc CXX=mpicxx FC=mpifort F77=mpifort MPICC=mpicc MPICXX=mpicxx MPIFC=mpifort MPIF77=mpifort
make -j
make install

exit 0
