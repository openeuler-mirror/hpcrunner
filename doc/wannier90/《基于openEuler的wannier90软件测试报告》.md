# 《基于openEuler的QMCPACK软件测试报告》

## 1.规范性自检

项目使用了fprettify对文件进行格式化

fprettify 是现代化的 Fortran 代码的自动格式化程序，它采用 Python 编写，对Fortran代码进行严格的空格格式化

格式化范例如下，设置中限制了一行最大字符数，所以并非所有行进行了代码添加。

```
program demo
integer :: endif,if,elseif
integer,DIMENSION(2) :: function
endif=3;if=2
if(endif==2)then
endif=5
elseif=if+4*(endif+&
2**10)
elseif(endif==3)then
function(if)=endif/elseif
print*,endif
endif
end program
------------------fprettify----------------------------
program demo
   integer :: endif, if, elseif
   integer, DIMENSION(2) :: function
   endif = 3; if = 2
   if (endif == 2) then
      endif = 5
      elseif = if + 4*(endif + &
                       2**10)
   elseif (endif == 3) then
      function(if) = endif/elseif
      print *, endif
   endif
end program
```

对于当前项目，检查代码规范性，可以通过使用fprettify对所有源码进行重新格式化，然后使用git查看文件修改。

统计代码不规范内容。

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

在qmcpack项目根目录下运行,运行结果如下

```bash
python run.py
/root/hpcrunner/downloads/wannier90-3.1.0
当前文件夹下共有[]的文件74个
当前文件夹下共有[.sh]的文件8个
当前文件夹下共有[.f90]的文件19个
当前文件夹下共有[.in]的文件2个
当前文件夹下共有[.pl]的文件1个
当前文件夹下共有[.travisci]的文件1个
当前文件夹下共有[.kpt]的文件9个
当前文件夹下共有[.gnu]的文件6个
当前文件夹下共有[.g95]的文件1个
当前文件夹下共有[.wpout-NOA]的文件2个
当前文件夹下共有[.gfort]的文件2个
当前文件夹下共有[.md]的文件6个
当前文件夹下共有[.inc_more]的文件1个
当前文件夹下共有[.py]的文件57个
当前文件夹下共有[.mod]的文件33个
当前文件夹下共有[.chk]的文件58个
当前文件夹下共有[.wpout]的文件29个
当前文件夹下共有[.macports]的文件1个
当前文件夹下共有[.proj]的文件1个
当前文件夹下共有[.sym]的文件2个
当前文件夹下共有[.win]的文件1108个
当前文件夹下共有[.mmn]的文件64个
当前文件夹下共有[.fig]的文件1个
当前文件夹下共有[.UPF]的文件27个
当前文件夹下共有[.yaml]的文件1个
当前文件夹下共有[.yml]的文件2个
当前文件夹下共有[.ifort_tcm]的文件1个
当前文件夹下共有[.gfort+openmpi]的文件1个
当前文件夹下共有[.amn]的文件69个
当前文件夹下共有[.rst]的文件2个
当前文件夹下共有[.dat]的文件87个
当前文件夹下共有[.inc]的文件24个
当前文件夹下共有[.x]的文件3个
当前文件夹下共有[.log]的文件31个
当前文件夹下共有[.pathscale]的文件1个
当前文件夹下共有[.pw2wan]的文件43个
当前文件夹下共有[.1]的文件24个
当前文件夹下共有[.scf]的文件39个
当前文件夹下共有[.spn]的文件6个
当前文件夹下共有[.out]的文件4个
当前文件夹下共有[.ifort]的文件1个
当前文件夹下共有[.eps]的文件16个
当前文件夹下共有[.vdw]的文件4个
当前文件夹下共有[.nag]的文件1个
当前文件夹下共有[.upf]的文件1个
当前文件夹下共有[.wout]的文件12个
当前文件夹下共有[.inp]的文件5个
当前文件夹下共有[.xlf]的文件1个
当前文件夹下共有[.eig]的文件67个
当前文件夹下共有[.wpout-gyrotropic]的文件2个
当前文件夹下共有[.F90]的文件31个
当前文件夹下共有[.bib]的文件2个
当前文件夹下共有[.qe]的文件1个
当前文件夹下共有[.nscf]的文件41个
当前文件夹下共有[.pgf90]的文件1个
当前文件夹下共有[.2]的文件1个
当前文件夹下共有[.homebrew]的文件1个
当前文件夹下共有[.dmn]的文件2个
当前文件夹下共有[.tex]的文件54个
当前文件夹下共有[.pyc]的文件33个
当前文件夹下共有[.png]的文件129个
当前文件夹下共有[.m]的文件1个
当前文件夹下共有[.header]的文件1个
当前文件夹下共有[.o]的文件32个
当前文件夹下共有[.sun]的文件1个
当前文件夹下共有[.c]的文件1个
当前文件夹下共有[.alpha]的文件1个
当前文件夹下共有[.xyz]的文件2个
当前文件夹下共有[.uHu]的文件16个
当前文件夹下共有[.bz2]的文件98个
当前文件夹下共有[.dynlib]的文件1个
当前文件夹下共有[.gz]的文件2个
当前文件夹下共有[.txt]的文件10个
当前文件夹下共有[.pov]的文件1个
当前文件夹下共有[.install]的文件1个
当前文件夹下共有[.pdf]的文件83个
当前文件夹下共有[.args=-pp]的文件68个

```

查看上述结果可知主要源码文件后缀名为 `F90`,`f90`,`py`,`sh`,`gfort`。

### 1.2.统计源码总行数

统计所有源码文件的代码行数

```bash
 find ./ -regex ".*\.F90\|.*\.f90\|.*\.py"\|.*\.sh"\|.*\.gfort"\
  | xargs wc -l
```

统计结果

```bash
   82082 total
```

### 1.3.统计不符合要求的总行数

对文件后缀名为 `f90`,`hpp`,`h`,`py`,`sh`,`c`,`csh`,`cc`,`pl`, 的所有文件进行格式
通过git与clang-format结合的方式进行统计

```bash
[root@ecs-4200 wannier90]#fprettify -r ./
57 files changed, 96082 insertions(+), 96213 deletions(-)
 rewrite pwscf/v3.2.3/pw2wannier90.f90 (78%)
 rewrite pwscf/v4.0/pw2wannier90.f90 (73%)
 rewrite pwscf/v4.1/pw2wannier90.f90 (73%)
 rewrite pwscf/v5.0/pw2wannier90.f90 (79%)
 rewrite pwscf/v6.0/pw2wannier90.f90 (77%)
 rewrite pwscf/v6.2.1/pw2wannier90.f90 (77%)
 rewrite pwscf/v6.3/pw2wannier90.f90 (76%)
 rewrite pwscf/v6.3/pw2wannier90_legacy.f90 (77%)
 rewrite pwscf/v6.4/pw2wannier90.f90 (76%)
 rewrite pwscf/v6.5/pw2wannier90.f90 (76%)
 rewrite src/comms.F90 (85%)
 rewrite src/constants.F90 (60%)
 rewrite src/disentangle.F90 (88%)
 rewrite src/error.F90 (77%)
 rewrite src/hamiltonian.F90 (88%)
 rewrite src/io.F90 (80%)
 rewrite src/kmesh.F90 (90%)
 rewrite src/overlap.F90 (75%)
 rewrite src/plot.F90 (91%)
 rewrite src/postw90/berry.F90 (92%)
 rewrite src/postw90/boltzwann.F90 (87%)
 rewrite src/postw90/dos.F90 (65%)
 rewrite src/postw90/geninterp.F90 (86%)
 rewrite src/postw90/get_oper.F90 (92%)
 rewrite src/postw90/gyrotropic.F90 (94%)
 rewrite src/postw90/kpath.F90 (93%)
 rewrite src/postw90/kslice.F90 (89%)
 rewrite src/postw90/postw90.F90 (89%)
 rewrite src/postw90/postw90_common.F90 (85%)
 rewrite src/postw90/postw90_readwrite.F90 (93%)
 rewrite src/postw90/postw90_types.F90 (61%)
 rewrite src/postw90/spin.F90 (88%)
 rewrite src/postw90/wan_ham.F90 (91%)
 rewrite src/readwrite.F90 (88%)
 rewrite src/sitesym.F90 (92%)
 rewrite src/transport.F90 (90%)
 rewrite src/utility.F90 (84%)
 rewrite src/w90chk2chk.F90 (91%)
 rewrite src/w90spn2spn.F90 (85%)
 rewrite src/wannier90_readwrite.F90 (93%)
 rewrite src/wannier90_types.F90 (61%)
 rewrite src/wannier_lib.F90 (82%)
 rewrite src/wannier_prog.F90 (83%)
 rewrite src/wannierise.F90 (86%)
 rewrite src/ws_distance.F90 (81%)
 rewrite test-suite/library-mode-test/test_library.F90 (88%)
 rewrite utility/PL_assessment/PL_assess.f90 (81%)
 rewrite utility/w90pov/src/driver.f90 (95%)
 rewrite utility/w90pov/src/io.f90 (85%)
 rewrite utility/w90vdw/w90vdw.f90 (86%)
```

### 1.4.统计结果

综上信息，项目中代码规范性自检检查结果为

通过率    : 0.2%           1-96213/96400*100%

不通过率  : 99.8%            96213/96400*100%

## 2.功能性测试

### 2.1.所选测试案例

qmcpack内置了大量的单元测试，可以使用其进行单元测试文件内容。

单元测试文件列表（部分）如下

```bash
[root@host- build]# tree tests
test-suite/
├── checkpoints
│   ├── cu_postw90
│   │   └── copper.chk.fmt.bz2
│   ├── example02
│   │   ├── lead.amn
│   │   ├── lead.chk.fmt.bz2
│   │   ├── lead.eig
│   │   ├── lead.mmn
│   │   ├── lead.win
│   │   └── Makefile
│   ├── fe_postw90
│   │   ├── Fe.amn
│   │   ├── Fe.chk.fmt.bz2
│   │   ├── Fe.eig
│   │   ├── Fe.mmn.bz2
│   │   ├── Fe.uHu.bz2
│   │   ├── Fe.win
│   │   └── Makefile
│   ├── gaas_postw90
│   │   ├── gaas.amn
│   │   ├── gaas.chk.fmt.bz2
│   │   ├── gaas.eig
│   │   ├── gaas.mmn
│   │   ├── gaas.mmn.bz2
│   │   ├── gaas.win
│   │   └── Makefile
│   ├── gaas_shc_postw90
│   │   ├── GaAs.amn.bz2
│   │   ├── GaAs.chk.fmt.bz2
│   │   ├── GaAs.eig
│   │   ├── GaAs.mmn.bz2
│   │   ├── GaAs.win
│   │   └── Makefile
│   ├── pt_shc_postw90
│   │   ├── Makefile
│   │   ├── Pt.amn.bz2
│   │   ├── Pt.chk.fmt.bz2
│   │   ├── Pt.eig
│   │   ├── Pt.mmn.bz2
│   │   ├── Pt.spn.bz2
│   │   └── Pt.win
│   ├── README.txt
│   ├── si_geninterp
│   │   ├── Makefile
│   │   ├── silicon.amn
│   │   ├── silicon.chk.fmt.bz2
│   │   ├── silicon.eig
│   │   ├── silicon.mmn.bz2
│   │   └── silicon.win
│   ├── si_geninterp_wsdistance
│   │   ├── Makefile
│   │   ├── silicon.amn
│   │   ├── silicon.chk.fmt.bz2
│   │   ├── silicon.eig
│   │   └── silicon.win
│   └── te_postw90
│       ├── Te.chk.fmt.bz2
│       └── Te.uHu.bz2
├── clean_tests
├── config
│   ├── README.md
│   └── TestFarm
│       ├── farm2_gcc520.inc
│       ├── farm2_intel13.inc
│       ├── farm2_intel15.inc
│       ├── farm2_nag6.inc
│       ├── farm2_pgi15.inc
│       ├── farmer3_gcc493.inc
│       ├── farmer3_intel15.inc
│       ├── farmer4_gcc485_openblas.inc
│       ├── farmer_gcc485.inc
│       ├── farmer_gcc485_serial.inc
│       ├── farmer_gcc640_serial.inc
│       ├── farmer_gcc730_openmpi1107.inc
│       ├── farmer_intel12.inc
│       ├── farmer_intel13.inc
│       ├── farmer_intel15.inc
│       ├── farmer_intel17_impi.inc
│       ├── farmer_intel17_openmpi313.inc
│       ├── farmer_intel18_openmpi313.inc
│       └── farmer_pgi18_mvapich23b.inc
├── library-mode-test
│   ├── CELL
│   ├── compare_results.py
│   ├── EIG
│   ├── gaas.amn
│   ├── gaas.eig
│   ├── gaas.mmn
│   ├── gaas.win
│   ├── KPOINTS
│   ├── Makefile
│   ├── PARAMS
│   ├── POSITIONS
│   ├── README
│   ├── ref
│   │   ├── gaas.amn -> ../gaas.amn
│   │   ├── gaas.eig -> ../gaas.eig
│   │   ├── gaas.mmn -> ../gaas.mmn
│   │   ├── gaas_ref.wout
│   │   ├── gaas.win -> ../gaas.win
│   │   ├── README.txt
│   │   └── results_ref.dat
│   ├── run.sh
│   └── test_library.F90
├── README.md
├── run_tests
├── testcode
│   ├── bin
│   │   └── testcode.py
│   ├── lib
│   │   └── testcode2
│   │       ├── ansi.py
│   │       ├── compatibility.py
│   │       ├── config.py
│   │       ├── dir_lock.py
│   │       ├── exceptions.py
│   │       ├── _functools_dummy.py
│   │       ├── __init__.py
│   │       ├── queues.py
│   │       ├── util.py
│   │       ├── validation.py
│   │       └── vcs.py
│   ├── LICENSE
│   └── README.rst
├── testcode-README.txt
├── tests
│   ├── jobconfig
│   ├── partestw90_mpierr
│   │   ├── benchmark.out.default.inp=wannier.win
│   │   ├── wannier.amn
│   │   ├── wannier.mmn
│   │   └── wannier.win
│   ├── testpostw90_boltzwann
│   │   ├── benchmark.out.default.inp=silicon.win
│   │   ├── Makefile
│   │   ├── silicon.amn
│   │   ├── silicon.chk.fmt.bz2 -> ../../checkpoints/si_geninterp_wsdistance/silicon.chk.fmt.bz2
│   │   ├── silicon.eig
│   │   ├── silicon.mmn.bz2 -> ../../checkpoints/si_geninterp/silicon.mmn.bz2
│   │   └── silicon.win
│   ├── testpostw90_example04_dos
│   │   ├── benchmark.out.default.inp=copper.win
│   │   ├── copper.chk.fmt.bz2 -> ../../checkpoints/cu_postw90/copper.chk.fmt.bz2
│   │   ├── copper.eig
│   │   ├── copper.win
│   │   └── Makefile
│   ├── testpostw90_example04_pdos
│   │   ├── benchmark.out.default.inp=copper.win
│   │   ├── copper.chk.fmt.bz2 -> ../../checkpoints/cu_postw90/copper.chk.fmt.bz2
│   │   ├── copper.eig
│   │   ├── copper.win
│   │   └── Makefile
│   ├── testpostw90_fe_ahc
│   │   ├── benchmark.out.default.inp=Fe.win
│   │   ├── Fe.amn
│   │   ├── Fe.chk.fmt.bz2 -> ../../checkpoints/fe_postw90/Fe.chk.fmt.bz2
│   │   ├── Fe.eig
│   │   ├── Fe.mmn.bz2 -> ../../checkpoints/fe_postw90/Fe.mmn.bz2
│   │   ├── Fe.win
│   │   └── Makefile
│   ├── testpostw90_fe_ahc_adaptandfermi
│   │   ├── benchmark.out.default.inp=Fe.win
│   │   ├── Fe.amn -> ../testpostw90_fe_ahc/Fe.amn
│   │   ├── Fe.chk.fmt.bz2 -> ../testpostw90_fe_ahc/Fe.chk.fmt.bz2
│   │   ├── Fe.eig -> ../testpostw90_fe_ahc/Fe.eig
│   │   ├── Fe.mmn.bz2 -> ../testpostw90_fe_ahc/Fe.mmn.bz2
│   │   ├── Fe.win
│   │   └── Makefile
│   ├── testpostw90_fe_dos_spin
│   │   ├── benchmark.out.default.inp=Fe.win
│   │   ├── Fe.amn -> ../../checkpoints/fe_postw90/Fe.amn
│   │   ├── Fe.chk.fmt.bz2 -> ../../checkpoints/fe_postw90/Fe.chk.fmt.bz2
│   │   ├── Fe.eig -> ../../checkpoints/fe_postw90/Fe.eig
│   │   ├── Fe.mmn.bz2 -> ../../checkpoints/fe_postw90/Fe.mmn.bz2
│   │   ├── Fe.spn
│   │   ├── Fe.win
│   │   └── Makefile
│   ├── testpostw90_fe_kpathcurv
│   │   ├── benchmark.out.default.inp=Fe.win
│   │   ├── Fe.amn
│   │   ├── Fe.chk.fmt.bz2 -> ../../checkpoints/fe_postw90/Fe.chk.fmt.bz2
│   │   ├── Fe.eig
│   │   ├── Fe.mmn.bz2 -> ../../checkpoints/fe_postw90/Fe.mmn.bz2
│   │   ├── Fe.uHu.bz2 -> ../../checkpoints/fe_postw90/Fe.uHu.bz2
│   │   ├── Fe.win
│   │   └── Makefile
│   ├── testpostw90_fe_kpathmorbcurv
│   │   ├── benchmark.out.default.inp=Fe.win
│   │   ├── Fe.amn
│   │   ├── Fe.chk.fmt.bz2 -> ../../checkpoints/fe_postw90/Fe.chk.fmt.bz2
│   │   ├── Fe.eig
│   │   ├── Fe.mmn.bz2 -> ../../checkpoints/fe_postw90/Fe.mmn.bz2
│   │   ├── Fe.uHu.bz2 -> ../../checkpoints/fe_postw90/Fe.uHu.bz2
│   │   ├── Fe.win
│   │   └── Makefile
│   ├── testpostw90_fe_kpathmorbcurv_ws
│   │   ├── benchmark.out.default.inp=Fe.win
│   │   ├── Fe.amn -> ../../checkpoints/fe_postw90/Fe.amn
│   │   ├── Fe.chk.fmt.bz2 -> ../../checkpoints/fe_postw90/Fe.chk.fmt.bz2
│   │   ├── Fe.eig -> ../../checkpoints/fe_postw90/Fe.eig
│   │   ├── Fe.mmn.bz2 -> ../../checkpoints/fe_postw90/Fe.mmn.bz2
│   │   ├── Fe.uHu.bz2 -> ../../checkpoints/fe_postw90/Fe.uHu.bz2
│   │   ├── Fe.win
│   │   └── Makefile
│   ├── testpostw90_fe_kslicecurv
│   │   ├── benchmark.out.default.inp=Fe.win
│   │   ├── Fe.amn
│   │   ├── Fe.chk.fmt.bz2 -> ../../checkpoints/fe_postw90/Fe.chk.fmt.bz2
│   │   ├── Fe.eig
│   │   ├── Fe.mmn.bz2 -> ../../checkpoints/fe_postw90/Fe.mmn.bz2
│   │   ├── Fe.uHu.bz2 -> ../../checkpoints/fe_postw90/Fe.uHu.bz2
│   │   ├── Fe.win
│   │   └── Makefile
...
```

在项目根目录下执行命令来运行单元测试和确定性测试

```bash
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
make tests
```

### 2.2.运行结果

```bash
(cd ./src/obj && make -f ../Makefile.2 w90chk2chk)
make[1]: Entering directory '/root/hpcrunner/software/libs/wannier90/src/obj'
make[1]: Nothing to be done for 'w90chk2chk'.
make[1]: Leaving directory '/root/hpcrunner/software/libs/wannier90/src/obj'
(cd ./src/obj && make -f ../Makefile.2 wannier)
make[1]: Entering directory '/root/hpcrunner/software/libs/wannier90/src/obj'
make[1]: Nothing to be done for 'wannier'.
make[1]: Leaving directory '/root/hpcrunner/software/libs/wannier90/src/obj'
(cd ./src/obj && make -f ../Makefile.2 post)
make[1]: Entering directory '/root/hpcrunner/software/libs/wannier90/src/obj'
make[1]: Nothing to be done for 'post'.
make[1]: Leaving directory '/root/hpcrunner/software/libs/wannier90/src/obj'
(cd ./test-suite && ./run_tests --category=default )
Using executable: /root/hpcrunner/software/libs/wannier90/test-suite/tests/../../wannier90.x.
Using executable: /root/hpcrunner/software/libs/wannier90/test-suite/tests/../../postw90.x.
Test id: 25092022-2.
Benchmark: default.

tests/testpostw90_boltzwann - silicon.win: Passed.

tests/testpostw90_example04_dos - copper.win: Passed.

tests/testpostw90_example04_pdos - copper.win: Passed.

tests/testpostw90_fe_ahc - Fe.win: Passed.

tests/testpostw90_fe_ahc_adaptandfermi - Fe.win: Passed.

tests/testpostw90_fe_dos_spin - Fe.win: Passed.

tests/testpostw90_fe_kpathcurv - Fe.win: Passed.

tests/testpostw90_fe_kpathmorbcurv - Fe.win: Passed.

tests/testpostw90_fe_kpathmorbcurv_ws - Fe.win: Passed.

tests/testpostw90_fe_kslicecurv - Fe.win: Passed.

tests/testpostw90_fe_kslicemorb - Fe.win: Passed.

tests/testpostw90_fe_kubo_Axy - Fe.win: Passed.

tests/testpostw90_fe_kubo_Szz - Fe.win: Passed.

tests/testpostw90_fe_kubo_jdos - Fe.win: Passed.

tests/testpostw90_fe_morb - Fe.win: Passed.

tests/testpostw90_fe_morbandahc - Fe.win: Passed.

tests/testpostw90_fe_spin - Fe.win: Passed.

tests/testpostw90_gaas_kdotp - gaas.win: Passed.

tests/testpostw90_gaas_sc_eta_corr - gaas.win: Passed.

tests/testpostw90_gaas_sc_xyz - gaas.win: Passed.

tests/testpostw90_gaas_sc_xyz_scphase2 - gaas.win: Passed.

tests/testpostw90_gaas_sc_xyz_scphase2_ws - gaas.win: Passed.

tests/testpostw90_gaas_sc_xyz_ws - gaas.win: Passed.

tests/testpostw90_gaas_shc - GaAs.win: Passed.

tests/testpostw90_pt_kpathbandsshc - Pt.win: Passed.

tests/testpostw90_pt_kpathshc - Pt.win: Passed.

tests/testpostw90_pt_ksliceshc - Pt.win: Passed.

tests/testpostw90_pt_shc - Pt.win: Passed.

tests/testpostw90_pt_shc_ryoo - Pt.win: Passed.

tests/testpostw90_si_geninterp - silicon.win: Passed.

tests/testpostw90_si_geninterp_wsdistance - silicon.win: Passed.

tests/testpostw90_te_gyrotropic - Te.win: Passed.

tests/testpostw90_te_gyrotropic_C - Te.win: Passed.

tests/testpostw90_te_gyrotropic_D0 - Te.win: Passed.

tests/testpostw90_te_gyrotropic_Dw - Te.win: Passed.

tests/testpostw90_te_gyrotropic_K - Te.win: Passed.

tests/testpostw90_te_gyrotropic_NOA - Te.win: Passed.

tests/testpostw90_te_gyrotropic_dos - Te.win: Passed.

tests/testw90_basic1 - wannier.win: Passed.

tests/testw90_basic2 - wannier.win: Passed.

tests/testw90_benzene_gamma_val - benzene.win: Passed.

tests/testw90_benzene_gamma_val_hexcell - benzene.win: Passed.

tests/testw90_benzene_gamma_valcond - benzene.win: Passed.

tests/testw90_bvec - lead.win: Passed.

tests/testw90_cube_format - gaas.win: Passed.

tests/testw90_disentanglement_sawfs - H3S.win: Passed.

tests/testw90_example01 - gaas.win: Passed.

tests/testw90_example02 - lead.win: Passed.

tests/testw90_example02_restart - lead.win: Passed.

tests/testw90_example03 - silicon.win: Passed.

tests/testw90_example03_labelinfo - silicon.win: Passed.

tests/testw90_example03_optmem - silicon.win: Passed.

tests/testw90_example04 - copper.win: Passed.

tests/testw90_example05 - diamond.win: Passed.

tests/testw90_example07 - silane.win: Passed.

tests/testw90_example11_1 - silicon.win: Passed.

tests/testw90_example11_2 - silicon.win: Passed.

tests/testw90_example21_As_sp - GaAs.win: Passed.

tests/testw90_example26 - gaas.win: Passed.

tests/testw90_gaas_disentanglement_issue192 - gaas.win: Passed.

tests/testw90_lavo3_dissphere - LaVO3.win: Passed.

tests/testw90_na_chain_gamma - Na_chain.win: Passed.

tests/testw90_nnkpt1 - wannier.win (arg(s): -pp): Passed.

tests/testw90_nnkpt2 - wannier.win (arg(s): -pp): Passed.

tests/testw90_nnkpt3 - wannier.win (arg(s): -pp): Passed.

tests/testw90_nnkpt4 - wannier.win (arg(s): -pp): Passed.

tests/testw90_nnkpt5 - wannier.win: Passed.

tests/testw90_precond_1 - gaas1.win: Passed.

tests/testw90_precond_2 - gaas2.win: Passed.

tests/testw90_write_u_matrices - gaas.win: Passed.

All done. 70 out of 70 tests passed.
(cd ./test-suite && ./run_tests --category=par --numprocs=4 )
Using executable: /root/hpcrunner/software/libs/wannier90/test-suite/tests/../../wannier90.x.
Using executable: /root/hpcrunner/software/libs/wannier90/test-suite/tests/../../postw90.x.
Test id: 25092022-3.
Benchmark: default.

tests/partestw90_mpierr - wannier.win: Passed.

tests/testpostw90_boltzwann - silicon.win: Passed.

tests/testpostw90_example04_dos - copper.win: Passed.

tests/testpostw90_example04_pdos - copper.win: Passed.

tests/testpostw90_fe_ahc - Fe.win: Passed.

tests/testpostw90_fe_ahc_adaptandfermi - Fe.win: Passed.

tests/testpostw90_fe_dos_spin - Fe.win: Passed.

tests/testpostw90_fe_kpathcurv - Fe.win: Passed.

tests/testpostw90_fe_kpathmorbcurv - Fe.win: Passed.

tests/testpostw90_fe_kpathmorbcurv_ws - Fe.win: Passed.

tests/testpostw90_fe_kslicecurv - Fe.win: Passed.

tests/testpostw90_fe_kslicemorb - Fe.win: Passed.

tests/testpostw90_fe_kubo_Axy - Fe.win: Passed.

tests/testpostw90_fe_kubo_Szz - Fe.win: Passed.

tests/testpostw90_fe_kubo_jdos - Fe.win: Passed.

tests/testpostw90_fe_morb - Fe.win: Passed.

tests/testpostw90_fe_morbandahc - Fe.win: Passed.

tests/testpostw90_fe_spin - Fe.win: Passed.

tests/testpostw90_gaas_kdotp - gaas.win: Passed.

tests/testpostw90_gaas_sc_eta_corr - gaas.win: Passed.

tests/testpostw90_gaas_sc_xyz - gaas.win: Passed.

tests/testpostw90_gaas_sc_xyz_scphase2 - gaas.win: Passed.

tests/testpostw90_gaas_sc_xyz_scphase2_ws - gaas.win: Passed.

tests/testpostw90_gaas_sc_xyz_ws - gaas.win: Passed.

tests/testpostw90_gaas_shc - GaAs.win: Passed.

tests/testpostw90_pt_kpathbandsshc - Pt.win: Passed.

tests/testpostw90_pt_kpathshc - Pt.win: Passed.

tests/testpostw90_pt_ksliceshc - Pt.win: Passed.

tests/testpostw90_pt_shc - Pt.win: Passed.

tests/testpostw90_pt_shc_ryoo - Pt.win: Passed.

tests/testpostw90_si_geninterp - silicon.win: Passed.

tests/testpostw90_si_geninterp_wsdistance - silicon.win: Passed.

tests/testpostw90_te_gyrotropic - Te.win: Passed.

tests/testpostw90_te_gyrotropic_C - Te.win: Passed.

tests/testpostw90_te_gyrotropic_D0 - Te.win: Passed.

tests/testpostw90_te_gyrotropic_Dw - Te.win: Passed.

tests/testpostw90_te_gyrotropic_K - Te.win: Passed.

tests/testpostw90_te_gyrotropic_NOA - Te.win: Passed.

tests/testpostw90_te_gyrotropic_dos - Te.win: Passed.

tests/testw90_basic1 - wannier.win: Passed.

tests/testw90_basic2 - wannier.win: Passed.

tests/testw90_benzene_gamma_val - benzene.win: Passed.

tests/testw90_benzene_gamma_val_hexcell - benzene.win: Passed.

tests/testw90_benzene_gamma_valcond - benzene.win: Passed.

tests/testw90_bvec - lead.win: Passed.

tests/testw90_cube_format - gaas.win: Passed.

tests/testw90_disentanglement_sawfs - H3S.win: Passed.

tests/testw90_example01 - gaas.win: Passed.

tests/testw90_example02 - lead.win: Passed.

tests/testw90_example02_restart - lead.win: Passed.

tests/testw90_example03 - silicon.win: Passed.

tests/testw90_example03_labelinfo - silicon.win: Passed.

tests/testw90_example03_optmem - silicon.win: Passed.

tests/testw90_example04 - copper.win: Passed.

tests/testw90_example05 - diamond.win: Passed.

tests/testw90_example07 - silane.win: Passed.

tests/testw90_example11_1 - silicon.win: Passed.

tests/testw90_example11_2 - silicon.win: Passed.

tests/testw90_example21_As_sp - GaAs.win: Passed.

tests/testw90_example26 - gaas.win: Passed.

tests/testw90_gaas_disentanglement_issue192 - gaas.win: Passed.

tests/testw90_lavo3_dissphere - LaVO3.win: Passed.

tests/testw90_na_chain_gamma - Na_chain.win: Passed.

tests/testw90_nnkpt1 - wannier.win (arg(s): -pp): Passed.

tests/testw90_nnkpt2 - wannier.win (arg(s): -pp): Passed.

tests/testw90_nnkpt3 - wannier.win (arg(s): -pp): Passed.

tests/testw90_nnkpt4 - wannier.win (arg(s): -pp): Passed.

tests/testw90_nnkpt5 - wannier.win: Passed.

tests/testw90_precond_1 - gaas1.win: Passed.

tests/testw90_precond_2 - gaas2.win: Passed.

tests/testw90_write_u_matrices - gaas.win: Passed.

All done. 71 out of 71 tests passed.
```

测试结果

单元测试运行正常，说明各类型函数和功能都响应正常。测试通过。

## 3.性能测试

### 3.1.测试平台信息对比

todo x86

|          | arm信息                           | x86信息                          |
| -------- | --------------------------------- | -------------------------------- |
| 操作系统 | openEuler 20.03 (LTS)             | openEuler 20.03 (LTS)            |
| 内核版本 | 4.19.90-2003.4.0.0036.oe1.aarch64 | 4.19.90-2112.8.0.0131.oe1.x86_64 |

### 3.2.测试软件环境信息对比

|          | arm信息       | x86信息   |
| -------- | ------------- | --------- |
| gcc      | kgcc 10.3.1 | gcc 10.3.0 |
| mpi      | hmpi1.2.0     | openmpi4.1.2 |
| BLAS | 3.10.0        | 3.10.0    |
| lapack  | 3.10.1        | 3.10.1    |

### 3.3.测试硬件性能信息对比

|        | arm信息     | x86信息  |
| ------ | ----------- | -------- |
| cpu    | Kunpeng 920 | Intel(R) Xeon(R) Gold 6278C CPU @ 2.60GHz       |
| 核心数 | 8          | 4        |
| 内存   | 16 GB       | 16 GB     |
| 磁盘io | 1.3 GB/s    | 132.57 MB/s|
| 虚拟化 | KVM         | KVM      |

### 3.4.测试选择的案例

examples/molecules/H2O 目录下的文件 simple-H2O.xml

对水分子进行一个简短的扩散蒙特卡罗计算

测试文件（部分）如下

```xml
! Gallium Arsenide: Tutorial Example 1

 num_wann    =  4
 num_iter    = 20


! SYSTEM

begin unit_cell_cart
bohr
-5.367  0.000  5.367
 0.000  5.367  5.367
-5.367  5.367  0.000
end unit_cell_cart

begin atoms_frac
Ga 0.00   0.00   0.00
As 0.25  0.25  0.25
end atoms_frac

begin projections
As:sp3
end projections

! KPOINTS

mp_grid : 2 2 2

begin kpoints
0.0 0.0 0.0
0.0 0.0 0.5
0.0 0.5 0.0
0.0 0.5 0.5
0.5 0.0 0.0
0.5 0.0 0.5
0.5 0.5 0.0
0.5 0.5 0.5
end kpoints

!We set this flag to read the bloch states from
!a formatted file. This is to ensure the example
!works on all platforms. The default (.false.) state
!should be used on production runs
wvfn_formatted=.true.

```

### 3.6.单线程

单线程运行测试时间对比（五次运行取平均值）

|             | arm        | x86      |
| ----------- | ---------- | -------- |
| 实际CPU时间 | 4.142s | 2.707s |
| 用户时间    | 4.065s  | 2.628s |

### 3.7.多线程

多线程运行测试时间对比（五次运行取平均值）

|             | arm        | x86       |
| ----------- | ---------- | --------- |
| 线程数      | 4          | 4         |
| 实际CPU时间 | 0.154s | 0.118s |
| 用户时间    | 0.0289s   | 0.202s   |

arm多线程时间耗费数据表：

| 线程          | 1        | 2       | 3       | 4        | 5       | 6        | 7       | 8       |
| :------------ | -------- | ------- | ------- | -------- | ------- | -------- | ------- | ------- |
| 用户时间(s)   | 4.142| 2.205 | 1.599 | 1.255 | 1.067  | 0.935  | 0.876  | 0.811 |
| 用户态时间(s) | 4.065  | 4.241 | 4.529 | 4.674 | 4.889 | 5.102 | 5.491 | 5.680 |
| 内核态时间(s) | 0.028   | 0.044   | 0.068   | 0.071   | 0.069   | 0.116    | 0.144  | 0.557   |

x86多线程时间耗费数据表：

| 线程            | 1      | 2      | 3       | 4       |
| --------------- | ------ | ------ | ------- | ------- |
| 用户时间 （s）  | 2.707 | 1.492 | 1.107  | 0.892  |
| 用户态时间（s） | 2.628 | 2.801 | 3.041 | 3.158 |
| 内核态时间（s） | 0.031  | 0.055  | 0.079   | 0.130   |

由上表可知，在线程逐渐增加的情况下，所减少的用户时间并非线性关系，线程数增加后，运算用时并未显著下降，且系统调用的时间有较为明显的上升趋势。

### 3.8.测试总结

arm平台内核态时间，在相同线程数下比x86平台耗费更少。随着线程数的增加，两个平台的对于同一个应用的所耗费的时间差距逐渐减少。

且线程增加并不会无限制减少应用的实际耗费时间，在合理的范围内分配线程数才能更好的利用算力资源。

## 4.精度测试

### 4.1.所选测试案例

test-suite/tests/testpostw90_boltzwann 目录下的文件 silicon.win


测试文件（部分）如下

```
num_bands         =   12       
num_wann          =   8
use_ws_distance = true
search_shells=12

boltzwann                    = true
boltz_calc_also_dos          = true
boltz_dos_energy_step        = 0.1
smr_type                     = gauss
boltz_dos_adpt_smr           = false
boltz_dos_smr_fixed_en_width = 0.03
kmesh                        = 20
boltz_mu_min                 = 5.
boltz_mu_max                 = 5.
boltz_mu_step                = 0.01
boltz_temp_min               = 300.
boltz_temp_max               = 300.
boltz_temp_step              = 50
boltz_relax_time             = 10.

dis_win_max       = 17.0d0
dis_froz_max      =  6.4d0
dis_num_iter      =  120
dis_mix_ratio     = 1.d0
dis_conv_tol      = 1.0e-13

num_iter          = 300 
num_print_cycles  = 10

Begin Atoms_Frac
Si  -0.25   0.75  -0.25
Si   0.00   0.00   0.00 
End Atoms_Frac
    
Begin Projections     
Si : sp3 
End Projections       
    
begin kpoint_path
L 0.50000  0.50000 0.5000 G 0.00000  0.00000 0.0000
G 0.00000  0.00000 0.0000 X 0.50000  0.00000 0.5000
X 0.50000 -0.50000 0.0000 K 0.37500 -0.37500 0.0000 
K 0.37500 -0.37500 0.0000 G 0.00000  0.00000 0.0000
end kpoint_path


Begin Unit_Cell_Cart
-2.6988 0.0000 2.6988
 0.0000 2.6988 2.6988
-2.6988 2.6988 0.0000
End Unit_Cell_Cart


mp_grid      = 4 4 4


begin kpoints
0.0000  0.0000   0.0000   
0.0000  0.2500   0.0000   
0.0000  0.5000   0.0000   
0.0000  0.7500   0.0000   
0.2500  0.0000   0.0000   
0.2500  0.2500   0.0000   
0.2500  0.5000   0.0000   
0.2500  0.7500   0.0000   
0.5000  0.0000   0.0000   
0.5000  0.2500   0.0000   
0.5000  0.5000   0.0000   
0.5000  0.7500   0.0000   
0.7500  0.0000   0.0000   
0.7500  0.2500   0.0000   
0.7500  0.5000   0.0000   
0.7500  0.7500   0.0000   
0.0000  0.0000   0.2500   
0.0000  0.2500   0.2500   
0.0000  0.5000   0.2500   
0.0000  0.7500   0.2500   
0.2500  0.0000   0.2500   
0.2500  0.2500   0.2500   
0.2500  0.5000   0.2500   
0.2500  0.7500   0.2500   
0.5000  0.0000   0.2500   
0.5000  0.2500   0.2500   
0.5000  0.5000   0.2500   
0.5000  0.7500   0.2500   
0.7500  0.0000   0.2500   
0.7500  0.2500   0.2500   
0.7500  0.5000   0.2500   
0.7500  0.7500   0.2500   
0.0000  0.0000   0.5000   
0.0000  0.2500   0.5000   
0.0000  0.5000   0.5000   
0.0000  0.7500   0.5000   
0.2500  0.0000   0.5000   
0.2500  0.2500   0.5000   
0.2500  0.5000   0.5000   
0.2500  0.7500   0.5000   
0.5000  0.0000   0.5000   
0.5000  0.2500   0.5000   
0.5000  0.5000   0.5000   
0.5000  0.7500   0.5000   
0.7500  0.0000   0.5000   
0.7500  0.2500   0.5000   
0.7500  0.5000   0.5000   
0.7500  0.7500   0.5000   
0.0000  0.0000   0.7500   
0.0000  0.2500   0.7500   
0.0000  0.5000   0.7500   
0.0000  0.7500   0.7500   
0.2500  0.0000   0.7500   
0.2500  0.2500   0.7500   
0.2500  0.5000   0.7500   
0.2500  0.7500   0.7500   
0.5000  0.0000   0.7500   
0.5000  0.2500   0.7500   
0.5000  0.5000   0.7500   
0.5000  0.7500   0.7500   
0.7500  0.0000   0.7500   
0.7500  0.2500   0.7500   
0.7500  0.5000   0.7500   
0.7500  0.7500   0.7500   
End Kpoints

```

### 4.2.获得对比数据

arm 运行结果(部分)

```bash
# Written by the BoltzWann module of the Wannier90 code.
# [Electrical conductivity in SI units, i.e. in 1/Ohm/m]
# Mu(eV) Temp(K) ElCond_xx ElCond_xy ElCond_yy ElCond_xz ElCond_yz ElCond_zz
   5.000000000       300.0000000       6504318.581      -207173.9444       6669730.424       200281.2121       209188.4582       6478066.903    

```


x86运行结果

```bash
# Written by the BoltzWann module of the Wannier90 code.
# [Electrical conductivity in SI units, i.e. in 1/Ohm/m]
# Mu(eV) Temp(K) ElCond_xx ElCond_xy ElCond_yy ElCond_xz ElCond_yz ElCond_zz
   5.000000000       300.0000000       6504319.606      -207173.9934       6669730.426       200280.1797       209188.5069       6478067.945    
```



使用以上数据进行误差计算

```python

x86 = [5.000000000,300.0000000 , 6504319.606,-207173.9934 ,6669730.426 ,200280.1797, 209188.5069, 6478067.945 ]
arm = [5.000000000 ,300.0000000 ,6504318.581,-207173.9444,6669730.424 ,200281.2121, 209188.4582, 6478066.903]

for i in range(len(arm)):
    print(abs((x86[i]-arm[i]) / x86[i]) * 100, '%')
```

### 4.3.误差运算结果

```bash
0.0 %
0.0 %
1.575875820271318e-05 %
2.3651617268612574e-05 %
2.998622433118328e-08 %
0.000515477867826386 %
2.3280437694984702e-05 %
1.608504278145663e-05 %
```

### 4.4.测试总结

所有运算结果偏差在1%以内，偏差较小。    
