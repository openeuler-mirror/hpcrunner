#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/spglib/spglib/archive/refs/tags/v1.16.0.tar.gz -f spglib-1.16.0.tar.gz
cd ${JARVIS_TMP}
rm -rf spglib-1.16.0
tar -xvf ${JARVIS_DOWNLOAD}/spglib-1.16.0.tar.gz
cd spglib-1.16.0
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$1
make -j
make install
