#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://sourceforge.net/projects/libtirpc/files/libtirpc/1.3.3/libtirpc-1.3.3.tar.bz2
cd ${JARVIS_TMP}
rm -rf libtirpc-1.3.3
tar -xvf ${JARVIS_DOWNLOAD}/libtirpc-1.3.3.tar.bz2
cd libtirpc-1.3.3
./configure --prefix=$1
make -j
make install

