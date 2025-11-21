#!/bin/bash
#检查网卡配置PF_LOG_BAR_SIZE是否为8
printf "\n###网卡配置PF_LOG_BAR_SIZE是否为8###\n"
#mst start
mlxconfig q|grep PF_LOG_BAR_SIZE

#检查网卡配置PCI_WR_ORDERING是否为1
printf "\n###检查网卡配置PCI_WR_ORDERING是否为1###\n"
mlxconfig q |grep PCI_WR_ORDERING

#检查BIOS版本
printf "\n###检查BIOS版本###\n"
dmidecode -s bios-version


#海思patch
printf "\n###检查海思patch 寄存器值是否修改###\n"
sh /etc/init.d/run_dev.sh

#检查dpc挂载
printf "\n###检查dpc挂载###\n"
ls /share/home
ls /share/software

#检查tuned服务状态
printf  "\n###检查tuned服务状态###\n"
#systemctl status tuned.service |grep Active |awk '{print$3}'
tuned-adm active

#检查numa_balancing
printf "\n###检查numa_balancing是否为0###\n"
cat /proc/sys/kernel/numa_balancing

#检查核隔离
printf "\n####检查核隔离是否为空###\n"
cat /sys/devices/system/cpu/nohz_full

#检查grub启动参数
printf "\n###检查grub启动参数###\n"

printf "\n###检查grub启动参数###\n"
#cat /proc/cmdline
tail -c 20  /proc/cmdline

#检查是否降频#
printf "\n###检查是否降频###\n"
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq | sort -r | tail -1 |cut -b -3

#检查内存频率
printf "\n###检查内存频率###\n"
dmidecode |grep -A20 "Memory Device" |egrep '^\s+Speed' |sort -r | tail -1
