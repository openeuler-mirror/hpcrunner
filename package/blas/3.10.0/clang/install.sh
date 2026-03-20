#!/bin/bash
#http://www.netlib.org/blas/blas-3.10.0.tgz
<< aaa
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://www.netlib.org/blas/blas-3.10.0.tgz
cd ${JARVIS_TMP}
rm -rf BLAS-3.10.0
tar -xvf ${JARVIS_DOWNLOAD}/blas-3.10.0.tgz
cd BLAS-3.10.0
`which flang` -c -O3 -fomit-frame-pointer -funroll-loops *.f
ar rv libblas.a *.o
mkdir $1/lib
cp libblas.a $1/lib
aaa

set -x
set -e
. "${DOWNLOAD_TOOL}" -u http://www.netlib.org/blas/blas-3.10.0.tgz
cd "${JARVIS_TMP}"
rm -rf BLAS-3.10.0
tar -xzvf "${JARVIS_DOWNLOAD}"/blas-3.10.0.tgz
cd BLAS-3.10.0
rm build -rf
mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=$1 -DBUILD_SHARED_LIBS=ON
make -j $(nproc)
make install


