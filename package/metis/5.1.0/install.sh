. ${DOWNLOAD_TOOL} -u https://src.fedoraproject.org/lookaside/pkgs/metis/metis-5.1.0.tar.gz/5465e67079419a69e0116de24fce58fe/metis-5.1.0.tar.gz
cd ${JARVIS_TMP}
rm -rf metis-5.1.0
tar -xf ${JARVIS_DOWNLOAD}/metis-5.1.0.tar.gz
cd metis-5.1.0
make config prefix=$1 shared=1
make install
