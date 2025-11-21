#!/bin/bash
set -e
source ${JARVIS_LIBSHELL}
check_rpms_installed  libtirpc-devel libtirpc || exit 1
set -x
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/hdf4/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.15/src/hdf-4.2.15.tar.gz
cd ${JARVIS_DEV_VROOT}/hdf4/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/hdf-4.2.15.tar.gz| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="hdf-4.2.15.tar.gz"
REG_META_TYPE="tar.gz"

[ -d hdf-4.2.15 ] && echo "Exist DIR:$(pwd)/hdf-4.2.15" && exit 1

tar -xvf ${JARVIS_DOWNLOAD}/hdf-4.2.15.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: hdf-4.2.15.tar.gz" && exit 1

cd hdf-4.2.15
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
echo "BUILD DIR:$(pwd)"

sed -i '974c #if defined(__linux__) && defined __x86_64__ && !( defined SUN) || defined(__aarch64__)' hdf/src/hdfi.h
sed -i '23660a LIBS="$LIBS -ltirpc"' configure
sed -i '23662c CPPFLAGS="$SYSCPPFLAGS -I/usr/include/tirpc"' configure
export CC=mpicc CXX=mpicxx FC=mpifort
./configure --prefix=$1 --enable-production --with-zlib=/usr/lib64 --enable-fortran --enable-hdf4-xdr --disable-shared --build=arm-linux  --with-jpeg=${LIBJPEG_PATH} --disable-netcdf CFLAGS="-fPIC -Wno-error=int-conversion -Wno-implicit-function-declaration -Wno-incompatible-function-pointer-types -Wno-implicit-int -fallow-argument-mismatch" CXXFLAGS="-fPIC -Wno-error=int-conversion -Wno-implicit-function-declaration -Wno-incompatible-function-pointer-types -Wno-implicit-int" FFLAGS="-fPIC -fallow-argument-mismatch -Wno-error=int-conversion -Wno-implicit-function-declaration -Wno-incompatible-function-pointer-types -Wno-implicit-int" LDFLAGS="-L/usr/lib64 -ltirpc"
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
} 2>&1 | tee ${JARVIS_DEV_VROOT}/hdf4/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/hdf4/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
