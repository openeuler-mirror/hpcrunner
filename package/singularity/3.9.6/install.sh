#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
export PATH=/usr/local/go/bin:$PATH
. $CHECK_ROOT && yum install -y libseccomp-devel squashfs-tools cryptsetup
file_noext='singularity-ce-3.9.6'
file_name="${file_noext}.tar.gz"
. ${DOWNLOAD_TOOL} -u https://github.com/sylabs/singularity/releases/download/v3.9.6/${file_name}
rm -rf ${file_noext}
tar -xzvf ${JARVIS_DOWNLOAD}/${file_name}
cd ${file_noext}
./mconfig
make -C builddir
sudo make -C builddir install