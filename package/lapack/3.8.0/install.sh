#!/bin/bash
set -x
set -e
. $DOWNLOAD_TOOL -u https://www.cp2k.org/static/downloads/lapack-3.8.0.tgz
cd ${JARVIS_TMP}
rm -rf lapack-3.8.0
tar -xvf ${JARVIS_DOWNLOAD}/lapack-3.8.0.tgz
cd lapack-3.8.0
mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=$1 -DBUILD_SHARED_LIBS=ON
make -j $(nproc)
make install
ln -s $1/lib64 $1/lib
#cp make.inc.example make.inc
#make -j
#mkdir $1/lib/
#cp *.a $1/lib/
