#!/bin/bash
process=$(pidof $1)
cur_time=$(date +%Y-%m-%d-%H-%M)
root_dir=$(pwd)
log_dir=$1/$cur_time
mkdir -p $log_dir
log_file=$log_dir/gdb-$HOSTNAME.log
> $log_file
for proc in $process
do
   echo "**************Process $proc**************" >> $log_file
   # 使用GDB获取进程的堆栈信息
   gdb -ex "attach $proc" -ex "thread apply all bt" -ex "detach" -ex "quit" -batch >> $log_file
   echo "******************************************">> $log_file
done
echo "

" >> $log_file
