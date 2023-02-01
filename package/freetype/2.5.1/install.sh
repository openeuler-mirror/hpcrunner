#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://sourceforge.net/projects/freetype/files/freetype2/2.5.1/freetype-2.5.1.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/freetype-2.5.1.tar.gz
cd freetype-2.5.1

./configure --enable-shared --prefix=$1
make -j
make install
cd include
cp -r * $1/include