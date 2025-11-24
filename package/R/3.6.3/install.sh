#!/bin/bash
set -x
set -e

set +x && source ${JARVIS_LIBSHELL}  && set -x
set +x && check_rpms_installed libXt-devel libXt libXmu-devel libXmu libXt-devel libXt libX11-devel libX11 libXext-devel libXext \
	readline-devel readline \
	cairo-devel cairo harfbuzz-devel harfbuzz pango-devel pango libpng-devel libpng glib2-devel glib2 libjpeg-turbo-devel libjpeg-turbo \
       	curl libcurl libcurl-devel \
       	zlib zlib-devel bzip2 bzip2-devel xz-devel bzip2 bzip2-devel xz xz-libs xz-devel \
       	openssl openssl-devel \
	glibc glibc-common glibc-devel \
       	pcre2 pcre2-devel pcre pcre-devel || exit 1
set -x

. ${DOWNLOAD_TOOL} -u https://cloud.r-project.org/src/base/R-3/R-3.6.3.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/R-3.6.3.tar.gz
cd R-3.6.3
./configure -enable-R-shlib -enable-R-static-lib --with-libpng --with-jpeglib --prefix=$1
make all -j
make install
