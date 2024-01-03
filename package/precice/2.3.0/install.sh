#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/precice/precice/archive/v2.3.0.tar.gz -f precice-2.3.0.tar.gz
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/precice-2.3.0.tar.gz
cd precice-2.3.0
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$1 -DPRECICE_PETScMapping=OFF -DPRECICE_PythonActions=OFF
make -j
make install
