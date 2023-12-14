#!/bin/bash
set -x
set -e
#yum install -y perl-lib* boost-*
svn co -r 703 https://forge.ipsl.jussieu.fr/ioserver/svn/XIOS1/branches/xios-1.0/ $1
cd $1

export HDF5=`which h5diff`
export HDF5=${HDF5%/*/*}
export NETCDF=`nc-config --prefix`
export PNETCDF=`pnetcdf-config --prefix`
export BLITZ=$BLITZ_PATH
export MPI=`which mpirun`
export MPI=${MPI%/*/*}

sed -i "27s/^/#/g;33s/^/#/g" bld.cfg

cat << EOF > arch/arch-AARCH64_GNU_LINUX.env
export HDF5_INC_DIR="${HDF5}/include"
export HDF5_LIB_DIR="${HDF5}/lib"
export NETCDF_INC_DIR="${NETCDF}/include"
export NETCDF_LIB_DIR="${NETCDF}/lib"
export BOOST_INC_DIR="/usr/include/boost/"
export BOOST_LIB_DIR="/usr/lib64/"
export BLITZ_INC_DIR="${BLITZ}/include"
export BLITZ_LIB_DIR="${BLITZ}/lib"
EOF

cat << EOF > arch/arch-AARCH64_GNU_LINUX.fcm
################################################################################
###################        Projet xios - xmlioserver       #####################
################################################################################
%CCOMPILER      mpicc
%FCOMPILER      mpif90
%LINKER         mpif90
%BASE_CFLAGS    -ansi -w -D_GLIBCXX_USE_CXX11_ABI=0
%PROD_CFLAGS    -O3 -DBOOST_DISABLE_ASSERTS
%DEV_CFLAGS     -g -O2
%DEBUG_CFLAGS   -g
%BASE_FFLAGS    -D__NONE__
%PROD_FFLAGS    -O3
%DEV_FFLAGS     -g -O2
%DEBUG_FFLAGS   -g
%BASE_INC       -D__NONE__
%BASE_LD        -lstdc++
%CPP            cpp
%FPP            cpp -P
%MAKE           gmake
EOF


cat << EOF > arch/arch-AARCH64_GNU_LINUX.path
NETCDF_INCDIR="-I ${NETCDF}/include"
NETCDF_LIBDIR="-L ${NETCDF}/lib"
NETCDF_LIB="-lnetcdff -lnetcdf"
MPI_INCDIR="-I ${MPI}/include"
MPI_LIBDIR="-L ${MPI}/lib"
MPI_LIB="-lmpi"
HDF5_INCDIR="-I ${HDF5}/include"
HDF5_LIBDIR="-L ${HDF5}/lib"
HDF5_LIB="-lhdf5_hl -lhdf5  -lz"
BOOST_INCDIR="-I /usr/include/boost/"
BOOST_LIBDIR="-L /usr/lib64/"
BOOST_LIB=""
BLITZ_INCDIR="-I ${BLITZ}/include"
BLITZ_LIBDIR="-L ${BLITZ}/lib"
BLITZ_LIB="-lblitz"
EOF


chmod +x ./make_xios
cd extern
ln -s ${BLITZ} ./blitz
ln -s ${NETCDF} ./netcdf4
ln -s /usr/include/boost ./boost
cd ..
./make_xios --dev --job 32 --full --arch AARCH64_GNU_LINUX
