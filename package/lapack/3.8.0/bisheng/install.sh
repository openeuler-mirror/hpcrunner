#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/lapack-3.8.0.tgz
cd lapack-3.8.0
cp make.inc.example make.inc
sed -i '11s/gcc/clang/g' ./make.inc
sed -i '12s/$/& -march=native/g' ./make.inc
sed -i '22s/gfortran/flang/g' ./make.inc
sed -i '23s/-frecursive$//g' ./make.inc
sed -i '25s/-frecursive$//g' ./make.inc
sed -i '30s/gfortran/flang/g' ./make.inc
sed -i '50s/^/#  /g' ./make.inc
sed -i '54s/^#//g' ./make.inc
make -j
mkdir $1/lib/
cp *.a $1/lib/
