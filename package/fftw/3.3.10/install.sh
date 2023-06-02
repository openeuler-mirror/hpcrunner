#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
rm -rf fftw-3.3.10
${DOWNLOAD_TOOL} -u http://www.fftw.org/fftw-3.3.10.tar.gz
tar -xvf ${JARVIS_DOWNLOAD}/fftw-3.3.10.tar.gz
cd fftw-3.3.10
./configure --prefix=$1 --enable-single --enable-float --enable-neon --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing"
make -j && make install
make clean
./configure --prefix=$1 --enable-long-double --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing"
make -j && make install
make clean
./configure --prefix=$1 --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing"
make -j && make install
