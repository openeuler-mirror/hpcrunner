#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/dgasmith/gau2grid/archive/v1.3.0.tar.gz
cd ${JARVIS_TMP}
rm gau2grid-1.3.0 -rf
tar -xvf ${JARVIS_DOWNLOAD}/v1.3.0.tar.gz
cd gau2grid-1.3.0
mkdir  build
cd build
yum install python python3-pip  -y
#pip3 install numpy
wget https://files.pythonhosted.org/packages/bd/54/15a0ba87e6335d02475201c9767a6a424ee39ed438ebdb6438f34abc2c25/numpy-2.0.1-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
pip3 install numpy-2.0.1-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
cmake ..  -DCMAKE_INSTALL_PREFIX=$1 -DPYTHON_EXECUTABLE=/usr/bin/python3
make -j
make install
