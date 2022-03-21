#!/bin/bash
set -e
cd ${JARVIS_TMP}
#install ucx
tar -xvf ${JARVIS_DOWNLOAD}/ucx-1.12.0.tar.gz
cd ucx
./autogen.sh
./contrib/configure-release --prefix=$1/ucx
make -j8
make install
#install openmpi
tar -xvf ${JARVIS_DOWNLOAD}/openmpi-4.1.2.tar.gz
cd openmpi-4.1.2
CPP=cpp CC=nvc CFLAGS='-DNDEBUG -O1 -nomp -fPIC -fno-strict-aliasing -tp=haswell' CXX=nvc++ CXXFLAGS='-DNDEBUG -O1 -nomp -fPIC -finline-functions -tp=haswell' F77=nvfortran F90=nvfortran FC=nvfortran FCFLAGS='-O1 -nomp -fPIC -tp=haswell' FFLAGS='-fast -Mipa=fast,inline -tp=haswell' LDFLAGS=-Wl,--as-needed ./configure --prefix=$1 --disable-debug --disable-getpwuid --disable-mem-debug --disable-mem-profile --disable-memchecker --disable-static --enable-mca-no-build=btl-uct --enable-mpi1-compatibility --enable-oshmem --with-cuda=/usr/local/cuda --with-ucx=$1/ucx --enable-mca-no-build=op-avx
make -j8
make install

export LIBRARY_PATH=$1/lib:$LIBRARY_PATH
export PATH=$1/bin:$PATH \
UCX_IB_PCI_RELAXED_ORDERING=on \
UCX_MAX_RNDV_RAILS=1 \
UCX_MEMTYPE_CACHE=n \
UCX_MEMTYPE_REG_WHOLE_ALLOC_TYPES=cuda \
UCX_TLS=rc_v,sm,cuda_copy,cuda_ipc,gdr_copy (or UCX_TLS=all)
