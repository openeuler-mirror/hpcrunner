#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://www.cairographics.org/releases/pixman-0.38.0.tar.gz
cd ${JARVIS_TMP}

tar xvf ${JARVIS_DOWNLOAD}/pixman-0.38.0.tar.gz
cd pixman-0.38.0
./configure --prefix=$1
make -j
make install
