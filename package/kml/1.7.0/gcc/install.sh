#!/bin/bash
set -x
set -e
kml_version=1.7.0
. ${DOWNLOAD_TOOL} -u https://kunpeng-repo.obs.cn-north-4.myhuaweicloud.com/Kunpeng%20BoostKit/Kunpeng%20BoostKit%2022.0.0/BoostKit-kml_${kml_version}.zip
. ${DOWNLOAD_TOOL} -u https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.10.1.tar.gz -f lapack-3.10.1.tar.gz
. ${DOWNLOAD_TOOL} -u https://github.com/Reference-ScaLAPACK/scalapack/archive/refs/tags/v2.2.0.tar.gz -f scalapack-2.2.0.tar.gz

cd ${JARVIS_TMP}
rm -rf boostkit-kml-${kml_version}-1.aarch64.rpm
unzip -o ${JARVIS_DOWNLOAD}/BoostKit-kml_${kml_version}.zip
#rpm -e boostkit-kml-${kml_version}-1.aarch64
if [ -d /usr/local/kml ];then
   rpm -e boostkit-kml
fi
rpm --force --nodeps -ivh --relocate /usr/local/kml=$1 --badreloc=$1  boostkit-kml-${kml_version}-1.aarch64.rpm


# generate full lapack
netlib=${JARVIS_DOWNLOAD}/lapack-3.10.1.tar.gz
netlib2=${JARVIS_DOWNLOAD}/scalapack-2.2.0.tar.gz
klapack=$1/lib/libklapack.a
kservice=$1/lib/libkservice.a
kscalapack=$1/lib/libkscalapack.a
kblas=$1/lib/kblas/omp/libkblas.so
echo $netlib
echo $klapack
echo $netlib2
echo $kscalapack

# build netlib lapack
cd ${JARVIS_TMP}
rm -rf netlib
mkdir netlib
cd netlib
tar zxvf $netlib
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_DEPRECATED=ON ../lapack-3.10.1
make -j
cd ../

cp build/lib/liblapack.a liblapack_adapt.a

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
    rm -rf ${sym}_netlib.f.o; \
done < comm.sym

# (optional) build a full lapack shared library
gcc -o libklapack_full.so -shared -fPIC -Wl,--whole-archive $klapack liblapack_adapt.a $kservice -Wl,--no-whole-archive -fopenmp -lpthread -lgfortran -lm

\cp libklapack_full.so $1/lib/

# build netlib2 scalapack
cd ${JARVIS_TMP}
rm -rf netlib2
mkdir netlib2
cd netlib2
tar zxvf $netlib2
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_CXX_COMPILER=mpicxx -DCMAKE_C_COMPILER=mpicc -DCMAKE_Fortran_COMPILER=mpifort -DLAPACK_LIBRARIES=$1/lib/libklapack_full.so -DBLAS_LIBRARIES=$kblas ../scalapack-2.2.0
make -j
cd ../

cp ../netlib/build/lib/liblapack.a liblapack_adapt.a
cp build/lib/libscalapack.a libscalapack_adapt.a

nm -g libscalapack_adapt.a | grep 'T ' | grep -oP '\K\w+(?=_$)' | sort | uniq > netlib.sym
nm -g $kscalapack | grep 'T ' | grep -oP '\K\w+(?=_$)' | sort | uniq > kscalapack.sym
comm -12 kscalapack.sym netlib.sym > comm.sym
# update symbols name of libscalapack_adapt.a
while read sym; do \
    if ! nm libscalapack_adapt.a | grep -qe " T ${sym}_\$"; then \
        continue; \
    fi; \
    ar x libscalapack_adapt.a $sym.f.o; \
    mv $sym.f.o ${sym}_netlib.f.o; \
    objcopy --redefine-sym ${sym}_=${sym}_netlib_ ${sym}_netlib.f.o; \
    ar d libscalapack_adapt.a ${sym}.f.o; \
    ar ru libscalapack_adapt.a ${sym}_netlib.f.o; \
    rm -rf ${sym}_netlib.f.o; \
done < comm.sym

gcc -o libkscalapack_full.so -shared -fPIC -Wl,--whole-archive $kscalapack libscalapack_adapt.a -Wl,--no-whole-archive $klapack liblapack_adapt.a  $kservice -fopenmp -lpthread -lgfortran -lm

\cp libkscalapack_full.so $1/lib/
echo "Generated liblapack_adapt.a and libklapack_full.so"
echo "Generated libscalapack_adapt.a and libkscalapack_full.so"

exit 0
