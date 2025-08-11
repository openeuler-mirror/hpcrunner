#!/bin/bash
set -x
set -e

# 检查fftw是否已安装
if yum list installed | grep -q "fftw3-devel"; then
    echo "fftw3-devel 已经安装。"
else
    echo "fftw3-devel 未安装，正在进行安装..."
    # 安装fftw3-devel
	yum install --downloadonly --downloaddir=./downloads/fftw3-devel  fftw3-devel -y
	yum localinstall ./downloads/fftw3-devel/*.rpm -y
    if [ $? -eq 0 ]; then
        echo "fftw3-devel 安装成功。"
    else
        echo "fftw3-devel 安装失败。"
        exit 1
    fi
fi





