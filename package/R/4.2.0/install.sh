#!/bin/bash
. $CHECK_ROOT && yum install -y bzip2-devel cairo-devel fontconfig-devel freetype-devel fribidi-devel gcc gcc-gfortran gcc-c++ gettext-devel harfbuzz-devel lapack-devel blas-devel libX11-devel libXext-devel libXt-devel libcurl-devel libicu-devel libjpeg-devel libpng-devel libtiff-devel libtirpc-devel libxcrypt-devel ncurses-devel pango-devel pkgconf-devel pcre2-devel readline-devel tcl-devel tk-devel xz-devel zlib-devel texlive texlive-inconsolata texinfo firefox java-1.8.0-openjdk-devel imake libpng-tools
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://cloud.r-project.org/src/base/R-4/R-4.2.0.tar.gz
cd ${JARVIS_TMP}
rm -rf R-4.2.0
tar -xvf ${JARVIS_DOWNLOAD}/R-4.2.0.tar.gz
cd R-4.2.0
./configure --prefix=$1 -enable-R-shlib --with-libpng --with-jpeglib --with-blas --with-lapack --with-tcl-config=/usr/lib64/tclConfig.sh --with-tk-config=/usr/lib64/tkConfig.sh --with-libdeflate-compression=no FPICFLAGS="-fPIC" 
make all -j
make install
