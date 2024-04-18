#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://www.ijg.org/files/jpegsrc.v9b.tar.gz
cd ${JARVIS_TMP}
rm -rf jpeg-9b
tar xvf ${JARVIS_DOWNLOAD}/jpegsrc.v9b.tar.gz
cd jpeg-9b
./configure --prefix=$1 CFLAGS="-fPIC" --build=aarch64-unknown-linux-gnu
make -j
make install
