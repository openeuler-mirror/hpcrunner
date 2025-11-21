#!/bin/bash
set -e
source ${JARVIS_LIBSHELL}
check_rpms_installed zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make libffi-devel || exit 1
set -x

PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/python/${BASENAME}
mkdir -p ${WORK_DIR}
{
. ${DOWNLOAD_TOOL} -u https://www.python.org/ftp/python/2.7.16/Python-2.7.16.tgz
cd ${WORK_DIR}
rm Python-2.7.16 -rf
tar -zxvf ${JARVIS_DOWNLOAD}/Python-2.7.16.tgz
REG_META_HVALUE="$(md5sum ${JARVIS_DOWNLOAD}/Python-2.7.16.tgz  | awk '{print $1}')"
REG_META_HTYPE="md5"
REG_META_PACKAGE="Python-2.7.16.tgz"
REG_META_TYPE="tgz"

cd Python-2.7.16
./configure --prefix=$1  CFLAGS="-Wno-implicit-function-declaration" --enable-shared
make -j 16
make install

python -m ensurepip

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
    "dependencies": [
   
        ]
}
EOF

} 2>&1 | tee ${WORK_DIR}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${WORK_DIR}/${log_file} ${1}
set +x
exit ${res}

