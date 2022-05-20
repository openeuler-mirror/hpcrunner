#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://mirror.iscas.ac.cn/kunpeng/archive/Tuning_kit/Packages/Hyper-tuner_2.3.0_linux.tar.gz
cd ${JARVIS_TMP}
tar zxvf ${JARVIS_DOWNLOAD}/Hyper-tuner_2.3.0_linux.tar.gz
cd Hyper_tuner
export ip=`hostname -I |awk 'print $1'`
./install.sh web -ip=$ip -mpi=$ip -jip=$ip
