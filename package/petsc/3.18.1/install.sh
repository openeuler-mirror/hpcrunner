#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/petsc/petsc/archive/refs/tags/v3.18.1.tar.gz
cd ${JARVIS_TMP}
rm -rf petsc-3.18.1
mv ${JARVIS_DOWNLOAD}/v3.18.1.tar.gz ${JARVIS_DOWNLOAD}/petsc-3.18.1.tar.gz
tar -xvf ${JARVIS_DOWNLOAD}/petsc-3.18.1.tar.gz
cd petsc-3.18.1
./configure F77=$F77 --prefix=$1 --with-cc=mpicc --with-cxx=mpicxx --with-fc=mpifort --force --download-fblaslapack=1
make PETSC_DIR=${JARVIS_TMP}/petsc-3.18.1 PETSC_ARCH=arch-linux-c-debug all -j
make PETSC_DIR=${JARVIS_TMP}/petsc-3.18.1 PETSC_ARCH=arch-linux-c-debug install -j
sed -i 's/--oversubscribe/--oversubscribe --mca coll ^ucx/g' ${JARVIS_TMP}/petsc-3.18.1/arch-linux-c-debug/tests/ksp/ksp/tutorials/runex54f_hem.sh
