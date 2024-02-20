#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/blitzpp/blitz/archive/refs/tags/1.0.1.tar.gz -f blitz-1.0.1.tar.gz
cd ${JARVIS_TMP}
rm -rf blitz-1.0.1
tar -xzvf ${JARVIS_DOWNLOAD}/blitz-1.0.1.tar.gz
cd blitz-1.0.1
autoreconf -fiv
./configure --prefix=$1 --enable-fortran --enable-64bit
sed -i "9s/print/print(/g" blitz/generate/genstencils.py
sed -i "9s/$/)/g" blitz/generate/genstencils.py
make lib
make install
cp -rf ./src $1

