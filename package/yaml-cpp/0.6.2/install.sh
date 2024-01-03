#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/jbeder/yaml-cpp/archive/yaml-cpp-0.6.2.zip
cd ${JARVIS_TMP}
unzip ${JARVIS_DOWNLOAD}/yaml-cpp-0.6.2.zip
cd yaml-cpp-yaml-cpp-0.6.2
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$1 -DBUILD_SHARED_LIBS=ON ..
make -j
make install

