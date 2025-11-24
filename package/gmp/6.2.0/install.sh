#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/gmp/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u https://gmplib.org/download/gmp/gmp-6.2.0.tar.xz
cd ${JARVIS_DEV_VROOT}/gmp/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/gmp-6.2.0.tar.xz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="gmp-6.2.0.tar.xz"
REG_META_TYPE="tgz"

[ -d gmp-6.2.0 ] && echo "Exist DIR:$(pwd)/gmp-6.2.0" && exit 1

tar -xvf ${JARVIS_DOWNLOAD}/gmp-6.2.0.tar.xz
[ ! $? -eq 0 ] && echo "Invalid file: gmp-6.2.0.tar.xz" && exit 1
cd gmp-6.2.0
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"

./configure --enable-cxx --prefix=$1
make -j
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

} 2>&1 | tee ${JARVIS_DEV_VROOT}/gmp/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/gmp/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
