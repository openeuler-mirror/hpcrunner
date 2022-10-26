# 《基于openEuler的DUNS软件测试报告》

## 1.规范性自检

DUNS于2003年之后就停止更新，其代码更是由Fortran77编写，现网支持的fortran格式化工具fprettify也只支持f90以及更高的版本，因此这里无法对DUNS进行代码格式测试。

### 1.1.选择统计文件类型

统计项目文件类型及其文件数量

使用python编写脚本文件

```python
import os

print(os.getcwd())

def getAllFiles(targetDir):
    files = []
    listFiles = os.listdir(targetDir)
    for i in range(0, len(listFiles)):
        path = os.path.join(targetDir, listFiles[i])
        if os.path.isdir(path):
            files.extend(getAllFiles(path))
        elif os.path.isfile(path):
            files.append(path)
    return files

all_files = getAllFiles(os.curdir)
type_dict = dict()

for each_file in all_files:
    if os.path.isdir(each_file):
        type_dict.setdefault("directory", 0)
        type_dict["directory"] += 1
    else:
        ext = os.path.splitext(each_file)[1]
        type_dict.setdefault(ext, 0)
        type_dict[ext] += 1

for each_type in dict(sorted(type_dict.items(), reverse=True, key=lambda item: item[1])).keys():
    print("当前文件夹下共有[%s]的文件%d个" % (each_type, type_dict[each_type]))
```

在duns项目根目录下运行,运行结果如下

```bash
python run.py
/root/duns-2.7.1
当前文件夹下共有[.F]的文件80个
当前文件夹下共有[]的文件31个
当前文件夹下共有[.Inc]的文件28个
当前文件夹下共有[.f]的文件19个
当前文件夹下共有[.html]的文件10个
当前文件夹下共有[.cpp]的文件6个
当前文件夹下共有[.c]的文件2个
当前文件夹下共有[.ps]的文件2个
当前文件夹下共有[.inc]的文件1个
当前文件夹下共有[.sgml]的文件1个
当前文件夹下共有[.txt]的文件1个
当前文件夹下共有[.eps]的文件1个
当前文件夹下共有[.py]的文件1个
当前文件夹下共有[.doc]的文件1个
```

查看上述结果可知主要源码文件后缀名为 `.F`，`.Inc`，`.f`

### 1.2.统计源码总行数

统计所有源码文件的代码行数

```bash
 find ./ -regex ".*\.F90\|.*\.f90\|.*\.py"\|.*\.sh"\|.*\.gfort"\
  | xargs wc -l
```

统计结果

```bash
   48446 total
```

### 1.3 文件列表

```bash
duns-2.7.1
|-- CHANGES
|-- COPYING
|-- doc
|   |-- algorithm.ps
|   |-- duns_tut-1.html
|   |-- duns_tut-2.html
|   |-- duns_tut-3.html
|   |-- duns_tut-4.html
|   |-- duns_tut-5.html
|   |-- duns_tut-6.html
|   |-- duns_tut-7.html
|   |-- duns_tut-8.html
|   |-- duns_tut-9.html
|   |-- duns_tut.html
|   |-- duns_tut.ps
|   |-- duns_tut.sgml
|   |-- duns_tut.txt
|   `-- fig1.eps
|-- HISTORY
|-- INSTALL
|-- lib
|   |-- acklib.f
|   |-- amach.f
|   |-- blocksolver.f
|   |-- ckinterp.f
|   |-- cklib.f
|   |-- ckstrt.f
|   |-- cmach.f
|   |-- dmach.f
|   |-- graficV3.f
|   |-- grcomn.inc
|   |-- grctrl.f
|   |-- Makefile
|   |-- math.f
|   |-- mbgrafic.f
|   |-- mbgrctrl.f
|   |-- mcklib.f
|   |-- pcmach.f
|   |-- tranfit.f
|   |-- tranlib.f
|   |-- vode.f
|   |-- xerror.f
|   |-- Xnounderscore.c
|   `-- Xunderscore.c
|-- makesystem
|   |-- Makesystem_aix
|   |-- Makesystem_aixpar
|   |-- Makesystem_alpha
|   |-- Makesystem_cray
|   |-- Makesystem_hp
|   |-- Makesystem_hp1
|   |-- Makesystem_linux
|   |-- Makesystem_linuxf2c
|   |-- Makesystem_linuxfpar
|   |-- Makesystem_linuxic
|   |-- Makesystem_linuxpar
|   |-- Makesystem_linuxRH7
|   `-- Makesystem_sgi
|-- pregrid
|   |-- assemble.F
|   |-- bcassemble.F
|   |-- config.F
|   |-- corners.F
|   |-- duns.F
|   |-- getaxismap.F
|   |-- getintgc.F
|   |-- getside.F
|   |-- getsurface.F
|   |-- getsurfacen.F
|   |-- gridread.F
|   |-- include
|   |   |-- bounds.Inc
|   |   |-- dualtime.Inc
|   |   |-- execution.Inc
|   |   |-- flowfield.Inc
|   |   |-- grid.Inc
|   |   |-- parallel.Inc
|   |   |-- properties.Inc
|   |   |-- reactions.Inc
|   |   |-- solblock.Inc
|   |   |-- solver.Inc
|   |   |-- stab.Inc
|   |   |-- timestep.Inc
|   |   |-- turbulence.Inc
|   |   `-- variables.Inc
|   |-- inprepar.F
|   |-- inread.F
|   |-- interp.F
|   |-- main.cpp
|   |-- Makefile
|   |-- metric.F
|   |-- parameters
|   |-- parprepar.F
|   |-- pregrid.F
|   |-- prepar.F
|   |-- rdist.F
|   `-- readcom.F
|-- README
|-- REVISION
|-- set_me_up
|-- src
|   |-- assemble.F
|   |-- bcassemble.F
|   |-- bc.F
|   |-- blockadi.F
|   |-- blockbc.F
|   |-- blocklhs.F
|   |-- blocksolver.F
|   |-- boundwrite.F
|   |-- calcwi.F
|   |-- check.F
|   |-- config.F
|   |-- configplot.F
|   |-- corners.F
|   |-- diagadi.F
|   |-- duns.F
|   |-- dunsplot.F
|   |-- eos.F
|   |-- getaxismap.F
|   |-- getintgc.F
|   |-- getside.F
|   |-- getsurface.F
|   |-- gridread.F
|   |-- inbc.F
|   |-- include
|   |   |-- bounds.Inc
|   |   |-- dualtime.Inc
|   |   |-- execution.Inc
|   |   |-- flowfield.Inc
|   |   |-- grid.Inc
|   |   |-- parallel.Inc
|   |   |-- properties.Inc
|   |   |-- reactions.Inc
|   |   |-- solblock.Inc
|   |   |-- solver.Inc
|   |   |-- stab.Inc
|   |   |-- timestep.Inc
|   |   |-- turbulence.Inc
|   |   `-- variables.Inc
|   |-- inprepar.F
|   |-- inread.F
|   |-- interp2.F
|   |-- interp.F
|   |-- interpold.F
|   |-- intupdate.F
|   |-- jaccal.F
|   |-- lhs.F
|   |-- lineq.F
|   |-- main.cpp
|   |-- mainplot.cpp
|   |-- Makefile
|   |-- metric.F
|   |-- mocbc.F
|   |-- outbc.F
|   |-- parameters
|   |-- parprepar.F
|   |-- parupdate.F
|   |-- plot.cpp
|   |-- plot.doc
|   |-- prepar.F
|   |-- preset.F
|   |-- qread.F
|   |-- rdist.F
|   |-- reactck.F
|   |-- react.F
|   |-- readcom.F
|   |-- restart.F
|   |-- rhsupwind.F
|   |-- setsignals.cpp
|   |-- sigaction.F
|   |-- spropck.F
|   |-- sprop.F
|   |-- stabbc.F
|   |-- stabprepar.F
|   |-- step1.F
|   |-- tecmovie.F
|   |-- tecout.F
|   |-- timer.cpp
|   |-- timestp.F
|   |-- turbeddy.F
|   |-- turbsource.F
|   |-- update.F
|   |-- vnjac.F
|   `-- wallbc.F
|-- TODO
|-- util
|   |-- dunsdiff
|   |-- dunssource
|   `-- dunstest
`-- VERSION
```

## 2.功能性测试

官方给出诸多测试，如`airfoil`，`bfs`，`cduct`，`cylinder`等，这里对每个测试案例进行测试

### 2.1.测试脚本

每个测试用例下都有其各自的测试脚本，`bfs`下的测试脚本如下，其他测试脚本大致相同

```bash
#!/bin/sh

DUNSSOURCE=$DUNSPATH27/util/dunssource
RETVAL=0

case "$1" in

   run )
        $DUNSSOURCE -d . 3d
    	cp parameters duns-3d
        cd duns-3d
        make duns-opt.e
        make clean
        cd ..
        ./duns-3d/duns-opt.e -nv > out6.dat
        ;;

   clean )
        \rm -rf core dunsout.* crash.* save.* out6.dat duns-3d
        ;;
   * )
    RETVAL=1
    echo "Usage: $0 run / clean"
esac

exit $RETVAL
```

进行cduct目录下进行测试：
```bash
./testscript run
```

### 2.2.运行结果

```bash
[root@host trinityrnaseq-v2.14.0]# ./testscript run &> /dev/null && cat out.dat
DUNS Version 2.7.1







> grid 
> formatted 





 Number of blocks for grid =             3
 Block             1           30           21           21
 Block             2           30           21           21
 Block             3           30           21           21
 
 Reading connectivity file duns.conn
B   1 s  1  0   0 b  0  2 123 s  3  0   0 s  4  0   0 s  5  0   0 s  6  0   0
B   2 b  0  1 123 b  0  3 123 s  3  0   0 s  4  0   0 s  5  0   0 s  6  0   0
B   3 b  2  0 123 s  2  0   0 s  3  0   0 s  4  0   0 s  5  0   0 s  6  0   0
 
 Assembling sweep blocks
 Sweep block:   1
   1   1123    2   2123    3   3123  
   1   2
   0   0
 Sweep block:   2
   1   1213  
   3   4
   0   0
 Sweep block:   3
   2   2213  
   3   4
   0   0
 Sweep block:   4
   3   3213  
   3   4
   0   0
 Sweep block:   5
   1   1312  
   5   6
   0   0
 Sweep block:   6
   2   2312  
   5   6
   0   0
 Sweep block:   7
   3   3312  
   5   6
   0   0
  
 **** nmx:            45012   ****
 **** iblkmx:        133100   ****
 **** iimx:              89   ****
 **** iimx2:             31   ****
  
 **** surfmax:          8160  ****
 **** bindmax:          4576  ****
 number of interior ghost cells :          1200
 Tolerance =   3.3870972E-06
> flow-field 
> viscous 





> gas-properties 
> compressible 
> gas-constant 287. 
> gamma 1.4 
> viscosity 5.8e-2 
> prandtl-number 0.7 





> initialize 
> temperature 300. 
> u-velocity 1. 
> pressure 1e5 





> boundary-conditions 
> surface 1 
> subsonic-inflow 
> velocity 15. 
> temperature 315. 
> surface 2 
> subsonic-outflow 
> pressure 1e5 
> surface 3 4 5 6 
> viscous-wall 
> adiabatic 





> spatial-accuracy 
> third 





> precondition 
> inviscid on 
> viscous on 
> pressure 1e5 
> velocity 15. 





> run 
> min-cfl 
> max-vnn 
> cfl 2.0 
> vnn 2.0 
> print-conv 5 
> print-rstrt 100 
> steps 1000 





Running for 1000 steps ntmn =             1
 ntmx =          1000
 Number of interpolated points:           852
 
 dunsout output at step           100
 
 Error reading in dunsout.v                        variables. Using defaults.
 
 dunsout output at step           200
 
 
 dunsout output at step           300
 
 
 dunsout output at step           400
 
 
 dunsout output at step           500
 
 
 dunsout output at step           600
 
 
 dunsout output at step           700
 
 
 dunsout output at step           800
 
 
 dunsout output at step           900
 
 
 dunsout output at step          1000
 
 
cpu time for solution:     61.9410     sec
 
cpu time/iteration/point:     1.376100 microsec
    timestep:                 0.067301 microsec
    righthand side:           0.886477 microsec
    lefthand side:            0.380931 microsec
    stiff solver:             0.000000 microsec
    equation of state:        0.012568 microsec
    boundary condition:       0.006360 microsec
 
 Timings:   1.376     0.6730E-01 0.8865     0.3809      0.000     0.1257E-01 0.6360E-02
 
> save-restart 
> filename save 





> save-plotting 
> filename save 
> cell-centered 0 
> variables p1 u v w t 

 
 save output at step          1000
 
> quit 
Exiting DUNS program with value 0.
```

## 3.性能测试

### 3.1.测试平台信息对比

|          | arm信息                                       | x86信息                     |
| -------- | --------------------------------------------- | --------------------------- |
| 操作系统 | openEuler 20.09                               | openEuler 20.09             |
| 内核版本 | 4.19.90-2110.8.0.0119.oe1.aarch64             | 4.19.90-2003.4.0.0036.oe1.x86_64 |

### 3.2.测试软件环境信息对比

|       | arm信息       | x86信息   |
| ----- | ------------- | --------- |
| gcc   | bisheng 2.1.0    | gcc 9.3.0 |
| bowtie2  | 2.4.5      | 2.4.5     |
| trinity  | 2.14.0     | 2.14.0    |

### 3.3.测试硬件性能信息对比

|        | arm信息     | x86信息    |
| ------ | ----------- | ---------- |
| cpu    | Kunpeng 920 | Intel(R) Xeon(R) Platinum 8255C CPU|
| 核心数 | 8           | 4         |
| 内存   | 16 GB       | 8 GB      |
| 磁盘io | 1.3 GB/s    | 1.3 MB/s   |
| 虚拟化 | KVM         | KVM        |

### 3.4.各测试用例比对

| airfoil     | arm        | x86       |
| ----------- | ---------- | --------- |
| 实际CPU时间 | 0m29.587s  | 0m20.158s |
| 用户时间    | 0m29.019s  | 0m19.566  |

| bfs     | arm        | x86       |
| ----------- | ---------- | --------- |
| 实际CPU时间 | 0m16.917s  | 0m10.420s |
| 用户时间    | 0m16.397s  | 0m9.901s  |

| cduct     | arm        | x86       |
| ----------- | ---------- | --------- |
| 实际CPU时间 | 1m18.574s  | 0m56.856s |
| 用户时间    | 1m18.163s  | 0m56.247s |

| cylinder    | arm        | x86       |
| ----------- | ---------- | --------- |
| 实际CPU时间 | 4m40.808s  | 3m32.234s |
| 用户时间    | 4m39.537s  | 3m30.153s |

| cylinder-ext   | arm     | x86       |
| ----------- | ---------- | --------- |
| 实际CPU时间 | 1m23.231s  | 1m1.296s |
| 用户时间    | 1m22.873s  | 1m0.593s |

| rbcc      | arm        | x86       |
| ----------- | ---------- | --------- |
| 实际CPU时间 | 2m49.730s  | 1m59.213s |
| 用户时间    | 2m48.522s  | 1m58.397s |

| shear      | arm        | x86       |
| ----------- | ---------- | --------- |
| 实际CPU时间 | 2m49.730s  | 1m59.213s |
| 用户时间    | 2m48.522s  | 1m58.397s |

| swirl      | arm        | x86       |
| ----------- | ---------- | --------- |
| 实际CPU时间 | 0m17.004s  | 0m10.356s |
| 用户时间    | 0m16.471s  | 0m9.803s |