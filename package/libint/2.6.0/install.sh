#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
export GCC_LIBS=/home/HT3/HPCRunner2/software/libs/kgcc9
tar -xvf ${JARVIS_DOWNLOAD}/libint-2.6.0.tar.gz
cd libint-2.6.0
./autogen.sh
mkdir build
cd build
export LDFLAGS="-L${GCC_LIBS}/gmp/6.2.0/lib -L${GCC_LIBS}/boost/1.72.0/lib"
export CPPFLAGS="-I${GCC_LIBS}/gmp/6.2.0/include -I${GCC_LIBS}/boost/1.72.0/include"
../configure CXX=mpicxx --enable-eri=1 --enable-eri2=1 --enable-eri3=1 --with-max-am=4 --with-eri-max-am=4,3 --with-eri2-max-am=6,5 --with-eri3-max-am=6,5 --with-opt-am=3 --enable-generic-code --disable-unrolling --with-libint-exportdir=libint_cp2k_lmax4
make export
tar -xvf libint_cp2k_lmax4.tgz
cd libint_cp2k_lmax4
./configure --prefix=$1 CC=mpicc CXX=mpicxx FC=mpifort --enable-fortran --enable-shared
make -j 32
make install
