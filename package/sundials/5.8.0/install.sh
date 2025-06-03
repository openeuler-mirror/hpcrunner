#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/LLNL/sundials/archive/refs/tags/v5.8.0.tar.gz -f sundials-5.8.0.tar.gz
cd ${JARVIS_TMP}
rm -rf sundials-5.8.0
tar -xvf ${JARVIS_DOWNLOAD}/sundials-5.8.0.tar.gz
cd sundials-5.8.0
mkdir build && cd build
echo $1
cmake -DCMAKE_INSTALL_PREFIX=$1 \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DEXAMPLES_ENABLE=OFF ..
make -j && make install
