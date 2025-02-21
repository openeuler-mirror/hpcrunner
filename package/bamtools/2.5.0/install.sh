#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/pezmaster31/bamtools/archive/refs/tags/v2.5.0.tar.gz -f bamtools-2.5.0.tar.gz
cd ${JARVIS_TMP}
rm -rf bamtools-2.5.0
tar -xvf ${JARVIS_DOWNLOAD}/bamtools-2.5.0.tar.gz
cd bamtools-2.5.0
export CC=clang CXX=clang++ FC=flang
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$1 .. -DCMAKE_CXX_FLAGS="-std=c++14 -O3" ..
make -j
make install
