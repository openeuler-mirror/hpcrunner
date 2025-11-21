#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/boost/clang/${BASENAME}
BASE=$(pwd)
{
. ${DOWNLOAD_TOOL} -u https://nchc.dl.sourceforge.net/project/boost/boost/1.70.0/boost_1_70_0.tar.bz2
cd ${JARVIS_DEV_VROOT}/boost/clang/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/boost_1_70_0.tar.bz2 | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="boost_1_70_0.tar.bz2"
REG_META_TYPE="bz2"

[ -d boost_1_70_0 ] && echo "Exist DIR:$(pwd)/boost_1_70_0" && exit 1
tar -xvf ${JARVIS_DOWNLOAD}/boost_1_70_0.tar.bz2
[ ! $? -eq 0 ] && echo "Invalid file: boost_1_70_0.tar.bz2" && exit 1

cd boost_1_70_0
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"

sed -i '60s/.*/#ifdef PTHREAD_STACK_MIN/' ./boost/thread/pthread/thread_data.hpp
./bootstrap.sh --with-toolset=clang \
               --with-libraries=system,filesystem,serialization,program_options

./b2 cxxflags="-std=c++14 -stdlib=libc++ -Wno-error=enum-constexpr-conversion" \
     linkflags="-std=c++14 -stdlib=libc++ -Wno-error=enum-constexpr-conversion" \
     install --prefix=$PATH_INSTALL

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
setenv PRJ_URL_BOOST_01700 "${REG_PROJECT_URL}"
EOF

} 2>&1 | tee ${JARVIS_DEV_VROOT}/boost/clang/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/boost/clang/${BASENAME}/${log_file} "${PATH_INSTALL}"
set +x
exit ${res} 
