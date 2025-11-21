#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/proj/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u http://download.osgeo.org/proj/proj-7.0.0.tar.gz
cd ${JARVIS_DEV_VROOT}/proj/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/proj-7.0.0.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="proj-7.0.0.tar.gz"
REG_META_TYPE="tgz"
[ -d proj-5.2.0 ] && echo "Exist DIR:$(pwd)/proj-7.0.0" && exit 1
tar -xvf ${JARVIS_DOWNLOAD}/proj-7.0.0.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: proj-7.0.0.tar.gz" && exit 1

cd proj-7.0.0
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"
sed -i '/constexpr uint16 TIFFTAG_GDAL_METADATA = 42112;.*$/i\#ifndef TIFFTAG_GDAL_METADATA' ./src/grids.cpp 
sed -i '/constexpr uint16 TIFFTAG_GDAL_METADATA = 42112;.*$/a\#endif' ./src/grids.cpp 
sed -i '/constexpr uint16 TIFFTAG_GDAL_NODATA = 42113;.*$/i\#ifndef TIFFTAG_GDAL_NODATA' ./src/grids.cpp 
sed -i '/constexpr uint16 TIFFTAG_GDAL_NODATA = 42113;.*$/a\#endif' ./src/grids.cpp

./configure --enable-shared --enable-static --prefix=$1
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
      
        ]
}
EOF

cat > ${PATH_INSTALL}/module_tail.modulefile << EOF
prepend-path    PKG_CONFIG_PATH    \$prefix/lib/pkgconfig
prepend-path    CPLUS_INCLUDE_PATH \$prefix/include
EOF

} 2>&1 | tee ${JARVIS_DEV_VROOT}/proj/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/proj/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
