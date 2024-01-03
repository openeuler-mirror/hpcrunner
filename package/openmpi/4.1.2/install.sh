#!/bin/bash
set -x
set -e
ucx_version='1.12.1'
openmpi_ver='4.1.2'
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/openucx/ucx/releases/download/v${ucx_version}/ucx-${ucx_version}.tar.gz
. ${DOWNLOAD_TOOL} -u https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-${openmpi_ver}.tar.gz
#install ucx
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/ucx-${ucx_version}.tar.gz
cd ucx-${ucx_version}
./contrib/configure-release --prefix=$1/ucx --enable-optimizations --disable-logging --disable-debug --disable-assertions --disable-params-check --disable-doxygen-doc --with-verbs
make -j 32
make install

#install openmpi
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/openmpi-${openmpi_ver}.tar.gz
cd openmpi-${openmpi_ver}
./configure --prefix=$1 --enable-pretty-print-stacktrace --enable-orterun-prefix-by-default --with-cma --with-ucx=$1/ucx --enable-mpi1-compatibility
make -j install