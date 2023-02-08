#!/bin/bash
set -x
set -e
kml_version=1.4.0
. ${DOWNLOAD_TOOL} -u https://kunpeng-repo.obs.cn-north-4.myhuaweicloud.com/Kunpeng%20BoostKit/Kunpeng%20BoostKit%2021.0.0/BoostKit-kml_${kml_version}_bisheng.zip
. ${DOWNLOAD_TOOL} -u https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.9.1.tar.gz -f lapack-3.9.1.tar.gz
cd ${JARVIS_TMP}

unzip -o ${JARVIS_DOWNLOAD}/BoostKit-kml_${kml_version}_bisheng.zip
rpm2cpio boostkit-kml-${kml_version}-1.aarch64.rpm | cpio -div
mkdir -p $1
cp -r usr/local/kml/* $1

# generate full lapack
netlib=${JARVIS_DOWNLOAD}/lapack-3.9.1.tar.gz
klapack=$1/lib/libklapack.a
kservice=$1/lib/libkservice.a
echo $netlib
echo $klapack

# build netlib lapack
rm -rf netlib
mkdir netlib
cd netlib
tar zxvf $netlib
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON ../lapack-3.9.1
make -j
cd ../..

cp netlib/build/lib/liblapack.a liblapack_adapt.a

# get symbols defined both in klapack and netlib lapack
nm -g liblapack_adapt.a | grep 'T ' | grep -oP '\K\w+(?=_$)' | sort | uniq > netlib.sym
nm -g $klapack | grep 'T ' | grep -oP '\K\w+(?=_$)' | sort | uniq > klapack.sym
comm -12 klapack.sym netlib.sym > comm.sym 

objcopy -W dsecnd_ -W second_ liblapack_adapt.a

# add _netlib_ postfix to symbols in liblapack_adapt.a (e.g. dgetrf_netlib_)
while read sym; do \
    if ! nm liblapack_adapt.a | grep -qe " T ${sym}_\$"; then \
        continue; \
    fi; \
    ar x liblapack_adapt.a $sym.f.o; \
    mv $sym.f.o ${sym}_netlib.f.o; \
    objcopy --redefine-sym ${sym}_=${sym}_netlib_ ${sym}_netlib.f.o; \
    ar d liblapack_adapt.a ${sym}.f.o; \
    ar ru liblapack_adapt.a ${sym}_netlib.f.o; \
    rm ${sym}_netlib.f.o; \
done < comm.sym

# (optional) build a full lapack shared library
clang -o libklapack_full.so -shared -fPIC -Wl,--whole-archive $klapack liblapack_adapt.a $kservice -Wl,--no-whole-archive -fopenmp -lpthread -lflang -lm

\cp libklapack_full.so $1/lib/
echo "Generated liblapack_adapt.a and libklapack_full.so"
exit 0
