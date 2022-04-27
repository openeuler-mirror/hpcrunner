#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://nchc.dl.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.gz
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/libpng-1.6.37.tar.gz
cd libpng-1.6.37
./configure --prefix=$1 --build=aarch64-unknown-linux-gnu
make -j
make install
