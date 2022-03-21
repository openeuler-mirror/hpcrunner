#!/bin/bash
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/gmp-6.2.0.tar.xz
cd gmp-6.2.0
./configure --prefix=$1
make -j
make install