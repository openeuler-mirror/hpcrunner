#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://cucis.ece.northwestern.edu/projects/PnetCDF/Release/pnetcdf-1.12.1.tar.gz
cd ${JARVIS_TMP}
tar zxvf ${JARVIS_DOWNLOAD}/pnetcdf-1.12.1.tar.gz
cd pnetcdf-1.12.1
./configure --prefix=$1 --build=aarch64-linux --enable-shared --enable-fortran --enable-large-file-test
make -j16
make install
