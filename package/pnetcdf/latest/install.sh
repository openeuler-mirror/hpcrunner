#!/bin/bash
set -x
set -e
pnetcdf_version=`curl https://parallel-netcdf.github.io/wiki/Download.html|awk -F "../Release/pnetcdf-" '{print $2}'|awk -F ".tar.gz" '{print $1}'|awk NF|awk NR==1`
. ${DOWNLOAD_TOOL} -u https://parallel-netcdf.github.io/Release/pnetcdf-${pnetcdf_version}.tar.gz
cd ${JARVIS_TMP}
tar zxvf ${JARVIS_DOWNLOAD}/pnetcdf-${pnetcdf_version}.tar.gz
cd pnetcdf-${pnetcdf_version}
./configure --prefix=$1  MPIF77="mpif77" 
make -j
make install
