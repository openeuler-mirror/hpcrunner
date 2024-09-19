#!/bin/bash
set -x
set -e
#. ${DOWNLOAD_TOOL} -u http://forge.abinit.org/fallbacks/libxc-4.3.0.tar.gz
. ${DOWNLOAD_TOOL} -u https://gitlab.com/libxc/libxc/-/archive/4.3.0/libxc-4.3.0.tar.gz
cd ${JARVIS_TMP}
rm -rf libxc-4.3.0
tar -xvf ${JARVIS_DOWNLOAD}/libxc-4.3.0.tar.gz
cd libxc-4.3.0
cd build
cmake ..  -DCMAKE_INSTALL_PREFIX=$1
make -j
make install

