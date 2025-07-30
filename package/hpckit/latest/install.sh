#!/bin/bash
set -e
export hpckit_ver=`curl https://mirrors.huaweicloud.com/kunpeng/archive/HPC/HPCKit/| awk -F "HPCKit_" '{print $2}'|awk -F "_Linux-aarch64" '{print $1}'|awk '{lines[NR]=$0} END{print lines[NR-1]}'`
../meta.sh $1