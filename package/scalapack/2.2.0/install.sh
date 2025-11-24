#!/bin/bash
set -x
set -e


PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/scalapack/clang/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u https://codeload.github.com/Reference-ScaLAPACK/scalapack/tar.gz/refs/tags/v2.2.0
cd ${JARVIS_DEV_VROOT}/scalapack/clang/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/scalapack-2.2.0.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="scalapack-2.1.0.tgz"
REG_META_TYPE="tgz"

[ -d scalapack-2.2.0 ] && echo "Exist DIR:$(pwd)/scalapack-2.2.0" && exit 1
tar  -xvf ${JARVIS_DOWNLOAD}/scalapack-2.2.0.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: scalapack-2.2.0.tar.gz" && exit 1
cd scalapack-2.2.0
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)


rm build -rf
mkdir build&&cd build 
cmake .. -DCMAKE_INSTALL_PREFIX=$1 -DBUILD_SHARED_LIBS=ON -DBLAS_LIBRARIES=${KPLBLAS_PATH}/lib/libkplblas.so -DLAPACK_LIBRARIES=${LAPACK_PATH}/lib/liblapack.so -DCMAKE_Fortran_FLAGS="-O3" -DCMAKE_C_COMPILER=mpicc -DCMAKE_Fortran_COMPILER=mpif90 -DCMAKE_C_FLAGS="-std=c89"
make -j  && make install
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

} 2>&1 | tee ${JARVIS_DEV_VROOT}/scalapack/clang/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/scalapack/clang/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
