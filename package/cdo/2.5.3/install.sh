#!/bin/bash
set -x
set -e
cdo_ver='2.5.3'
export CC=mpicc CXX=mpicxx FC=mpifort
if [ -z "${HDF5_PATH}" ] || [ -z "${NETCDF_PATH}" ]; then
    echo "HDF5_PATH and NETCDF_PATH environment variable does not exist "
    exit 0
fi
. ${DOWNLOAD_TOOL} -u https://code.mpimet.mpg.de/attachments/download/30045/cdo-${cdo_ver}.tar.gz 
cd ${JARVIS_TMP}
tar xf ${JARVIS_DOWNLOAD}/cdo-${cdo_ver}.tar.gz
cd cdo-${cdo_ver}
./configure --prefix=$1 --with-hdf5=${HDF5_PATH} --with-netcdf=${NETCDF_PATH}
make -j
make install
