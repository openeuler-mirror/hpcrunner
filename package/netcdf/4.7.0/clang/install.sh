#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/netcdf/clang/${BASENAME}
{
set -x
set -e
netcdf_c_version='4.7.0'
netcdf_f_version='4.4.5'
. ${DOWNLOAD_TOOL} -u https://codeload.github.com/Unidata/netcdf-fortran/tar.gz/refs/tags/v${netcdf_f_version} -f netcdf-fortran-${netcdf_f_version}.tar.gz
. ${DOWNLOAD_TOOL} -u https://codeload.github.com/Unidata/netcdf-c/tar.gz/refs/tags/v${netcdf_c_version} -f netcdf-c-${netcdf_c_version}.tar.gz 
cd ${JARVIS_DEV_VROOT}/netcdf/clang/${BASENAME}

REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/netcdf-fortran-${netcdf_f_version}.tar.gz | awk '{print $1}')";"$(md5sum ${JARVIS_DOWNLOAD}/netcdf-c-${netcdf_c_version}.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5;md5"
REG_META_PACKAGE="netcdf-fortran-${netcdf_f_version}.tar.gz;netcdf-c-${netcdf_c_version}.tar.gz"
REG_META_TYPE="tgz,tgz"
[ -d netcdf-c-${netcdf_c_version} ] && echo "Exist DIR:$(pwd)/netcdf-c-${netcdf_c_version}" && exit 1
[ -d netcdf-fortran-${netcdf_f_version} ] && echo "Exist DIR:$(pwd)/netcdf-fortran-${netcdf_f_version}" && exit 1
tar -xvf ${JARVIS_DOWNLOAD}/netcdf-c-${netcdf_c_version}.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: netcdf-c-${netcdf_c_version}" && exit 1
tar -xvf ${JARVIS_DOWNLOAD}/netcdf-fortran-${netcdf_f_version}.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: netcdf-fortran-${netcdf_f_version}" && exit 1
cd netcdf-c-${netcdf_c_version}
if [ x"$(arch)" = xaarch64 ];then
    build_type='--build=aarch64-unknown-linux-gnu'
else
    build_type=''
fi
export CC=mpicc CXX=mpicxx FC=mpifort
HDF5_DIR=${HDF5_CLANG_PATH}
PNETCDF_DIR=${PNETCDF_CLANG_PATH}

cd include/
rm -rf ncconfigure.h
unzip ${JARVIS_DOWNLOAD}/ncconfigure.zip
cd ..

./configure --prefix=$1 ${build_type} --enable-shared --enable-netcdf-4 --disable-dap --with-pic --disable-doxygen --enable-static --enable-pnetcdf --enable-largefile CPPFLAGS="-O3 -I${HDF5_DIR}/include -I${PNETCDF_DIR}/include" LDFLAGS="-L${HDF5_DIR}/lib -L${PNETCDF_DIR}/lib -Wl,-rpath=${HDF5_DIR}/lib -Wl,-rpath=${PNETCDF_DIR}/lib" CFLAGS="-O3 -L${HDF5_DIR}/lib -L${PNETCDF_DIR}/lib -I${HDF5_DIR}/include -I${PNETCDF_DIR}/include"

make -j16
make install

export PATH=$1/bin:$PATH
export LD_LIBRARY_PATH=$1/lib:$LD_LIBRARY_PATH
export NETCDF=${1}

cd ../netcdf-fortran-${netcdf_f_version}
./configure --prefix=$1 ${build_type} --enable-shared --with-pic --disable-doxygen --enable-largefile --enable-static CPPFLAGS="-O3 -I${HDF5_DIR}/include -I${1}/include" LDFLAGS="-L${HDF5_DIR}/lib -L${1}/lib -Wl,-rpath=${HDF5_DIR}/lib -Wl,-rpath=${1}/lib" CFLAGS="-O3 -L${HDF5_DIR}/HDF5/lib -L${1}/lib -I${HDF5_DIR}/include -I${1}/include" CXXFLAGS="-O3 -L${HDF5_DIR}/lib -L${1}/lib -I${HDF5_DIR}/include -I${1}/include" FCFLAGS="-O3 -L${HDF5_DIR}/lib -L${1}/lib -I${HDF5_DIR}/include -I${1}/include"
sed -i '11686c wl="-Wl,"' libtool
sed -i '11838c wl="-Wl,"' libtool
make -j16
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
            "url": "${PNETCDF_PATH}",
            "packaging": "none"
        }
        ]
}
EOF

} 2>&1 | tee ${JARVIS_DEV_VROOT}/netcdf/clang/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/netcdf/clang/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
