#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/openblas/clang/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/xianyi/OpenBLAS/archive/refs/tags/v0.3.9.tar.gz -f OpenBLAS-0.3.9.tar.gz
cd ${JARVIS_DEV_VROOT}/openblas/clang/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/OpenBLAS-0.3.9.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="OpenBLAS-0.3.9.tar.gz"
REG_META_TYPE="tgz"


[ -d OpenBLAS-0.3.9 ] && echo "Exist DIR:$(pwd)/OpenBLAS-0.3.9" && exit 1
tar -xzvf ${JARVIS_DOWNLOAD}/OpenBLAS-0.3.9.tar.gz -C ./
[ ! $? -eq 0 ] && echo "Invalid file: OpenBLAS-0.3.9.tar.gz" && exit 1

cd OpenBLAS-0.3.9
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"
export CC="clang -Wno-error=implicit-function-declaration" CXX=clang++ FC=flang
cp Makefile.system Makefile.system-bak
sed -i '1219c COMMON_OPT = -O2 -Wno-implicit-function-declaration' Makefile.system
make -j 
make PREFIX="${PATH_INSTALL}" install
cat > ${PATH_INSTALL}/install_registry.json << EOF
{
    "projectURL": "${REG_PROJECT_URL}",
    "projectDate": "${REG_PROJECT_DATE}",
    "packaging": "tgz",
    "package": "${REG_META_PACKAGE}",
    "hashType": "${REG_META_HTYPE}",
    "hashValue": "${REG_META_HVALUE}",
    "dependencies": [
        ]
}
EOF
} 2>&1 | tee ${JARVIS_DEV_VROOT}/openblas/clang/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/openblas/clang/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
