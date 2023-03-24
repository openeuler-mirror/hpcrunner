#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://www.cp2k.org/static/downloads/plumed-2.5.2.tgz
cd ${JARVIS_TMP}
rm -rf plumed-2.5.2
tar -xvf ${JARVIS_DOWNLOAD}/plumed-2.5.2.tgz
cd plumed-2.5.2

array=(${LD_LIBRARY_PATH//:/ })
for var in ${array[@]}
do
   if [[ -e $var/libopenblas.so ]];then
        openblas_path=$var
   fi
done

if [ ! -n "$openblas_path" ];then
        echo "Please load openblas."
        exit 1
fi

./configure CXX=mpicxx CC=mpicc FC=mpifort --prefix=$1 --enable-external-blas --enable-gsl --enable-external-lapack LDFLAGS=-L$openblas_path LIBS="-lopenblas"
make -j
make install
