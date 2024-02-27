#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://www.cp2k.org/static/downloads/elpa-2020.11.001.tar.gz
cd ${JARVIS_TMP}
rm -rf elpa-2020.11.001
tar -xvf ${JARVIS_DOWNLOAD}/elpa-2020.11.001.tar.gz
cd elpa-2020.11.001

array=(${LD_LIBRARY_PATH//:/ })
for var in ${array[@]}
do
   if [[ -e $var/libopenblas.so ]];then
        openblas_path=$var
   fi	
   if [[ -e $var/libscalapack.a ]];then
        scalapack_path=$var
   fi
done

if [ ! -n "$openblas_path" ];then
        echo "Please load openblas."
        exit 1
fi
if [ ! -n "$scalapack_path" ];then
        echo "Please load scalapack."
        exit 1
fi


./configure --prefix=$1 --enable-openmp --enable-shared=no LIBS="$scalapack_path/libscalapack.a $openblas_path/libopenblas.a" --disable-sse --disable-sse-assembly --disable-avx --disable-avx2 --disable-avx512

make -j 4
make install
