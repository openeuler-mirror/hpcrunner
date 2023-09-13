#!/bin/bash
set -x
set -e
cd ${JARVIS_DOWNLOAD}
rm -rf g2clib-image
git clone https://gitee.com/linruoxuan/g2clib-image.git
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/g2clib-image/g2clib-1.6.0-patch.tar.gz
cd g2clib-1.6.0-patch

sed -i '22c INC=-I/glade/p/work/haley/dev/external/gnu/4.7.2/include -I${JASPER_PATH}/include' makefile
sed -i '33c CC=clang' makefile
make all
mkdir $1/lib
mkdir $1/include 
mv libgrib2c.a $1/lib/
cp grib2.h $1/include/
