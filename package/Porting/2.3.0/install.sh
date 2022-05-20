#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://mirror.iscas.ac.cn/kunpeng/archive/Porting_Dependency/Packages/Porting-advisor_2.3.0_linux-Kunpeng.tar.gz
cd ${JARVIS_TMP}
tar zxvf ${JARVIS_DOWNLOAD}/Porting-advisor_2.3.0_linux-Kunpeng.tar.gz
cd Porting-advisor_2.3.0_linux-Kunpeng
./install web

