#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.3/src/hdf5-1.10.3.tar.gz
cd ${JARVIS_TMP}
rm -rf hdf5-1.10.3
tar -xvf ${JARVIS_DOWNLOAD}/hdf5-1.10.3.tar.gz
cd hdf5-1.10.3
export CC=mpicc CXX=mpicxx FC=mpif90 F77=mpif90
./configure --prefix=$1 --enable-fortran --enable-static=yes --enable-parallel --enable-shared CFLAGS="-O3 -fPIC -Wno-incompatible-pointer-types-discards-qualifiers -Wno-non-literal-null-conversion" FCFLAGS="-O3 -fPIC" LDFLAGS="-Wl,--build-id"
sed -i '11835c wl="-Wl,"' libtool
make -j
make install
