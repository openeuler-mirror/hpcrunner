#!/bin/bash

set -x
set -e
pnetcdf_ver='1.11.2'
. ${DOWNLOAD_TOOL} -u http://cucis.ece.northwestern.edu/projects/PnetCDF/Release/pnetcdf-${pnetcdf_ver}.tar.gz
cd ${JARVIS_TMP}
rm -rf pnetcdf-${pnetcdf_ver}
tar zxvf ${JARVIS_DOWNLOAD}/pnetcdf-${pnetcdf_ver}.tar.gz
cd pnetcdf-${pnetcdf_ver}
./configure --prefix=$1 --enable-shared --enable-fortran --enable-large-file-test
make -j16
make install
