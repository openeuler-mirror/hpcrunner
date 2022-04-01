#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
export PATH=/usr/local/go/bin:$PATH
#sudo yum install -y libseccomp-devel squashfs-tools cryptsetup
file_noext='singularity-ce-3.9.6'
file_name="${file_noext}.tar.gz"
if [ ! -f "${JARVIS_DOWNLOAD}/${file_name}" ]; then
    wget --no-check-certificate -P ${JARVIS_DOWNLOAD} https://github.com/sylabs/singularity/releases/download/v3.9.6/${file_name}
fi
rm -rf ${file_noext}
tar -xzvf ${JARVIS_DOWNLOAD}/${file_name}
cd ${file_noext}
./mconfig
make -C builddir
sudo make -C builddir install