#!/bin/bash
process=$(pidof lnd)
> gdb.log
for proc in $process
do 
   echo "**************Process $proc**************" >> gdb.log
   # 使用GDB获取进程的堆栈信息
   gdb -ex "attach $proc" -ex "thread apply all bt" -ex "detach" -ex "quit" -batch >> gdb.log
   echo "******************************************">> gdb.log
done
