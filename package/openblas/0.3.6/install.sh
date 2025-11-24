#!/bin/bash
set -e
set -x
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/openblas/${BASENAME}
mkdir -p ${WORK_DIR}
{
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/xianyi/OpenBLAS/archive/refs/tags/v0.3.6.tar.gz -f OpenBLAS-0.3.6.tar.gz
cd ${WORK_DIR}
[ -d OpenBLAS-0.3.6  ] && echo "Exist DIR:$(pwd)/OpenBLAS-0.3.6" && exit 1
tar -xzvf ${JARVIS_DOWNLOAD}/OpenBLAS-0.3.6.tar.gz
REG_META_HVALUE="$(md5sum ${JARVIS_DOWNLOAD}/OpenBLAS-0.3.6.tar.gz | awk '{print $1}')"
REG_META_HTYPE="md5"
REG_META_PACKAGE="OpenBLAS-0.3.6.tar.gz"
REG_META_TYPE="tgz"
cd OpenBLAS-0.3.6
make -j 
make PREFIX=$1 install

REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
cat > ${PATH_INSTALL}/install_registry.json << EOF
{
    "projectURL": "${REG_PROJECT_URL}",
    "projectDate": "${REG_PROJECT_DATE}",
    "packaging": "${REG_META_TYPE}",
    "package": "${REG_META_PACKAGE}",
    "hashType": "${REG_META_HTYPE}",
    "hashValue": "${REG_META_HVALUE}",
    "dependencies": []
}
EOF

} 2>&1 | tee ${WORK_DIR}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${WORK_DIR}/${log_file} ${1}
set +x
exit ${res}
