#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/hdfeos2/${BASENAME}
{
if [ -z "${HDF4_PATH}" ] ||  [ -z "${LIBJPEG_PATH}" ]; then
	echo "ERROR: INVALID ENV HDF4_PATH:${HDF4_PATH},LIBJPEG_PATH:${LIBJPEG_PATH}!!!"
	exit 1
fi
. ${DOWNLOAD_TOOL} -u https://git.earthdata.nasa.gov/rest/git-lfs/storage/DAS/hdfeos/cb0f900d2732ab01e51284d6c9e90d0e852d61bba9bce3b43af0430ab5414903?response-content-disposition=attachment%3B%20filename%3D%22HDF-EOS2.20v1.00.tar.Z%22%3B%20filename*%3Dutf-8%27%27HDF-EOS2.20v1.00.tar.Z -f HDF-EOS2.20v1.00.tar

#cp -f cb0f900d2732ab01e51284d6c9e90d0e852d61bba9bce3b43af0430ab5414903* HDF-EOS2.20v1.00.tar
cd ${JARVIS_DEV_VROOT}/hdfeos2/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/HDF-EOS2.20v1.00.tar | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="HDF-EOS2.20v1.00.tar"
REG_META_TYPE="tgz"
# gzip -d ${JARVIS_DOWNLOAD}/HDF-EOS2.20v1.00.tar

[ -d hdfeos ] && echo "Exist DIR:$(pwd)/hdfeos" && exit 1
tar -xvf ${JARVIS_DOWNLOAD}/HDF-EOS2.20v1.00.tar
[ ! $? -eq 0 ] && echo "Invalid file: HDF-EOS2.20v1.00.tar" && exit 1
cd hdfeos
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes ./configure --with-hdf4=${HDF4_PATH} --with-jpeg=${LIBJPEG_PATH} --with-zlib=/usr/local --prefix=$1 --build=aarch64-unknown-linux-gnu
make -j
make install
cp -r include $1/
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
} 2>&1 | tee ${JARVIS_DEV_VROOT}/hdfeos2/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/hdfeos2/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
