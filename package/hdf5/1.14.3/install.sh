#!/bin/bash
set -x
set -e
. $CHECK_ROOT
hdf5_big_version='1.14.3'
hdf5_version="${hdf5_big_version}"
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/releases/hdf5/v1_14/v1_14_3/downloads/hdf5-1.14.3.tar.gz
cd ${JARVIS_TMP}
rm -rf hdfsrc
tar -xvf ${JARVIS_DOWNLOAD}/hdf5-${hdf5_version}.tar.gz
cd hdfsrc
./configure --prefix=$1 --enable-fortran --enable-static=yes --with-zlib=/usr --enable-parallel --enable-shared
sed -i '11835c wl="-Wl,"' libtool
make -j
make install

