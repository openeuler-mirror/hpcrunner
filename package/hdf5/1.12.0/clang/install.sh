#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/hdf5/clang/${BASENAME}
{
#. $CHECK_ROOT && yum -y install zlib zlib-devel
if [ ! -f /usr/include/zlib.h ]; then
	echo "ERROR: Please yum install zlib zlib-devel"
	exit 1  
fi
hdf5_big_version='1.12'
hdf5_version="${hdf5_big_version}.0"
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${hdf5_big_version}/hdf5-${hdf5_version}/src/hdf5-${hdf5_version}.tar.gz
cd ${JARVIS_DEV_VROOT}/hdf5/clang/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/hdf5-${hdf5_version}.tar.gz| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="hdf5-${hdf5_version}.tar.gz"
REG_META_TYPE="tar.gz"
[ -d hdf5-${hdf5_version} ] && echo "Exist DIR:$(pwd)/hdf5-${hdf5_version}" && exit 1

tar -xvf ${JARVIS_DOWNLOAD}/hdf5-${hdf5_version}.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: hdf5-${hdf5_version}" && exit 1

cd hdf5-${hdf5_version}
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
echo "BUILD DIR:$(pwd)"
export CC=mpicc CXX=mpicxx FC=mpif90 F77=mpif90
./configure --prefix=$1 --enable-fortran --enable-static=yes --with-zlib=/usr/lib --enable-parallel --enable-shared CFLAGS="-O3 -fPIC -Wno-incompatible-pointer-types-discards-qualifiers -Wno-non-literal-null-conversion" FCFLAGS="-O3 -fPIC" LDFLAGS="-Wl,--build-id"
sed -i '11835c wl="-Wl,"' libtool
make -j16
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
} 2>&1 | tee ${JARVIS_DEV_VROOT}/hdf5/clang/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/hdf5/clang/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
