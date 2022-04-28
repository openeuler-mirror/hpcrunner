#!/bin/bash
#https://github.com/uclouvain/openjpeg/archive/refs/tags/v2.4.0.tar.gz
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/uclouvain/openjpeg/archive/refs/tags/v2.4.0.tar.gz -f /openjpeg-2.4.0.tar.gz
cd ${JARVIS_TMP}
rm -rf openjpeg-2.4.0
tar -xvf ${JARVIS_DOWNLOAD}/openjpeg-2.4.0.tar.gz
cd openjpeg-2.4.0
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$1
make install

