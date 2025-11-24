#!/bin/bash
set -x
set -e

install_path=$1

${DOWNLOAD_TOOL} -u http://www.netlib.org/scalapack/scalapack-2.1.0.tgz

if [ -d "$install_path/scalapack-2.1.0" ]; then
rm -rf $install_path/scalapack-2.1.0
fi

tar --no-same-owner -zxvf ${JARVIS_DOWNLOAD}/scalapack-2.1.0.tgz -C $install_path


cd $install_path/scalapack-2.1.0
echo "WORKDIR:$(pwd)"
cp SLmake.inc.example SLmake.inc

if ! [ -z ${LAPACK_CLANG_PATH} ]; then
    echo "LAPACK_CLANG_PATH was defined"
else
    echo "Need to set environment var LAPACK_CLANG_PATH" && exit 1;
fi

LAPACK_PATH=${LAPACK_CLANG_PATH}
# -fallow-rank-mismatch
if mpicc -v 2>&1  | grep clang >/dev/null 2>&1; then
sed -i "33s/$/ -Wno-implicit-function-declaration -Wno-implicit-int/g" ./SLmake.inc
else
sed -i "31s/$/ -fPIC -fallow-argument-mismatch/g" ./SLmake.inc
sed -i "32s/$/ -fPIC -fallow-argument-mismatch/g" ./SLmake.inc
sed -i "33s/$/ -fPIC -Wno-implicit-function-declaration -Wno-implicit-int/g" ./SLmake.inc	
fi
sed -i "58s%-lblas%${LAPACK_CLANG_PATH}/lib/libopenblas.a%g" ./SLmake.inc
sed -i "59s%-llapack%${LAPACK_CLANG_PATH}/lib/libopenblas.a%g" ./SLmake.inc

make verbose=1

mkdir $install_path/lib -p
cp *.a $install_path/lib -ar

mkdir $install_path/include -p
cp ./SRC/*.h $install_path/include -ar
