#!/bin/bash
set -e
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.15/src/hdf-4.2.15.tar.gz
cd ${JARVIS_TMP}
rm -rf hdf-4.2.15
tar -xvf ${JARVIS_DOWNLOAD}/hdf-4.2.15.tar.gz
cd hdf-4.2.15/
yum install -y libtirpc-devel
sed -i '974c #if defined(__linux__) && defined __x86_64__ && !( defined SUN) || defined(__aarch64__)' hdf/src/hdfi.h
sed -i '23660a LIBS="$LIBS -ltirpc"' configure
sed -i '23662c CPPFLAGS="$SYSCPPFLAGS -I/usr/include/tirpc"' configure
sed -i 'N; s/\n\(static int32_t \*.*\)/ || defined __aarch64__\n\1/; P; D' mfhdf/libsrc/xdrposix.c
sed -i '/^\.c.lo:/{:a; $!N; /-MT/!ba; s/-MT/-std=c89 &/}' mfhdf/libsrc/Makefile.in
for file in \
  hdf/test/Makefile.in \
  hdf/util/Makefile.in \
  mfhdf/test/Makefile.in \
  mfhdf/ncdump/Makefile.in \
  mfhdf/ncgen/Makefile.in \
  mfhdf/hdfimport/Makefile.in \
  mfhdf/hdiff/Makefile.in
do
  sed -i '/^\.c\.o:/{:a; $!N; /-MT/!ba; s/-MT/-std=c89 &/}' "$file"
done
export CC=mpicc CXX=mpicxx FC=mpifort
./configure --prefix=$1 --enable-production --with-zlib=/usr --enable-fortran --enable-hdf4-xdr --disable-shared --build=arm-linux  --with-jpeg=${LIBJPEG_PATH} --disable-netcdf CFLAGS="-fPIC -Wno-error=int-conversion" CXXFLAGS="-fPIC" FFLAGS="-fPIC" LDFLAGS="-L/usr/lib64 -ltirpc" CPPFLAGS="-I/usr/include/tirpc" --build=aarch64-unknown-linux-gnu
make -j
make install
