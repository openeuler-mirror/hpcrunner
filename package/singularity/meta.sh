#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
. $CHECK_DEPS go
. $CHECK_ROOT && yum install -y libseccomp-devel squashfs-tools cryptsetup
file_noext="singularity-ce-$singularity_ver"
file_name="${file_noext}.tar.gz"
. ${DOWNLOAD_TOOL} -u  https://github.com/sylabs/singularity/releases/download/v${singularity_ver}/${file_name}
rm -rf ${file_noext}
tar -xzvf ${JARVIS_DOWNLOAD}/${file_name}
cd ${file_noext}
./mconfig --prefix=$1
make -C builddir
make -C builddir install