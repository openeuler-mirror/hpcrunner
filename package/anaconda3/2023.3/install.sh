#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-aarch64.sh
yum install libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver -y
bash ${JARVIS_DOWNLOAD}/Anaconda3-2023.03-Linux-aarch64.sh -u -b -p $1
source $1/etc/profile.d/conda.sh
conda config --set auto_activate_base false
