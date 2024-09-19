#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/pybind/pybind11/archive/v2.6.2.tar.gz
cd ${JARVIS_TMP}
rm -rf pybind11-2.6.2
tar -xvf ${JARVIS_DOWNLOAD}/v2.6.2.tar.gz
cd pybind11-2.6.2
mkdir  build
cd build
#yum install python3-devel -y
cmake ..  -DCMAKE_INSTALL_PREFIX=$1
make -j
make install

