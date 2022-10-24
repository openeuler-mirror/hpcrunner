#!/bin/bash
set -x
set -e
. "${DOWNLOAD_TOOL}" -u http://www.netlib.org/blas/blas-3.10.0.tgz 
cd "${JARVIS_TMP}"
rm -rf BLAS-3.10.0
tar -xzvf "${JARVIS_DOWNLOAD}"/blas-3.10.0.tgz
cd BLAS-3.10.0
#sed -i "35s/ftp/http/g" ./contrib/download_prerequisites
gfortran -c -O3 ./*.f
ar rv libblas.a ./*.o
mkdir $1/lib
cp libblas.a $1/lib
