#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://download.osgeo.org/proj/proj-5.2.0.tar.gz
cd ${JARVIS_TMP}
rm -rf proj-5.2.0
tar -xvf ${JARVIS_DOWNLOAD}/proj-5.2.0.tar.gz
cd proj-5.2.0

./configure --enable-shared --enable-static --prefix=$1
make all install