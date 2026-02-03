#!/bin/bash
set -x
set -e
. $DOWNLOAD_TOOL -u http://www.netlib.org/lapack/lapack-3.4.2.tgz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/lapack-3.4.2.tgz
cd lapack-3.4.2
cp make.inc.example make.inc
sed -i '45s/gcc/clang/g' ./make.inc
sed -i '15s/gfortran/flang/g' ./make.inc
sed -i '19s/gfortran/flang/g' ./make.inc
rm build -rf
mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=$1 -DBUILD_SHARED_LIBS=ON
make -j $(nproc)
make install
ln -s $1/lib64 $1/lib

cd ..
sed -i "s|\$(TOPSRCDIR)|$1/lib64|g" make.inc
make -j $(nproc) blaslib

