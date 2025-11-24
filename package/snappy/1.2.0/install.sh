#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/snappy/${BASENAME}
mkdir -p ${WORK_DIR}
{
. ${DOWNLOAD_TOOL} -u https://github.com/google/snappy/archive/refs/tags/1.2.0.tar.gz -f snappy-1.2.0.tar.gz
. ${DOWNLOAD_TOOL} -u https://github.com/google/benchmark/archive/refs/tags/v1.8.3.tar.gz -f benchmark-1.8.3.tar.gz 
. ${DOWNLOAD_TOOL} -u https://github.com/google/googletest/archive/refs/tags/v1.14.0.tar.gz -f googletest-1.14.0.tar.gz
cd ${WORK_DIR}
HVAL=$(md5sum ${JARVIS_DOWNLOAD}/snappy-1.2.0.tar.gz | awk '{print $1}')
HVAL="$HVAL;$(md5sum ${JARVIS_DOWNLOAD}/benchmark-1.8.3.tar.gz | awk '{print $1}')"
HVAL="$HVAL;$(md5sum ${JARVIS_DOWNLOAD}/googletest-1.14.0.tar.gz | awk '{print $1}')"
REG_META_HVALUE="$HVAL"
REG_META_HTYPE="md5;md5;md5"
REG_META_PACKAGE="snappy-1.2.0.tar.gz;benchmark-1.8.3.tar.gz;googletest-1.14.0.tar.gz"
REG_META_TYPE="tgz;tgz;tgz"
[ -d snappy-1.2.0 ] && echo "Exist DIR:$(pwd)/snappy-1.2.0" && exit 1
tar zxvf ${JARVIS_DOWNLOAD}/snappy-1.2.0.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: udunits-2.2.28.tar.gz" && exit 1
tar zxvf ${JARVIS_DOWNLOAD}/benchmark-1.8.3.tar.gz -C snappy-1.2.0/third_party/benchmark --strip-components=1
[ ! $? -eq 0 ] && echo "Invalid file: benchmark-1.8.3.tar.gz" && exit 1
tar zxvf ${JARVIS_DOWNLOAD}/googletest-1.14.0.tar.gz -C snappy-1.2.0/third_party/googletest --strip-components=1
[ ! $? -eq 0 ] && echo "Invalid file: googletest-1.14.0.tar.gz" && exit 1

cd snappy-1.2.0
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"
mkdir build
cd build 
cmake -DCMAKE_INSTALL_PREFIX=${PATH_INSTALL} -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_BUILD_TYPE=Release ../ && make && make install
mkdir -p ${PATH_INSTALL}/bin 
cp snappy_benchmark ${PATH_INSTALL}/bin -ar
cp snappy_unittest  ${PATH_INSTALL}/bin -ar
cp snappy_test_tool ${PATH_INSTALL}/bin -ar

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
