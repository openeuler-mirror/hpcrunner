#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.15/src/hdf-4.2.15.tar.gz
cd ${JARVIS_TMP}
rm -rf hdf-4.2.15
tar -xvf ${JARVIS_DOWNLOAD}/hdf-4.2.15.tar.gz
cd hdf-4.2.15
FFLAGS+='-fallow-argument-mismatch' ./configure --prefix=$1  --with-zlib=/usr/local --disable-fortran --with-jpeg=${LIBJPEG_PATH} --disable-netcdf
make -j
make install
