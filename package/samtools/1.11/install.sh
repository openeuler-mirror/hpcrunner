#!/bin/bash
set -x
set -e
if [ ! -f /usr/include/ncurses/curses.h ] || [ ! -f /usr/lib64/libncurses.so ]; then
	echo "ERROR: yum install ncurses ncurses-devel ncurses-base ncurses-libs for /usr/include/ncurses/curses.h,/usr/lib64/libncurses.so"
	exit 1
fi
if [ -z "${HTSLIB_PATH}" ]; then
	echo "ERROR: Require ENV: HTSLIB_PATH"
	exit 1
fi
echo "HTSLIB_PATH ENV:${HTSLIB_PATH}"
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/samtools/${BASENAME}
mkdir -p ${WORK_DIR}
{
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2
cd ${WORK_DIR}
[ -d samtools-1.11  ] && echo "Exist DIR:$(pwd)/samtools-1.11 " && exit 1
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/samtools-1.11.tar.bz2 | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="samtools-1.11.tar.bz2"
REG_META_TYPE="bz2"
tar xjvf ${JARVIS_DOWNLOAD}/samtools-1.11.tar.bz2
[ ! $? -eq 0 ] && echo "Invalid file: samtools-1.11.tar.bz2" && exit 1
cd samtools-1.11
CFLAGS="-fsigned-char" ./configure --prefix=$1 --with-htslib=${HTSLIB_PATH}
make -j
make install
mkdir $1/include $1/lib -p
cp ./*.h $1/include -ar
cp ./*.a $1/lib -ar

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
