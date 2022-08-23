#!/bin/bash
set -x
set -e
. $DOWNLOAD_TOOL -u https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.10.1.tar.gz 
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/lapack-3.10.1.tar.gz
cd lapack-3.10.1
cp make.inc.example make.inc
make -j $(nproc)
mkdir $1/lib/
cp *.a $1/lib/
cp -r LAPACKE/include $1/
