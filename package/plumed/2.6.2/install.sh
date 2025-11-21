#!/bin/bash
set -x
set -e
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/plumed/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u https://www.cp2k.org/static/downloads/plumed-2.6.2.tgz
cd ${JARVIS_DEV_VROOT}/plumed/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/plumed-2.6.2.tgz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="plumed-2.6.2.tgz"
REG_META_TYPE="tgz"

[ -d plumed-2.6.2 ] && echo "Exist DIR:$(pwd)/plumed-2.6.2" && exit 1
rm -rf plumed-2.6.2
tar -xvf ${JARVIS_DOWNLOAD}/plumed-2.6.2.tgz
[ ! $? -eq 0 ] && echo "Invalid file: plumed-2.6.2.tgz" && exit 1
cd plumed-2.6.2
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)


echo "BUILD DIR:$(pwd)"
export LIBS="-lkplblas -llapack -lscalapack -lgsl"
export LDFLAGS="-L${KPLBLAS_PATH}/lib -L${LAPACK_PATH}/lib -L${SCALAPACK_PATH}/lib -L${GSL_PATH}/lib"
./configure CXX=mpicxx CC=mpicc FC= mpifort --prefix=$1 --enable-external-blas --enable-gsl --enable-external-lapack --disable-python 
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

} 2>&1 | tee ${JARVIS_DEV_VROOT}/plumed/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/plumed/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
