#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/jpeg/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u http://www.ijg.org/files/jpegsrc.v9b.tar.gz
cd  ${JARVIS_DEV_VROOT}/jpeg/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/jpegsrc.v9b.tar.gz| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="scalapack-2.0.2.tgz"
REG_META_TYPE="tgz"
[ -d jpeg-9b ] && echo "Exist DIR:$(pwd)/jpeg-9b" && exit 1

tar xvf ${JARVIS_DOWNLOAD}/jpegsrc.v9b.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: jpeg-9b" && exit 1
cd jpeg-9b
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
echo "BUILD DIR:$(pwd)"
./configure --prefix=$1 CFLAGS="-fPIC" --build=aarch64-unknown-linux-gnu
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
} 2>&1 | tee ${JARVIS_DEV_VROOT}/jpeg/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/jpeg/${BASENAME}/${log_file} ${1}
set +x
exit ${res}