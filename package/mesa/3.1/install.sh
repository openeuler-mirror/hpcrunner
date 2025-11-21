#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/mesa/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u https://archive.mesa3d.org/older-versions/3.x/MesaLib-3.1.tar.gz
cd ${JARVIS_DEV_VROOT}/mesa/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/MesaLib-3.1.tar.gz| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="MesaLib-3.1.tar.gz"
REG_META_TYPE="tar.gz"
[ -d Mesa-3.1 ] && echo "Exist DIR:$(pwd)/Mesa-3.1" && exit 1

tar -xvf ${JARVIS_DOWNLOAD}/MesaLib-3.1.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: MesaLib-3.1.tar.gz" && exit 1
cd Mesa-3.1
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"
cp -f /usr/share/libtool/build-aux/config.guess ./
cp -f /usr/share/libtool/build-aux/config.sub  ./
./configure --prefix=${PATH_INSTALL} --x-libraries=/usr/lib64 --x-include=/usr/include
make
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
} 2>&1 | tee ${JARVIS_DEV_VROOT}/mesa/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/mesa/${BASENAME}/${log_file} ${1}
set +x
exit ${res}