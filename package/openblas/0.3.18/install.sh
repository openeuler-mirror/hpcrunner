#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/xianyi/OpenBLAS/archive/refs/tags/v0.3.18.tar.gz -f OpenBLAS-0.3.18.tar.gz
cd ${JARVIS_TMP}
rm -rf OpenBLAS-0.3.18
tar -xzvf ${JARVIS_DOWNLOAD}/OpenBLAS-0.3.18.tar.gz
cd OpenBLAS-0.3.18
export CC="gcc -Wno-implicit-function-declaration"  CXX=c++ FC=gfortran
make -j 
make PREFIX=$1 install
