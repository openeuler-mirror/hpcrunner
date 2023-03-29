#!/bin/bash
set -x
set -e
openmpi_ver='4.0.1'
. ${DOWNLOAD_TOOL} -u https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-${openmpi_ver}.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/openmpi-${openmpi_ver}.tar.gz
cd openmpi-${openmpi_ver}
./configure CC=gcc CXX=g++ FC=gfortran --prefix=$1 --enable-pretty-print-stacktrace --enable-orterun-prefix-by-default --enable-mpi1-compatibility
make -j install
