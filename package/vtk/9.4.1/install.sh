#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://vtk.org/files/release/9.4/VTK-9.4.1.tar.gz
cd ${JARVIS_TMP}
rm -rf VTK-9.4.1
tar -xvf ${JARVIS_DOWNLOAD}/VTK-9.4.1.tar.gz
cd VTK-9.4.1
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$1 ..
make -j && make install
