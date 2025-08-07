#!/bin/bash
set -x
set -e

./jarvis -install openblas/0.3.23 clang
./jarvis -install gsl/2.7.1 clang

wget https://github.com/DReichLab/EIG/archive/refs/tags/v8.0.0.tar.gz -O ${JARVIS_DOWNLOAD}/EIG-8.0.0.tar.gz 

cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/EIG-8.0.0.tar.gz  > /dev/null 2>&1
cd cd EIG-8.0.0/src 
sed -i "1s%^.*$%override CFLAGS += -I../include -I$targetdir/openblas/openblas_install/include%g" Makefile
sed -i '10d' Makefile
sed -i '12d' Makefile
sed -i "10s%^.*$%override CFLAGS += -I$targetdir/openblas/openblas_install/include -I$targetdir/gsl/gsl_install/include%g" Makefile
sed -i "11s%^.*$%override LDFLAGS += -L$targetdir/openblas/openblas_install/lib -L$targetdir/gsl/gsl_install/lib%g" Makefile
make -j 16 
make install