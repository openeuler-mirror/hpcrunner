#download from https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.1/src/hdf5-1.10.1.tar.gz
#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/hdf5/nompi/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.1/src/hdf5-1.10.1.tar.gz
cd ${JARVIS_DEV_VROOT}/hdf5/nompi/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/hdf5-1.10.1.tar.gz| awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="hdf5-1.10.1.tar.gz"
REG_META_TYPE="tar.gz"
[ -d hdf5-1.10.1 ] && echo "Exist DIR:$(pwd)/hdf5-1.10.1" && exit 1
tar -xvf ${JARVIS_DOWNLOAD}/hdf5-1.10.1.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: hdf5-1.10.1.tar.gz" && exit 1
cd hdf5-1.10.1
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)
echo "BUILD DIR:$(pwd)"
#CC=mpicc CXX=mpicxx FC=mpifort F77=mpifort -Wno-incompatible-pointer-types-discards-qualifiers
./configure --prefix=$1  --enable-fortran --enable-static=yes --enable-cxx --enable-shared
sed -i '11835c wl="-Wl,"' libtool
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

cat > ${PATH_INSTALL}/module_tail.modulefile << EOF
prepend-path    LD_RUN_PATH    \$prefix/lib
prepend-path    CPLUS_INCLUDE_PATH    \$prefix/include
EOF

} 2>&1 | tee ${JARVIS_DEV_VROOT}/hdf5/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/hdf5/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
