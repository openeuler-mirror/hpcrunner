#!/bin/bash
set -x
set -e
sudo yum groupinstall 'Development Tools'
sudo . $CHECK_ROOT && yum install dkms rpm-build make check check-devel subunit subunit-devel
cd ${JARVIS_TMP}
ucx_version='1.12.1'
gdr_ver='2.3'
openmpi_ver='4.0.1'
#install GDRCOPY
. ${DOWNLOAD_TOOL} -u https://github.com/NVIDIA/gdrcopy/archive/v${gdr_ver}.tar.gz
. ${DOWNLOAD_TOOL} -u https://github.com/openucx/ucx/releases/download/v${ucx_version}/ucx-${ucx_version}.tar.gz
. ${DOWNLOAD_TOOL} -u https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-${openmpi_ver}.tar.gz
tar -x -f ${JARVIS_DOWNLOAD}/v${gdr_ver}.tar.gz
mkdir -p $1/gdrcopy/include $1/gdrcopy/lib64
cd gdrcopy-${gdr_ver}
make PREFIX=$1/gdrcopy lib lib_install

#install ucx
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/ucx-${ucx_version}.tar.gz
cd ucx-${ucx_version}
./autogen.sh
./contrib/configure-release --prefix=$1/ucx --enable-optimizations --disable-logging --disable-debug --disable-assertions --disable-params-check --disable-doxygen-doc --with-cuda=/usr/local/cuda --with-gdrcopy=$1/gdrcopy/ --with-verbs --with-rdmacm
make -j 32
make install

#install openmpi
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/openmpi-${openmpi_ver}.tar.gz
cd openmpi-${openmpi_ver}
./configure --prefix=$1 CPP=cpp CC=nvc CXX=nvc++ F77=nvfortran F90=nvfortran FC=nvfortran LDFLAGS=-Wl,--as-needed --disable-debug --disable-getpwuid --disable-mem-debug --disable-mem-profile --disable-memchecker --disable-static --enable-mca-no-build=btl-uct --enable-mpi1-compatibility --enable-oshmem --enable-mpirun-prefix-by-default --enable-cuda --enable-dlopen --enable-weak-symbols --enable-heterogeneous --enable-binaries --enable-script-wrapper-compilers --enable-orterun-prefix-by-default --enable-mca-no-build=btl-uct --with-cuda --with-ucx=$1/ucx
make -j
make install