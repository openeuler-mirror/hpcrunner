#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://ftpmirror.gnu.org/gsl/gsl-2.7.1.tar.gz
cd ${JARVIS_TMP}
rm -rf gsl-2.7.1
tar -xvf ${JARVIS_DOWNLOAD}/gsl-2.7.1.tar.gz
cd gsl-2.7.1
./configure --prefix=$1  
make -j
make install