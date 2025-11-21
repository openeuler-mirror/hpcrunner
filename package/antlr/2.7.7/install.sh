#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/antlr/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u https://www.antlr2.org/download/antlr-2.7.7.tar.gz
cd ${JARVIS_DEV_VROOT}/antlr/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/antlr-2.7.7.tar.gz| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="antlr-2.7.7.tar.gz"
REG_META_TYPE="tar.gz"
[ -d antlr-2.7.7 ] && echo "Exist DIR:$(pwd)/antlr-2.7.7" && exit 1
tar xvf ${JARVIS_DOWNLOAD}/antlr-2.7.7.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: antlr-2.7.7.tar.gz" && exit 1
cd antlr-2.7.7
sed -i "13a #include <strings.h>" lib/cpp/antlr/CharScanner.hpp
sed -i "14a #include <cstdio>" lib/cpp/antlr/CharScanner.hpp
./configure \
--prefix=$1 \
--disable-csharp \
--disable-java \
--disable-python --build=arm-linux
make -j
make install

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
} 2>&1 | tee ${JARVIS_DEV_VROOT}/antlr/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/antlr/${BASENAME}/${log_file} ${1}
set +x
exit ${res}