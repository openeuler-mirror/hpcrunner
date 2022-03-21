#!/bin/bash
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/plumed-2.6.2.tgz
cd plumed-2.6.2
./configure CXX=mpicxx CC=mpicc FC=mpifort --prefix=$1 --enable-external-blas --enable-gsl --enable-external-lapack LDFLAGS=-L/home//HT3/HPCRunner2/package/lapack/3.8.0/lapack-3.8.0/ LIBS="-lrefblas –llapack"
make -j
make install
