#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/bamtools/${BASENAME}
mkdir -p ${WORK_DIR}
{
. ${DOWNLOAD_TOOL} -u https://github.com/pezmaster31/bamtools/archive/refs/tags/v2.5.0.tar.gz -f bamtools-2.5.0.tar.gz
cd ${WORK_DIR}
[ -d bamtools-2.5.0  ] && echo "Exist DIR:$(pwd)/bamtools-2.5.0 " && exit 1
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/bamtools-2.5.0.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="samtools-1.11.tar.bz2"
REG_META_TYPE="tgz"

tar -xvf ${JARVIS_DOWNLOAD}/bamtools-2.5.0.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: bamtools-2.5.0.tar.gz" && exit 1
cd bamtools-2.5.0

export CC=clang CXX=clang++ FC=flang
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$1 .. -DCMAKE_CXX_FLAGS="-std=c++14 -O3" ..
make -j
make install

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
