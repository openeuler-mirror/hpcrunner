#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/libxc-5.1.4.tar.gz
cd libxc-5.1.4
./configure FC=gfortran CC=gcc --prefix=$1
make -j
make install
