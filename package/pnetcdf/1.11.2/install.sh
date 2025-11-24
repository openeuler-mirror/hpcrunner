#!/bin/bash

set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/pnetcdf/${BASENAME}
pnetcdf_ver='1.11.2'
{
. ${DOWNLOAD_TOOL} -u http://cucis.ece.northwestern.edu/projects/PnetCDF/Release/pnetcdf-${pnetcdf_ver}.tar.gz
cd ${JARVIS_DEV_VROOT}/pnetcdf/${BASENAME}

REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/pnetcdf-1.11.2.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="pnetcdf-1.11.2.tar.gz"
REG_META_TYPE="tar.gz"

[ -d pnetcdf-1.11.2 ] && echo "Exist DIR:$(pwd)/pnetcdf-1.11.2" && exit 1
tar zxvf ${JARVIS_DOWNLOAD}/pnetcdf-1.11.2.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: pnetcdf-1.11.2.tar.gz" && exit 1
cd pnetcdf-1.11.2
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"
#./configure --prefix=${PATH_INSTALL} --enable-shared --enable-fortran --enable-large-file-test FCFLAGS="-fallow-argument-mismatch -g -O2" 
./configure --prefix=$1 --build=aarch64-linux --enable-shared --enable-fortran --enable-large-file-test FCFLAGS="-fallow-argument-mismatch -g -O2"  CC=mpicc CXX=mpicxx FC=mpif90 F77=mpif90
make -j 32
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
} 2>&1 | tee ${JARVIS_DEV_VROOT}/pnetcdf/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/pnetcdf/${BASENAME}/${log_file} ${1}
set +x
exit ${res}