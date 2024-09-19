#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/evaleev/libint/archive/release-1-2-0.tar.gz
cd ${JARVIS_TMP}
rm  libint-release-1-2-0 -rf
tar -xvf ${JARVIS_DOWNLOAD}/release-1-2-0.tar.gz
cd libint-release-1-2-0
mkdir build
cd build
cmake ..  -DCMAKE_INSTALL_PREFIX=$1
make -j
make install
