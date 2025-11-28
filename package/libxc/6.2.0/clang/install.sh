#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
. ${DOWNLOAD_TOOL} -u https://gitlab.com/libxc/libxc/-/archive/6.2.0/libxc-6.2.0.tar.gz -f libxc-6.2.0.tar.gz
rm -rf libxc-6.2.0
tar -xvf ${JARVIS_DOWNLOAD}/libxc-6.2.0.tar.gz
cd libxc-6.2.0
autoreconf -i
mkdir build
cd build
../configure --prefix=$1 AR=ar FC=flang F77=flang F90=flang CC=clang
make -j
make install
