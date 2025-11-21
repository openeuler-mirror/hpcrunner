#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/jasper/${BASENAME}
jasper_ver="jasper-1.900.2"
{
. ${DOWNLOAD_TOOL} -u https://www.ece.uvic.ca/~frodo/jasper/software/${jasper_ver}.tar.gz
cd ${JARVIS_DEV_VROOT}/jasper/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/${jasper_ver}.tar.gz| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="${jasper_ver}.tar.gz"
REG_META_TYPE="tgz"
[ -d ${jasper_ver}] && echo "Exist DIR:$(pwd)/${jasper_ver}" && exit 1

tar -xvf ${JARVIS_DOWNLOAD}/${jasper_ver}.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: ${jasper_ver}.tar.gz" && exit 1
cd ${jasper_ver}
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
echo "BUILD DIR:$(pwd)"
./configure --prefix=$1
if command -v clang &> /dev/null; then
  CLANG_VERSION=$(clang -v 2>&1 | grep -oP 'clang version \K\d+\.\d+\.\d+')
  if [[ ${CLANG_VERSION} == 17.* ]]; then
    sed -i '76a #include "jasper/jas_debug.h"' ./src/libjasper/base/jas_getopt.c
    sed -i '76a #include "jasper/jas_debug.h"' ./src/libjasper/bmp/bmp_dec.c
    sed -i '76a #include "jasper/jas_debug.h"' ./src/libjasper/jpc/jpc_t1dec.c
    sed -i '71a #include "jasper/jas_debug.h"' ./src/libjasper/jpg/jpg_dummy.c
    sed -i '71a #include "jasper/jas_debug.h"' ./src/libjasper/mif/mif_cod.c
    sed -i '81a #include "jasper/jas_debug.h"' ./src/libjasper/pnm/pnm_dec.c

    sed -i 's/jpc_ft_synthesize(int/jpc_ft_synthesize(jpc_fix_t/g' ./src/libjasper/jpc/jpc_qmfb.c
    sed -i 's/analyze)(int/analyze)(jpc_fix_t/g' ./src/libjasper/jpc/jpc_qmfb.h
    sed -i 's/synthesize)(int/synthesize)(jpc_fix_t/g' ./src/libjasper/jpc/jpc_qmfb.h
    sed -i '76a #include "jpc_fix.h"' ./src/libjasper/jpc/jpc_qmfb.h

    sed -i -e '122,129H' -e '122,129d' -e '148G' ./src/libjasper/jpc/jpc_tsfb.c
    sed -i -e '150,157H' -e '150,157d' -e '177G' ./src/libjasper/jpc/jpc_tsfb.c
  fi
fi
sed -i '961 { /^\/\// { s/^\/\//\/\*/; s/$/&\*\// } }' ./src/appl/jiv.c
sed -i '962 { /^\/\// { s/^\/\//\/\*/; s/$/&\*\// } }' ./src/appl/jiv.c
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
} 2>&1 | tee ${JARVIS_DEV_VROOT}/jasper/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/jasper/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
