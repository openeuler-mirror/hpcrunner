#!/bin/bash 
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://www.fftw.org/fftw-3.3.8.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/fftw-3.3.8.tar.gz
cd fftw-3.3.8

./configure --prefix=$1 --enable-single --enable-float --enable-neon --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing"
make -j && make install
make clean
./configure --prefix=$1 --enable-long-double --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing"
make -j && make install
make clean
./configure --prefix=$1 --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing"
make -j && make install


