#!/bin/bash

temperatures='100 500 900'
N=15                           #并行进程数
lmp_exec=lmp                   #lammps可执行文件
tension_rate=0.005            #单轴拉伸应变率 (/ps)

for T in ${temperatures};do
  mpirun -np ${N} ${lmp_exec} -in in.tension -v model_name data.lmp -v rate ${tension_rate} -v T ${T}
done
