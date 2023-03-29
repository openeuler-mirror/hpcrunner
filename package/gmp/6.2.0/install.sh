#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://gmplib.org/download/gmp/gmp-6.2.0.tar.xz
cd ${JARVIS_TMP}
rm -rf gmp-6.2.0
tar -xvf ${JARVIS_DOWNLOAD}/gmp-6.2.0.tar.xz
cd gmp-6.2.0
./configure --enable-cxx --prefix=$1
make -j
make install
