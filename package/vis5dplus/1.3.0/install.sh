#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://sourceforge.net/projects/vis5d/files/vis5d/vis5d%2B-1.3.0-beta/vis5d%2B-1.3.0-beta.tar.gz
cd ${JARVIS_TMP}
rm -rf vis5d+-1.3.0-beta
tar -xvf ${JARVIS_DOWNLOAD}/vis5d%2B-1.3.0-beta.tar.gz
cd vis5d+-1.3.0-beta
cd src
patch -p0 < ${JARVIS_ROOT}/package/vis5dplus/1.3.0/script.c.patch
cd -
sed -i '40c extern float vis_round( float x ); ' src/misc.h
sed -i '150c float vis_round(float x)' src/misc.c
FFLAGS='-fno-range-check -fallow-rank-mismatch' LDFLAGS=-L${MESA_PATH}/lib CFLAGS=-I${MESA_PATH}/include CPPFLAGS=-I${MESA_PATH}/include ./configure --prefix=$1 --disable-fortran --with-netcdf=${NETCDF_PATH} --disable-shared --build=aarch64-unknown-linux-gnu

make
make install 
