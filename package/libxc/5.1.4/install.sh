#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/libxc-5.1.4.tar.gz
cd libxc-5.1.4
./configure --prefix=$1 CC=clang CXX=clang++ FC=flang CFLAGS='-fPIC' FCFLAGS='-fPIC'
make -j
make install
