#!/bin/bash
set -x
set -e
yum install -y subversion
svn co http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS2/trunk $1
cp -r /pacific_ext/huawei/cc/trunk/* $1
cd $1

export HDF5=`which h5diff`
export HDF5=${HDF5%/*/*}
export NETCDF=`nc-config --prefix`
export PNETCDF=`pnetcdf-config --prefix`
export MPI=`which mpirun`
export MPI=${MPI%/*/*}

sed -i "47s/^/#/g;48s/^/#/g" bld.cfg

cat << EOF > arch/arch-AARCH64_GNU_LINUX.env
export HDF5_INC_DIR="${HDF5}/include"
export HDF5_LIB_DIR="${HDF5}/lib"
export NETCDF_INC_DIR="${NETCDF}/include"
export NETCDF_LIB_DIR="${NETCDF}/lib"
EOF

cat << EOF > arch/arch-AARCH64_GNU_LINUX.fcm
################################################################################
###################        Projet xios - xmlioserver       #####################
################################################################################
%CCOMPILER      mpicc
%FCOMPILER      mpif90
%LINKER         mpif90
%BASE_CFLAGS    -w -std=c++11
%PROD_CFLAGS    -O0 -DBOOST_DISABLE_ASSERTS
%DEV_CFLAGS     -g -O2
%DEBUG_CFLAGS   -g
%BASE_FFLAGS    -D__NONE__
%PROD_FFLAGS    -O0
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
EOF

chmod +x ./make_xios

./make_xios --prod --job 32 --full --arch AARCH64_GNU_LINUX