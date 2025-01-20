#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://archive.apache.org/dist/xerces/c/3/sources/xerces-c-3.3.0.tar.gz
cd ${JARVIS_TMP}
rm -rf xerces-c-3.3.0
tar -xvf ${JARVIS_DOWNLOAD}/xerces-c-3.3.0.tar.gz
cd xerces-c-3.3.0
export XERCESCROOT='pwd'
./configure --prefix=$1
make -j all && make install
