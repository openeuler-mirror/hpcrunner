#!/bin/bash
#下载地址：http://www.zlib.net/zlib-1.2.11.tar.gz
set -x
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure --prefix=$1
make -j
make install
