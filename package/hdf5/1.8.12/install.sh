#!/bin/bash
set -x
set -e
hdf5_ver='1.8.12'
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-${hdf5_ver}/src/hdf5-${hdf5_ver}.tar.gz
cd ${JARVIS_TMP}
rm -rf hdf5-${hdf5_ver}
tar -xvf ${JARVIS_DOWNLOAD}/hdf5-${hdf5_ver}.tar.gz
cd hdf5-${hdf5_ver}
#
./configure --prefix=$1  --enable-fortran --enable-static=yes --enable-parallel --enable-shared
make -j
make install
