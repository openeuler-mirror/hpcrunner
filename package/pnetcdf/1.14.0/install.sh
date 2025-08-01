#!/bin/bash
set -x
set -e
pnetcdf_version='1.14.0'
. ${DOWNLOAD_TOOL} -u https://parallel-netcdf.github.io/Release/pnetcdf-${pnetcdf_version}.tar.gz
cd ${JARVIS_TMP}
tar zxvf ${JARVIS_DOWNLOAD}/pnetcdf-${pnetcdf_version}.tar.gz
cd pnetcdf-${pnetcdf_version}
./configure --prefix=$1 --build=aarch64-linux --enable-shared --enable-fortran --enable-large-file-test CFLAGS="-fPIC -DPIC" CXXFLAGS="-fPIC -DPIC" FCFLAGS="-fPIC" FFLAGS="-fPIC" CC=mpicc CXX=mpicxx FC=mpifort F77=mpifort FFLAGS="-fallow-argument-mismatch" FCFLAGS="-fallow-argument-mismatch" 
make -j16
make install
