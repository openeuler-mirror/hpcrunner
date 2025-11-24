#!/bin/bash
#. $CHECK_ROOT && yum install libXt-devel.aarch64 readline-devel.aarch64
set -x
set -e

set +x && source ${JARVIS_LIBSHELL}  && set -x
set +x && check_rpms_installed libXt-devel libXt libXmu-devel libXmu libXt-devel libXt libX11-devel libX11 libXext-devel libXext \
	readline-devel readline \
	cairo-devel cairo harfbuzz-devel harfbuzz pango-devel pango libpng-devel libpng glib2-devel glib2 libjpeg-turbo-devel libjpeg-turbo \
       	curl libcurl libcurl-devel \
       	zlib zlib-devel bzip2 bzip2-devel xz-devel bzip2 bzip2-devel xz xz-libs xz-devel \
       	openssl openssl-devel \
	glibc glibc-common glibc-devel \
       	pcre2 pcre2-devel || exit 1
set -x

PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/R/${BASENAME}
mkdir -p ${WORK_DIR}
{
. ${DOWNLOAD_TOOL} -u https://cran.r-project.org/src/base/R-4/R-4.2.0.tar.gz
cd ${WORK_DIR}
[ -d R-4.2.0  ] && echo "Exist DIR:$(pwd)/R-4.2.0 " && exit 1
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/R-4.2.0.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="R-4.2.0.tar.gz"
REG_META_TYPE="tgz"
tar -xvf ${JARVIS_DOWNLOAD}/R-4.2.0.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: R-4.2.0.tar.gz" && exit 1
cd R-4.2.0
./configure -enable-R-shlib -enable-R-static-lib --with-libpng --with-jpeglib --prefix=$1

make all -j
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

