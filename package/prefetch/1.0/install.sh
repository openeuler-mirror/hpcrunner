#!/bin/bash
set -x
set -e
cd ${JARVIS_TMP}
git clone --depth=1 https://gitee.com/openeuler/prefetch_tuning.git
cd prefetch_tuning
make clean && make
insmod prefetch_tuning.ko
lsmod | grep prefetch_tuning
#uninstall: rmmod prefetch_tuning
#use: echo 1 > /sys/class/misc/prefetch/policy
# 0-15是指CPU硬件预取算法预取数据的单位大小的级别，其中0表示禁用预取算法，1-3表示预取的单位大小为2、4、8个字节，4-7表示预取的单位大小为16、32、64、128个字节，8-15表示预取的单位大小为256、512、1024、2048、4096、8192、16384、32768个字节。选择合适的预取算法级别和单位大小可以帮助提高程序的运行速度。