#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/LLNL/sundials/archive/refs/tags/v7.2.1.tar.gz
cd ${JARVIS_TMP}
rm -rf sundials-7.2.1
tar -xvf ${JARVIS_DOWNLOAD}/sundials-7.2.1.tar.gz
cd sundials-7.2.1
mkdir build && cd build
echo $1
cmake -DCMAKE_INSTALL_PREFIX=$1 \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DEXAMPLES_ENABLE=OFF ..
make -j && make install
