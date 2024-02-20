#!/bin/bash
set -x
set -e
. "${DOWNLOAD_TOOL}" -u http://www.netlib.org/blas/blas-3.8.0.tgz
cd "${JARVIS_TMP}"
rm -rf BLAS-3.8.0
tar -xzvf "${JARVIS_DOWNLOAD}"/blas-3.8.0.tgz
cd BLAS-3.8.0
gfortran -c -O3 -fPIC -shared ./*.f
gfortran -O3 -fPIC -shared -o libblas.so ./*.o
mkdir $1/lib
cp libblas.so $1/lib