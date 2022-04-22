#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
if [ -d /usr/local/kml ];then
   rpm -e boostkit-kml
fi
rpm --force --nodeps -ivh ${JARVIS_ROOT}/package/kml/1.4.0/gcc/*.rpm

# generate full lapack
netlib=${JARVIS_DOWNLOAD}/lapack-3.9.1.tar.gz
klapack=/usr/local/kml/lib/libklapack.a
kservice=/usr/local/kml/lib/libkservice.a
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
gcc -o libklapack_full.so -shared -fPIC -Wl,--whole-archive $klapack liblapack_adapt.a $kservice -Wl,--no-whole-archive -fopenmp -lpthread -lgfortran -lm

\cp libklapack_full.so /usr/local/kml/lib/
echo "Generated liblapack_adapt.a and libklapack_full.so"
exit 0