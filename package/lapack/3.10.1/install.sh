#!/bin/bash
set -x
set -e
. $DOWNLOAD_TOOL -u https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.10.1.tar.gz 
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/lapack-3.10.1.tar.gz
cd lapack-3.10.1
rm build -rf
mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=$1 -DBUILD_SHARED_LIBS=ON
make -j $(nproc)
make install
ln -s $1/lib64 $1/lib