#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.19.6.tar.gz
cd ${JARVIS_TMP}
rm -rf petsc-3.19.6
tar -xvf ${JARVIS_DOWNLOAD}/petsc-3.19.6.tar.gz
cd petsc-3.19.6
./configure F77=$F77 --prefix=$1 --with-cc=mpicc --with-cxx=mpicxx --with-fc=mpifort \
	--download-parmetis=1 --download-metis=1 \
	--download-hdf5=/root/test/hpcrunner/downloads/hdf5-1.13.0.tar.bz2 --force
make PETSC_DIR=${JARVIS_TMP}/petsc-3.19.6 PETSC_ARCH=arch-linux-c-debug all -j
make PETSC_DIR=${JARVIS_TMP}/petsc-3.19.6 PETSC_ARCH=arch-linux-c-debug install -j
