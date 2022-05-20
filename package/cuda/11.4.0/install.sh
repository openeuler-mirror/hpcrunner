#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://developer.download.nvidia.com/compute/cuda/11.4.0/local_installers/cuda_11.4.0_470.42.01_linux_sbsa.run
#禁用nouveau驱动
mv /etc/modprobe.d/disable-nouveau.conf /etc/modprobe.d/disable-nouveau.conf.bak
echo -e 'blacklist nouveau\noptions nouveau modeset=0' >/etc/modprobe.d/disable-nouveau.conf
cp /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r)-nouveau.img
dracut -f /boot/initramfs-$(uname -r).img $(uname -r)

sh $JARVIS_DOWNLOAD/cuda_11.4.0_470.42.01_linux_sbsa.run
