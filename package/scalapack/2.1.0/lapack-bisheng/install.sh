#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
tar  -xvf ${JARVIS_DOWNLOAD}/scalapack-2.1.0.tgz
cd scalapack-2.1.0
cp SLmake.inc.example SLmake.inc
LAPACK_PATH=$1
LAPACK_PATH=${LAPACK_PATH%/*/*/*}
LAPACK_PATH=${LAPACK_PATH}/lapack-bisheng/3.8.0/lib
sed -i "58s/-lblas//g" ./SLmake.inc
sed -i "59s/-llapack//g" ./SLmake.inc
sed -i "58s%$%${LAPACK_PATH}/librefblas.a%g" ./SLmake.inc
sed -i "59s%$%${LAPACK_PATH}/liblapack.a%g" ./SLmake.inc
sed -i '17a $(LIBS) += -fuse-ld=lld' REDIST/TESTING/Makefile
make
mkdir -p $1/lib
cp *.a $1/lib
mkdir -p $1/include
cp SRC/*.h $1/include
