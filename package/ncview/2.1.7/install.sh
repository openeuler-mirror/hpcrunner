#!/bin/bash

# download from ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.7.tar.gz
. $CHECK_ROOT && yum install libX11 libX11-devel libXaw libXaw-devel libpng-devel libpng
set -x
set -e
. ${DOWNLOAD_TOOL} -u ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.7.tar.gz 

cd ${JARVIS_TMP}
rm -rf ncview-2.1.7
tar -xvf ${JARVIS_DOWNLOAD}/ncview-2.1.7.tar.gz
cd ncview-2.1.7
NETCDF_DIR=${1%/*/*}/netcdf-clang/4.7.0
UDUNITS_DIR=${1%/*/*}/udunits/2.2.28

./configure --prefix=$1 --with-nc-config=${NETCDF_DIR}/bin/nc-config -with-udunits2_incdir=${UDUNITS_DIR}/include -with-udunits2_libdir=${UDUNITS_DIR}/lib 

make -j
make install
