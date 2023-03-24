#download from https://www.ece.uvic.ca/~frodo/jasper/software/${jasper_ver}.tar.gz
#!/bin/bash
set -x
set -e
jasper_ver="jasper-1.900.2"
. ${DOWNLOAD_TOOL} -u https://www.ece.uvic.ca/~frodo/jasper/software/${jasper_ver}.tar.gz
cd ${JARVIS_TMP}
rm -rf ${jasper_ver}
tar -xvf ${JARVIS_DOWNLOAD}/${jasper_ver}.tar.gz
cd ${jasper_ver}
./configure --prefix=$1
make -j
make install
