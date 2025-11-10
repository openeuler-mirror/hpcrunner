#!/bin/bash
set -x
set -e
pnetcdf_version='1.12.1'
#. ${DOWNLOAD_TOOL} -u http://cucis.ece.northwestern.edu/projects/PnetCDF/Release/pnetcdf-${pnetcdf_version}.tar.gz
. ${DOWNLOAD_TOOL} -u https://gitee.com/kp-hpc-mod/hpc-src/raw/master/pnetcdf/pnetcdf-1.12.1.tar.gz
cd ${JARVIS_TMP}
rm -rf pnetcdf-${pnetcdf_version}
tar zxvf ${JARVIS_DOWNLOAD}/pnetcdf-${pnetcdf_version}.tar.gz
cd pnetcdf-${pnetcdf_version}
use_gcc=0
which mpicc 2> /dev/null 1> /dev/null
if [ "$?" -eq "0" ]; then
        if [ "`mpicc --version | grep gcc`" ]; then
                use_gcc=1
        fi
fi
FFLAGS=""
FCFLAGS=""
if [ "$use_gcc" -eq "1" ]; then
        if [ "`mpicc --version | grep gcc | grep -oP \"\)\s*\K[0-9]+(?=\.)\"`" -ge '10' ]; then
                FFLAGS="-fallow-argument-mismatch"
                FCFLAGS="-fallow-argument-mismatch"
        fi
fi
if [ x"$(arch)" = xaarch64 ];then
    build_type='--build=aarch64-linux'
else
    build_type=''
fi
./configure --prefix=$1 ${build_type} --enable-shared --enable-fortran --enable-large-file-test FFLAGS="$FFLAGS" FCFLAGS="$FCFLAGS"
make -j16
make install
