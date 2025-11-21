#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/libpng/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u https://nchc.dl.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.gz
cd ${JARVIS_DEV_VROOT}/libpng/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/libpng-1.6.37.tar.gz| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="libpng-1.6.37.tar.gz"
REG_META_TYPE="tgz"
[ -d libpng-1.6.37 ] && echo "Exist DIR:$(pwd)/libpng-1.6.37" && exit 1
tar xvf ${JARVIS_DOWNLOAD}/libpng-1.6.37.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: libpng-1.6.37.tar.gz" && exit 1
cd libpng-1.6.37
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
echo "BUILD DIR:$(pwd)"
./configure --prefix=$1 --build=aarch64-unknown-linux-gnu
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
} 2>&1 | tee ${JARVIS_DEV_VROOT}/libpng/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/libpng/${BASENAME}/${log_file} ${1}
set +x
exit ${res}