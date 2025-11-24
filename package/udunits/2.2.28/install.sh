#!/bin/bash
set -x
set -e
set +x && source ${JARVIS_LIBSHELL}  && set -x
set +x && check_rpms_installed  expat-devel expat || exit 1
set -x
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/udunits/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u https://artifacts.unidata.ucar.edu/repository/downloads-udunits/2.2.28/udunits-2.2.28.tar.gz
cd ${JARVIS_DEV_VROOT}/udunits/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/udunits-2.2.28.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="udunits-2.2.28.tar.gz"
REG_META_TYPE="tar.gz"

[ -d udunits-2.2.28 ] && echo "Exist DIR:$(pwd)/udunits-2.2.28" && exit 1

tar xvf ${JARVIS_DOWNLOAD}/udunits-2.2.28.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: udunits-2.2.28.tar.gz" && exit 1
cd udunits-2.2.28
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"
./configure --prefix=$1 LDFLAGS="-L/usr/lib64" CFLAGS="-I/usr/include" 
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

cat > ${PATH_INSTALL}/module_tail.modulefile << EOF
setenv UDUNITS2_INCLUDE \$prefix/include
setenv UDUNITS2_LIBS    \$prefix/lib
EOF

} 2>&1 | tee ${JARVIS_DEV_VROOT}/udunits/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/udunits/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
