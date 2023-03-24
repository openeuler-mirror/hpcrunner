. ${DOWNLOAD_TOOL} -u http://coin-or-tools.github.io/ThirdParty-Metis/metis-4.0.3.tar.gz
cd ${JARVIS_TMP}
rm -rf metis-4.0.3
tar -xf ${JARVIS_DOWNLOAD}/metis-4.0.3.tar.gz
cd metis-4.0.3
make
