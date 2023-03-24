. ${DOWNLOAD_TOOL} -u https://github.com/hypre-space/hypre/archive/refs/tags/v2.25.0.tar.gz
cd ${JARVIS_TMP}
rm -rf hypre-2.25.0
tar -xf ${JARVIS_DOWNLOAD}/v2.25.0.tar.gz
cd hypre-2.25.0/src
./configure --disable-fortran --prefix=$1
make -j
make install
