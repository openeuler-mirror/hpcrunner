#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
#rm -rf fftw-3.3.10
${DOWNLOAD_TOOL} -u http://www.fftw.org/fftw-3.3.10.tar.gz
tar -xvf ${JARVIS_DOWNLOAD}/fftw-3.3.10.tar.gz
cd fftw-3.3.10
CFLAGS="-O3 -fPIC"
./configure --prefix=$1 --enable-fma --enable-generic-simd256 --enable-single --enable-float --enable-neon --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="$CFLAGS" FFLAGS="$CFLAGS" FCFLAGS="$CFLAGS"
make -j 16 && make install
