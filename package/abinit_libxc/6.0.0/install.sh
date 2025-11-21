#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/abinit_deps/${BASENAME}
mkdir -p ${WORK_DIR}
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
{
${DOWNLOAD_TOOL} -u https://forge.abinit.org/libxc-6.0.0.tar.gz  -f libxc-6.0.0.tar.gz
cd ${WORK_DIR}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/libxc-6.0.0.tar.gz| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="libxc-6.0.0.tar.gz"
REG_META_TYPE="tar.gz"
[ -d libxc-6.0.0 ] && echo "Exist DIR:$(pwd)/libxc-6.0.0" && exit 1
tar -xvf ${JARVIS_DOWNLOAD}/libxc-6.0.0.tar.gz
cd libxc-6.0.0


CFLAGS="-fsigned-char -fPIC -DPIC" CPPFLAGS="-fsigned-char -fPIC -DPIC" FCFLAGS="-fPIC" FFLAGS="-fPIC" ./configure --enable-kxc \
	--prefix=${PATH_INSTALL}
make -j16
make install
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
echo "BUILD DIR:$(pwd)"

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

