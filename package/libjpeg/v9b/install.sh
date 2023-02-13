#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://www.ijg.org/files/jpegsrc.v9b.tar.gz
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/jpegsrc.v9b.tar.gz
cd jpeg-9b
./configure --prefix=$1 --build=aarch64-unknown-linux-gnu
./configure --prefix=$1 CFLAGS="-fPIC"
make install
