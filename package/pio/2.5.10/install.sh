#!/bin/bash
set -x
set -e
pio_ver="2_5_10"
. ${DOWNLOAD_TOOL} -u https://github.com/NCAR/ParallelIO/archive/refs/tags/pio${pio_ver}.tar.gz -f pio${pio_ver}.tar.gz
cd ${JARVIS_TMP}
rm -rf ParallelIO-pio${pio_ver}
tar -xvf ${JARVIS_DOWNLOAD}/pio${pio_ver}.tar.gz
cd ParallelIO-pio${pio_ver}

export CPPFLAGS="-I$PNETCDF_PATH/include -I$NETCDF_CLANG_PATH/include -I$HDF5_CLANG_PATH/include"
export LDFLAGS="-L$PNETCDF_PATH/lib -L$NETCDF_CLANG_PATH/lib"
export CC=mpicc FC=mpifort
export CFLAGS="-g -Wall ${CFLAGS}"
#cmake -DNETCDF_C_PATH=${NETCDF_CLANG_PATH} -DNETCDF_FORTRAN_PATH=${NETCDF_CLANG_PATH} -DPNETCDF_PATH=${PNETCDF_PATH} -DHDF5_PATH=${HDF5_PATH}-DCMAKE_INSTALL_PREFIX=$1 ..
autoreconf --install
autoconf
./configure --enable-fortran --prefix=$1
sed -i "s/lt_prog_compiler_wl_FC=''/lt_prog_compiler_wl_FC='-Wl,'/g" config.status
make install
