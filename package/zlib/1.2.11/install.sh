#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/zlib/${BASENAME}
{
zlib_ver='1.2.11'
. ${DOWNLOAD_TOOL} -u https://zlib.net/fossils/zlib-${zlib_ver}.tar.gz
cd ${JARVIS_DEV_VROOT}/zlib/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/zlib-${zlib_ver}.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="zlib-${zlib_ver}.tar.gz"
REG_META_TYPE="tgz"

tar -xvf ${JARVIS_DOWNLOAD}/zlib-${zlib_ver}.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: zlib-${zlib_ver}.tar.gz" && exit 1

cd zlib-${zlib_ver}
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
echo "BUILD DIR:$(pwd)"

./configure --prefix=$1
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

} 2>&1 | tee ${JARVIS_DEV_VROOT}/zlib/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/zlib/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
