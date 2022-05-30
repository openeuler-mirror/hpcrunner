#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://brehm-research.de/files/libvori-210412.tar.gz
cd ${JARVIS_TMP}
rm -rf libvori-210412
tar -xzvf ${JARVIS_DOWNLOAD}/libvori-210412.tar.gz
cd libvori-210412
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$1
make -j
make install

