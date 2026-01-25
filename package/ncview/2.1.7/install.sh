#!/bin/bash

# download from ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.7.tar.gz
. $CHECK_ROOT && yum install libX11 libX11-devel libXaw libXaw-devel libpng-devel libpng
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://src.fedoraproject.org/repo/pkgs/ncview/ncview-2.1.7.tar.gz/debd6ca61410aac3514e53122ab2ba07/ncview-2.1.7.tar.gz

cd ${JARVIS_TMP}
rm -rf ncview-2.1.7
tar -xvf ${JARVIS_DOWNLOAD}/ncview-2.1.7.tar.gz
cd ncview-2.1.7
NETCDF_DIR=${1%/*/*}/netcdf-clang/4.7.0
UDUNITS_DIR=${1%/*/*}/udunits/2.2.28

CC=mpicc CXX=mpicxx FC=mpifort ./configure LDFLAGS="-L${NETCDF_CLANG_PATH}/lib -L${HDF5_CLANG_PATH}/lib -L${PNETCDF_PATH}/lib" CPPFLAGS="-I${NETCDF_CLANG_PATH}/include -I${HDF5_CLANG_PATH}/include -I${PNETCDF_PATH}/include" --prefix=${JARVIS_ROOT}/software/apps/bisheng/ncview/2.1.7 --with-nc-config=${NETCDF_CLANG_PATH}/bin/nc-config --with-udunits2_incdir=${UDUNITS_PATH}/include --with-udunits2_libdir=${UDUNITS_PATH}/lib CFLAGS="-Wno-implicit-function-declaration -Wno-implicit-int -Wno-int-conversion"

make -j
make install
