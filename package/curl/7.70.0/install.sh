#!/bin/bash
set -x
set -e

PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/curl/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/curl/curl/releases/download/curl-7_70_0/curl-7.70.0.tar.gz

cd ${JARVIS_DEV_VROOT}/curl/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/curl-7.70.0.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="curl-7.70.0.tar.gz"
REG_META_TYPE="tgz"

[ -d curl-7.70.0 ] && echo "Exist DIR:$(pwd)/curl-7.70.0" && exit 1

tar -zxvf ${JARVIS_DOWNLOAD}/curl-7.70.0.tar.gz
cd curl-7.70.0
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"

./buildconf
./configure --prefix=${PATH_INSTALL} 
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
        {
            "artifactId": "lapack",
            "version": "",
            "scope": "compile",
            "url": "${LAPACK_PATH}",
            "packaging": "none"
        }
        ]
}
EOF

} 2>&1 | tee ${JARVIS_DEV_VROOT}/curl/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/curl/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
           




