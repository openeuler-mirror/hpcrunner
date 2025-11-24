#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/bwa/clang/${BASENAME}
mkdir -p ${WORK_DIR}
{
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/jratcliff63367/sse2neon/archive/refs/heads/master.zip -f sse2neon-master.zip
. ${DOWNLOAD_TOOL} -u https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.17.tar.bz2
cd ${WORK_DIR}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/bwa-0.7.17.tar.bz2 | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="bwa-0.7.17.tar.bz2"
REG_META_TYPE="bz2"

rm -rf bwa-0.7.17  sse2neon-master
tar  -jxvf ${JARVIS_DOWNLOAD}/bwa-0.7.17.tar.bz2
unzip ${JARVIS_DOWNLOAD}/sse2neon-master.zip
cd bwa-0.7.17
cp ${WORK_DIR}/sse2neon-master/SSE2NEON.h ./ -ar
sed -i "1s/gcc/clang/g" Makefile
sed -i "14s%$%-I.%g" Makefile
sed -i '29s/<emmintrin.h>/<SSE2NEON.h>/g' ksw.c
sed -i "33s%^%//%g" rle.h
make 
mkdir -p ${PATH_INSTALL}/bin 
cp -r ../bwa-0.7.17/bwakit *.pl bwa ${PATH_INSTALL}/bin

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

#download from $JARVIS_PROXY/jratcliff63367/sse2neon  https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.17.tar.bz2
#module  load  bisheng/2.1.0    
} 2>&1 | tee ${WORK_DIR}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${WORK_DIR}/${log_file} ${1}
set +x
exit ${res}
