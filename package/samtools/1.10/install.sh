#!/bin/bash
set -x
set -e
if [ ! -f /usr/lib64/libz.so ] || [ ! -f /usr/include/zlib.h ]; then
        echo "ERROR: yum install zlib zlib-devel for /usr/lib64/libz.so"
        exit 1
fi

if [ ! -f /usr/lib64/libbz2.so ] || [ ! -f /usr/include/bzlib.h ]; then
        echo "ERROR: yum install bzip2 bzip2-devel for /usr/lib64/libbz2.so"
        exit 1
fi


if [ ! -f /usr/lib64/liblzma.so ] || [ ! -f /usr/include/lzma/version.h ]; then
        echo "ERROR: yum install xz xz-devel for /usr/lib64/liblzma.so"
        exit 1
fi

if [ ! -f /usr/lib64/libcurl.so ] || [ ! -f  /usr/include/curl/curl.h ]; then
        echo "ERROR: yum install libcurl libcurl-devel for /usr/lib64/libcurl.so"
        exit 1
fi

if [ ! -f /usr/lib64/libcrypto.so ] || [ ! -f /usr/include/openssl/ssl.h ]; then
        echo "ERROR: yum install openssl openssl-devel for /usr/lib64/libcrypto.so"
        exit 1
fi

if [ ! -f /usr/include/ncurses/curses.h ] || [ ! -f /usr/lib64/libncurses.so ]; then
        echo "ERROR: yum install ncurses ncurses-devel ncurses-base ncurses-libs for /usr/include/ncurses/curses.h,/usr/lib64/libncurses.so"
        exit 1
fi

PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/samtools/${BASENAME}
mkdir -p ${WORK_DIR}
{
. ${DOWNLOAD_TOOL} -u https://github.com/samtools/samtools/releases/download/1.10/samtools-1.10.tar.bz2
cd ${WORK_DIR}
[ -d samtools-1.10  ] && echo "Exist DIR:$(pwd)/samtools-1.10 " && exit 1
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/samtools-1.10.tar.bz2 | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="samtools-1.11.tar.bz2"
REG_META_TYPE="bz2"
tar jxvf ${JARVIS_DOWNLOAD}/samtools-1.10.tar.bz2
[ ! $? -eq 0 ] && echo "Invalid file: samtools-1.10.tar.bz2" && exit 1
cd samtools-1.10
./configure --prefix=$1
make CFLAGS="-Wall -O2 -fsigned-char" all all-htslib
make CFLAGS="-Wall -O2 -fsigned-char" install install-htslib
mkdir $1/include/bam -p
cp *.h $1/include/bam -ar
cp *.a $1/lib -ar

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
