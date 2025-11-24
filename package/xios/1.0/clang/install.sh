#!/bin/bash
set -x
set -e
#yum install -y perl-lib* boost-*
PATH_INSTALL="$1"
BASENAME=$(basename "$1")
log_file=tee_install_$(date +%Y%m%d%H%M%S).xlog
mkdir -p ${JARVIS_DEV_VROOT}/xios/clang/${BASENAME}
BASE=$(pwd)
{
[ -d ${PATH_INSTALL}/xios-1.0 ] && echo "Exist DIR:${PATH_INSTALL}/xios-1.0" && exit 
echo "Check package: ${JARVIS_DOWNLOAD}/xios-1.0.tar.gz"
if [ -f ${JARVIS_DOWNLOAD}/xios-1.0.tar.gz ]; then
	rm -rf ${PATH_INSTALL}/xios-1.0
	tar -zxvf ${JARVIS_DOWNLOAD}/xios-1.0.tar.gz -C ${PATH_INSTALL}/
	[ ! $? -eq 0 ] && echo "Invalid file: xios-1.0.tar.gz" && exit 1
else
	if [ ! -f /usr/bin/svn ]; then
		echo "ERROR: yum install subversion for /usr/bin/svn"
		exit 1
	fi
	rm -rf ${PATH_INSTALL}/xios-1.0
	svn co -r 703 https://forge.ipsl.jussieu.fr/ioserver/svn/XIOS1/branches/xios-1.0/ $1/xios-1.0	
fi
cd ${PATH_INSTALL}/xios-1.0

REG_META_HVALUE=""
REG_META_HTYPE="md5"
REG_META_PACKAGE="xios-1.0.tar.gz"
REG_META_TYPE="tar.gz"

export HDF5=`which h5diff`
export HDF5=${HDF5%/*/*}
export NETCDF=`nc-config --prefix`
export PNETCDF=`pnetcdf-config --prefix`
export BLITZ=$BLITZ_PATH
export MPI=`which mpirun`
export MPI=${MPI%/*/*}

echo "HDF5:${HDF5}"
echo "NETCDF:${NETCDF}"
echo "PNETCDF:${PNETCDF}"
echo "BLITZ:${BLITZ}"
echo "MPI:${MPI}"
echo "BOOST_PATH:${BOOST_PATH}"

sed -i "27s/^/#/g;33s/^/#/g" bld.cfg

cat << EOF > arch/arch-AARCH64_GNU_LINUX.env
export HDF5_INC_DIR="${HDF5}/include"
export HDF5_LIB_DIR="${HDF5}/lib"
export NETCDF_INC_DIR="${NETCDF}/include"
export NETCDF_LIB_DIR="${NETCDF}/lib"
export BOOST_INC_DIR="${BOOST_PATH}/include/boost/"
export BOOST_LIB_DIR="${BOOST_PATH}/lib"
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
BOOST_INCDIR="-I ${BOOST_PATH}/include/boost/"
BOOST_LIBDIR="-L ${BOOST_PATH}/lib/"
BOOST_LIB=""
BLITZ_INCDIR="-I ${BLITZ}/include"
BLITZ_LIBDIR="-L ${BLITZ}/lib"
BLITZ_LIB="-lblitz"
EOF


chmod +x ./make_xios
cd extern
rm ./blitz -f
ln -s ${BLITZ} ./blitz
rm ./netcdf4 -f
ln -s ${NETCDF} ./netcdf4
rm ./boost -f
ln -s ${BOOST_PATH}/include/boost ./boost
cd ..
./make_xios --dev --job 32 --full --arch AARCH64_GNU_LINUX

REG_PROJECT_URL=$(pwd)
REG_PROJECT_DATE=$(date +%Y%m%d%H%M%S)

cd ${PATH_INSTALL}
rm -f lib inc
ln -s xios-1.0/lib .
ln -s xios-1.0/inc .

cat > ${PATH_INSTALL}/install_registry.json << EOF
{
    "projectURL": "${REG_PROJECT_URL}",
    "projectDate": "${REG_PROJECT_DATE}",
    "packaging": "${REG_META_TYPE}",
    "package": "${REG_META_PACKAGE}",
    "hashType": "${REG_META_HTYPE}",
    "hashValue": "${REG_META_HVALUE}",
    "dependencies": [
   
        ]
}
EOF

} 2>&1 | tee ${JARVIS_DEV_VROOT}/xios/clang/${BASENAME}/${log_file}
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
cp ${JARVIS_DEV_VROOT}/xios/clang/${BASENAME}/${log_file} "${PATH_INSTALL}"
set +x
exit ${res}

