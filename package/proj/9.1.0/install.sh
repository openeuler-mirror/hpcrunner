#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://download.osgeo.org/proj/proj-9.1.0.tar.gz
cd ${JARVIS_TMP}
rm -rf proj-9.1.0
tar -xvf ${JARVIS_DOWNLOAD}/proj-9.1.0.tar.gz
cd proj-9.1.0
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$1
make all -j
make install

