#!/bin/bash
set -x
set -e
cd ${JARVIS_DOWNLOAD}
rm g2clib-1.6.0-patch.tar.gz -f
wget http://www.ncl.ucar.edu/Download/files/g2clib-1.6.0-patch.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/g2clib-1.6.0-patch.tar.gz
cd g2clib-1.6.0-patch
if [ -z "${JASPER_PATH}" ] || [ -z "${LIBPNG_PATH}" ]; then
    echo "JASPER_PATH and LIBPNG_PATH environment variable does not exist "
    exit 0
else
    echo "JASPER_PATH and LIBPNG_PATH environment variables are ready "
fi
sed -i '22c INC=-I${JASPER_PATH}/include -I${LIBPNG_PATH}/include/libpng16' makefile
sed -i '33c CC=gcc' makefile
sed -i '8c #include "png.h"' dec_png.c

make all
mkdir $1/lib
mkdir $1/include 
mv libgrib2c.a $1/lib/
cp grib2.h $1/include/
