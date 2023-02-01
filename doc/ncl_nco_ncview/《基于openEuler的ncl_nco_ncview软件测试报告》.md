# 《基于openEuler的NCL/NCO/NCVIEW软件测试报告》

## 1.规范性自检

项目使用了Artistic Style对文件进行格式化

AStyle，即Artistic Style，是一个可用于C, C++, C++/CLI, Objective‑C, C# 和Java编程语言格式化和美化的工具。我们在使用编辑器的缩进（TAB）功能时，由于不同编辑器的差别，有的插入的是制表符，有的是2个空格，有的是4个空格。这样如果别人用另一个编辑器来阅读程序时，可能会由于缩进的不同，导致阅读效果一团糟。为了解决这个问题，使用C++开发了一个插件，它可以自动重新缩进，并手动指定空格的数量，自动格式化源文件。它是可以通过命令行使用，也可以作为插件，在其他IDE中使用。

文件格式化配置参考文件`config/mfem.astylerc`，文件内容如下

```astylerc
--style=allman
--indent=spaces=3
--keep-one-line-statements
--keep-one-line-blocks
--pad-header
--max-code-length=80
--max-instatement-indent=80
--min-conditional-indent=0
--indent-col1-comments
--indent-labels
--break-after-logical
--add-brackets
--indent-switches
--convert-tabs
--lineend=linux
--suffix=none
--preserve-date
--formatted
```

检查代码规范性，可以通过使用AStyle对所有源码进行重新格式化，然后使用git查看文件修改。

统计代码不规范内容。
## NCL
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

在NCL项目根目录下运行,运行结果如下

```bash
当前文件夹下共有[.f]的文件3857个
当前文件夹下共有[.c]的文件1481个
当前文件夹下共有[.m]的文件882个
当前文件夹下共有[]的文件852个
当前文件夹下共有[.h]的文件826个
当前文件夹下共有[.table]的文件618个
当前文件夹下共有[.rgb]的文件270个
当前文件夹下共有[.ncl]的文件259个
当前文件夹下共有[.sed]的文件84个
当前文件夹下共有[.res]的文件63个
当前文件夹下共有[.nc]的文件58个
当前文件夹下共有[.sh]的文件52个
当前文件夹下共有[.gc]的文件43个
当前文件夹下共有[.cdf]的文件36个
当前文件夹下共有[.specific]的文件32个
当前文件夹下共有[.fc]的文件31个
当前文件夹下共有[.dat]的文件27个
当前文件夹下共有[.f90]的文件23个
当前文件夹下共有[.gp]的文件22个
当前文件夹下共有[.csh]的文件14个
当前文件夹下共有[.asc]的文件14个
当前文件夹下共有[.ttf]的文件13个
当前文件夹下共有[.o]的文件12个
当前文件夹下共有[.doc]的文件11个
当前文件夹下共有[.py]的文件9个
当前文件夹下共有[.ncmap]的文件8个
当前文件夹下共有[.txt]的文件6个
当前文件夹下共有[.xml]的文件6个
当前文件夹下共有[.md]的文件5个
当前文件夹下共有[.grb2]的文件5个
当前文件夹下共有[.l]的文件4个
当前文件夹下共有[.areas]的文件4个
当前文件夹下共有[.java]的文件4个
当前文件夹下共有[.ksh]的文件3个
当前文件夹下共有[.PGI]的文件3个
当前文件夹下共有[.INTEL]的文件3个
当前文件夹下共有[.GNU]的文件3个
当前文件夹下共有[.yml]的文件3个
当前文件夹下共有[.csv]的文件2个
当前文件夹下共有[.dbf]的文件2个
当前文件夹下共有[.shx]的文件2个
当前文件夹下共有[.shp]的文件2个
当前文件夹下共有[.prj]的文件2个
当前文件夹下共有[.null]的文件2个
当前文件夹下共有[.y]的文件2个
当前文件夹下共有[.template]的文件2个
当前文件夹下共有[.64]的文件2个
当前文件夹下共有[.tiff]的文件1个
当前文件夹下共有[.bit]的文件1个
当前文件夹下共有[.xbm]的文件1个
当前文件夹下共有[.ad]的文件1个
当前文件夹下共有[.tbl]的文件1个
当前文件夹下共有[.PS]的文件1个
当前文件夹下共有[.CO]的文件1个
当前文件夹下共有[.3]的文件1个
当前文件夹下共有[.1]的文件1个
当前文件夹下共有[.US]的文件1个
当前文件夹下共有[.2]的文件1个
当前文件夹下共有[.4]的文件1个
当前文件夹下共有[.PO]的文件1个
当前文件夹下共有[.png]的文件1个
当前文件夹下共有[.pngi]的文件1个
当前文件夹下共有[.form]的文件1个
当前文件夹下共有[.pre]的文件1个
当前文件夹下共有[.imagen]的文件1个
当前文件夹下共有[.file]的文件1个
当前文件夹下共有[.grib2]的文件1个
当前文件夹下共有[.grb]的文件1个
当前文件夹下共有[.hdf]的文件1个
当前文件夹下共有[.he2]的文件1个
当前文件夹下共有[.he5]的文件1个
当前文件夹下共有[.cocos]的文件1个
当前文件夹下共有[.cpt]的文件1个
当前文件夹下共有[.bin]的文件1个
当前文件夹下共有[.ctl]的文件1个
当前文件夹下共有[.mdl]的文件1个
当前文件夹下共有[.xlsx]的文件1个
当前文件夹下共有[.F90]的文件1个
当前文件夹下共有[.xsl]的文件1个
当前文件夹下共有[.pl]的文件1个
当前文件夹下共有[.ifort]的文件1个
当前文件夹下共有[.xl]的文件1个
当前文件夹下共有[.absoft]的文件1个
当前文件夹下共有[.man]的文件1个
当前文件夹下共有[.amd64]的文件1个
当前文件夹下共有[.g95]的文件1个
当前文件夹下共有[.IA64]的文件1个
当前文件夹下共有[.ini]的文件1个
当前文件夹下共有[.32]的文件1个
当前文件夹下共有[.n32]的文件1个
当前文件夹下共有[.patch]的文件1个

```

查看上述结果可知主要源码文件后缀名为 `c`,`h`,`f`

### 1.2.统计源码总行数

统计所有源码文件的代码行数

```bash
 find ./ -regex ".*\.f\|.*\.c\|.*\.h\|"\
  | xargs wc -l
```

统计结果

```bash
   1001123 total
```

### 1.3.统计不符合要求的总行数

对文件后缀名为 `h`,`c` 的所有文件进行格式
通过git与astyle结合的方式进行统计
```bash
# astyle  -R ./*.cpp,*.h,*.hpp -v
...
------------------------------------------------------------
 2,179 formatted   128 unchanged   14.4 seconds   1,095,902 lines
```

### 1.4.统计结果

综上信息，项目中代码规范性自检检查结果为

通过率    : 0.2%           1-96213/96400*100%

不通过率  : 99.8%            96213/96400*100%

# 2.功能性测试

ncl作为图形软件，并无内置测试用例，通过判断ncl软件是否编译成功来进行功能性测试，官方文档中，只有满足所有依赖安装并正确链接方可有ncl软件生成
```bash
ncl -v
```
## 2.2.运行结果

```bash
Running NCL...
 Copyright (C) 1995-2019 - All Rights Reserved
 University Corporation for Atmospheric Research
 NCAR Command Language Version 6.6.2
 The use of this software is governed by a License Agreement.
 See http://www.ncl.ucar.edu/ for more details.
```


测试结果

ncl软件存在，编译过程满足各项依赖

## 3.性能测试

ncl作为图形软件，需要环境支持图形，作为云端服务器，图形环境不满足，如DISPLAY等环境变量并无设定

## NCO
### 1.1.选择统计文件类型

统计项目文件类型及其文件数量

使用python编写脚本文件

代码同NCL

在NCL项目根目录下运行,运行结果如下

```bash
当前文件夹下共有[.c]的文件68个
当前文件夹下共有[]的文件59个
当前文件夹下共有[.h]的文件56个
当前文件夹下共有[.cdl]的文件56个
当前文件夹下共有[.nco]的文件34个
当前文件夹下共有[.txt]的文件32个
当前文件夹下共有[.sh]的文件30个
当前文件夹下共有[.hh]的文件26个
当前文件夹下共有[.cc]的文件21个
当前文件夹下共有[.png]的文件17个
当前文件夹下共有[.1]的文件16个
当前文件夹下共有[.in]的文件14个
当前文件夹下共有[.am]的文件8个
当前文件夹下共有[.shtml]的文件8个
当前文件夹下共有[.pl]的文件7个
当前文件夹下共有[.m4]的文件7个
当前文件夹下共有[.hpp]的文件6个
当前文件夹下共有[.eps]的文件6个
当前文件夹下共有[.py]的文件3个
当前文件夹下共有[.cpp]的文件3个
当前文件夹下共有[.ncl]的文件3个
当前文件夹下共有[.pm]的文件3个
当前文件夹下共有[.xcf]的文件3个
当前文件夹下共有[.old]的文件2个
当前文件夹下共有[.cu]的文件2个
当前文件夹下共有[.po]的文件2个
当前文件夹下共有[.md]的文件2个
当前文件夹下共有[.bat]的文件2个
当前文件夹下共有[.yml]的文件2个
当前文件夹下共有[.texi]的文件2个
当前文件夹下共有[.ac]的文件1个
当前文件夹下共有[.spec]的文件1个
当前文件夹下共有[.guess]的文件1个
当前文件夹下共有[.sub]的文件1个
当前文件夹下共有[.tex]的文件1个
当前文件夹下共有[.l]的文件1个
当前文件夹下共有[.g]的文件1个
当前文件夹下共有[.pot]的文件1个
当前文件夹下共有[.log]的文件1个
当前文件夹下共有[.cmd]的文件1个
当前文件夹下共有[.eg]的文件1个
当前文件夹下共有[.in2]的文件1个
当前文件夹下共有[.xsd]的文件1个
当前文件夹下共有[.slurm]的文件1个
当前文件夹下共有[.dat]的文件1个
当前文件夹下共有[.css]的文件1个
当前文件夹下共有[.pptx]的文件1个
当前文件夹下共有[.html]的文件1个
当前文件夹下共有[.ods]的文件1个
当前文件夹下共有[.3]的文件1个
当前文件夹下共有[.pdf]的文件1个
当前文件夹下共有[.odp]的文件1个
当前文件夹下共有[.jpg]的文件1个
当前文件夹下共有[.svg]的文件1个

```

查看上述结果可知主要源码文件后缀名为 `c`,`h`

### 1.2.统计源码总行数

统计所有源码文件的代码行数

```bash
 find ./ -regex ".*\.f\|.*\.c\|.*\.h\|"\
  | xargs wc -l
```

统计结果

```bash
     116955 total
```

### 1.3.统计不符合要求的总行数

对文件后缀名为 `h`,`c` 的所有文件进行格式
通过git与astyle结合的方式进行统计
```bash
# astyle  -R ./*.c,*.h,*.hpp -v
...
Unchanged  src/nco/nco_var_utl.c
Unchanged  src/nco/nco_var_utl.h
Unchanged  src/nco/ncpdq.c
Unchanged  src/nco/ncra.c
Unchanged  src/nco/ncrename.c
Unchanged  src/nco/ncwa.c
------------------------------------------------------------
 124 formatted   124 unchanged   4.6 seconds   244,852 lines
```
```bash
 248 files changed, 126025 insertions(+), 106164 deletions(-)
 create mode 100644 bld/libnco_tst.c.orig
 rewrite doc/cdtime.c (72%)
 copy doc/{cdtime.c => cdtime.c.orig} (100%)
 create mode 100644 src/nco/libnco.h.orig
 rewrite src/nco/mpncbo.c (91%)
 copy src/nco/{mpncbo.c => mpncbo.c.orig} (100%)
 rewrite src/nco/mpncecat.c (91%)
 copy src/nco/{mpncecat.c => mpncecat.c.orig} (100%)
 rewrite src/nco/mpncflint.c (92%)
 copy src/nco/{mpncflint.c => mpncflint.c.orig} (100%)
 rewrite src/nco/mpncpdq.c (89%)
 copy src/nco/{mpncpdq.c => mpncpdq.c.orig} (100%)
 rewrite src/nco/mpncra.c (86%)
 copy src/nco/{mpncra.c => mpncra.c.orig} (100%)
 rewrite src/nco/mpncwa.c (92%)
 copy src/nco/{mpncwa.c => mpncwa.c.orig} (100%)
 rewrite src/nco/ncap_utl.c (91%)
 copy src/nco/{ncap_utl.c => ncap_utl.c.orig} (100%)
 create mode 100644 src/nco/ncap_utl.h.orig
 rewrite src/nco/ncatted.c (72%)
 copy src/nco/{ncatted.c => ncatted.c.orig} (100%)
 rewrite src/nco/ncbo.c (89%)
 copy src/nco/{ncbo.c => ncbo.c.orig} (100%)
 rewrite src/nco/ncecat.c (91%)
 copy src/nco/{ncecat.c => ncecat.c.orig} (100%)
 rewrite src/nco/ncflint.c (91%)
 copy src/nco/{ncflint.c => ncflint.c.orig} (100%)
 rewrite src/nco/ncks.c (91%)
 copy src/nco/{ncks.c => ncks.c.orig} (100%)
 create mode 100644 src/nco/nco.h.orig
 rewrite src/nco/nco_att_utl.c (88%)
 copy src/nco/{nco_att_utl.c => nco_att_utl.c.orig} (100%)
 create mode 100644 src/nco/nco_att_utl.h.orig
 rewrite src/nco/nco_aux.c (83%)
 copy src/nco/{nco_aux.c => nco_aux.c.orig} (100%)
 create mode 100644 src/nco/nco_aux.h.orig
 rewrite src/nco/nco_bnr.c (75%)
 copy src/nco/{nco_bnr.c => nco_bnr.c.orig} (100%)
 create mode 100644 src/nco/nco_bnr.h.orig
 rewrite src/nco/nco_cln_utl.c (80%)
 copy src/nco/{nco_cln_utl.c => nco_cln_utl.c.orig} (100%)
 rewrite src/nco/nco_cln_utl.h (76%)
 copy src/nco/{nco_cln_utl.h => nco_cln_utl.h.orig} (100%)
 rewrite src/nco/nco_cnf_dmn.c (92%)
 copy src/nco/{nco_cnf_dmn.c => nco_cnf_dmn.c.orig} (100%)
 create mode 100644 src/nco/nco_cnf_dmn.h.orig
 rewrite src/nco/nco_cnf_typ.c (92%)
 copy src/nco/{nco_cnf_typ.c => nco_cnf_typ.c.orig} (100%)
 create mode 100644 src/nco/nco_cnf_typ.h.orig
 rewrite src/nco/nco_cnk.c (85%)
 copy src/nco/{nco_cnk.c => nco_cnk.c.orig} (100%)
 create mode 100644 src/nco/nco_cnk.h.orig
 rewrite src/nco/nco_cnv_arm.c (79%)
 copy src/nco/{nco_cnv_arm.c => nco_cnv_arm.c.orig} (100%)
 create mode 100644 src/nco/nco_cnv_arm.h.orig
 rewrite src/nco/nco_cnv_csm.c (90%)
 copy src/nco/{nco_cnv_csm.c => nco_cnv_csm.c.orig} (100%)
 create mode 100644 src/nco/nco_cnv_csm.h.orig
 create mode 100644 src/nco/nco_crt.c.orig
 create mode 100644 src/nco/nco_crt.h.orig
 rewrite src/nco/nco_ctl.c (89%)
 copy src/nco/{nco_ctl.c => nco_ctl.c.orig} (100%)
 create mode 100644 src/nco/nco_ctl.h.orig
 rewrite src/nco/nco_dbg.c (61%)
 copy src/nco/{nco_dbg.c => nco_dbg.c.orig} (100%)
 create mode 100644 src/nco/nco_dbg.h.orig
 rewrite src/nco/nco_dmn_utl.c (69%)
 copy src/nco/{nco_dmn_utl.c => nco_dmn_utl.c.orig} (100%)
 create mode 100644 src/nco/nco_dmn_utl.h.orig
 rewrite src/nco/nco_fl_utl.c (89%)
 copy src/nco/{nco_fl_utl.c => nco_fl_utl.c.orig} (100%)
 create mode 100644 src/nco/nco_fl_utl.h.orig
 rewrite src/nco/nco_flt.c (88%)
 copy src/nco/{nco_flt.c => nco_flt.c.orig} (100%)
 create mode 100644 src/nco/nco_flt.h.orig
 rewrite src/nco/nco_getopt.c (71%)
 copy src/nco/{nco_getopt.c => nco_getopt.c.orig} (100%)
 create mode 100644 src/nco/nco_getopt.h.orig
 rewrite src/nco/nco_grp_trv.c (72%)
 copy src/nco/{nco_grp_trv.c => nco_grp_trv.c.orig} (100%)
 create mode 100644 src/nco/nco_grp_trv.h.orig
 rewrite src/nco/nco_grp_utl.c (80%)
 copy src/nco/{nco_grp_utl.c => nco_grp_utl.c.orig} (100%)
 create mode 100644 src/nco/nco_grp_utl.h.orig
 create mode 100644 src/nco/nco_kd.c.orig
 create mode 100644 src/nco/nco_kd.h.orig
 rewrite src/nco/nco_lmt.c (92%)
 copy src/nco/{nco_lmt.c => nco_lmt.c.orig} (100%)
 create mode 100644 src/nco/nco_lmt.h.orig
 rewrite src/nco/nco_lst_utl.c (76%)
 copy src/nco/{nco_lst_utl.c => nco_lst_utl.c.orig} (100%)
 create mode 100644 src/nco/nco_lst_utl.h.orig
 rewrite src/nco/nco_map.c (92%)
 copy src/nco/{nco_map.c => nco_map.c.orig} (100%)
 rewrite src/nco/nco_map.h (73%)
 copy src/nco/{nco_map.h => nco_map.h.orig} (100%)
 create mode 100644 src/nco/nco_md5.c.orig
 create mode 100644 src/nco/nco_md5.h.orig
 rewrite src/nco/nco_mmr.c (83%)
 copy src/nco/{nco_mmr.c => nco_mmr.c.orig} (100%)
 create mode 100644 src/nco/nco_mmr.h.orig
 create mode 100644 src/nco/nco_mpi.h.orig
 rewrite src/nco/nco_msa.c (87%)
 copy src/nco/{nco_msa.c => nco_msa.c.orig} (100%)
 create mode 100644 src/nco/nco_msa.h.orig
 rewrite src/nco/nco_mss_val.c (90%)
 copy src/nco/{nco_mss_val.c => nco_mss_val.c.orig} (100%)
 create mode 100644 src/nco/nco_mss_val.h.orig
 rewrite src/nco/nco_mta.c (77%)
 copy src/nco/{nco_mta.c => nco_mta.c.orig} (100%)
 rewrite src/nco/nco_mta.h (69%)
 copy src/nco/{nco_mta.h => nco_mta.h.orig} (100%)
 rewrite src/nco/nco_netcdf.c (75%)
 copy src/nco/{nco_netcdf.c => nco_netcdf.c.orig} (100%)
 create mode 100644 src/nco/nco_netcdf.h.orig
 rewrite src/nco/nco_omp.c (88%)
 copy src/nco/{nco_omp.c => nco_omp.c.orig} (100%)
 create mode 100644 src/nco/nco_omp.h.orig
 rewrite src/nco/nco_pck.c (87%)
 copy src/nco/{nco_pck.c => nco_pck.c.orig} (100%)
 create mode 100644 src/nco/nco_pck.h.orig
 rewrite src/nco/nco_ply.c (86%)
 copy src/nco/{nco_ply.c => nco_ply.c.orig} (100%)
 rewrite src/nco/nco_ply.h (62%)
 copy src/nco/{nco_ply.h => nco_ply.h.orig} (100%)
 rewrite src/nco/nco_ply_lst.c (92%)
 copy src/nco/{nco_ply_lst.c => nco_ply_lst.c.orig} (100%)
 create mode 100644 src/nco/nco_ply_lst.h.orig
 rewrite src/nco/nco_ppc.c (92%)
 copy src/nco/{nco_ppc.c => nco_ppc.c.orig} (100%)
 create mode 100644 src/nco/nco_ppc.h.orig
 rewrite src/nco/nco_prn.c (92%)
 copy src/nco/{nco_prn.c => nco_prn.c.orig} (100%)
 create mode 100644 src/nco/nco_prn.h.orig
 rewrite src/nco/nco_rec_var.c (81%)
 copy src/nco/{nco_rec_var.c => nco_rec_var.c.orig} (100%)
 create mode 100644 src/nco/nco_rec_var.h.orig
 rewrite src/nco/nco_rgr.c (88%)
 copy src/nco/{nco_rgr.c => nco_rgr.c.orig} (100%)
 rewrite src/nco/nco_rgr.h (68%)
 copy src/nco/{nco_rgr.h => nco_rgr.h.orig} (100%)
 rewrite src/nco/nco_rth_flt.c (67%)
 copy src/nco/{nco_rth_flt.c => nco_rth_flt.c.orig} (100%)
 create mode 100644 src/nco/nco_rth_flt.h.orig
 rewrite src/nco/nco_rth_utl.c (84%)
 copy src/nco/{nco_rth_utl.c => nco_rth_utl.c.orig} (100%)
 create mode 100644 src/nco/nco_rth_utl.h.orig
 rewrite src/nco/nco_s1d.c (95%)
 copy src/nco/{nco_s1d.c => nco_s1d.c.orig} (100%)
 create mode 100644 src/nco/nco_s1d.h.orig
 rewrite src/nco/nco_scl_utl.c (71%)
 copy src/nco/{nco_scl_utl.c => nco_scl_utl.c.orig} (100%)
 create mode 100644 src/nco/nco_scl_utl.h.orig
 rewrite src/nco/nco_scm.c (89%)
 copy src/nco/{nco_scm.c => nco_scm.c.orig} (100%)
 create mode 100644 src/nco/nco_scm.h.orig
 rewrite src/nco/nco_sld.c (92%)
 copy src/nco/{nco_sld.c => nco_sld.c.orig} (100%)
 rewrite src/nco/nco_sld.h (60%)
 copy src/nco/{nco_sld.h => nco_sld.h.orig} (100%)
 rewrite src/nco/nco_sng_utl.c (84%)
 copy src/nco/{nco_sng_utl.c => nco_sng_utl.c.orig} (100%)
 rewrite src/nco/nco_sng_utl.h (74%)
 copy src/nco/{nco_sng_utl.h => nco_sng_utl.h.orig} (100%)
 rewrite src/nco/nco_sph.c (82%)
 copy src/nco/{nco_sph.c => nco_sph.c.orig} (100%)
 create mode 100644 src/nco/nco_sph.h.orig
 rewrite src/nco/nco_srm.c (75%)
 copy src/nco/{nco_srm.c => nco_srm.c.orig} (100%)
 create mode 100644 src/nco/nco_srm.h.orig
 create mode 100644 src/nco/nco_typ.h.orig
 create mode 100644 src/nco/nco_uthash.h.orig
 rewrite src/nco/nco_var_avg.c (93%)
 copy src/nco/{nco_var_avg.c => nco_var_avg.c.orig} (100%)
 create mode 100644 src/nco/nco_var_avg.h.orig
 rewrite src/nco/nco_var_lst.c (85%)
 copy src/nco/{nco_var_lst.c => nco_var_lst.c.orig} (100%)
 create mode 100644 src/nco/nco_var_lst.h.orig
 rewrite src/nco/nco_var_rth.c (73%)
 copy src/nco/{nco_var_rth.c => nco_var_rth.c.orig} (100%)
 rewrite src/nco/nco_var_rth.h (86%)
 copy src/nco/{nco_var_rth.h => nco_var_rth.h.orig} (100%)
 rewrite src/nco/nco_var_scv.c (86%)
 copy src/nco/{nco_var_scv.c => nco_var_scv.c.orig} (100%)
 rewrite src/nco/nco_var_scv.h (77%)
 copy src/nco/{nco_var_scv.h => nco_var_scv.h.orig} (100%)
 rewrite src/nco/nco_var_utl.c (88%)
 copy src/nco/{nco_var_utl.c => nco_var_utl.c.orig} (100%)
 rewrite src/nco/nco_var_utl.h (81%)
 copy src/nco/{nco_var_utl.h => nco_var_utl.h.orig} (100%)
 rewrite src/nco/ncpdq.c (91%)
 copy src/nco/{ncpdq.c => ncpdq.c.orig} (100%)
 rewrite src/nco/ncra.c (92%)
 copy src/nco/{ncra.c => ncra.c.orig} (100%)
 rewrite src/nco/ncrename.c (89%)
 copy src/nco/{ncrename.c => ncrename.c.orig} (100%)
 rewrite src/nco/ncwa.c (91%)
 copy src/nco/{ncwa.c => ncwa.c.orig} (100%)
```
### 1.4.统计结果

综上信息，项目中代码规范性自检检查结果为

通过率    : 7%           79800/1,095,902*100%

不通过率  : 93%            1-79800/1,095,902*100%

# 2.功能性测试

NCO作为netCDF的operator，并无内置测试用例，判断软件是否正常运行,官方也并未给出测试集

```bash
ncdiff
```
## 2.2.运行结果

```bash
ncdiff Command line options cheatsheet (full details at http://nco.sf.net/nco.html#ncdiff):
ncdiff [-3] [-4] [-5] [-6] [-7] [-A] [--bfr byt] [-C] [-c] [--cmp sng] [--cnk_byt byt] [--cnk_csh byt] [--cnk_dmn nm,lmn] [--cnk_map map] [--cnk_min byt] [--cnk_plc plc] [--cnk_scl sz] [-D dbg_lvl] [-d ...] [-F] [--fl_fmt fmt] [-G grp:lvl] [-g ...] [--glb ...] [-H] [-h] [--hdf] [--hdr_pad nbr] [--hpss] [-L lvl] [-l path] [--msa] [-n ...] [--no_cll_msr] [--no_frm_trm] [--no_tmp_fl] [-O] [-o out.nc] [-p path] [-R] [-r] [--ram_all] [-t thr_nbr] [--uio] [--unn] [-v ...] [-X box] [-x] [-y op_typ] in1.nc in2.nc [out.nc]

-3, --3, classic        Output file in netCDF3 CLASSIC (32-bit offset) storage format
-4, --4, netcdf4        Output file in netCDF4 (HDF5) storage format
-5, --5, 64bit_data     Output file in netCDF3 64-bit data (i.e., CDF5, PnetCDF) storage format
-6, --6, 64, 64bit_offset       Output file in netCDF3 64-bit offset storage format
-7, --7, netcdf4_classic        Output file in netCDF4 CLASSIC format (3+4=7)
-A, --apn, append       Append to existing output file, if any
    --bfr_sz, buffer_size sz    Buffer size to open files with
-C, --no_crd, xcl_ass_var       Exclude coordinates, CF-associated variables (ancillary, bounds, ...)
-c, --crd, xtr_ass_var  Extract coordinates, CF-associated variables (ancillary, bounds, ...)
    --cmp cmp_sng       Compression string (e.g., 'gbr,3|zstd,1')
    --cnk_byt, chunk_byte sz_byt        Chunksize in bytes
    --cnk_csh, chunk_cache sz_byt       Chunk cache size in bytes
    --cnk_dmn, chunk_dimension nm,sz_lmn        Chunksize of dimension nm (in elements not bytes)
    --cnk_map, chunk_map map    Chunking map [dmn,lfp,nc4,nco,prd,rd1,rew,scl,xpl,xst]
    --cnk_min, chunk_min sz_byt Minimum size [B] of variable to chunk
    --cnk_plc, chunk_policy plc Chunking policy [all,g2d,g3d,xpl,xst,uck]
    --cnk_scl, chunk_scalar sz_lmn      Chunksize scalar (in elements not bytes) (for all dimensions)
-D, --dbg_lvl, debug-level lvl  Debug-level is lvl
-d, --dmn, dimension dim,[min][,[max]][,[stride]] Dimension's limits and stride in hyperslab
-F, --ftn, fortran      Fortran indexing conventions (1-based) for I/O
    --fl_fmt, file_format fmt   File format for output [classic,64bit_offset,64bit_data,netcdf4,netcdf4_classic]
-G, --gpe [grp_nm][:[lvl]]      Group Path Editing path, levels to replace
-g, --grp grp1[,grp2[...]] Group(s) to process (regular expressions supported)
    --glb_att_add nm=val        Global attribute to add
-H, --fl_lst_in, file_list      Do not create "input_file_list" global attribute that stores stdin filenames
-h, --hst, history      Do not append to "history" global attribute
    --hdf_upk, hdf_unpack       HDF unpack convention: unpacked=scale_factor*(packed-add_offset)
    --hdr_pad, header_pad       Pad output header with nbr bytes
    --hpss, hpss_try    Search for unfound files on HPSS with 'hsi get ...'
-L, --dfl_lvl, deflate lvl      Lempel-Ziv deflation/compression (lvl=0..9) for netCDF4 output
-l, --lcl, local path   Local storage path for remotely-retrieved files
    --msa, msa_usr_rdr  Multi-Slab-Algorithm output in User-Order
-n, --nintap nbr_files,[nbr_numeric_chars[,increment]] NINTAP-style abbreviation of file list
    --no_cll_msr        Do not extract cell_measures variables
    --no_frm_trm        Do not extract formula_terms variables
    --no_tmp_fl         Do not write output to temporary file
-O, --ovr, overwrite    Overwrite existing output file, if any
-o, --output, fl_out    Output file name (or use last positional argument)
-p, --pth, path path    Path prefix for all input filenames
-R, --rtn, retain       Retain remotely-retrieved files after use
-r, --revision, version Compile-time configuration and/or program version
    --ram_all, diskless_all     Open netCDF3 files and create output files in RAM
-t, --thr_nbr, threads, omp_num_threads thr_nbr Thread number for OpenMP
    --uio, share_all    Unbuffered I/O to read/write netCDF3 file(s)
    --unn, union        Select union of specified groups and variables
-v, --variable var1[,var2[...]] Variable(s) to process (regular expressions supported)
-X, --auxiliary lon_min,lon_max,lat_min,lat_max Auxiliary coordinate bounding box
-x, --xcl, exclude      Extract all variables EXCEPT those specified with -v
-y, --op_typ, operation op_typ  Binary arithmetic operation: add,sbt,mlt,dvd (+,-,*,/)
in1.nc in2.nc           Input file names (or use stdin)
[out.nc]                Output file name (or use -o option)

Eight ways to find more help on ncdiff and/or NCO:
1. Examples:     http://nco.sf.net/nco.html#xmp_ncdiff
2. Ref. manual:  http://nco.sf.net/nco.html#ncdiff
3. User Guide:   http://nco.sf.net#RTFM
4. Manual pages: 'man ncdiff', 'man nco', ...
5. Homepage:     http://nco.sf.net
6. Code:         http://github.com/nco/nco
7. Help Forum:   http://sf.net/p/nco/discussion/9830
8. Publications: http://nco.sf.net#pub
Post questions, suggestions, patches at http://sf.net/projects/nco
```


测试结果

nco可正常执行
## NCVIEW
### 1.1.选择统计文件类型

统计项目文件类型及其文件数量

使用python编写脚本文件
代码同上

```

在NCVIEW项目根目录下运行,运行结果如下

```bash
当前文件夹下共有[.f]的文件3857个
当前文件夹下共有[.c]的文件1481个
当前文件夹下共有[.m]的文件882个
当前文件夹下共有[]的文件852个
当前文件夹下共有[.h]的文件826个
当前文件夹下共有[.table]的文件618个
当前文件夹下共有[.rgb]的文件270个
当前文件夹下共有[.ncl]的文件259个
当前文件夹下共有[.sed]的文件84个
当前文件夹下共有[.res]的文件63个
当前文件夹下共有[.nc]的文件58个
当前文件夹下共有[.sh]的文件52个
当前文件夹下共有[.gc]的文件43个
当前文件夹下共有[.cdf]的文件36个
当前文件夹下共有[.specific]的文件32个
当前文件夹下共有[.fc]的文件31个
当前文件夹下共有[.dat]的文件27个
当前文件夹下共有[.f90]的文件23个
当前文件夹下共有[.gp]的文件22个
当前文件夹下共有[.csh]的文件14个
当前文件夹下共有[.asc]的文件14个
当前文件夹下共有[.ttf]的文件13个
当前文件夹下共有[.o]的文件12个
当前文件夹下共有[.doc]的文件11个
当前文件夹下共有[.py]的文件9个
当前文件夹下共有[.ncmap]的文件8个
当前文件夹下共有[.txt]的文件6个
当前文件夹下共有[.xml]的文件6个
当前文件夹下共有[.md]的文件5个
当前文件夹下共有[.grb2]的文件5个
当前文件夹下共有[.l]的文件4个
当前文件夹下共有[.areas]的文件4个
当前文件夹下共有[.java]的文件4个
当前文件夹下共有[.ksh]的文件3个
当前文件夹下共有[.PGI]的文件3个
当前文件夹下共有[.INTEL]的文件3个
当前文件夹下共有[.GNU]的文件3个
当前文件夹下共有[.yml]的文件3个
当前文件夹下共有[.csv]的文件2个
当前文件夹下共有[.dbf]的文件2个
当前文件夹下共有[.shx]的文件2个
当前文件夹下共有[.shp]的文件2个
当前文件夹下共有[.prj]的文件2个
当前文件夹下共有[.null]的文件2个
当前文件夹下共有[.y]的文件2个
当前文件夹下共有[.template]的文件2个
当前文件夹下共有[.64]的文件2个
当前文件夹下共有[.tiff]的文件1个
当前文件夹下共有[.bit]的文件1个
当前文件夹下共有[.xbm]的文件1个
当前文件夹下共有[.ad]的文件1个
当前文件夹下共有[.tbl]的文件1个
当前文件夹下共有[.PS]的文件1个
当前文件夹下共有[.CO]的文件1个
当前文件夹下共有[.3]的文件1个
当前文件夹下共有[.1]的文件1个
当前文件夹下共有[.US]的文件1个
当前文件夹下共有[.2]的文件1个
当前文件夹下共有[.4]的文件1个
当前文件夹下共有[.PO]的文件1个
当前文件夹下共有[.png]的文件1个
当前文件夹下共有[.pngi]的文件1个
当前文件夹下共有[.form]的文件1个
当前文件夹下共有[.pre]的文件1个
当前文件夹下共有[.imagen]的文件1个
当前文件夹下共有[.file]的文件1个
当前文件夹下共有[.grib2]的文件1个
当前文件夹下共有[.grb]的文件1个
当前文件夹下共有[.hdf]的文件1个
当前文件夹下共有[.he2]的文件1个
当前文件夹下共有[.he5]的文件1个
当前文件夹下共有[.cocos]的文件1个
当前文件夹下共有[.cpt]的文件1个
当前文件夹下共有[.bin]的文件1个
当前文件夹下共有[.ctl]的文件1个
当前文件夹下共有[.mdl]的文件1个
当前文件夹下共有[.xlsx]的文件1个
当前文件夹下共有[.F90]的文件1个
当前文件夹下共有[.xsl]的文件1个
当前文件夹下共有[.pl]的文件1个
当前文件夹下共有[.ifort]的文件1个
当前文件夹下共有[.xl]的文件1个
当前文件夹下共有[.absoft]的文件1个
当前文件夹下共有[.man]的文件1个
当前文件夹下共有[.amd64]的文件1个
当前文件夹下共有[.g95]的文件1个
当前文件夹下共有[.IA64]的文件1个
当前文件夹下共有[.ini]的文件1个
当前文件夹下共有[.32]的文件1个
当前文件夹下共有[.n32]的文件1个
当前文件夹下共有[.patch]的文件1个

```

查看上述结果可知主要源码文件后缀名为 `c`,`h`,`f`

### 1.2.统计源码总行数

统计所有源码文件的代码行数

```bash
 find ./ -regex ".*\.f\|.*\.c\|.*\.h\|"\
  | xargs wc -l
```

统计结果

```bash
   1001123 total
```

### 1.3.统计不符合要求的总行数

对文件后缀名为 `h`,`c` 的所有文件进行格式
通过git与astyle结合的方式进行统计
```bash
# astyle  -R ./*.cpp,*.h,*.hpp -v
...
------------------------------------------------------------
 2,179 formatted   128 unchanged   14.4 seconds   1,095,902 lines
```

### 1.4.统计结果

综上信息，项目中代码规范性自检检查结果为

通过率    : 0.2%           1-96213/96400*100%

不通过率  : 99.8%            96213/96400*100%

# 2.功能性测试
NCVIEW作为netCDF的operator，并无内置测试用例，判断软件是否正常运行,官方也并未给出测试集

```bash
ncview
```
## 2.2.运行结果
```bash
Ncview 2.1.7 David W. Pierce  29 March 2016
http://meteora.ucsd.edu:80/~pierce/ncview_home_page.html
Copyright (C) 1993 through 2015, David W. Pierce
Ncview comes with ABSOLUTELY NO WARRANTY; for details type `ncview -w'.
This is free software licensed under the Gnu General Public License version 3; type `ncview -c' for redistribution details.
```
测试结果

ncview可正常执行