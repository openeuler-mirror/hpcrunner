#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.18.1.tar.gz
cd ${JARVIS_TMP}
rm -rf petsc-3.18.1
tar -xvf ${JARVIS_DOWNLOAD}/petsc-3.18.1.tar.gz
cd petsc-3.18.1
./configure F77=$F77 --prefix=$1 --with-cc=mpicc --with-cxx=mpicxx --with-fc=mpifort --force
make PETSC_DIR=${JARVIS_TMP}/petsc-3.18.1 PETSC_ARCH=arch-linux-c-debug all -j
make PETSC_DIR=${JARVIS_TMP}/petsc-3.18.1 PETSC_ARCH=arch-linux-c-debug install -j
sed -i 's/--oversubscribe/--oversubscribe --mca coll ^ucx/g' ${JARVIS_TMP}/petsc-3.18.1/arch-linux-c-debug/tests/ksp/ksp/tutorials/runex54f_hem.sh