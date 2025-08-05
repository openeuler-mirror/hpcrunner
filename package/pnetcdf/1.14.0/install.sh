#!/bin/bash
set -x
set -e
pnetcdf_version='1.14.0'
. ${DOWNLOAD_TOOL} -u https://parallel-netcdf.github.io/Release/pnetcdf-${pnetcdf_version}.tar.gz
cd ${JARVIS_TMP}
tar zxvf ${JARVIS_DOWNLOAD}/pnetcdf-${pnetcdf_version}.tar.gz
cd pnetcdf-${pnetcdf_version}
./configure --prefix=$1  MPIF77="mpif77" 
make -j
make install
