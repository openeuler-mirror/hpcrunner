#!/bin/bash
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/gsl-2.6.tar.gz
cd gsl-2.6
./configure --prefix=$1 CC=clang CXX=clang++ FC=flang
make -j
make install
