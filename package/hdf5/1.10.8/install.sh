#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORKDIR=${JARVIS_DEV_VROOT}/hdf5/${BASENAME}

mkdir -p ${WORKDIR}
{
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.8/src/hdf5-1.10.8.tar.gz
cd ${WORKDIR}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/hdf5-1.10.8.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="hdf5-1.10.8.tar.gz"
REG_META_TYPE="tar.gz"
[ -d hdf5-1.10.8 ] && echo "Exist DIR:$(pwd)/hdf5-1.10.8" && exit 1

tar -xvf ${JARVIS_DOWNLOAD}/hdf5-1.10.8.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: hdf5-1.10.8.tar.gz" && exit 1
cd hdf5-1.10.8

export CC=mpicc CXX=mpicxx FC=mpif90 F77=mpif90
./configure --prefix=$1  --enable-fortran --enable-static=yes --enable-parallel --enable-shared  --enable-shared CFLAGS="-O3 -fPIC -Wno-incompatible-pointer-types-discards-qualifiers -Wno-non-literal-null-conversion -Wno-implicit-function-declaration -Wno-implicit-int -Wno-int-conversion" FCFLAGS="-O3 -fPIC" LDFLAGS="-Wl,--build-id"

sed -i '11835c wl="-Wl,"' libtool
make -j
make install

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
} 2>&1 | tee ${WORKDIR}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${WORKDIR}/${log_file} ${1}
set +x
exit ${res}

