#!/bin/bash
set -x
set -e
. $CHECK_ROOT && yum -y install zlib zlib-devel
hdf5_big_version='1.12'
hdf5_version="${hdf5_big_version}.1"
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${hdf5_big_version}/hdf5-${hdf5_version}/src/hdf5-${hdf5_version}.tar.gz
cd ${JARVIS_TMP}
rm -rf hdf5-${hdf5_version}
tar -xvf ${JARVIS_DOWNLOAD}/hdf5-${hdf5_version}.tar.gz
cd hdf5-${hdf5_version}
export CC=mpicc CXX=mpicxx FC=mpif90 F77=mpif90
./configure --prefix=$1 --enable-fortran --enable-static=yes --with-zlib=/usr/lib --enable-parallel --enable-shared CFLAGS="-O3 -fPIC -Wno-incompatible-pointer-types-discards-qualifiers -Wno-non-literal-null-conversion" FCFLAGS="-O3 -fPIC" LDFLAGS="-Wl,--build-id"
sed -i '11835c wl="-Wl,"' libtool
make -j16
make install
