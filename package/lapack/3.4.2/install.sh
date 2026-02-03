#!/bin/bash
set -x
set -e
. $DOWNLOAD_TOOL -u http://www.netlib.org/lapack/lapack-3.4.2.tgz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/lapack-3.4.2.tgz
cd lapack-3.4.2
cp make.inc.example make.inc
sed -i '25c set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fallow-argument-mismatch -w")' CMakeLists.txt
rm build -rf
mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=$1 -DBUILD_SHARED_LIBS=ON
make -j $(nproc)
make install
ln -s $1/lib64 $1/lib

