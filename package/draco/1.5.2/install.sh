#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/google/draco/archive/refs/tags/1.5.2.tar.gz
cd ${JARVIS_TMP}
rm -rf draco-1.5.2
tar -xvf ${JARVIS_DOWNLOAD}/1.5.2.tar.gz
cd draco-1.5.2

mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$1 -DBUILD_SHARED_LIBS=ON ..
make -j4
make install
