#!/bin/bash
set -x
set -e

export CC=mpicc CXX=mpicxx FC=mpifort
export ESMF_ABI=64
export ESMF_BOPT=O
export ESMF_OPTLEVEL=3
export ESMF_C=mpicc
export ESMF_COMM=openmpi
export ESMF_COMPILER=gfortran
export ESMF_CXX=mpicxx
export ESMF_DIR=${JARVIS_TMP}/esmf-8.7.0
export ESMF_F90=mpif90
export ESMF_INSTALL_PREFIX=$1
export ESMF_NETCDF=nc-config
export ESMF_INSTALL_MODDIR=include
export ESMF_INSTALL_LIBDIR=lib
export ESMF_INSTALL_BINDIR=bin

if [ -z "${NETCDF_PATH}" ]; then
    echo "NETCDF_PATH environment variable does not exist "
    exit 0
fi
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/esmf-org/esmf/archive/refs/tags/v8.7.0.tar.gz -f esmf-8.7.0.tar.gz 
cd ${JARVIS_TMP}
tar xf ${JARVIS_DOWNLOAD}/esmf-8.7.0.tar.gz
cd esmf-8.7.0
make -j64
make install
