#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://distfiles.macports.org/szip/szip-2.1.1.tar.gz 
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/szip-2.1.1.tar.gz
cd szip-2.1.1
./configure --prefix=$1
make -j
make install
