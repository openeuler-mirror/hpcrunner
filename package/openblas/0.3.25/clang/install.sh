#!/bin/bash
set -x
set -e
ver="0.3.25"
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/OpenBLAS/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/xianyi/OpenBLAS/archive/refs/tags/v${ver}.tar.gz -f OpenBLAS-${ver}.tar.gz
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/OpenBLAS-${ver}.tar.gz| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="OpenBLAS-${ver}.tar.gz"
REG_META_TYPE="tgz"
cd ${JARVIS_DEV_VROOT}/OpenBLAS/${BASENAME}


tar -xzvf ${JARVIS_DOWNLOAD}/OpenBLAS-${ver}.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: OpenBLAS-0.3.25.tar.gz" && exit 1
cd OpenBLAS-${ver}
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"

if [ -d "build" ]; then
rm -rf build
fi
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=${PATH_INSTALL} \
         -DBUILD_SHARED_LIBS=ON \
         -DUSE_OPENMP=ON
make -j16
make  install

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

} 2>&1 | tee ${JARVIS_DEV_VROOT}/OpenBLAS/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/OpenBLAS/${BASENAME}/${log_file} ${PATH_INSTALL}
set +x
exit ${res}
