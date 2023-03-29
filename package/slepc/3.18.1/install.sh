#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://slepc.upv.es/download/distrib/slepc-3.18.1.tar.gz
cd ${JARVIS_TMP}
rm -rf slepc-3.18.1
tar -xvf ${JARVIS_DOWNLOAD}/slepc-3.18.1.tar.gz
cd slepc-3.18.1
PETSC_PATH=${PETSC_PATH}
PETSC_DIR=${PETSC_PATH} ./configure --prefix=$1 --with-clean
make SLEPC_DIR=${JARVIS_TMP}/slepc-3.18.1 PETSC_DIR=${PETSC_PATH} -j
make SLEPC_DIR=${JARVIS_TMP}/slepc-3.18.1 PETSC_DIR=${PETSC_PATH} install -j