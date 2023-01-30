#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://pkgconfig.freedesktop.org/releases/pkg-config-0.29.tar.gz
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/pkg-config-0.29.tar.gz 
cd pkg-config-0.29
./configure --prefix=$1 --enable-shared
make -j
make install
