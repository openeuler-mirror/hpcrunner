#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/gdal/${BASENAME}
{

if [ -z "${PROJ_PATH}" ] || [ -z "${NETCDF_PATH}" ] ; then
echo "ERROR: Require PROJ_PATH:${PROJ_PATH}"
echo "ERROR: Require LIBPNG_PATH:${NETCDF_PATH}"
exit 1
fi
. ${DOWNLOAD_TOOL} -u http://download.osgeo.org/gdal/3.9.0/gdal-3.9.0.tar.gz
cd ${JARVIS_DEV_VROOT}/gdal/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/gdal-3.9.0.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="gdal-3.9.0.tar.gz"
REG_META_TYPE="tgz"
[ -d gdal-3.9.0 ] && echo "Exist DIR:$(pwd)/gdal-3.9.0" && exit 1
tar -xvf ${JARVIS_DOWNLOAD}/gdal-3.9.0.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: gdal-3.9.0.tar.gz " && exit 1
cd gdal-3.9.0
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"
mkdir build -p
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=${PATH_INSTALL} \
-DGDAL_BUILD_OPTIONAL_DRIVERS=OFF -DOGR_BUILD_OPTIONAL_DRIVERS=OFF -DCMAKE_BUILD_TYPE=Release  \
-DGDAL_USE_NETCDF=ON -DNETCDF_INCLUDE_DIR=$NETCDF_PATH/include  -DNETCDF_LIBRARY=$NETCDF_PATH/lib/libnetcdf.so \
-DCMAKE_PREFIX_PATH=$PROJ_PATH 

#make VERBOSE=on

make  
make install
cat > ${PATH_INSTALL}/module_tail.modulefile << EOF
setenv PRJ_URL_GDAL_030900 "${REG_PROJECT_URL}"
EOF

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
