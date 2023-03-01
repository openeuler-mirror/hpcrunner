#download from https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.1/src/hdf5-1.10.1.tar.gz
#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.1/src/hdf5-1.10.1.tar.gz
cd ${JARVIS_TMP}
rm -rf hdf5-1.10.1
tar -xvf ${JARVIS_DOWNLOAD}/hdf5-1.10.1.tar.gz
cd hdf5-1.10.1
#CC=mpicc CXX=mpicxx FC=mpifort F77=mpifort -Wno-incompatible-pointer-types-discards-qualifiers
./configure --prefix=$1  --enable-fortran --enable-static=yes --enable-parallel --enable-shared
sed -i '11835c wl="-Wl,"' libtool
make -j
make install
