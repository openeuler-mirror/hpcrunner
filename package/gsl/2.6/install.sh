#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://mirrors.aliyun.com/gnu/gsl/gsl-2.6.tar.gz
cd ${JARVIS_TMP}
rm -rf gsl-2.6
tar -xvf ${JARVIS_DOWNLOAD}/gsl-2.6.tar.gz
cd gsl-2.6
./configure --prefix=$1  
make -j
make install
