#!/bin/bash
. $CHECK_ROOT && yum install -y bzip2-devel cairo-devel fontconfig-devel freetype-devel fribidi-devel gcc gcc-gfortran gcc-c++ gettext-devel harfbuzz-devel lapack-devel blas-devel libX11-devel libXext-devel libXt-devel libcurl-devel libicu-devel libjpeg-devel libpng-devel libtiff-devel libtirpc-devel libxcrypt-devel ncurses-devel pango-devel pkgconf-devel pcre2-devel readline-devel tcl-devel tk-devel xz-devel zlib-devel texlive texlive-inconsolata texinfo firefox java-1.8.0-openjdk-devel imake pcre-devel
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://cloud.r-project.org/src/base/R-3/R-3.6.3.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/R-3.6.3.tar.gz
cd R-3.6.3
./configure -enable-R-shlib -enable-R-static-lib --with-libpng --with-jpeglib --prefix=$1 --with-blas --with-lapack --with-tcl-config=/usr/lib64/tclConfig.sh --with-tk-config=/usr/lib64/tkConfig.sh --with-libdeflate-compression=no
make all -j
make install
