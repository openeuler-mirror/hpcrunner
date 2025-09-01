#!/bin/bash
set -x
set -e
szip_ver='2.1.1'
. ${DOWNLOAD_TOOL} -u https://distfiles.macports.org/szip/szip-${szip_ver}.tar.gz 
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/szip-${szip_ver}.tar.gz
cd szip-${szip_ver}
./configure --prefix=$1 --enable-netcdf-4  --enable-shared
make -j
make install
