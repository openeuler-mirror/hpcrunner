#!/bin/bash
set -x
set -e

PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/fftw/${BASENAME}
{
${DOWNLOAD_TOOL} -u http://www.fftw.org/fftw-3.3.10.tar.gz
cd ${JARVIS_DEV_VROOT}/fftw/${BASENAME}
REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/fftw-3.3.10.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="fftw-3.3.10.tar.gz"
REG_META_TYPE="tgz"

[ -d fftw-3.3.10 ] && echo "Exist DIR:$(pwd)/fftw-3.3.10" && exit 1

tar -xvf ${JARVIS_DOWNLOAD}/fftw-3.3.10.tar.gz
[ ! $? -eq 0 ] && echo "Invalid file: fftw-3.3.10.tar.gz" && exit 1
cd fftw-3.3.10
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

./configure --prefix=${PATH_INSTALL} --enable-single --enable-float --enable-neon --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing"
make -j && make install
[ -e "${PATH_INSTALL}"/lib/libfftw3f.so ] || {  echo "Failed to Install ${REG_META_PACKAGE},No exist:libfftw3f.so" ; exit 1 ;}

make clean
./configure --prefix=${PATH_INSTALL} --enable-long-double --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing"
make -j && make install
[ -e "${PATH_INSTALL}"/lib/libfftw3l.so ] || {  echo "Failed to Install ${REG_META_PACKAGE},No exist:libfftw3l.so" ; exit 1 ;}

make clean
./configure --prefix=${PATH_INSTALL} --enable-shared --enable-threads --enable-openmp --enable-mpi CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing"
make -j && make install

[ -e "${PATH_INSTALL}"/lib/libfftw3.so ] || {  echo "Failed to Install ${REG_META_PACKAGE},No exist:libfftw3.so" ; exit 1 ;}

cat > ${PATH_INSTALL}/install_registry.json << EOF
{
    "projectURL": "${REG_PROJECT_URL}",
    "projectDate": "${REG_PROJECT_DATE}",
    "packaging": "${REG_META_TYPE}",
    "package": "${REG_META_PACKAGE}",
    "hashType": "${REG_META_HTYPE}",
    "hashValue": "${REG_META_HVALUE}",
    "dependencies": []
}
EOF

} 2>&1 | tee ${JARVIS_DEV_VROOT}/fftw/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/fftw/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
