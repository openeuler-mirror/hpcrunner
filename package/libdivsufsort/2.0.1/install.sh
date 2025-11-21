#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/samtools/${BASENAME}
mkdir -p ${WORK_DIR} 
{
. ${DOWNLOAD_TOOL} -u https://github.com/y-256/libdivsufsort/archive/refs/tags/2.0.1.tar.gz -f libdivsufsort-2.0.1.tar.gz
cd ${WORK_DIR}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/libdivsufsort-2.0.1.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="libdivsufsort-2.0.1.tar.gz"
REG_META_TYPE="bz2"

[ -d libdivsufsort-2.0.1  ] && echo "Exist DIR:$(pwd)/libdivsufsort-2.0.1 " && exit 1
tar xvf ${JARVIS_DOWNLOAD}/libdivsufsort-2.0.1.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: libdivsufsort-2.0.1.tar.gz" && exit 1
cd libdivsufsort-2.0.1
sed -i "47s/OFF/ON/g" CMakeLists.txt
sed -i "48s/OFF/ON/g" CMakeLists.txt
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$1
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

