#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/y-256/libdivsufsort/archive/refs/tags/2.0.1.tar.gz -f libdivsufsort-2.0.1.tar.gz
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/libdivsufsort-2.0.1.tar.gz
cd libdivsufsort-2.0.1
sed -i "47s/OFF/ON/g" CMakeLists.txt
sed -i "48s/OFF/ON/g" CMakeLists.txt
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$1
make -j
make install