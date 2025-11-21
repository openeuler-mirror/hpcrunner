#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/boost/clang/${BASENAME}
BASE=$(pwd)
{
. ${DOWNLOAD_TOOL} -u https://nchc.dl.sourceforge.net/project/boost/boost/1.72.0/boost_1_72_0.tar.bz2
cd ${JARVIS_DEV_VROOT}/boost/clang/${BASENAME}
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

sed -i '60s/.*/#ifdef PTHREAD_STACK_MIN/' ./boost/thread/pthread/thread_data.hpp
#./bootstrap.sh --with-toolset=clang --with-libraries=system,serialization,program_options
# 若需要支持python，则需要安装yum install python3-devel
# 当前版本filesystem接口测试失败，因此关闭filesystem
# ./b2 toolset=clang cxxflags="-std=c++14 -stdlib=libc++ -Wno-error=enum-constexpr-conversion" linkflags="-std=c++14 -stdlib=libc++ -Wno-error=enum-constexpr-conversion" libs/filesystem/test
# --without-python
#./bootstrap.sh
#./b2 toolset=clang cxxflags="-std=c++14 -stdlib=libc++ -Wno-error=enum-constexpr-conversion" linkflags="-std=c++14 -stdlib=libc++ -Wno-error=enum-constexpr-conversion" install --prefix=${PATH_INSTALL} --without-filesystem --without-python

export CC="clang  -O3 -fcommon -Wno-incompatible-function-pointer-types -Wno-enum-constexpr-conversion Wno-implicit-function-declaration -Wno-dynamic-exception-spec -Wno-error=register  -Wno-implicit-int -Wno-enum-constexpr-conversion  -Wno-missing-template-arg-list-after-template-kw -fdelayed-template-parsing "
export  CXX="clang++  -O3 -fcommon -Wno-incompatible-function-pointer-types -Wno-enum-constexpr-conversion -Wno-implicit-function-declaration -Wno-dynamic-exception-spec -Wno-error=register  -Wno-implicit-int -Wno-enum-constexpr-conversion  -Wno-missing-template-arg-list-after-template-kw  -fdelayed-template-parsing"
export  FC="flang  -O3 -fcommon -Wno-incompatible-function-pointer-types -Wno-enum-constexpr-conversion -Wno-implicit-function-declaration -Wno-dynamic-exception-spec -Wno-error=register  -Wno-implicit-int -Wno-enum-constexpr-conversion  -Wno-missing-template-arg-list-after-template-kw  "

( unset CPLUS_INCLUDE_PATH; ./bootstrap.sh )
./b2 toolset=clang cxxflags="-Wno-enum-constexpr-conversion" -d+2 install --prefix=${PATH_INSTALL}
cd status
../b2 toolset=clang cxxflags="-Wno-enum-constexpr-conversion" --limit-tests=system*
cd -

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

} 2>&1 | tee ${JARVIS_DEV_VROOT}/boost/clang/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/boost/clang/${BASENAME}/${log_file} "${PATH_INSTALL}"
set +x
exit ${res} 
