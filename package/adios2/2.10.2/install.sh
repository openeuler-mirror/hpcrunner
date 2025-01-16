#!/bin/bash
set -x
set -e
adios2_version="2.10.2"
. ${DOWNLOAD_TOOL} -u https://github.com/ornladios/ADIOS2/archive/refs/tags/v${adios2_version}.tar.gz -f ADIOS2-${adios2_version}.tar.gz
. $CHECK_DEPS mpicc
. $CHECK_DEPS HDF5
. $CHECK_ROOT && yum install -y bzip2 bzip2-devel
cd ${JARVIS_TMP}
rm -rf ADIOS2-${adios2_version}
tar -xvf ${JARVIS_DOWNLOAD}/ADIOS2-${adios2_version}.tar.gz
cd ADIOS2-${adios2_version}
mkdir -p build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$1 -DUCX_LIBRARIES=${HMPI_PATH}/hucx/lib/libucp.so -DCMAKE_C_FLAGS="-I${HMPI_PATH}/hucx/include" -DCMAKE_CXX_FLAGS="-L${HMPI_PATH}/hucx/lib -lucs"
make -j
make install
