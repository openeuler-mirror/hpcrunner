#download from $JARVIS_PROXY/weathersource/grib_api/archive/refs/tags/v1.21.0.tar.gz
#module  load  bisheng/4.1.0   hmpi/2.4.3  hdf5-clang/1.12.0  netcdf-clang/4.7.4  pnetcdf/1.11.2 
#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/grib_api/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u  $JARVIS_PROXY/weathersource/grib_api/archive/refs/tags/v1.21.0.tar.gz -f grib_api-1.21.0.tar.gz
cd ${JARVIS_DEV_VROOT}/grib_api/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/grib_api-1.21.0.tar.gz| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="grib_api-1.21.0.tar.gz"
REG_META_TYPE="tar.gz"
[ -d grib_api-1.21.0 ] && echo "Exist DIR:$(pwd)/grib_api-1.21.0" && exit 1

tar  -xvf ${JARVIS_DOWNLOAD}/grib_api-1.21.0.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: grib_api-1.21.0.tar.gz" && exit 1
cd grib_api-1.21.0
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
echo "BUILD DIR:$(pwd)"
CC=mpicc F77=mpifort FC=mpifort ./configure --with-netcdf=${NETCDF_CLANG_PATH} --prefix=${1} --build=aarch64-unknown-linux-gnu --disable-jpeg
sed -i '10270c wl="-Wl,"' libtool
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
      
        ]
}
EOF
} 2>&1 | tee ${JARVIS_DEV_VROOT}/grib_api/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/grib_api/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
