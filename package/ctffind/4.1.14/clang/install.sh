#download from https://grigoriefflab.umassmed.edu/system/tdf?path=ctffind-4.1.14.tar.gz\&file=1\&type=node\&id=26
#!/bin/bash
set -x
set -e

PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/ctffind/clang/${BASENAME}
{
. ${DOWNLOAD_TOOL} -u https://grigoriefflab.umassmed.edu/system/tdf?path=ctffind-4.1.14.tar.gz\&file=1\&type=node\&id=26 -f ctffind-4.1.14.tar.gz

cd ${JARVIS_DEV_VROOT}/ctffind/clang/${BASENAME}

REG_META_HVALUE=$(md5sum ${JARVIS_DOWNLOAD}/ctffind-4.1.14.tar.gz | awk '{print $1}')
REG_META_HTYPE="md5"
REG_META_PACKAGE="ctffind-4.1.14.tar.gz"
REG_META_TYPE="tgz"

[ -d ctffind-4.1.14 ] && echo "Exist DIR:$(pwd)/ctffind-4.1.14" && exit 1


tar -xvf ${JARVIS_DOWNLOAD}/ctffind-4.1.14.tar.gz -C ./
[ ! $? -eq 0 ] && echo "Invalid file: fftw-3.3.8.tar.gz" && exit 1
cd ctffind-4.1.14
REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

echo "BUILD DIR:$(pwd)"

if [ ! -f /usr/include/jpeglib.h ]; then
	echo "ERROR: need file:/usr/include/jpeglib.h, yum install libjpeg libjpeg-devel"
	exit 1
fi
if [ ! -f /usr/include/tiffvers.h ]; then
	echo "ERROR: need file:/usr/include/jpeglib.h, yum install libtiff libtiff-devel"
	exit 1
fi

if [ -z "${FFTW_PATH}" ]; then
	echo "ERROR: Require ENV:FTTW_PATH"
	exit 1
fi

echo "FFTW_PATH:${FFTW_PATH}"

sed -i "7s%^%//%g" src/core/matrix.cpp
sed -i '7i  #define _AL_SINCOS(x, s, c)   s = sinf(x);  c = cosf(x);' src/core/matrix.cpp
#. $CHECK_ROOT && yum install -y libjpeg* libtiff* fftw*
autoreconf -f -i
./configure --prefix=$1 --disable-mkl --enable-openmp --enable-debugmode --with-fftw-dir=${FFTW_PATH} CC=clang CXX=clang++ FC=flang
sed -i "296s/-O2/-O0/g" Makefile
sed -i "298s/-O2/-O0/g" Makefile
sed -i "302s/-O2/-O0/g" Makefile
make 
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

} 2>&1 | tee ${JARVIS_DEV_VROOT}/ctffind/clang/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/ctffind/clang/${BASENAME}/${log_file} ${1}
set +x
exit ${res}
