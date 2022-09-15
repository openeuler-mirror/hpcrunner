#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://downloads.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure --prefix=$1
make -j
make install
