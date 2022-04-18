#!/bin/bash
#http://www.netlib.org/blas/blas-3.10.0.tgz
set -x
set -e
cd ${JARVIS_TMP}
rm -rf BLAS-3.10.0
tar -xvf ${JARVIS_DOWNLOAD}/blas-3.10.0.tgz
cd BLAS-3.10.0
`which flang` -c -O3 -fomit-frame-pointer -funroll-loops *.f
ar rv libblas.a *.o
mkdir $1/lib
cp libblas.a $1/lib
