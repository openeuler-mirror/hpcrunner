#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/g2clib/${BASENAME}

{
cd ${JARVIS_DOWNLOAD}
#git clone https://gitee.com/linruoxuan/g2clib-image.git
. ${DOWNLOAD_TOOL} -u http://www.ncl.ucar.edu/Download/files/g2clib-1.6.0-patch.tar.gz -f g2clib-1.6.0-patch.tar.gz
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/g2clib-1.6.0-patch.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="g2clib-1.6.0-patch.tar.gz"
REG_META_TYPE="tgz" 
cd ${JARVIS_DEV_VROOT}/g2clib/${BASENAME}
[ -d g2clib-1.6.0-patch] && echo "Exist DIR:$(pwd)/g2clib-1.6.0-patch" && exit 1
tar -xvf ${JARVIS_DOWNLOAD}/g2clib-1.6.0-patch.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: g2clib-1.6.0-patch.tar.gz" && exit 1

cd g2clib-1.6.0-patch
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
echo "BUILD DIR:$(pwd)"
if [ -z "${JASPER_PATH}" ] || [ -z "${LIBPNG_PATH}" ]; then
    echo "JASPER_PATH and LIBPNG_PATH environment variable does not exist "
    exit 0
else
    echo "JASPER_PATH and LIBPNG_PATH environment variables are ready "
fi
sed -i '22c INC=-I${JASPER_PATH}/include -I${LIBPNG_PATH}/include/libpng16' makefile
sed -i '33c CC=gcc' makefile
sed -i '8c #include "png.h"' dec_png.c
make all
cat > ${PATH_INSTALL}/install_registry.json << EOF
{
    "projectURL": "${REG_PROJECT_URL}",
    "projectDate": "${REG_PROJECT_DATE}",
    "packaging": "${REG_META_TYPE}",
    "package": "${REG_META_PACKAGE}",
    "hashType": "${REG_META_HTYPE}",
    "hashValue": "${REG_META_HVALUE}",
    "dependencies": [
        {
            "artifactId": "jasper",
            "version": "",
            "scope": "compile",
            "url": "${JASPER_PATH}",
            "packaging": "none"
        },
         {
            "artifactId": "libpng",
            "version": "",
            "scope": "compile",
            "url": "${LIBPNG_PATH}",
            "packaging": "none"
        }
        ]
}
EOF
mkdir $1/lib -p
mkdir $1/include -p
cp libgrib2c.a $1/lib/ -ar

cp grib2.h $1/include/ -ar

} 2>&1 | tee ${JARVIS_DEV_VROOT}/g2clib/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/g2clib/${BASENAME}/${log_file} ${1}
set +x
exit ${res}

