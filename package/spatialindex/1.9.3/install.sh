#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/libspatialindex/libspatialindex/archive/refs/tags/1.9.3.tar.gz
cd ${JARVIS_TMP}
rm -rf libspatialindex-1.9.3
tar -zxf ${JARVIS_DOWNLOAD}/1.9.3.tar.gz
cd libspatialindex-1.9.3
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$1 ..
make -j
make install
