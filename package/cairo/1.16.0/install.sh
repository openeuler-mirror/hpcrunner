#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://www.cairographics.org/releases/cairo-1.16.0.tar.xz
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/cairo-1.16.0.tar.xz
cd cairo-1.16.0
./configure --prefix=$1 
make all install
