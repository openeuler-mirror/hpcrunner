#!/bin/bash
set -x
set -e
hdf5_big_version='1.12'
hdf5_version='${hdf5_big_version}.0'
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${hdf5_big_version}/hdf5-${hdf5_version}/src/hdf5-${hdf5_version}.tar.gz
cd ${JARVIS_TMP}
rm -rf hdf5-${hdf5_version}
tar -xvf ${JARVIS_DOWNLOAD}/hdf5-${hdf5_version}.tar.gz
cd hdf5-${hdf5_version}
./configure --prefix=$1  --enable-fortran --enable-static=yes --enable-parallel --enable-shared
make -j
make install
