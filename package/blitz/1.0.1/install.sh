#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/blitz/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/blitzpp/blitz/archive/refs/tags/1.0.1.tar.gz -f blitz-1.0.1.tar.gz
cd ${JARVIS_DEV_VROOT}/blitz/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/blitz-1.0.1.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="blitz-1.0.1.tar.gz"
REG_META_TYPE="tgz"

[ -d blitz-1.0.1 ] && echo "Exist DIR:$(pwd)/blitz-1.0.1" && exit 1
tar -xzvf ${JARVIS_DOWNLOAD}/blitz-1.0.1.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: blitz-1.0.1.tar.gz" && exit 1
cd blitz-1.0.1
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)


autoreconf -fiv
./configure --prefix=${PATH_INSTALL} --enable-fortran --enable-64bit
sed -i "9s/print/print(/g" blitz/generate/genstencils.py
sed -i "9s/$/)/g" blitz/generate/genstencils.py
make lib
make install
cp -rf ./src ${PATH_INSTALL}

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

} 2>&1 | tee ${JARVIS_DEV_VROOT}/blitz/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/blitz/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
