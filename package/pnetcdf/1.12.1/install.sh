#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORKDIR=${JARVIS_DEV_VROOT}/pnetcdf/${BASENAME}
mkdir -p ${WORKDIR}
pnetcdf_ver='1.12.1'
{
. ${DOWNLOAD_TOOL} -u http://cucis.ece.northwestern.edu/projects/PnetCDF/Release/pnetcdf-${pnetcdf_ver}.tar.gz
cd ${WORKDIR}

REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/pnetcdf-${pnetcdf_ver}.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="pnetcdf-${pnetcdf_ver}.tar.gz"
REG_META_TYPE="tar.gz"

[ -d pnetcdf-${pnetcdf_ver} ] && echo "Exist DIR:$(pwd)/pnetcdf-${pnetcdf_ver}" && exit 1
tar zxvf ${JARVIS_DOWNLOAD}/pnetcdf-${pnetcdf_ver}.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: pnetcdf-1.11.2.tar.gz" && exit 1
cd pnetcdf-${pnetcdf_ver}
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"
export CC=mpicc CXX=mpicxx FC=mpifort F77=mpifort F90=mpifort
./configure --build=aarch64-linux  --prefix=$1 --enable-shared --enable-fortran --enable-large-file-test FCFLAGS="-fallow-argument-mismatch -g -O2"
make -j16
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
} 2>&1 | tee ${WORKDIR}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${WORKDIR}/${log_file} ${1}
set +x
exit ${res}
