#download from https://grigoriefflab.umassmed.edu/system/tdf?path=ctffind-4.1.14.tar.gz\&file=1\&type=node\&id=26
#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://grigoriefflab.umassmed.edu/system/tdf?path=ctffind-4.1.14.tar.gz\&file=1\&type=node\&id=26 -f ctffind-4.1.14.tar.gz
cd ${JARVIS_TMP}
rm -rf ctffind-4.1.14
tar -xvf ${JARVIS_DOWNLOAD}/ctffind-4.1.14.tar.gz
cd ctffind-4.1.14

sed -i "7s%^%//%g" src/core/matrix.cpp
sed -i '7i  #define _AL_SINCOS(x, s, c)   s = sinf(x);  c = cosf(x);' src/core/matrix.cpp
#yum install -y libjpeg* libtiff* fftw*
autoreconf -f -i
./configure --prefix=$1 --disable-mkl --enable-openmp --enable-debugmode CC=clang CXX=clang++ FC=flang
sed -i "296s/-O2/-O0/g" Makefile
sed -i "298s/-O2/-O0/g" Makefile
sed -i "302s/-O2/-O0/g" Makefile
make 
make install

