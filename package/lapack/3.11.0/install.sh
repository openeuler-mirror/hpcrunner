#!/bin/bash
set -x
set -e

PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog

mkdir -p ${JARVIS_DEV_VROOT}/lapack/clang/${BASENAME}
{

[[ "${PATH_INSTALL}" =~ "lapack" ]] ||  { echo "Invalid Param: ${PATH_INSTALL}" ; exit 1 ;}
. $DOWNLOAD_TOOL -u https://www.cp2k.org/static/downloads/lapack-3.11.0.tgz
cd ${JARVIS_DEV_VROOT}/lapack/clang/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/lapack-3.11.0.tgz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="lapack-3.11.0.tgz"
REG_META_TYPE="tgz"

[ -d lapack-3.11.0 ] && echo "Exist DIR:$(pwd)/lapack-3.11.0" && exit 1
tar -xvf ${JARVIS_DOWNLOAD}/lapack-3.11.0.tgz -C ./
[ ! $? -eq 0 ] && echo "Invalid file: lapack-3.11.0.tgz" && exit 1
cd lapack-3.11.0
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
echo "BUILD DIR:$(pwd)"

mkdir build 
cd build 
export CC=clang CXX=clang++ FC=flang
rm build -rf
mkdir build 
cmake .. -DCMAKE_INSTALL_LIBDIR=$1/lib  -DBUILD_SHARED_LIBS=ON -DUSE_OPTIMIZED_BLAS=ON -DBLAS_LIBRARIES=${KPLBLAS_PATH}/lib/libkplblas.so -DCMAKE_Fortran_FLAGS="-O2"
make -j && make install

[ -L "${PATH_INSTALL}"/lib ] && rm "${PATH_INSTALL}"/lib
ln -s "${PATH_INSTALL}"/lib64 "${PATH_INSTALL}"/lib

cat > ${PATH_INSTALL}/install_registry.json << EOF
{
    "projectURL": "${REG_PROJECT_URL}",
    "projectDate": "${REG_PROJECT_DATE}",
    "packaging": "${REG_META_TYPE}",
    "package": "${REG_META_PACKAGE}",
    "hashType": "${REG_META_HTYPE}",
    "hashValue": "${REG_META_HVALUE}",
    "dependencies": [
        ]
}
EOF
cat > ${PATH_INSTALL}/module_tail.modulefile << EOF
prepend-path LD_LIBRARY_PATH  "${PATH_INSTALL}"
EOF

} 2>&1 | tee ${JARVIS_DEV_VROOT}/lapack/clang/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/lapack/clang/${BASENAME}/${log_file} ${PATH_INSTALL}
set +x
exit ${res}

#cp make.inc.example make.inc
#make -j
#mkdir $1/lib/
#cp *.a $1/lib/
