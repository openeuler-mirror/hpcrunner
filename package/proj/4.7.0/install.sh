#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://download.osgeo.org/proj/proj-4.7.0.tar.gz
cd ${JARVIS_TMP}
rm -rf proj-4.7.0
tar -xvf ${JARVIS_DOWNLOAD}/proj-4.7.0.tar.gz
cd proj-4.7.0

./configure --enable-shared --enable-static --build=aarch64-unknown-linux-gnu --prefix=$1
make all install

