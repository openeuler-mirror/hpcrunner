#!/bin/bash
set -x
set -e
. $CHECK_ROOT && yum install libstdc++-devel.aarch64 bison flex
. ${DOWNLOAD_TOOL} -u https://gitlab.inria.fr/scotch/scotch/-/archive/v7.0.1/scotch-v7.0.1.tar.gz
cd ${JARVIS_TMP}
rm -rf scotch-v7.0.1
tar -xvf ${JARVIS_DOWNLOAD}/scotch-v7.0.1.tar.gz
cd scotch-v7.0.1
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$1 -DIDXSIZE=32 -DTHREADS=OFF -DCMAKE_BUILD_TYPE=Release ..
make -j
make install
