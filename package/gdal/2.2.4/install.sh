#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://download.osgeo.org/gdal/2.2.4/gdal-2.2.4.tar.gz
cd ${JARVIS_TMP}
rm -rf gdal-2.2.4
tar -xvf ${JARVIS_DOWNLOAD}/gdal-2.2.4.tar.gz
cd gdal-2.2.4

./configure --with-static-proj4=${PROJ_PATH} --prefix=$1 --with-png=${LIBPNG_PATH} --with-gif=internal --with-libtiff=internal \
      --with-geotiff=internal --with-jpeg=${LIBJPEG_PATH} --with-libz=/usr/local \
      --with-sqlite3=no --with-expat=no --with-curl=no --without-ld-shared \
      --with-hdf4=no --with-hdf5=no --with-pg=no --without-grib --enable-shared \
      --with-freexl=no --with-geos=no --with-openjpeg=no --with-mysql=no \
      --with-ecw=no --with-fgdb=no --with-odbc=no --with-xml2=no --with-ogdi=no\
      --with-pcraster=no --with-xerces=no
make all install
