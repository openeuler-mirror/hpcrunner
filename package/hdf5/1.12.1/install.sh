#!/bin/bash
set -x
set -e
hdf5_big_version='1.12'
hdf5_version="${hdf5_big_version}.1"
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${hdf5_big_version}/hdf5-${hdf5_version}/src/hdf5-${hdf5_version}.tar.gz
cd ${JARVIS_TMP}
rm -rf hdf5-${hdf5_version}
tar -xvf ${JARVIS_DOWNLOAD}/hdf5-${hdf5_version}.tar.gz
cd hdf5-${hdf5_version}
#获取除了第一个参数之外的参数
args=${@:2}
if [ -z "$args" ]; then
    ./configure --prefix=$1  --enable-fortran --enable-static=yes --enable-parallel --enable-shared --with-zlib=/usr/lib
else
    ./configure --prefix=$1 $args
fi
make -j
make install
