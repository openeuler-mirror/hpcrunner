#!/bin/bash
PATH_INSTALL=$1
BUILD_DIR=$2
set -x
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/Unidata/netcdf-fortran/archive/refs/tags/v${netcdf_f_version}.tar.gz -f netcdf-fortran-${netcdf_f_version}.tar.gz
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/Unidata/netcdf-c/archive/refs/tags/v${netcdf_c_version}.tar.gz -f netcdf-c-${netcdf_c_version}.tar.gz 
if [ "X${BUILD_DIR}Y" != "XY" ] && [ -d "${BUILD_DIR}" ]; then
cd $BUILD_DIR
else
cd ${JARVIS_TMP}
fi

[ -d netcdf-c-${netcdf_c_version} ] && echo "Exist DIR:$(pwd)" && exit 1
[ -d netcdf-fortran-${netcdf_f_version} ] && echo "Exist DIR:$(pwd)" && exit 1

REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/netcdf-c-${netcdf_c_version}.tar.gz | awk '{print $1}')";"$(md5sum ${JARVIS_DOWNLOAD}/netcdf-c-${netcdf_c_version}.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5;md5"
REG_META_PACKAGE="netcdf-fortran-${netcdf_f_version}.tar.gz;netcdf-c-${netcdf_c_version}.tar.gz"
REG_META_TYPE="tgz,tgz"

tar -zxvf ${JARVIS_DOWNLOAD}/netcdf-c-${netcdf_c_version}.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: netcdf-c-${netcdf_c_version}" && exit 1
tar -zxvf ${JARVIS_DOWNLOAD}/netcdf-fortran-${netcdf_f_version}.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: netcdf-fortran-${netcdf_f_version}" && exit 1

cd netcdf-c-${netcdf_c_version}
if [ x"$(arch)" = xaarch64 ];then
    build_type='--build=aarch64-unknown-linux-gnu'
else
    build_type=''
fi
export CC=mpicc CXX=mpicxx FC=mpifort
export HDF5_DIR=${HDF5_CLANG_PATH}
export PNETCDF_DIR=${PNETCDF_CLANG_PATH}
[ ! -d ${HDF5_DIR}/lib ] && echo "Require DIR:${HDF5_DIR}/lib" && exit 1
[ ! -d ${PNETCDF_DIR}/lib ] && echo "Require DIR:${PNETCDF_DIR}/lib" && exit 1

./configure --prefix=$1 ${build_type} --enable-shared --enable-netcdf-4 --disable-dap --with-pic --disable-doxygen --enable-static --enable-pnetcdf --enable-largefile CPPFLAGS="-O3 -I${HDF5_DIR}/include -I${PNETCDF_DIR}/include" LDFLAGS="-L${HDF5_DIR}/lib -L${PNETCDF_DIR}/lib -Wl,-rpath=${HDF5_DIR}/lib -Wl,-rpath=${PNETCDF_DIR}/lib" CFLAGS="-O3 -L${HDF5_DIR}/lib -L${PNETCDF_DIR}/lib -I${HDF5_DIR}/include -I${PNETCDF_DIR}/include"

make -j16
make install

[ -f $1/lib/libnetcdf.so ] ||  exit 1

export PATH=$1/bin:$PATH
export LD_LIBRARY_PATH=$1/lib:$LD_LIBRARY_PATH
export NETCDF=${1}

cd ../netcdf-fortran-${netcdf_f_version}
./configure --prefix=$1 ${build_type} --enable-shared --with-pic --disable-doxygen --enable-largefile --enable-static CPPFLAGS="-O3 -I${HDF5_DIR}/include -I${1}/include" LDFLAGS="-L${HDF5_DIR}/lib -L${1}/lib -Wl,-rpath=${HDF5_DIR}/lib -Wl,-rpath=${1}/lib" CFLAGS="-O3 -L${HDF5_DIR}/lib -L${1}/lib -I${HDF5_DIR}/include -I${1}/include" CXXFLAGS="-O3 -L${HDF5_DIR}/lib -L${1}/lib -I${HDF5_DIR}/include -I${1}/include" FCFLAGS="-O3 -L${HDF5_DIR}/lib -L${1}/lib -I${HDF5_DIR}/include -I${1}/include"
sed -i 's/^wl=""/wl="-Wl,"/g' ./libtool
#sed -i '11686c wl="-Wl,"' libtool
#sed -i '11838c wl="-Wl,"' libtool
set +x
make -j16
make install
[  -f $1/lib/libnetcdff.so ] ||  exit 1

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
            "url": "${HDF5_DIR}",
            "packaging": "none"
        },
        {
            "artifactId": "pnetcdf",
            "version": "",
            "scope": "compile",
            "url": "${PNETCDF_DIR}",
            "packaging": "none"
        }
        ]
}
EOF
