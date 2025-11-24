#!/bin/bash
set -e
set -x
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/bcftools/${BASENAME}
mkdir -p ${WORK_DIR}
{
if [ ! -f /usr/share/libtool/build-aux/config.guess ]; then
	echo "ERROR: yum install libtool for /usr/share/libtool/build-aux/config.guess"
	exit 1
fi
${DOWNLOAD_TOOL} -u https://github.com/samtools/bcftools/archive/1.11.tar.gz -f bcftools-1.11.tar.gz
cd ${WORK_DIR}
[ -d bcftools-1.11  ] && echo "Exist DIR:$(pwd)/bcftools-1.11 " && exit 1
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/bcftools-1.11.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="bcftools-1.11.tar.gz"
REG_META_TYPE="tar.gz"

tar --no-same-owner -zxvf ${JARVIS_DOWNLOAD}/bcftools-1.11.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: bcftools-1.11.tar.gz" && exit 1
cd bcftools-1.11

autoheader
autoconf

sed -i 's/\-O2/\-O3 -march=armv8.2-a -mtune=tsv110/g' $(grep -lr "\-O2" ./)
cp /usr/share/libtool/build-aux/config.guess . -ar
cp /usr/share/libtool/build-aux/config.sub . -ar

./configure --prefix=$1 --build=aarch64-unknown-linux-gnu --host=aarch64-unknown-linux-gnu --with-htslib=${HTSLIB_PATH}

make -j16
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
