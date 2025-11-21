#!/bin/bash
set -e
source ${JARVIS_LIBSHELL}
check_rpms_installed  bzip2 bzip2-devel blosc blosc-devel bison bison-devel libffi libffi-devel bzip2 bzip2-devel libpng libpng-devel python3 python3-devel libfabric libfabric-devel || exit 1
set -x
[ -z ${HDF5_PATH} ] && echo "ERROR: require ENV:HDF5_PATH" && exit 1

PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
BUILDDIR=${JARVIS_DEV_VROOT}/adios2/${BASENAME}
mkdir -p ${BUILDDIR}
{
adios2_version="2.10.2"
. ${DOWNLOAD_TOOL} -u https://github.com/ornladios/ADIOS2/archive/refs/tags/v${adios2_version}.tar.gz -f ADIOS2-${adios2_version}.tar.gz
#. $CHECK_DEPS mpicc
#. $CHECK_DEPS HDF5
#. $CHECK_ROOT && yum install -y bzip2 bzip2-devel

### disable python, -DADIOS2_USE_Python=OFF
### enable python, -DADIOS2_USE_Python=OFF
### refer ADIOS2-2.10.2/requirements.txt
### numpy>=1.19
### mpi4py>=3.0.3

cd ${BUILDDIR}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/ADIOS2-${adios2_version}.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="ADIOS2-${adios2_version}.tar.gz"
REG_META_TYPE="tgz"

[ -d "ADIOS2-${adios2_version}" ] && echo "Exist DIR:$(pwd)/ADIOS2-${adios2_version}" && exit 1
rm -rf ADIOS2-${adios2_version}
tar -xvf ${JARVIS_DOWNLOAD}/ADIOS2-${adios2_version}.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: ADIOS2-${adios2_version}.tar.gz" && exit 1

cd ADIOS2-${adios2_version}
sed -i '376i\configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.h.cmake  ${CMAKE_CURRENT_SOURCE_DIR}/ffs/config.h)' thirdparty/ffs/ffs/CMakeLists.txt
sed -i '818i\configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.h.cmake ${CMAKE_CURRENT_SOURCE_DIR}/config.h)' thirdparty/EVPath/EVPath/CMakeLists.txt
mkdir -p build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$1 -DUCX_LIBRARIES=${HMPI_PATH}/hucx/lib/libucp.so -DCMAKE_C_FLAGS="-I${HMPI_PATH}/hucx/include" -DCMAKE_CXX_FLAGS="-L${HMPI_PATH}/hucx/lib -lucs"
make  VERBOSE=1 -j32
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

}  2>&1 | tee ${BUILDDIR}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${BUILDDIR}/${log_file} ${1}
set +x
exit ${res}
