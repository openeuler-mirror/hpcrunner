#!/bin/bash
set -x
set -e
szip_ver='3.0.3'
. ${DOWNLOAD_TOOL} -u https://perftools.pages.jsc.fz-juelich.de/cicd/otf2/tags/otf2-3.0.3/otf2-${szip_ver}.tar.gz 
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/otf2-${szip_ver}.tar.gz
cd otf2-${szip_ver}
./configure --prefix=$1
make -j
make install
