#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
tar -xzvf ${JARVIS_DOWNLOAD}/libvori-210412.tar.gz
cd libvori-210412
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$1
make -j
make install

