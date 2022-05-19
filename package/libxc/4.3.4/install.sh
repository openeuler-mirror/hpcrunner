#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://forge.abinit.org/fallbacks/libxc-4.3.4.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/libxc-4.3.4.tar.gz
cd libxc-4.3.4
./configure  --prefix=$1  
make -j
make install

