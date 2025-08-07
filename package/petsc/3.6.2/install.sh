#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.6.2.tar.gz
. ${DOWNLOAD_TOOL} -u https://ftp.mcs.anl.gov/pub/petsc/externalpackages/parmetis-4.0.3-p2.tar.gz
. ${DOWNLOAD_TOOL} -u http://ftp.mcs.anl.gov/pub/petsc/externalpackages/metis-5.1.0-p1.tar.gz
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.11/src/hdf5-1.10.11.tar.bz2

yum install -y lapack lapack-devel

cd ${JARVIS_TMP}
rm -rf petsc-3.6.2
tar -xvf ${JARVIS_DOWNLOAD}/petsc-3.6.2.tar.gz
cd petsc-3.6.2
export PETSC_DIR=${JARVIS_TMP}/petsc-3.6.2 PETSC_ARCH=arch-linux-c-debug
./configure CFLAGS="-fPIC -Wno-implicit-int -Wno-int-conversion" FFLAGS="-fPIC" F90=$F90 --prefix=$1 --with-cc=mpicc --with-cxx=mpicxx --with-fc=mpifort \
	--with-shared-libraries=0 \
	--with-make-np=64 \
	--download-parmetis=${JARVIS_DOWNLOAD}/parmetis-4.0.3-p2.tar.gz \
	--download-metis=${JARVIS_DOWNLOAD}/metis-5.1.0-p1.tar.gz \
	--download-hdf5=${JARVIS_DOWNLOAD}/hdf5-1.10.11.tar.bz2 \
	--force

make MAKE_NP=64
make check
make test
