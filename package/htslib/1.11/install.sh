#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/htslib/${BASENAME}
mkdir -p ${WORK_DIR}
{
#yum install -y libcurl libcurl-devel openssl openssl-devel zlib-devel bzip2 bzip2-devel xz-devel boost-devel
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

${DOWNLOAD_TOOL} -u $JARVIS_PROXY/samtools/htslib/releases/download/1.11/htslib-1.11.tar.bz2 htslib-1.11.tar.bz2
cd ${WORK_DIR}
[ -d htslib-1.11  ] && echo "Exist DIR:$(pwd)/htslib-1.11 " && exit 1

REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/htslib-1.11.tar.bz2 | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="htslib-1.11.tar.bz2"
REG_META_TYPE="bz2"
tar -xvf ${JARVIS_DOWNLOAD}/htslib-1.11.tar.bz2
[ ! $? -eq 0 ] && echo "Invalid file: htslib-1.11.tar.bz2" && exit 1
cd htslib-1.11 
autoreconf -i
./configure --prefix=$1 --host=aarch64-unknown-linux-gnu
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
