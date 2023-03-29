#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://www.netlib.org/scalapack/scalapack-2.1.0.tgz
cd ${JARVIS_TMP}
rm -rf scalapack-2.1.0
tar -xvf ${JARVIS_DOWNLOAD}/scalapack-2.1.0.tgz
cd scalapack-2.1.0
rm -rf build
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$1 -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_SHARED_LIBS=ON -DBLAS_LIBRARIES=/usr/local/kml/lib/kblas/omp/libkblas.so -DLAPACK_LIBRARIES=/usr/local/kml/lib/libklapack_full.so -DCMAKE_C_COMPILER=mpicc -DCMAKE_Fortran_COMPILER=mpif90 ..
make -j
make install