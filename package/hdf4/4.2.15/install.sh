#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.15/src/hdf-4.2.15.tar.gz
cd ${JARVIS_TMP}
rm -rf hdf-4.2.15
tar -xvf ${JARVIS_DOWNLOAD}/hdf-4.2.15.tar.gz
cd hdf-4.2.15
sed -i '974c #if defined(__linux__) && defined __x86_64__ && !( defined SUN) || defined(__aarch64__)' hdf/src/hdfi.h
sed -i '23660a LIBS="$LIBS -ltirpc"' configure
sed -i '23662c CPPFLAGS="$SYSCPPFLAGS -I/usr/include/tirpc"' configure
export CC=mpicc CXX=mpicxx FC=mpifort
./configure --prefix=$1 --enable-production --with-zlib=/usr/lib64 --enable-fortran --enable-hdf4-xdr --disable-shared --build=arm-linux  --with-jpeg=${LIBJPEG_PATH} --disable-netcdf CFLAGS="-fPIC -Wno-error=int-conversion" CXXFLAGS="-fPIC -Wno-error=int-conversion" FFLAGS="-fPIC -fallow-argument-mismatch -Wno-error=int-conversion"
make -j
make install
