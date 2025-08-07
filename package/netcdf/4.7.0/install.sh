#!/bin/bash
#https://codeload.github.com/Unidata/netcdf-c/tar.gz/refs/tags/v4.7.0
#https://codeload.github.com/Unidata/netcdf-fortran/tar.gz/refs/tags/v4.4.5

set -x
set -e
. ${DOWNLOAD_TOOL} -u https://codeload.github.com/Unidata/netcdf-fortran/tar.gz/refs/tags/v4.4.5 -f netcdf-fortran-4.4.5.tar.gz
. ${DOWNLOAD_TOOL} -u https://codeload.github.com/Unidata/netcdf-c/tar.gz/refs/tags/v4.7.0 -f netcdf-c-4.7.0.tar.gz 
cd ${JARVIS_TMP}
rm -rf netcdf-c-4.7.0 netcdf-fortran-4.4.5
tar -xvf ${JARVIS_DOWNLOAD}/netcdf-c-4.7.0.tar.gz
tar -xvf ${JARVIS_DOWNLOAD}/netcdf-fortran-4.4.5.tar.gz
cd netcdf-c-4.7.0
HDF5_DIR=${HDF5_PATH}
PNETCDF_DIR=${PNETCDF_PATH}
./configure --prefix=$1 --build=aarch64-unknown-linux-gnu --enable-shared --enable-netcdf-4 --enable-dap --with-pic --disable-doxygen --enable-static --enable-pnetcdf --enable-largefile CPPFLAGS="-I${HDF5_DIR}/include -I${PNETCDF_DIR}/include" LDFLAGS="-L${HDF5_DIR}/lib -L${PNETCDF_DIR}/lib -Wl,-rpath=${HDF5_DIR}/lib -Wl,-rpath=${PNETCDF_DIR}/lib" CFLAGS="-L${HDF5_DIR}/lib -L${PNETCDF_DIR}/lib -I${HDF5_DIR}/include -I${PNETCDF_DIR}/include"

make -j16
make install

export PATH=$1/bin:$PATH
export LD_LIBRARY_PATH=$1/lib:$LD_LIBRARY_PATH
export NETCDF=${1}

cd ../netcdf-fortran-4.4.5
./configure --prefix=$1 --build=aarch64-unknown-linux-gnu --enable-shared --with-pic --disable-doxygen --enable-largefile --enable-static CPPFLAGS="-I${HDF5_DIR}/include -I${1}/include" LDFLAGS="-L${HDF5_DIR}/lib -L${1}/lib -Wl,-rpath=${HDF5_DIR}/lib -Wl,-rpath=${1}/lib" CFLAGS="-L${HDF5_DIR}/HDF5/lib -L${1}/lib -I${HDF5_DIR}/include -I${1}/include" CXXFLAGS="-L${HDF5_DIR}/lib -L${1}/lib -I${HDF5_DIR}/include -I${1}/include" FCFLAGS="-fallow-argument-mismatch -L${HDF5_DIR}/lib -L${1}/lib -I${HDF5_DIR}/include -I${1}/include"
sed -i '11838c wl="-Wl,"' libtool
make -j16
make install
