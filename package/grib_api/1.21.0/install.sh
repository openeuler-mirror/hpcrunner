#download from $JARVIS_PROXY/weathersource/grib_api/archive/refs/tags/v1.21.0.tar.gz
#module  load  bisheng/4.1.0   hmpi/2.4.3  hdf5-clang/1.12.0  netcdf-clang/4.7.4  pnetcdf/1.11.2 
#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u  $JARVIS_PROXY/weathersource/grib_api/archive/refs/tags/v1.21.0.tar.gz grib_api-1.21.0.tar.gz
cd ${JARVIS_TMP}
rm -rf grib_api-1.21.0
tar  -xvf ${JARVIS_DOWNLOAD}/grib_api-1.21.0.tar.gz
cd grib_api-1.21.0
CC=mpicc F77=mpifort FC=mpifort ./configure --with-netcdf=${NETCDF_CLANG_PATH} --prefix=${1} --build=aarch64-unknown-linux-gnu --disable-jpeg
sed -i '10270c wl="-Wl,"' libtool
make
make VERBOSE=1
make install
