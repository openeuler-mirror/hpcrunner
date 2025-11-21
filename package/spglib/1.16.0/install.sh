#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/spglib/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/spglib/spglib/archive/refs/tags/v1.16.0.tar.gz -f spglib-1.16.0.tar.gz
cd ${JARVIS_DEV_VROOT}/spglib/${BASENAME}

REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/spglib-1.16.0.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="spglib-1.16.0.tar.gz"
REG_META_TYPE="tgz"
[ -d spglib-1.16.0 ] && echo "Exist DIR:$(pwd)/spglib-1.16.0" && exit 1

tar -xvf ${JARVIS_DOWNLOAD}/spglib-1.16.0.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: spglib-1.16.0.tar.gz" && exit 1
cd spglib-1.16.0
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

} 2>&1 | tee ${JARVIS_DEV_VROOT}/spglib/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/spglib/${BASENAME}/${log_file} ${1}
set +x
exit ${res}