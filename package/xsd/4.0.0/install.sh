#!/bin/bash

set -x
set -e

PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/xsd/${BASENAME}
mkdir -p ${WORK_DIR}
{
${DOWNLOAD_TOOL} -u https://www.codesynthesis.com/download/xsd/4.0/xsd-4.0.0+dep.tar.bz2

cd ${WORK_DIR}

[ -d xsd-4.0.0+dep ] && echo "Exist DIR:$(pwd)/xsd-4.0.0+dep" && exit 1
tar --no-same-owner -xjvf ${JARVIS_DOWNLOAD}/xsd-4.0.0+dep.tar.bz2
REG_META_HVALUE="$(md5sum ${JARVIS_DOWNLOAD}/xsd-4.0.0+dep.tar.bz2 | awk '{print $1}')"
REG_META_HTYPE="md5"
REG_META_PACKAGE="xsd-4.0.0+dep.tar.bz2"
REG_META_TYPE="bz2"


cd xsd-4.0.0+dep

sed -i "11s|.*|#include <sstream>|" libxsd-frontend/xsd-frontend/semantic-graph/elements.cxx
sed -i "298s|.*|   std::wstringstream wss;\n   wss << path.string().c_str();\n   return os << wss.str();|" libxsd-frontend/xsd-frontend/semantic-graph/elements.cxx

sed -i '28s|throw (std::bad_alloc)|throw()|' libcutl/cutl/shared-ptr/base.cxx
sed -i '34s|throw (std::bad_alloc)|throw()|; 64s|throw (std::bad_alloc)|throw()|' libcutl/cutl/shared-ptr/base.hxx
sed -i '62s|throw (std::bad_alloc)|throw()|' libcutl/cutl/shared-ptr/base.ixx

make -j 4
make test
make install_prefix=$PATH_INSTALL install

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
           
