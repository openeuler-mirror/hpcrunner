#!/bin/bash
set -x
set -e
[ -z "${CC}" ] && echo "ERROR: invalid ENV CC!!!" && exit 1
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/boost/${BASENAME}
mkdir -p ${WORK_DIR}
{
${DOWNLOAD_TOOL} -u http://downloads.sourceforge.net/project/boost/boost/1.58.0/boost_1_58_0.tar.gz

cd ${WORK_DIR}
[ -d boost_1_58_0  ] && echo "Exist DIR:$(pwd)/boost_1_58_0" && exit 1

tar --no-same-owner -zxvf ${JARVIS_DOWNLOAD}/boost_1_58_0.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: boost_1_58_0.tar.gz" && exit 1

REG_META_HVALUE="$(md5sum ${JARVIS_DOWNLOAD}/boost_1_58_0.tar.gz | awk '{print $1}')"
REG_META_HTYPE="md5"
REG_META_PACKAGE="boost_1_58_0.tar.gz"
REG_META_TYPE="tgz"

cd boost_1_58_0

sed -ri 's/\-m64/\-mabi=lp64/g' $(grep -Rl '\-m64')

./bootstrap.sh --prefix=$PATH_INSTALL \
            --with-libraries=system,filesystem,serialization,program_options \
            --with-toolset=${CC}

./b2 install

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
