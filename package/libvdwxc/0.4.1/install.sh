set -x
set -e
. ${DOWNLOAD_TOOL} -u https://launchpad.net/libvdwxc/stable/0.4.0/+download/libvdwxc-0.4.0.tar.gz
cd ${JARVIS_TMP}
tar xvf ${JARVIS_DOWNLOAD}/libvdwxc-0.4.0.tar.gz
cd libvdwxc-0.4.0
./configure --prefix=$1 --enable-shared=yes --enable-static=yes
make -j
make install