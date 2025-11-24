#!/bin/bash

set -x
set -e
. ${DOWNLOAD_TOOL} -u https://sourceforge.net/projects/nco/files/nco-5.1.4.tar.gz
cd ${JARVIS_TMP}
rm -rf nco-5.1.4
tar zxvf ${JARVIS_DOWNLOAD}/nco-5.1.4.tar.gz
cd nco-5.1.4
echo ${UDUNITS_PATH}
export NETCDF_INC=${NETCDF_PATH}/include 
export NETCDF_LIB=${NETCDF_PATH}/lib 
./configure CPPFLAGS="-I${ANTLR_PATH}/include -I${UDUNITS_PATH}/include" CFLAGS="-L${ANTLR_PATH}/lib -I${NETCDF_PATH}/include -I${UDUNITS_PATH}/include -L${UDUNITS_PATH}/lib " --prefix=$1
make
make install
