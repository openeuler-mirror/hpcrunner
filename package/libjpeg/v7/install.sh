#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://www.ijg.org/files/jpegsrc.v7.tar.gz
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/jpegsrc.v7.tar.gz
cd jpeg-7
./configure --prefix=$1 --build=aarch64-unknown-linux-gnu
make -j
make install
