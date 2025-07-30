#!/bin/bash
set -x
set -e

wget https://github.com/DReichLab/AdmixTools/archive/v7.0.2.tar.gz -O ${JARVIS_DOWNLOAD}/AdmixTools-7.0.2.tar.gz

cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/AdmixTools-7.0.2.tar.gz
cd AdmixTools-7.0.2/src
sed -i '14d' Makefile
sed -i '18d' Makefile
sed -i "14s%^.*$%override CFLAGS += -I$targetdir/openblas/openblas_install/include -I$targetdir/gsl/gsl_install/include%g" Makefile
sed -i "15s%^.*$%override LDFLAGS += -L$targetdir/openblas/openblas_install/lib -L$targetdir/gsl/gsl_install/lib%g" Makefile
make -j 16 
make install