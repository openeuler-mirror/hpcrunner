#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/hdfeos5/${BASENAME}
{
if [ -z "${HDF5_PATH}" ] ; then
        echo "ERROR: INVALID ENV HDF4_PATH:${HDF5_PATH}!!!"
        exit 1
fi	
. ${DOWNLOAD_TOOL} -u https://git.earthdata.nasa.gov/rest/git-lfs/storage/DAS/hdfeos5/7054de24b90b6d9533329ef8dc89912c5227c83fb447792103279364e13dd452?response-content-disposition=attachment%3B%20filename%3D%22HDF-EOS5.1.16.tar.Z%22%3B%20filename*%3Dutf-8%27%27HDF-EOS5.1.16.tar.Z  -f HDF-EOS5.1.16.tar
cd  ${JARVIS_DEV_VROOT}/hdfeos5/${BASENAME}
#cp -f 7054de24b90b6d9533329ef8dc89912c5227c83fb447792103279364e13dd452* HDF-EOS5.1.16.tar

REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/HDF-EOS5.1.16.tar| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="HDF-EOS5.1.16.tar"
REG_META_TYPE="tgz"
[ -d hdfeos5 ] && echo "Exist DIR:$(pwd)/hdfeos5" && exit 1
tar -xvf ${JARVIS_DOWNLOAD}/HDF-EOS5.1.16.tar
cd hdfeos5
./configure CC=${HDF5_PATH}/bin/h5pcc --with-hdf4=${HDF5_PATH} --with-zlib=/usr/local --prefix=$1 --build=aarch64-unknown-linux-gnu
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
        {
            "artifactId": "hdf5",
            "version": "",
            "scope": "compile",
            "url": "${HDF5_PATH}",
            "packaging": "none"
        }
        ]
}
EOF
} 2>&1 | tee ${JARVIS_DEV_VROOT}/hdfeos5/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/hdfeos5/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
