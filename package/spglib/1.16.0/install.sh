#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/spglib-1.16.0.tar.gz
cd spglib-1.16.0
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$1
make -j
make install
