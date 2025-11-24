#!/bin/bash
set -x
set -e

PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog

mkdir -p ${JARVIS_DEV_VROOT}/blas/${BASENAME}
{

. "${DOWNLOAD_TOOL}" -u http://www.netlib.org/blas/blas-3.8.0.tgz
cd ${JARVIS_DEV_VROOT}/blas/${BASENAME}

[ -d BLAS-3.8.0 ] && echo "Exist DIR:$(pwd)/BLAS-3.8.0" && exit 1
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/blas-3.8.0.tgz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="blas-3.8.0.tgz"
REG_META_TYPE="tgz"

tar -xzvf "${JARVIS_DOWNLOAD}"/blas-3.8.0.tgz -C ./
[ ! $? -eq 0 ] && echo "Invalid file: blas-3.8.0.tgz" && exit 1

cd BLAS-3.8.0
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"

`which flang` -c -O3 -fPIC -shared ./*.f
`which flang` -O3 -fPIC -shared -o libblas.so ./*.o

mkdir -p ${PATH_INSTALL}/lib
cp libblas.so $1/lib -ar

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

} 2>&1 | tee ${JARVIS_DEV_VROOT}/blas/${BASENAME}/${log_file}

res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/blas/${BASENAME}/${log_file} ${PATH_INSTALL}
set +x
exit ${res}

