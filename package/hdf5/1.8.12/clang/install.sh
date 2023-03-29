#!/bin/bash
set -x
set -e
hdf5_ver='1.8.12'
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-${hdf5_ver}/src/hdf5-${hdf5_ver}.tar.gz
cd ${JARVIS_TMP}
rm -rf hdf5-${hdf5_ver}
tar -xvf ${JARVIS_DOWNLOAD}/hdf5-${hdf5_ver}.tar.gz
cd hdf5-${hdf5_ver}
if [ x"$(arch)" = xaarch64 ];then
    build_type='--build=aarch64-unknown-linux-gnu'
else
    build_type=''
fi
./configure --prefix=$1 ${build_type} --enable-fortran --enable-static=yes --enable-parallel --enable-shared CFLAGS="-O3 -fPIC -Wno-incompatible-pointer-types-discards-qualifiers -Wno-non-literal-null-conversion" FCFLAGS="-O3 -fPIC"
sed -i '10121c wl="-Wl,"' libtool
sed -i '10270c wl="-Wl,"' libtool
make -j
make install