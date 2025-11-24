#!/bin/bash
set -x
. ${DOWNLOAD_TOOL} -u https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.19.6.tar.gz
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.11/src/hdf5-1.10.11.tar.bz2
mkdir ${JARVIS_TMP}/petsc-opt-shared
cd ${JARVIS_TMP}/petsc-opt-shared
rm -rf petsc-3.19.6
tar -xvf ${JARVIS_DOWNLOAD}/petsc-3.19.6.tar.gz
cd petsc-3.19.6
./configure CFLAGS="-Ofast -mcpu=hip11 -fPIC -lm" CXXFLAGS="-Ofast -mcpu=hip11 -fPIC -lm" \
        FFLAGS="-Ofast -mcpu=hip11 -fPIC" F77=$F77 \
        --with-cc=mpicc --with-cxx=mpicxx --with-fc=mpifort \
        --with-debugging=0 \
        --prefix=$1 \
        --download-parmetis=1 --download-metis=1 \
        --download-hdf5=${JARVIS_DOWNLOAD}/hdf5-1.10.11.tar.bz2 --force
make PETSC_DIR=${JARVIS_TMP}/petsc-opt-shared/petsc-3.19.6 PETSC_ARCH=arch-linux-c-opt all -j
make PETSC_DIR=${JARVIS_TMP}/petsc-opt-shared/petsc-3.19.6 PETSC_ARCH=arch-linux-c-opt install -j
