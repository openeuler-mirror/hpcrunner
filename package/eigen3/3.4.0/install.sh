#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz 
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/eigen-3.4.0.tar.gz
cd eigen-3.4.0
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$1
make -j 
make install
