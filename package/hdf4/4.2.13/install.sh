#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://rpmfind.net/linux/epel/8/Everything/aarch64/Packages/h/hdf-4.2.14-5.el8.aarch64.rpm
cd ${JARVIS_TMP}
rm -rf hdf-4.2.15
mkdir hdf-4.2.15
cd hdf-4.2.15
rpm2cpio ${JARVIS_DOWNLOAD}/hdf-4.2.14-5.el8.aarch64.rpm | cpio -div
cp -r usr/* $1/
