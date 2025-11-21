#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/gdal/${BASENAME}
{

. ${DOWNLOAD_TOOL} -u http://download.osgeo.org/gdal/2.2.4/gdal-2.2.4.tar.gz
cd ${JARVIS_DEV_VROOT}/gdal/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/gdal-2.2.4.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="gdal-2.2.4.tar.gz"
REG_META_TYPE="tgz"
[ -d gdal-2.2.4 ] && echo "Exist DIR:$(pwd)/gdal-2.2.4" && exit 1
tar -xvf ${JARVIS_DOWNLOAD}/gdal-2.2.4.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: gdal-2.2.4.tar.gz " && exit 1
cd gdal-2.2.4
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"

./configure --with-static-proj4=${PROJ_PATH} --prefix=$1 --with-png=${LIBPNG_PATH} --with-gif=internal --with-libtiff=internal \
      --with-geotiff=internal --with-jpeg=${LIBJPEG_PATH} --with-libz=/usr/local \
      --with-sqlite3=no --with-expat=no --with-curl=no --without-ld-shared \
      --with-hdf4=no --with-hdf5=no --with-pg=no --without-grib --enable-shared \
      --with-freexl=no --with-geos=no --with-openjpeg=no --with-mysql=no \
      --with-ecw=no --with-fgdb=no --with-odbc=no --with-xml2=no --with-ogdi=no\
      --with-pcraster=no --with-xerces=no
make all install
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
            "artifactId": "libpng",
            "version": "",
            "scope": "compile",
            "url": "${LIBPNG_PATH}",
            "packaging": "none"
        },  {
            "artifactId": "proj",
            "version": "",
            "scope": "compile",
            "url": "${PROJ_PATH}",
            "packaging": "none"
        }
        ]
}
EOF
} 2>&1 | tee ${JARVIS_DEV_VROOT}/gdal/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/gdal/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
