#!/bin/bash
set -x
set -e
pnetcdf_version='1.12.1'
. ${DOWNLOAD_TOOL} -u http://cucis.ece.northwestern.edu/projects/PnetCDF/Release/pnetcdf-${pnetcdf_version}.tar.gz
cd ${JARVIS_TMP}
rm -rf pnetcdf-${pnetcdf_version}
tar zxvf ${JARVIS_DOWNLOAD}/pnetcdf-${pnetcdf_version}.tar.gz
cd pnetcdf-${pnetcdf_version}
./configure --prefix=$1 --build=aarch64-linux --enable-shared --enable-fortran --enable-large-file-test FFLAGS="-fallow-argument-mismatch" FCFLAGS="-fallow-argument-mismatch" 
make -j16
make install
