#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://vtk.org/files/release/6.2/VTK-6.2.0.tar.gz
cd ${JARVIS_TMP}
rm -rf VTK-6.2.0
tar -xvf ${JARVIS_DOWNLOAD}/VTK-6.2.0.tar.gz
cd VTK-6.2.0
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$1 .. \
	-DCMAKE_C_FLAGS="-Wno-implicit-function-declaration" \
	-DCMAKE_CXX_FLAGS="-std=c++14 -Wno-implicit-function-declaration"
make -j && make install
