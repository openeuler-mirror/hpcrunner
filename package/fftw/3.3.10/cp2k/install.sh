#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
#rm -rf fftw-3.3.10
${DOWNLOAD_TOOL} -u http://www.fftw.org/fftw-3.3.10.tar.gz
tar -xvf ${JARVIS_DOWNLOAD}/fftw-3.3.10.tar.gz
cd fftw-3.3.10
./configure --prefix=$1 --enable-shared --enable-static --enable-fma --enable-neon --enable-threads --enable-openmp CC=mpicc FC=mpifort CXX=mpicxx CFLAGS="-O3 -fPIC" FFLAGS="-O3 -fPIC" FCFLAGS="-O3 -fPIC"
make -j && make install
./configure --prefix=$1 --enable-shared --enable-static --enable-fma --enable-neon --enable-threads --enable-openmp --enable-float CC=mpicc FC=mpifort CXX=mpicxx CFLAGS="-O3 -fPIC" FFLAGS="-O3 -fPIC" FCFLAGS="-O3 -fPIC"
make -j && make install