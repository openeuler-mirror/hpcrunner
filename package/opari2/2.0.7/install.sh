#!/bin/bash
set -x
set -e
szip_ver='2.0.7'
. ${DOWNLOAD_TOOL} -u https://perftools.pages.jsc.fz-juelich.de/cicd/opari2/tags/opari2-2.0.7/opari2-${szip_ver}.tar.gz 
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/opari2-${szip_ver}.tar.gz
cd opari2-${szip_ver}
./configure --prefix=$1
make -j
make install
