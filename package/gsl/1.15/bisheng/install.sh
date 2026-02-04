#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://mirrors.ustc.edu.cn/gnu/gsl/gsl-1.15.tar.gz
cd ${JARVIS_TMP}
rm -rf gsl-1.15
tar -xvf ${JARVIS_DOWNLOAD}/gsl-1.15.tar.gz
cd gsl-1.15
./configure CFLAGS="-Wno-implicit-function-declaration -Wno-implicit-int" --build=aarch64-unknown-linux-gnu --prefix=$1
make -j
make install
