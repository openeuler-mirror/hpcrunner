#!/bin/bash
#wget https://distfiles.macports.org/szip/szip-2.1.1.tar.gz
set -x
set -e
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/szip-2.1.1.tar.gz
cd szip-2.1.1
./configure --prefix=$1
make -j
make install
