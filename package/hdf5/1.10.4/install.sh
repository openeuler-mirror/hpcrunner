#download from https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.1/src/hdf5-1.10.1.tar.gz
#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.4/src/hdf5-1.10.4.tar.gz
cd ${JARVIS_TMP}
rm -rf hdf5-1.10.4
tar -xvf ${JARVIS_DOWNLOAD}/hdf5-1.10.4.tar.gz
cd hdf5-1.10.4
#CC=mpicc CXX=mpicxx FC=mpifort F77=mpifort -Wno-incompatible-pointer-types-discards-qualifiers
CC=`which mpicc` FC=`which mpifort` ./configure --with-zlib=/usr/lib --prefix=$1 --enable-static=yes --enable-parallel --enable-shared --with-szlib=${JARVIS_LIBS}/bisheng2.3.0/szip/2.1.1/lib
make -j
make install
