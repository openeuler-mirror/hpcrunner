#!/bin/bash
set -x
set -e

if [[ $UseGitee -eq 1 ]]; then
. ${DOWNLOAD_TOOL} -u https://gitee.com/kp-hpc-mod/hpc-src/raw/master/hucx-1.1.1-huawei.zip -f hucx-1.1.1-huawei.zip
. ${DOWNLOAD_TOOL} -u https://gitee.com/kp-hpc-mod/hpc-src/raw/master/xucg-1.1.1-huawei.zip -f xucg-1.1.1-huawei.zip
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/kunpengcompute/hmpi/archive/refs/tags/v1.1.1-huawei.zip -f hmpi-1.1.1-huawei.zip
else
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/kunpengcompute/hucx/archive/refs/tags/v1.1.1-huawei.zip -f hucx-1.1.1-huawei.zip
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/kunpengcompute/xucg/archive/refs/tags/v1.1.1-huawei.zip -f xucg-1.1.1-huawei.zip
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/kunpengcompute/hmpi/archive/refs/tags/v1.1.1-huawei.zip -f hmpi-1.1.1-huawei.zip
fi

cd ${JARVIS_TMP}
. $CHECK_ROOT && yum install -y perl-Data-Dumper autoconf automake libtool binutils flex
rm -rf hmpi-1.1.1-huawei hucx-1.1.1-huawei xucg-1.1.1-huawei