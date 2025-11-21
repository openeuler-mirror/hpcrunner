#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/boost/${BASENAME}
BASE=$(pwd)
{

. ${DOWNLOAD_TOOL} -u https://nchc.dl.sourceforge.net/project/boost/boost/1.72.0/boost_1_72_0.tar.bz2
cd ${JARVIS_DEV_VROOT}/boost/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/boost_1_72_0.tar.bz2 | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="boost_1_72_0.tar.bz2"
REG_META_TYPE="bz2"

[ -d boost_1_72_0 ] && echo "Exist DIR:$(pwd)/boost_1_72_0" && exit 1
tar -xvf ${JARVIS_DOWNLOAD}/boost_1_72_0.tar.bz2
[ ! $? -eq 0 ] && echo "Invalid file: boost_1_72_0.tar.bz2" && exit 1

cd boost_1_72_0
if [ -f "${BASE}/patch.sh" ]; then
	"${BASE}/patch.sh" ${BASE} $(pwd)
fi
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"

#https://boostorg.jfrog.io/artifactory/main/release/1.72.0/source/boost_1_72_0.tar.gz
sed -i '60s/.*/#ifdef PTHREAD_STACK_MIN/' ./boost/thread/pthread/thread_data.hpp
( unset CPLUS_INCLUDE_PATH; ./bootstrap.sh )
./b2 install --prefix="${PATH_INSTALL}"

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

cat > ${PATH_INSTALL}/module_tail.modulefile << EOF
setenv PRJ_URL_BOOST_01720 "${REG_PROJECT_URL}"
EOF

} 2>&1 | tee ${JARVIS_DEV_VROOT}/boost/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/boost/${BASENAME}/${log_file} "${PATH_INSTALL}"
set +x
exit ${res}
