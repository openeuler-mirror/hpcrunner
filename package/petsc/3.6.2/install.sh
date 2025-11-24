#!/bin/bash
set -x
set -e

PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
WORK_DIR=${JARVIS_DEV_VROOT}/petsc/${BASENAME}
mkdir -p ${WORK_DIR}
{
install_path=$1

${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.16/src/hdf5-1.8.16.tar.bz2
${DOWNLOAD_TOOL} -u http://ftp.mcs.anl.gov/pub/petsc/externalpackages/f2cblaslapack-3.4.2.q1.tar.gz
${DOWNLOAD_TOOL} -u http://ftp.mcs.anl.gov/pub/petsc/externalpackages/parmetis-4.0.3-p2.tar.gz
${DOWNLOAD_TOOL} -u http://ftp.mcs.anl.gov/pub/petsc/externalpackages/sundials-2.5.0p1.tar.gz
${DOWNLOAD_TOOL} -u http://ftp.mcs.anl.gov/pub/petsc/externalpackages/metis-5.1.0-p1.tar.gz
${DOWNLOAD_TOOL} -u http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.6.2.tar.gz

cd ${WORK_DIR}

[ -d petsc-3.6.2  ] && echo "Exist DIR:$(pwd)/petsc-3.6.2" && exit 1
tar --no-same-owner -zxvf ${JARVIS_DOWNLOAD}/petsc-lite-3.6.2.tar.gz
REG_META_HVALUE="$(md5sum ${JARVIS_DOWNLOAD}/petsc-lite-3.6.2.tar.gz | awk '{print $1}')"
REG_META_HTYPE="md5"
REG_META_PACKAGE="petsc-lite-3.6.2.tar.gz"
REG_META_TYPE="tgz"

cd petsc-3.6.2

export PETSC_DIR=$(pwd)
export PETSC_ARCH=linux_gnu

export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

sed -i "37a\    args.append('--build=aarch64-unknown-linux-gnu')" config/BuildSystem/config/packages/hdf5.py
sed -i "38a\    args.append('--host=aarch64-unknown-linux-gnu')" config/BuildSystem/config/packages/hdf5.py

sed -i "68a\    args.append('--build=aarch64-unknown-linux-gnu')" config/BuildSystem/config/packages/sundials.py
sed -i "69a\    args.append('--host=aarch64-unknown-linux-gnu')" config/BuildSystem/config/packages/sundials.py

./configure -prefix=$install_path --with-make-np=4 \
            --with-fc=0 --with-x=false --with-ssl=false \
            --download-f2cblaslapack=${JARVIS_DOWNLOAD}/f2cblaslapack-3.4.2.q1.tar.gz \
            --download-parmetis=${JARVIS_DOWNLOAD}/parmetis-4.0.3-p2.tar.gz \
            --download-sundials=${JARVIS_DOWNLOAD}/sundials-2.5.0p1.tar.gz \
            --with-shared-libraries \
            --with-mpi-dir=${OPAL_PREFIX} \
            --download-metis=${JARVIS_DOWNLOAD}/metis-5.1.0-p1.tar.gz \
            --download-hdf5=${JARVIS_DOWNLOAD}/hdf5-1.8.16.tar.bz2
make
make test
make PETSC_DIR=${PETSC_DIR} PETSC_ARCH=${PETSC_ARCH} streams NPMAX=16
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
   
        ]
}
EOF

} 2>&1 | tee ${WORK_DIR}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${WORK_DIR}/${log_file} ${1}
set +x
exit ${res}
