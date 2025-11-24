#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/libvori/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u https://brehm-research.de/files/libvori-210412.tar.gz
cd ${JARVIS_DEV_VROOT}/libvori/${BASENAME}

REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/libvori-210412.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="libvori-210412.tar.gz"
REG_META_TYPE="tgz"

[ -d libvori-210412 ] && echo "Exist DIR:$(pwd)/libvori-210412" && exit 1
rm -rf libvori-210412
tar -xvf ${JARVIS_DOWNLOAD}/libvori-210412.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: libvori-210412.tar.gz" && exit 1
cd libvori-210412
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"

mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$1
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

} 2>&1 | tee ${JARVIS_DEV_VROOT}/libvori/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/libvori/${BASENAME}/${log_file} ${1}
set +x
exit ${res}