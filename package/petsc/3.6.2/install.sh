#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.6.2.tar.gz
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.11/src/hdf5-1.10.11.tar.bz2
cd ${JARVIS_TMP}
rm -rf petsc-3.6.2
tar -xvf ${JARVIS_DOWNLOAD}/petsc-3.6.2.tar.gz
cd petsc-3.6.2
export PETSC_DIR=${JARVIS_TMP}/petsc-3.6.2 PETSC_ARCH=linux_gnu
./configure CFLAGS="-fPIC -Wno-implicit-int -Wno-int-conversion" FFLAGS="-fPIC" F90=$F90 --prefix=$1 --with-cc=mpicc --with-cxx=mpicxx --with-fc=mpifort \
	--with-shared-libraries=0 \
        --download-parmetis=1 --download-metis=1 \
        --download-hdf5=${JARVIS_DOWNLOAD}/hdf5-1.10.11.tar.bz2 --force
make MAKE_NP=64
make check
make test
