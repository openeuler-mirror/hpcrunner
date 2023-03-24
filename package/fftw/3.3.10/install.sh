#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
rm -rf fftw-3.3.10
${DOWNLOAD_TOOL} -u http://www.fftw.org/fftw-3.3.10.tar.gz
tar -xvf ${JARVIS_DOWNLOAD}/fftw-3.3.10.tar.gz
cd fftw-3.3.10
./configure --prefix=$1 MPICC=mpicc --enable-shared --enable-threads --enable-openmp --enable-mpi
make -j install