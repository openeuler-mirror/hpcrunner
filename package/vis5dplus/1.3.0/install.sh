#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/vis5d/${BASENAME}
BUILD_DIR=$(pwd)
{
. ${DOWNLOAD_TOOL} -u https://sourceforge.net/projects/vis5d/files/vis5d/vis5d%2B-1.3.0-beta/vis5d%2B-1.3.0-beta.tar.gz
cd ${JARVIS_DEV_VROOT}/vis5d/${BASENAME}

REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/vis5d%2B-1.3.0-beta.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="vis5d%2B-1.3.0-beta.tar.gz"
REG_META_TYPE="tgz"
[ -d vis5d+-1.3.0-beta ] && echo "Exist DIR:$(pwd)/vis5d+-1.3.0-beta" && exit 1

tar -xvf ${JARVIS_DOWNLOAD}/vis5d%2B-1.3.0-beta.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: vis5d%2B-1.3.0-beta.tar.gz" && exit 1
cd vis5d+-1.3.0-beta
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"
cd src
patch -p0 < ${BUILD_DIR}/script.c.patch
cd -

sed -i '40c extern float vis_round( float x ); ' src/misc.h
sed -i '150c float vis_round(float x)' src/misc.c

FFLAGS='-fno-range-check -fallow-rank-mismatch' LDFLAGS=-L${MESA_PATH}/lib CFLAGS=-I${MESA_PATH}/include CPPFLAGS=-I${MESA_PATH}/include ./configure --prefix=$1 --disable-fortran --with-netcdf=${NETCDF_PATH} --disable-shared --build=aarch64-unknown-linux-gnu

make
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
        {
            "artifactId": "mesa",
            "version": "",
            "scope": "compile",
            "url": "${MESA_PATH}",
            "packaging": "none"
        },
         {
            "artifactId": "netcdf",
            "version": "",
            "scope": "compile",
            "url": "${NETCDF_PATH}",
            "packaging": "none"
        }
        ]
}
EOF

} 2>&1 | tee ${JARVIS_DEV_VROOT}/vis5d/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/vis5d/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
