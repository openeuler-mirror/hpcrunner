#!/bin/bash
set -x
set -e


PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/scalapack/clang/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u http://www.netlib.org/scalapack/scalapack-2.1.0.tgz
cd ${JARVIS_DEV_VROOT}/scalapack/clang/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/scalapack-2.1.0.tgz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="scalapack-2.1.0.tgz"
REG_META_TYPE="tgz"

[ -d scalapack-2.1.0 ] && echo "Exist DIR:$(pwd)/scalapack-2.1.0" && exit 1
tar  -xvf ${JARVIS_DOWNLOAD}/scalapack-2.1.0.tgz
[ ! $? -eq 0 ] && echo "Invalid file: scalapack-2.1.0.tgz" && exit 1
cd scalapack-2.1.0
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"
cp SLmake.inc.example SLmake.inc
if ! [ -z ${LAPACK_CLANG_PATH} ]; then
    echo "LAPACK_CLANG_PATH was defined"
else
    echo "Need to set environment var LAPACK_CLANG_PATH" && exit 1;
fi
sed -i "33s/$/ -Wno-implicit-function-declaration -Wno-implicit-int/g" ./SLmake.inc
sed -i "58s/-lblas//g" ./SLmake.inc
sed -i "59s/-llapack//g" ./SLmake.inc
sed -i "58s%$%${LAPACK_CLANG_PATH}/lib/libblas.so%g" ./SLmake.inc
sed -i "59s%$%${LAPACK_CLANG_PATH}/lib/liblapack.so%g" ./SLmake.inc
sed -i '17a $(LIBS) += -fuse-ld=lld' REDIST/TESTING/Makefile
make
mkdir -p $1/lib
cp *.a $1/lib
mkdir -p $1/include
cp SRC/*.h $1/include
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
