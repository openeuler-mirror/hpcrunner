#!/bin/bash

set -x
set -e
pnetcdf_ver='1.9.0'
. ${DOWNLOAD_TOOL} -u https://parallel-netcdf.github.io/Release/parallel-netcdf-1.9.0.tar.gz
cd ${JARVIS_TMP}
rm -rf pnetcdf-${pnetcdf_ver}
tar zxvf ${JARVIS_DOWNLOAD}/parallel-netcdf-1.9.0.tar.gz
cd parallel-netcdf-1.9.0
./configure --prefix=$1 --enable-shared --enable-fortran --enable-large-file-test
make -j16
make install