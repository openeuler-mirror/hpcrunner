#!/bin/bash
set -x
set -e
yum install -y libsecret-devel
. ${DOWNLOAD_TOOL} -u https://github.com/frankosterfeld/qtkeychain/archive/refs/tags/v0.13.2.tar.gz
cd ${JARVIS_TMP}
rm -rf qtkeychain-0.13.2
tar -zxf ${JARVIS_DOWNLOAD}/v0.13.2.tar.gz
cd qtkeychain-0.13.2
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$1 ..
make -j
make install
