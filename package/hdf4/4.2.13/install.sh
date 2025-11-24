#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/hdf4/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u https://rpmfind.net/linux/epel/8/Everything/aarch64/Packages/h/hdf-4.2.14-5.el8.aarch64.rpm
cd ${JARVIS_DEV_VROOT}/hdf4/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/hdf-4.2.14-5.el8.aarch64.rpm| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="hdf-4.2.14-5.el8.aarch64.rpm"
REG_META_TYPE="rpm"
[ -d hdf-4.2.15 ] && echo "Exist DIR:$(pwd)/hdf-4.2.15" && exit 1
mkdir hdf-4.2.15
cd hdf-4.2.15
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
echo "BUILD DIR:$(pwd)"
rpm2cpio ${JARVIS_DOWNLOAD}/hdf-4.2.14-5.el8.aarch64.rpm | cpio -div
cp -r usr/* $1/ -ar
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
} 2>&1 | tee ${JARVIS_DEV_VROOT}/hdf4/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/hdf4/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
