#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
export PATH=/usr/local/go/bin:$PATH
sudo yum install -y libseccomp-devel squashfs-tools cryptsetup
if [ ! -f "singularity-ce-3.9.6.tar.gz" ]; then
wget https://github.com/sylabs/singularity/releases/download/v3.9.6/singularity-ce-3.9.6.tar.gz
fi
rm -rf singularity-ce-3.9.6
tar -xzvf singularity-ce-3.9.6.tar.gz
cd singularity-ce-3.9.6
./mconfig
make -C builddir
sudo make -C builddir install