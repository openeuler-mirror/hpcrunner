#download from https://github.com/weathersource/grib_api/archive/refs/tags/v1.21.0.tar.gz
#module  load  bisheng2/2.1.0   hmpi1/1.1.1   netcdf/4.7.0   pnetcdf/1.11.2 
#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u  https://github.com/weathersource/grib_api/archive/refs/tags/v1.21.0.tar.gz grib_api-1.21.0.tar.gz
cd ${JARVIS_TMP}
rm -rf grib_api-1.21.0
tar  -xvf ${JARVIS_DOWNLOAD}/grib_api-1.21.0.tar.gz
cd grib_api-1.21.0
mkdir build
cd build
export CC=mpicc CXX=mpicxx FC=mpifort F77=mpifort
cmake .. -DCMAKE_INSTALL_PREFIX=$1
NETCDF_PATH=$1
NETCDF_PATH=${JARVIS_DOWNLOAD%/*}
NETCDF_PATH=${NETCDF_PATH}/software/libs/bisheng2/hmpi1/netcdf/4.7.0/lib
sed -i "s%NETCDF_netcdf_LIBRARY_RELEASE:FILEPATH=NETCDF_netcdf_LIBRARY_RELEASE-NOTFOUND%NETCDF_netcdf_LIBRARY_RELEASE:FILEPATH=${NETCDF_PATH}/libnetcdf.so%g" ./CMakeCache.txt
make VERBOSE=1
make install
