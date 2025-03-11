#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
. ${DOWNLOAD_TOOL} -u http://www.netlib.org/scalapack/scalapack-2.1.0.tgz
tar  -xvf ${JARVIS_DOWNLOAD}/scalapack-2.1.0.tgz
cd scalapack-2.1.0
cp SLmake.inc.example SLmake.inc
if ! [ -z ${LAPACK_BISHENG_PATH} ]; then
    echo "LAPACK_BISHENG_PATH was defined"
else
    echo "Need to set environment var LAPACK_BISHENG_PATH" && exit 1;
fi
sed -i "33s/$/ -Wno-implicit-function-declaration -Wno-implicit-int/g" ./SLmake.inc
sed -i "58s/-lblas//g" ./SLmake.inc
sed -i "59s/-llapack//g" ./SLmake.inc
sed -i "58s%$%${LAPACK_BISHENG_PATH}/lib/librefblas.a%g" ./SLmake.inc
sed -i "59s%$%${LAPACK_BISHENG_PATH}/lib/liblapack.a%g" ./SLmake.inc
sed -i '17a $(LIBS) += -fuse-ld=lld' REDIST/TESTING/Makefile
make
mkdir -p $1/lib
cp *.a $1/lib
mkdir -p $1/include
cp SRC/*.h $1/include
