#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
. ${DOWNLOAD_TOOL} -u http://www.netlib.org/scalapack/scalapack-2.1.0.tgz
rm -rf scalapack-2.1.0
tar  -xvf ${JARVIS_DOWNLOAD}/scalapack-2.1.0.tgz
cd scalapack-2.1.0
cp SLmake.inc.example SLmake.inc

LAPACK_PATH=${LAPACK_PATH}
sed -i "58s%-lblas%${LAPACK_PATH}libblas.so.3.8.0%g" ./SLmake.inc
sed -i "59s%-llapack%${LAPACK_PATH}liblapack.so.3.8.0%g" ./SLmake.inc
make 
mkdir $1/lib
cp *.a $1/lib
mkdir -p $1/include
cp SRC/*.h $1/include
