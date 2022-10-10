#!/bin/bash
set -x
set -e
zlib_ver='1.2.12'
. ${DOWNLOAD_TOOL} -u https://zlib.net/zlib-${zlib_ver}.tar.gz
cd ${JARVIS_TMP}
rm -rf zlib-${zlib_ver}
tar -xvf ${JARVIS_DOWNLOAD}/zlib-${zlib_ver}.tar.gz
cd zlib-${zlib_ver}
./configure --prefix=$1
make -j
make install
