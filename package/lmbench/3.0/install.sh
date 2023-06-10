#!/bin/bash

set -x
set -e
. $CHECK_ROOT && yum install libtirpc-devel
cd ${JARVIS_TMP}
if [ ! -d lmbench ]; then
    git clone --depth=1 https://github.com/intel/lmbench.git
fi
cd lmbench
cd src
sed -i '61c COMPILE=$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -ltirpc -I/usr/include/tirpc' Makefile
sed -i -e '114,115s/-O /-O2 /' Makefile
sed -i -e '139s/-O /-O2 /' Makefile
sed -i '231,234s/^/#/' Makefile
make OS=openEuler
#注意虽然安装会报错，但是程序是可以正常运行的
#本地时延测试（112ns）
#numactl -C 3 -m 0 ./lat_mem_rd -P 1 -W 5 -N 5 -t 1024M 1024
#-C:指定CPU核心，-m：指定numa节点 -P：并发进程数 -W：预热时间 -N：循环次数 -t：是否对被测区域采用垃圾数据初始化
# 1024M：测试内存的大小  1024：测试步幅
# 跨die时延测试（127ns）
#numactl -C 3 -m 1 ./lat_mem_rd -P 1 -W 5 -N 5 -t 1024M 1024
# 并行测试CPU时延（）
#numactl -C 0-64 -m 0-1 ./lat_mem_rd -P 64 -W 5 -N 5 -t 1024M 1024
#本地带宽测试
#1core : taskset -c 0 ./bw_mem -P 1 -W 5 -N 5 48M rd
#1cluster：taskset -c 0-3 ./bw_mem -P 4 -W 5 -N 5 48M rd
#1 die：taskset -c 0-31 ./bw_mem -P 32 -W 5 -N 5 48M rd
#1 CPU: taskset -c 0-64 ./bw_mem -P 64 -W 5 -N 5 48M rd