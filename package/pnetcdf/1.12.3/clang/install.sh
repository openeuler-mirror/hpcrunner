#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/pnetcdf/clang/${BASENAME}
{
pnetcdf_version='1.12.3'
. ${DOWNLOAD_TOOL} -u https://parallel-netcdf.github.io/Release/pnetcdf-${pnetcdf_version}.tar.gz
cd ${JARVIS_DEV_VROOT}/pnetcdf/clang/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/pnetcdf-${pnetcdf_version}.tar.gz| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="pnetcdf-${pnetcdf_version}.tar.gz"
REG_META_TYPE="tar.gz"
[ -d hdf5-1.10.1 ] && echo "Exist DIR:$(pwd)/pnetcdf-${pnetcdf_version}" && exit 1
tar zxvf ${JARVIS_DOWNLOAD}/pnetcdf-${pnetcdf_version}.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: pnetcdf-${pnetcdf_version}.tar.gz" && exit 1
cd pnetcdf-${pnetcdf_version}
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
echo "BUILD DIR:$(pwd)"
./configure --prefix=$1 --build=aarch64-linux --enable-shared --enable-fortran --enable-large-file-test CFLAGS="-fPIC -DPIC" CXXFLAGS="-fPIC -DPIC" FCFLAGS="-fPIC" FFLAGS="-fPIC" CC=mpicc CXX=mpicxx FC=mpifort F77=mpifort
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
} 2>&1 | tee ${JARVIS_DEV_VROOT}/pnetcdf/clang/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/pnetcdf/clang/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
