#!/bin/bash

set -x
set -e
pnetcdf_ver='1.9.0'
. ${DOWNLOAD_TOOL} -u https://parallel-netcdf.github.io/Release/parallel-netcdf-1.9.0.tar.gz
cd ${JARVIS_TMP}
rm -rf pnetcdf-${pnetcdf_ver}
tar zxvf ${JARVIS_DOWNLOAD}/parallel-netcdf-1.9.0.tar.gz
cd parallel-netcdf-1.9.0
use_gcc=0
which_mpicc=`which mpicc 2> /dev/null 1> /dev/null`
which_ret=$?
if [ "$which_ret" -eq "0" ]; then
        if [ "`mpicc --version | grep gcc`" ]; then
                use_gcc=1
        fi
fi
FFLAGS=""
FCFLAGS=""
if [ "$use_gcc" -eq "1" ]; then
        if [ "`$CC --version | grep gcc | grep -oP \"\)\s*\K[0-9]+(?=\.)\"`" -ge '10' ]; then
                FFLAGS="-fallow-argument-mismatch"
                FCFLAGS="-fallow-argument-mismatch"
        fi
fi
./configure --prefix=$1 --enable-shared --enable-fortran --enable-large-file-test FFLAGS="$FFLAGS" FCFLAGS="$FCFLAGS"
make -j16
make install