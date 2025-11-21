#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/elpa/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u https://www.cp2k.org/static/downloads/elpa-2019.05.001.tar.gz
cd ${JARVIS_DEV_VROOT}/elpa/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/elpa-2019.05.001.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="elpa-2019.05.001.tar.gz"
REG_META_TYPE="tgz"

[ -d elpa-2019.05.001 ] && echo "Exist DIR:$(pwd)/elpa-2019.05.001" && exit 1
rm -rf elpa-2019.05.001
tar -xvf ${JARVIS_DOWNLOAD}/elpa-2019.05.001.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: elpa-2019.05.001.tar.gz" && exit 1
cd elpa-2019.05.001
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"


./configure --prefix=$1 --enable-openmp --enable-shared --enable-static LIBS="${SCALAPACK_PATH}/lib/libscalapack.so ${LAPACK_PATH}/liblapack.so ${KPLBLAS_PATH}/lib/libkplblas.so" --disable-sse --disable-sse-assembly --disable-avx --disable-avx2 CC=mpicc CXX=mpicxx FC=mpif90 FCFLAGS="-O3" CFLAGS="-O3"
sed -i 's/\\\$wl-soname \\\$wl\\\$soname/-fuse-ld=ld -Wl,-soname,\\\$soname/g' libtool
sed -i 's/\\\$wl--whole-archive\\\$convenience \\\$wl--no-whole-archive//g' libtool

make -j 4
make install
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

} 2>&1 | tee ${JARVIS_DEV_VROOT}/elpa/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/elpa/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
