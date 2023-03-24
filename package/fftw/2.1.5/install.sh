#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://www.fftw.org/fftw-2.1.5.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/fftw-2.1.5.tar.gz
cd fftw-2.1.5
./configure  --prefix=$1 --enable-shared --enable-threads --enable-openmp --enable-mpi --enable-type-prefix CC=mpicc --enable-float #--enable-fma --enable-neon
make -j install
