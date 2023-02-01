#!/bin/bash
set -x
set -e

. ${DOWNLOAD_TOOL} -u https://archive.mesa3d.org/older-versions/3.x/MesaLib-3.1.tar.gz
cd ${JARVIS_TMP}
rm -rf Mesa-3.1
tar -xvf ${JARVIS_DOWNLOAD}/MesaLib-3.1.tar.gz
cd Mesa-3.1
cp -f /usr/share/libtool/build-aux/config.guess ./
cp -f /usr/share/libtool/build-aux/config.sub  ./
./configure --prefix=$1
make
make install