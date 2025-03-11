#!/bin/bash
set -x
set -e
. $DOWNLOAD_TOOL -u $JARVIS_PROXY/Reference-LAPACK/lapack/archive/refs/tags/v3.10.1.tar.gz 
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/lapack-3.10.1.tar.gz
cd lapack-3.10.1
cp make.inc.example make.inc
sed -i '9s/gcc/clang/g' ./make.inc
sed -i '10s/$/& -march=native/g' ./make.inc
sed -i '20s/gfortran/flang/g' ./make.inc
sed -i '21s/-frecursive$//g' ./make.inc
sed -i '23s/-frecursive$//g' ./make.inc
sed -i '30s/gfortran/flang/g' ./make.inc
sed -i '46s/^/#  /g' ./make.inc
sed -i '50s/^#//g' ./make.inc
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