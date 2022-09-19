# 《基于openEuler的QMCPACK软件测试报告》

## 1.规范性自检

项目使用了Clang-Format对文件进行格式化

Clang-Format是一个广泛使用的C++代码格式化器。我们在使用编辑器的缩进（TAB）功能时，由于不同编辑器的差别，有的插入的是制表符，有的是2个空格，有的是4个空格。这样如果别人用另一个编辑器来阅读程序时，可能会由于缩进的不同，导致阅读效果一团糟。为了解决这个问题，使用C++开发了一个插件，它可以自动重新缩进，并手动指定空格的数量，自动格式化源文件。它是可以通过命令行使用，也可以作为插件，在其他IDE中使用。

文件格式化配置参考文件`src/.clang-format`，文件内容如下

```clang-format
---
Language:        Cpp
AccessModifierOffset: -2
AlignAfterOpenBracket: Align
AlignConsecutiveAssignments: true
AlignConsecutiveDeclarations: false
AlignEscapedNewlines: Left
AlignOperands: false
AlignTrailingComments: true
AllowAllParametersOfDeclarationOnNextLine: false
AllowShortBlocksOnASingleLine: true
AllowShortCaseLabelsOnASingleLine: false
AllowShortFunctionsOnASingleLine: All
AllowShortIfStatementsOnASingleLine: false
AllowShortLoopsOnASingleLine: false
AlwaysBreakAfterDefinitionReturnType: None
AlwaysBreakAfterReturnType: None
AlwaysBreakBeforeMultilineStrings: false
AlwaysBreakTemplateDeclarations: true
BinPackArguments: true
BinPackParameters: false
BraceWrapping:
  AfterClass:      true
  AfterControlStatement: true
  AfterEnum:       true
  AfterFunction:   true
  AfterNamespace:  true
  AfterObjCDeclaration: true
  AfterStruct:     true
  AfterUnion:      true
  AfterExternBlock: true
  BeforeCatch:     true
  BeforeElse:      true
  IndentBraces:    false
  SplitEmptyFunction: false
  SplitEmptyRecord: false
  SplitEmptyNamespace: false
BreakBeforeBinaryOperators: None
BreakBeforeBraces: Custom
BreakBeforeInheritanceComma: false
BreakBeforeTernaryOperators: true
BreakConstructorInitializersBeforeComma: false
BreakConstructorInitializers: BeforeColon
BreakAfterJavaFieldAnnotations: false
BreakStringLiterals: true
ColumnLimit:     120
CommentPragmas:  '^ IWYU pragma:'
CompactNamespaces: false
ConstructorInitializerAllOnOneLineOrOnePerLine: true
ConstructorInitializerIndentWidth: 4
ContinuationIndentWidth: 4
Cpp11BracedListStyle: true
DerivePointerAlignment: false
DisableFormat:   false
ExperimentalAutoDetectBinPacking: false
FixNamespaceComments: true
ForEachMacros:
  - foreach
  - Q_FOREACH
  - BOOST_FOREACH
IncludeBlocks:   Preserve
IncludeCategories:
  - Regex:           '^"(llvm|llvm-c|clang|clang-c)/'
    Priority:        2
  - Regex:           '^(<|"(gtest|gmock|isl|json)/)'
    Priority:        3
  - Regex:           '.*'
    Priority:        1
IncludeIsMainRegex: '(Test)?$'
IndentCaseLabels: false
IndentPPDirectives: None
IndentWidth:     2
IndentWrappedFunctionNames: true
JavaScriptQuotes: Leave
JavaScriptWrapImports: true
KeepEmptyLinesAtTheStartOfBlocks: false
MacroBlockBegin: ''
MacroBlockEnd:   ''
MaxEmptyLinesToKeep: 2
NamespaceIndentation: None
ObjCBlockIndentWidth: 2
ObjCSpaceAfterProperty: false
ObjCSpaceBeforeProtocolList: true
PenaltyBreakAssignment: 2
PenaltyBreakBeforeFirstCallParameter: 30000
PenaltyBreakComment: 300
PenaltyBreakFirstLessLess: 120
PenaltyBreakString: 1000
PenaltyExcessCharacter: 1000000
PenaltyReturnTypeOnItsOwnLine: 10000
PointerAlignment: Left
ReflowComments:  false
SortIncludes:    false
SortUsingDeclarations: true
SpaceAfterCStyleCast: false
SpaceAfterTemplateKeyword: false
SpaceBeforeAssignmentOperators: true
SpaceBeforeParens: ControlStatements
SpaceInEmptyParentheses: false
SpacesBeforeTrailingComments: 1
SpacesInAngles:  false
SpacesInContainerLiterals: true
SpaceBeforeCtorInitializerColon: true
SpaceBeforeInheritanceColon: true
SpaceBeforeRangeBasedForLoopColon: true
SpaceInEmptyParentheses: false
SpacesInCStyleCastParentheses: false
SpacesInParentheses: false
SpacesInSquareBrackets: false
Standard:        Cpp11
TabWidth:        8
UseTab:          Never
...
```

对于当前项目，检查代码规范性，可以通过使用Clang-Format对所有源码进行重新格式化，然后使用git查看文件修改。

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
⋊> ~/t/qmcpack-3.13.0 python3 ../count.py
/home/binshuo/tmp/qmcpack-3.13.0
当前文件夹下共有[.xml]的文件1625个
当前文件夹下共有[.dat]的文件972个
当前文件夹下共有[.cpp]的文件848个
当前文件夹下共有[.h]的文件720个
当前文件夹下共有[.hpp]的文件452个
当前文件夹下共有[.py]的文件364个
当前文件夹下共有[.h5]的文件328个
当前文件夹下共有[]的文件277个
当前文件夹下共有[.out]的文件228个
当前文件夹下共有[.in]的文件191个
当前文件夹下共有[.txt]的文件183个
当前文件夹下共有[.output]的文件86个
当前文件夹下共有[.png]的文件78个
当前文件夹下共有[.sh]的文件77个
当前文件夹下共有[.cu]的文件64个
当前文件夹下共有[.rst]的文件63个
当前文件夹下共有[.inp]的文件62个
当前文件夹下共有[.error]的文件46个
当前文件夹下共有[.cobaltlog]的文件46个
当前文件夹下共有[.cuh]的文件34个
当前文件夹下共有[.cmake]的文件28个
当前文件夹下共有[.c]的文件26个
当前文件夹下共有[.csh]的文件25个
当前文件夹下共有[.cc]的文件22个
当前文件夹下共有[.pdf]的文件22个
当前文件夹下共有[.md]的文件21个
当前文件夹下共有[.xyz]的文件21个
当前文件夹下共有[.upf]的文件16个
当前文件夹下共有[.bib]的文件16个
当前文件夹下共有[.ncpp]的文件12个
当前文件夹下共有[.jpg]的文件12个
当前文件夹下共有[.qmc]的文件12个
当前文件夹下共有[.err]的文件11个
当前文件夹下共有[.gamess]的文件10个
当前文件夹下共有[.tex]的文件10个
当前文件夹下共有[.eps]的文件10个
当前文件夹下共有[.qmca]的文件9个
当前文件夹下共有[.xsd]的文件9个
当前文件夹下共有[.xsf]的文件9个
当前文件夹下共有[.dot]的文件9个
当前文件夹下共有[.dox]的文件9个
当前文件夹下共有[.chk]的文件8个
当前文件夹下共有[.icc]的文件7个
当前文件夹下共有[.POSCAR]的文件7个
当前文件夹下共有[.pl]的文件7个
当前文件夹下共有[.yaml]的文件6个
当前文件夹下共有[.plt]的文件6个
当前文件夹下共有[.diff]的文件6个
当前文件夹下共有[.log]的文件5个
当前文件夹下共有[.gms]的文件5个
当前文件夹下共有[.fci]的文件4个
当前文件夹下共有[.gbs]的文件4个
当前文件夹下共有[.bas]的文件4个
当前文件夹下共有[.pbs]的文件3个
当前文件夹下共有[.files]的文件3个
当前文件夹下共有[.css]的文件3个
当前文件夹下共有[.graffle]的文件3个
当前文件夹下共有[.UPF]的文件2个
当前文件夹下共有[.sub]的文件2个
当前文件夹下共有[.hdf5]的文件2个
当前文件夹下共有[.bat]的文件2个
当前文件夹下共有[.supp]的文件2个
当前文件夹下共有[.yml]的文件2个
当前文件夹下共有[.su]的文件2个
当前文件夹下共有[.data]的文件2个
当前文件夹下共有[.html]的文件2个
当前文件夹下共有[.cfg]的文件2个
当前文件夹下共有[.doc]的文件2个
当前文件夹下共有[.sty]的文件2个
当前文件夹下共有[.pptx]的文件2个
当前文件夹下共有[.el]的文件2个
当前文件夹下共有[.settings]的文件1个
当前文件夹下共有[.scf]的文件1个
当前文件夹下共有[.csv]的文件1个
当前文件夹下共有[.dets]的文件1个
当前文件夹下共有[.fci-Natorb]的文件1个
当前文件夹下共有[.dump]的文件1个
当前文件夹下共有[.json]的文件1个
当前文件夹下共有[.sample]的文件1个
当前文件夹下共有[.mol]的文件1个
当前文件夹下共有[.gpw]的文件1个
当前文件夹下共有[.bibtex]的文件1个
当前文件夹下共有[.hpp_]的文件1个
当前文件夹下共有[.iml]的文件1个
当前文件夹下共有[.CHGCAR]的文件1个
当前文件夹下共有[.IBZKPT]的文件1个
当前文件夹下共有[.OSZICAR]的文件1个
当前文件夹下共有[.KPOINTS]的文件1个
当前文件夹下共有[.PCDAT]的文件1个
当前文件夹下共有[.OUTCAR]的文件1个
当前文件夹下共有[.DOSCAR]的文件1个
当前文件夹下共有[.INCAR]的文件1个
当前文件夹下共有[.CONTCAR]的文件1个
当前文件夹下共有[.XDATCAR]的文件1个
当前文件夹下共有[.EIGENVAL]的文件1个
当前文件夹下共有[.cif]的文件1个
当前文件夹下共有[.ug]的文件1个
当前文件夹下共有[.svg]的文件1个
当前文件夹下共有[.tag]的文件1个
```

查看上述结果可知主要源码文件后缀名为 `cpp`,`hpp`,`h`,`py`,`sh`,`c`,`csh`,`cc`,`pl`。

### 1.2.统计源码总行数

统计所有源码文件的代码行数

```bash
 find ./ -regex ".*\.hpp\|.*\.h\|.*\.cpp"\|.*\.py"\|.*\.sh"\|.*\.c"\|.*\.csh"\|.*\.cc"\|.*\.pl" \
  | xargs wc -l
```

统计结果

```bash
   281876 total
```

### 1.3.统计不符合要求的总行数

对文件后缀名为 `cpp`,`hpp`,`h`,`py`,`sh`,`c`,`csh`,`cc`,`pl`, 的所有文件进行格式
通过git与clang-format结合的方式进行统计

```bash
[root@host- src]# find . -regex '.*\.\(cpp\|hpp\)' -exec clang-format -style=./src/.clang-format -i {} \; 
[root@host- src]# git commit -m "fomat update"
[master 5d0cd68] fomat update
 217 files changed, 10171 insertions(+), 9688 deletions(-)
 rewrite src/Platforms/CUDA/CUDATypeMapping.hpp (60%)
 rewrite src/Platforms/OMPTarget/ompBLAS.cpp (64%)
 rewrite src/Platforms/ROCm/hipBLAS.hip.cpp (93%)
 rewrite src/Platforms/ROCm/hipBLAS.hpp (78%)
 rewrite src/Platforms/ROCm/hipblasTypeMapping.hpp (62%)
 rewrite src/einspline/bspline_eval_d_std.cpp (90%)
 rewrite src/einspline/multi_bspline_eval_d_std3.cpp (84%)
 rewrite src/einspline/multi_bspline_eval_s_std3.cpp (85%)
 rewrite src/einspline/multi_bspline_eval_z_std3.cpp (82%)
 rewrite src/formic/utils/lapack_interface.cpp (84%)
```

### 1.4.统计结果

综上信息，项目中代码规范性自检检查结果为

通过率    : 96.57%           1-9688/281876*100%

不通过率  : 3.43%            9688/281876*100%

## 2.功能性测试

### 2.1.所选测试案例

qmcpack内置了大量的单元测试，可以使用其进行单元测试文件内容。

单元测试文件列表（部分）如下

```bash
[root@host- build]# tree tests
tests/
├── CMakeFiles
│   ├── CMakeDirectoryInformation.cmake
│   └── progress.marks
├── cmake_install.cmake
├── converter
│   ├── CMakeFiles
│   │   ├── CMakeDirectoryInformation.cmake
│   │   └── progress.marks
│   ├── cmake_install.cmake
│   ├── converter_test.py
│   ├── CTestTestfile.cmake
│   ├── Makefile
│   ├── pwconverter_test.py
│   ├── test_aldet1
│   │   ├── aldet1.inp
│   │   ├── aldet1.out
│   │   ├── cmd_args.txt
│   │   ├── gold.structure.xml
│   │   └── gold.wfnoj.xml
│   ├── test_aldet5
│   │   ├── aldet5.inp
│   │   ├── aldet5.out
│   │   ├── cmd_args.txt
│   │   ├── gold.structure.xml
│   │   └── gold.wfnoj.xml
│   ├── test_aldet6
│   │   ├── aldet6.inp
│   │   ├── aldet6.out
│   │   ├── cmd_args.txt
│   │   ├── gold.structure.xml
│   │   └── gold.wfnoj.xml
│   ├── test_Be_ccd
│   │   ├── be_ccd.inp
│   │   ├── be_ccd.out
│   │   ├── gold.Input.xml
│   │   ├── gold.structure.xml
│   │   └── gold.wfnoj.xml
│   ├── test_Be_sto3g
│   │   ├── be.inp
│   │   ├── be.out
│   │   └── expect_fail.txt
│   ├── test_Bi_dirac
│   │   ├── Bi.mol
│   │   ├── df_Bi.out
│   │   ├── df.inp
│   │   ├── gold.orbs.h5
│   │   ├── gold.qmc.in-wfnoj.xml
│   │   ├── gold.structure.xml
│   │   └── gold.wfnoj.xml
│   ├── test_C4_MSD_excited
│   │   ├── C4_AE_Mol_QP.h5
│   │   ├── cmd_args.txt
│   │   ├── gold.qmc.in-wfnoj.xml
│   │   ├── gold.structure.xml
│   │   ├── gold.wfnoj.xml
│   │   └── orbitals
│   ├── test_C_sto3g
│   │   ├── carbon.inp
│   │   ├── carbon.out
│   │   └── expect_fail.txt
│   ├── test_diamond2_rmg
│   │   ├── diamond2.h5
│   │   ├── gold.qmc.in-wfnoj.xml
│   │   ├── gold.structure.xml
│   │   ├── gold.wfnoj.xml
│   │   └── input
│   ├── test_HCNp
│   │   ├── gold.Input.txt
│   │   ├── gold.Input.xml
│   │   ├── gold.structure.xml
│   │   ├── gold.wfnoj.xml
│   │   ├── HCN+.inp
│   │   └── HCN+.out
│   ├── test_HDF5_Be_ccd
│   │   ├── be_ccd.inp
│   │   ├── be_ccd.out
│   │   ├── cmd_args.txt
│   │   ├── gold.Input.xml
│   │   ├── gold.orbs.h5
│   │   ├── gold.structure.xml
│   │   └── gold.wfnoj.xml
│   ├── test_HDF5_FeCO6
│   │   ├── cmd_args.txt
│   │   ├── FeCO6.inp
│   │   ├── FeCO6.out
│   │   ├── gold.Input.xml
│   │   ├── gold.orbs.h5
│   │   ├── gold.structure.xml
│   │   └── gold.wfnoj.xml
│   ├── test_He_sto3g
│   │   ├── gold.Input.xml
│   │   ├── gold.structure.xml
│   │   ├── gold.wfnoj.xml
│   │   ├── he.inp
│   │   └── he.out
│   ├── test_LiH_pyscf
│   │   ├── cmd_args.txt
│   │   ├── gold.qmc.in-wfnoj.xml
│   │   ├── gold.structure.xml
│   │   ├── gold.wfnoj.xml
│   │   ├── LiH.h5
│   │   ├── LiH.py
│   │   ├── LiH.pyscf.out
│   │   └── orbitals
│   ├── test_LiH_pyscf_UHF
│   │   ├── cmd_args.txt
│   │   ├── gold.qmc.in-wfnoj.xml
│   │   ├── gold.structure.xml
│   │   ├── gold.wfnoj.xml
│   │   ├── LiH.h5
│   │   ├── LiH.py
│   │   ├── LiH.pyscf.out
│   │   └── orbitals
│   ├── test_LiH_qp
│   │   ├── cc-pv5z
│   │   ├── cmd_args.txt
│   │   ├── gold.qmc.in-wfnoj.xml
│   │   ├── gold.structure.xml
│   │   ├── gold.wfnoj.xml
│   │   ├── LiH.qp.out
│   │   ├── LiH.xyz
│   │   ├── orbitals
│   │   ├── QP2QMCACK.h5
│   │   └── script.sh
│   ├── test_NaCl_qbox
│   │   ├── gold.h5
│   │   └── qbox.sample
│   ├── test_O2_pwscf
│   │   ├── charge-density.hdf5
│   │   ├── data-file-schema.xml
│   │   ├── gold.h5 -> /root/hpcrunner/tmp/qmcpack-3.13.0/tests/solids/monoO_noncollinear_1x1x1_pp/o2_45deg_spins.pwscf.h5
│   │   └── wfc1.hdf5
│   ├── test_O_ext
│   │   ├── gms.inp
│   │   ├── gms.out
│   │   ├── gold.Input.xml
│   │   ├── gold.structure.xml
│   │   └── gold.wfnoj.xml
│   └── test_O_rmg
│       ├── gold.qmc.in-wfnoj.xml
│       ├── gold.structure.xml
│       ├── gold.wfnoj.xml
│       ├── input
│       └── o.h5
├── CTestTestfile.cmake
├── estimator
│   ├── CMakeFiles
│   │   ├── CMakeDirectoryInformation.cmake
│   │   └── progress.marks
│   ├── cmake_install.cmake
│   ├── CTestTestfile.cmake
│   └── Makefile
├── heg
│   ├── heg_14_gamma
│   │   ├── CMakeFiles
│   │   │   ├── CMakeDirectoryInformation.cmake
│   │   │   └── progress.marks
│   │   ├── cmake_install.cmake
│   │   ├── CTestTestfile.cmake
│   │   ├── deterministic-heg_14_gamma-sjb-1-1
...
```

在项目根目录下执行命令来运行单元测试和确定性测试

```bash
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
ctest -R unit 
ctest -R deterministic -LE unstable
```

### 2.2.运行结果

```bash
[root@host- build]# ctest -R unit 
Test project /root/qmcpack-3.13.0/build
      Start  1: deterministic-unit_test_io_hdf5
 1/35 Test  #1: deterministic-unit_test_io_hdf5 ........................   Passed    1.67 sec
      Start  2: deterministic-unit_test_io_ohmmsdata
 2/35 Test  #2: deterministic-unit_test_io_ohmmsdata ...................   Passed    0.30 sec
      Start  3: deterministic-unit_test_einspline
 3/35 Test  #3: deterministic-unit_test_einspline ......................   Passed    0.24 sec
      Start  5: deterministic-unit_test_containers_ohmmspete
 4/35 Test  #5: deterministic-unit_test_containers_ohmmspete ...........   Passed    0.18 sec
      Start  6: deterministic-unit_test_containers_ohmmssoa
 5/35 Test  #6: deterministic-unit_test_containers_ohmmssoa ............   Passed    0.20 sec
      Start  7: deterministic-unit_test_containers_MinimalContainers
 6/35 Test  #7: deterministic-unit_test_containers_MinimalContainers ...   Passed    0.19 sec
      Start  8: deterministic-unit_test_containers_pools
 7/35 Test  #8: deterministic-unit_test_containers_pools ...............   Passed    0.18 sec
      Start  9: deterministic-unit_test_message
 8/35 Test  #9: deterministic-unit_test_message ........................   Passed    0.19 sec
      Start 10: deterministic-unit_test_message_mpi
 9/35 Test #10: deterministic-unit_test_message_mpi ....................   Passed    0.73 sec
      Start 11: deterministic-unit_test_cpu
10/35 Test #11: deterministic-unit_test_cpu ............................   Passed    0.21 sec
      Start 12: deterministic-unit_test_particle
11/35 Test #12: deterministic-unit_test_particle .......................   Passed    0.37 sec
      Start 13: deterministic-unit_test_lattice
12/35 Test #13: deterministic-unit_test_lattice ........................   Passed    0.16 sec
      Start 14: deterministic-unit_test_longrange
13/35 Test #14: deterministic-unit_test_longrange ......................   Passed    3.34 sec
      Start 15: deterministic-unit_test_particleio
14/35 Test #15: deterministic-unit_test_particleio .....................   Passed    0.17 sec
      Start 16: deterministic-unit_test_particle_base
15/35 Test #16: deterministic-unit_test_particle_base ..................   Passed    0.18 sec
      Start 17: deterministic-unit_test_utilities
16/35 Test #17: deterministic-unit_test_utilities ......................   Passed    0.24 sec
      Start 18: deterministic-unit_test_utilities_for_testing
17/35 Test #18: deterministic-unit_test_utilities_for_testing ..........   Passed    0.13 sec
      Start 19: deterministic-unit_test_numerics
18/35 Test #19: deterministic-unit_test_numerics .......................   Passed    0.21 sec
      Start 20: deterministic-unit_test_type_traits
19/35 Test #20: deterministic-unit_test_type_traits ....................   Passed    0.17 sec
      Start 21: deterministic-unit_test_Concurrency
20/35 Test #21: deterministic-unit_test_Concurrency ....................   Passed    0.21 sec
      Start 22: deterministic-unit_test_spline2
21/35 Test #22: deterministic-unit_test_spline2 ........................   Passed    0.23 sec
      Start 23: deterministic-unit_test_wavefunction_common
22/35 Test #23: deterministic-unit_test_wavefunction_common ............   Passed    0.30 sec
      Start 24: deterministic-unit_test_wavefunction_trialwf
23/35 Test #24: deterministic-unit_test_wavefunction_trialwf ...........   Passed    3.89 sec
      Start 25: deterministic-unit_test_wavefunction_sposet
24/35 Test #25: deterministic-unit_test_wavefunction_sposet ............   Passed    2.00 sec
      Start 26: deterministic-unit_test_wavefunction_jastrow
25/35 Test #26: deterministic-unit_test_wavefunction_jastrow ...........   Passed    1.68 sec
      Start 27: deterministic-unit_test_wavefunction_determinant
26/35 Test #27: deterministic-unit_test_wavefunction_determinant .......   Passed    5.69 sec
      Start 28: deterministic-unit_test_hamiltonian_coulomb
27/35 Test #28: deterministic-unit_test_hamiltonian_coulomb ............   Passed    8.21 sec
      Start 29: deterministic-unit_test_hamiltonian_force
28/35 Test #29: deterministic-unit_test_hamiltonian_force ..............   Passed    0.90 sec
      Start 30: deterministic-unit_test_hamiltonian_ham
29/35 Test #30: deterministic-unit_test_hamiltonian_ham ................   Passed    2.46 sec
      Start 31: deterministic-unit_test_estimators
30/35 Test #31: deterministic-unit_test_estimators .....................   Passed    1.22 sec
      Start 32: deterministic-unit_test_estimators_mpi
31/35 Test #32: deterministic-unit_test_estimators_mpi .................   Passed    0.87 sec
      Start 33: deterministic-unit_test_drivers
32/35 Test #33: deterministic-unit_test_drivers ........................   Passed    2.13 sec
      Start 34: deterministic-unit_test_new_drivers
33/35 Test #34: deterministic-unit_test_new_drivers ....................   Passed    3.89 sec
      Start 35: deterministic-unit_test_drivers_mpi
34/35 Test #35: deterministic-unit_test_drivers_mpi ....................   Passed    0.82 sec
      Start 45: deterministic-unit_test_tools
35/35 Test #45: deterministic-unit_test_tools ..........................   Passed    0.52 sec

100% tests passed, 0 tests failed out of 35

Label Time Summary:
deterministic      =  76.56 sec*proc (35 tests)
quality_unknown    =  76.56 sec*proc (35 tests

[root@host- build]# ctest -R deterministic -LE unstable
Test project /root/hpcrunner/tmp/qmcpack-3.13.0/build
       Start    1: deterministic-unit_test_io_hdf5
 1/981 Test    #1: deterministic-unit_test_io_hdf5 ..............................................................   Passed    0.15 sec
       Start    2: deterministic-unit_test_io_ohmmsdata
 2/981 Test    #2: deterministic-unit_test_io_ohmmsdata .........................................................   Passed    0.14 sec
       Start    3: deterministic-unit_test_einspline
 3/981 Test    #3: deterministic-unit_test_einspline ............................................................   Passed    0.14 sec
       Start    4: deterministic-integration_dualallocators
 4/981 Test    #4: deterministic-integration_dualallocators .....................................................   Passed    0.30 sec
       Start    5: deterministic-unit_test_containers_ohmmspete
 5/981 Test    #5: deterministic-unit_test_containers_ohmmspete .................................................   Passed    0.13 sec
       Start    6: deterministic-unit_test_containers_ohmmssoa
 6/981 Test    #6: deterministic-unit_test_containers_ohmmssoa ..................................................   Passed    0.14 sec
       Start    7: deterministic-unit_test_containers_MinimalContainers
 7/981 Test    #7: deterministic-unit_test_containers_MinimalContainers .........................................   Passed    0.14 sec
       Start    8: deterministic-unit_test_containers_pools
 8/981 Test    #8: deterministic-unit_test_containers_pools .....................................................   Passed    0.13 sec
       Start    9: deterministic-unit_test_message
 9/981 Test    #9: deterministic-unit_test_message ..............................................................   Passed    0.13 sec
       Start   10: deterministic-unit_test_message_mpi
10/981 Test   #10: deterministic-unit_test_message_mpi ..........................................................   Passed    0.72 sec
       Start   11: deterministic-unit_test_cpu
11/981 Test   #11: deterministic-unit_test_cpu ..................................................................   Passed    0.13 sec
       Start   12: deterministic-unit_test_particle
 ...
977/981 Test #1845: deterministic-diamondC_2x1x1_pp-vmc_gaussian_sdj-1-1-nonlocalecp ............................   Passed    0.04 sec
        Start 1867: deterministic-grapheneC_1x1_pp-vmc_sdj_z10-1-1
978/981 Test #1867: deterministic-grapheneC_1x1_pp-vmc_sdj_z10-1-1 ..............................................   Passed    4.48 sec
        Start 1868: deterministic-grapheneC_1x1_pp-vmc_sdj_z10-1-1-ionion
979/981 Test #1868: deterministic-grapheneC_1x1_pp-vmc_sdj_z10-1-1-ionion .......................................   Passed    0.04 sec
        Start 1869: deterministic-grapheneC_1x1_pp-vmc_sdj_z30-1-1
980/981 Test #1869: deterministic-grapheneC_1x1_pp-vmc_sdj_z30-1-1 ..............................................   Passed    4.02 sec
        Start 1870: deterministic-grapheneC_1x1_pp-vmc_sdj_z30-1-1-ionion
981/981 Test #1870: deterministic-grapheneC_1x1_pp-vmc_sdj_z30-1-1-ionion .......................................   Passed    0.04 sec

100% tests passed, 0 tests failed out of 981

Label Time Summary:
QMCPACK                     = 2176.22 sec*proc (60 tests)
QMCPACK-checking-results    =  33.65 sec*proc (877 tests)
deterministic               = 2280.86 sec*proc (981 tests)
quality_unknown             = 2280.86 sec*proc (981 tests)
unit                        =  66.23 sec*proc (36 tests)

Total Test time (real) = 515.67 sec
total time used: 562s
SUCCESSFULLY EXECUTED AT 2022-09-11 10:52:35, CONGRADULATIONS!!!
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
| gcc      | bisheng 2.1.0 | gcc 9.3.0 |
| mpi      | hmpi1.1.1     | hmpi1.1.1 |
| CMake    | 3.23.1        | 3.23.1    |
| OpenBLAS | 0.3.18        | 0.3.18    |
| HDF5     | 1.10.1        | 1.10.1    |
| BOOST    | 1.72.0        | 1.72.0    |
| FFTW     | 3.3.10        | 3.3.10    |
| LibXml2  | 2.10.1        | 2.10.1    |

### 3.3.测试硬件性能信息对比

|        | arm信息     | x86信息  |
| ------ | ----------- | -------- |
| cpu    | Kunpeng 920 |          |
| 核心数 | 16          | 4        |
| 内存   | 32 GB       | 8 GB     |
| 磁盘io | 1.3 GB/s    | 400 MB/s |
| 虚拟化 | KVM         | KVM      |

### 3.4.测试选择的案例

examples/molecules/H2O 目录下的文件 simple-H2O.xml

对水分子进行一个简短的扩散蒙特卡罗计算

测试文件（部分）如下

```xml
<?xml version="1.0"?>
<simulation>
  <project id="H2O" series="1">
    <application name="qmcapp" role="molecu" class="serial" version="0.2">
      Simple Example of moleculear H2O
    </application>
  </project>

  <particleset name="e">
    <group name="u" size="4">
      <parameter name="charge">-1</parameter>
      <attrib name="position" datatype="posArray">
        2.9151687332e-01 -6.5123272502e-01 -1.2188463918e-01
        5.8423636048e-01  4.2730406357e-01 -4.5964306231e-03
        3.5228575807e-01 -3.5027014639e-01  5.2644808295e-01
       -5.1686250912e-01 -1.6648002292e+00  6.5837023441e-01
      </attrib>
    </group>
    <group name="d" size="4">
      <parameter name="charge">-1</parameter>
      <attrib name="position" datatype="posArray">
        3.1443445436e-01  6.5068682609e-01 -4.0983449009e-02
       -3.8686061749e-01 -9.3744432997e-02 -6.0456005388e-01
        2.4978241724e-02 -3.2862514649e-02 -7.2266047173e-01
       -4.0352404772e-01  1.1927734805e+00  5.5610824921e-01
      </attrib>
    </group>
  </particleset>
  <particleset name="ion0" size="3">
    <group name="O">
      <parameter name="charge">6</parameter>
      <parameter name="valence">4</parameter>
      <parameter name="atomicnumber">8</parameter>
    </group>
    <group name="H">
      <parameter name="charge">1</parameter>
      <parameter name="valence">1</parameter>
      <parameter name="atomicnumber">1</parameter>
    </group>
    <attrib name="position" datatype="posArray">
      0.0000000000e+00  0.0000000000e+00  0.0000000000e+00
      0.0000000000e+00 -1.4308249289e+00  1.1078707576e+00
      0.0000000000e+00  1.4308249289e+00  1.1078707576e+00
    </attrib>
    <attrib name="ionid" datatype="stringArray">
      O H H
    </attrib>
  </particleset>

  <include href="H2O.HF.wfs.xml"/>

  <!--  Hamiltonian -->
  <hamiltonian name="h0" type="generic" target="e">
    <pairpot name="ElecElec" type="coulomb" source="e" target="e"/>
    <pairpot name="ELEMENT-ECP" type="pseudo" source="ion0" target="e" format="xml" wavefunction="psi0" >
       <pseudo elementType="O" format="xml" href="O.BFD.xml" />
       <pseudo elementType="H" format="xml" href="H.BFD.xml" />
    </pairpot>
    <constant name="IonIon" type="coulomb" source="ion0" target="ion0"/>
  </hamiltonian>

 <init source="ion0" target="e"/>

  <qmc method="vmc" move="pbyp" gpu="yes">
    <estimator name="LocalEnergy" hdf5="no"/>
    <parameter name="walkers">    1 </parameter>
    <parameter name="samplesperthread">      64 </parameter>
    <parameter name="stepsbetweensamples">    1 </parameter>
    <parameter name="substeps">  5 </parameter>
    <parameter name="warmupSteps">  100 </parameter>
    <parameter name="blocks">  1 </parameter>
    <parameter name="timestep">  0.3 </parameter>
    <parameter name="usedrift">   no </parameter>
  </qmc>
  <qmc method="dmc" move="pbyp" checkpoint="-1" gpu="yes">
    <estimator name="LocalEnergy" hdf5="no"/>
    <parameter name="minimumtargetwalkers"> 128 </parameter>
    <parameter name="reconfiguration">   no </parameter>
    <parameter name="warmupSteps">  100 </parameter>
    <parameter name="timestep">  0.005 </parameter>
    <parameter name="steps">   10 </parameter>
    <parameter name="blocks">  200 </parameter>
    <parameter name="nonlocalmoves">  yes </parameter>
  </qmc>

</simulation>
```

### 3.5.所用函数

函数位于文件同级目录下的H2O.HF.wfs.xml文件中

```xml
[root@host- example_H2O-1-1]# cat H2O.HF.wfs.xml
<?xml version="1.0"?>
<qmcsystem>
  <wavefunction id="psi0" target="e">
    <determinantset name="LCAOBSet" type="MolecularOrbital" transform="yes" source="ion0">
      <basisset name="LCAOBSet">
        <atomicBasisSet name="Gaussian-G2" angular="cartesian" type="Gaussian" elementType="O" normalized="no">
          <grid type="log" ri="1.e-6" rf="1.e2" npts="1001"/>
          <!-- Possible substitution O00 by a Slater-type orbital
  <basisGroup rid="O00" n="0" l="0" type="Slater">
    <radfunc exponent="1.13763" contraction="1.0"/>
  </basisGroup>
-->
          <basisGroup rid="O00" n="0" l="0" type="Gaussian">
            <radfunc exponent="1.253460000000e-01" contraction="5.574095889400e-02"/>
            <radfunc exponent="2.680220000000e-01" contraction="3.048477751890e-01"/>
            <radfunc exponent="5.730980000000e-01" contraction="4.537516653790e-01"/>
            <radfunc exponent="1.225429000000e+00" contraction="2.959257817680e-01"/>
            <radfunc exponent="2.620277000000e+00" contraction="1.956698557000e-02"/>
            <radfunc exponent="5.602818000000e+00" contraction="-1.286269051440e-01"/>
            <radfunc exponent="1.198024500000e+01" contraction="1.202399113300e-02"/>
            <radfunc exponent="2.561680100000e+01" contraction="4.069997000000e-04"/>
            <radfunc exponent="5.477521600000e+01" contraction="-7.599994400000e-05"/>
          </basisGroup>
          <basisGroup rid="O10" n="1" l="0" type="Gaussian">
            <radfunc exponent="1.686633000000e+00" contraction="1.000000000000e+00"/>
          </basisGroup>
          <basisGroup rid="O20" n="2" l="0" type="Gaussian">
            <radfunc exponent="2.379970000000e-01" contraction="1.000000000000e+00"/>
          </basisGroup>
          <basisGroup rid="O31" n="3" l="1" type="Gaussian">
            <radfunc exponent="8.359800000000e-02" contraction="4.495798060300e-02"/>
            <radfunc exponent="1.670170000000e-01" contraction="1.501749352080e-01"/>
            <radfunc exponent="3.336730000000e-01" contraction="2.559988895500e-01"/>
            <radfunc exponent="6.666270000000e-01" contraction="2.818788783850e-01"/>
            <radfunc exponent="1.331816000000e+00" contraction="2.428348952300e-01"/>
            <radfunc exponent="2.660761000000e+00" contraction="1.611339304790e-01"/>
            <radfunc exponent="5.315785000000e+00" contraction="8.230796448900e-02"/>
            <radfunc exponent="1.062010800000e+01" contraction="3.989898278600e-02"/>
            <radfunc exponent="2.121731800000e+01" contraction="4.678997981000e-03"/>
          </basisGroup>
          <basisGroup rid="O41" n="4" l="1" type="Gaussian">
            <radfunc exponent="1.846960000000e-01" contraction="1.000000000000e+00"/>
          </basisGroup>
          <basisGroup rid="O51" n="5" l="1" type="Gaussian">
            <radfunc exponent="6.006210000000e-01" contraction="1.000000000000e+00"/>
          </basisGroup>
          <basisGroup rid="O62" n="6" l="2" type="Gaussian">
            <radfunc exponent="6.693400000000e-01" contraction="1.000000000000e+00"/>
          </basisGroup>
          <basisGroup rid="O72" n="7" l="2" type="Gaussian">
            <radfunc exponent="2.404278000000e+00" contraction="1.000000000000e+00"/>
          </basisGroup>
          <basisGroup rid="O83" n="8" l="3" type="Gaussian">
            <radfunc exponent="1.423104000000e+00" contraction="1.000000000000e+00"/>
          </basisGroup>
        </atomicBasisSet>
        <atomicBasisSet name="Gaussian-G2" angular="cartesian" type="Gaussian" elementType="H" normalized="no">
          <grid type="log" ri="1.e-6" rf="1.e2" npts="1001"/>
          <!-- Possible substitution H00 by a Slater-type orbital
  <basisGroup rid="H00" n="0" l="0" type="Slater">
    <radfunc exponent="1.47231" contraction="1.0"/>
  </basisGroup>
-->
          <basisGroup rid="H00" n="0" l="0" type="Gaussian">
            <radfunc exponent="8.700887800000e+00" contraction="6.271822462700e-02"/>
            <radfunc exponent="1.955520500000e+00" contraction="2.619585423470e-01"/>
            <radfunc exponent="5.590436000000e-01" contraction="7.570104581320e-01"/>
          </basisGroup>
          <basisGroup rid="H10" n="1" l="0" type="Gaussian">
            <radfunc exponent="1.649254000000e-01" contraction="1.000000000000e+00"/>
          </basisGroup>
          <basisGroup rid="H20" n="2" l="0" type="Gaussian">
            <radfunc exponent="3.206250000000e-02" contraction="1.000000000000e+00"/>
          </basisGroup>
          <basisGroup rid="H31" n="3" l="1" type="Gaussian">
            <radfunc exponent="7.900744000000e-01" contraction="1.000000000000e+00"/>
          </basisGroup>
          <basisGroup rid="H41" n="4" l="1" type="Gaussian">
            <radfunc exponent="1.523514000000e-01" contraction="1.000000000000e+00"/>
          </basisGroup>
          <basisGroup rid="H52" n="5" l="2" type="Gaussian">
            <radfunc exponent="8.838179000000e-01" contraction="1.000000000000e+00"/>
          </basisGroup>
        </atomicBasisSet>
      </basisset>
      <slaterdeterminant>
        <determinant id="updet" size="4">
          <occupation mode="ground"/>
          <coefficient size="57" id="updetC">
  8.56319000000000e-01 -1.06750000000000e-02 -9.24550000000000e-02  0.00000000000000e+00
  0.00000000000000e+00  1.26393000000000e-01  0.00000000000000e+00  0.00000000000000e+00
 -3.68840000000000e-02  0.00000000000000e+00  0.00000000000000e+00 -2.07730000000000e-02
...
 -2.76080000000000e-01 -1.14118000000000e-01  2.65321000000000e-01 -1.84865000000000e-01
 -8.04570000000000e-02  0.00000000000000e+00  0.00000000000000e+00 -4.31949000000000e-01
</coefficient>
        </determinant>
        <determinant id="downdet" size="4">
          <occupation mode="ground"/>
          <coefficient size="57" id="downdetC">
  8.56319000000000e-01 -1.06750000000000e-02 -9.24550000000000e-02  0.00000000000000e+00
  0.00000000000000e+00  1.26393000000000e-01  0.00000000000000e+00  0.00000000000000e+00
 -3.68840000000000e-02  0.00000000000000e+00  0.00000000000000e+00 -2.07730000000000e-02
 -1.12000000000000e-04  9.06000000000000e-04 -7.94000000000000e-04  0.00000000000000e+00
...
 -1.84865000000000e-01 -8.04570000000000e-02  0.00000000000000e+00  0.00000000000000e+00
  4.31949000000000e-01 -9.00582000000000e-01  6.42306000000000e-01 -2.74190000000000e-02
  0.00000000000000e+00  7.87438000000000e-01  6.93741000000000e-01  0.00000000000000e+00
 -2.76080000000000e-01 -1.14118000000000e-01  2.65321000000000e-01 -1.84865000000000e-01
 -8.04570000000000e-02  0.00000000000000e+00  0.00000000000000e+00 -4.31949000000000e-01
</coefficient>
        </determinant>
      </slaterdeterminant>
    </determinantset>
    <jastrow name="J2" type="Two-Body" function="Bspline" print="yes">
      <correlation rcut="10" size="10" speciesA="u" speciesB="u">
        <coefficients id="uu" type="Array"> 0.02904699284 -0.1004179 -0.1752703883 -0.2232576505 -0.2728029201 -0.3253286875 -0.3624525145 -0.3958223107 -0.4268582166 -0.4394531176</coefficients>
      </correlation>
      <correlation rcut="10" size="10" speciesA="u" speciesB="d">
        <coefficients id="ud" type="Array"> 0.9306688133 0.6283592574 0.4630241043 0.3755854892 0.3332513693 0.2974511175 0.2550685097 0.1970164333 0.1357042029 0.1118100397</coefficients>
      </correlation>
    </jastrow>
    <jastrow name="J1" type="One-Body" function="Bspline" source="ion0" print="yes">
      <correlation rcut="10" size="10" cusp="0" elementType="O">
        <coefficients id="eO" type="Array"> -4.015799605 -3.62876664 -2.757339603 -1.838809307 -1.151244223 -0.4626768909 -0.2120317752 -0.1393180507 0.5134645233 6.448937991</coefficients>
      </correlation>
      <correlation rcut="10" size="10" cusp="0" elementType="H">
        <coefficients id="eH" type="Array"> -0.335752041 -0.295753591 -0.2738202473 -0.226321688 -0.1769789243 -0.1762652319 -0.189956563 -0.1816472944 -0.03838699175 0.3453052314</coefficients>
      </correlation>
    </jastrow>
    <jastrow name="J3" type="eeI" function="polynomial" source="ion0" print="yes">
      <correlation ispecies="O" especies="u" isize="3" esize="3" rcut="10">
        <coefficients id="uuO" type="Array" optimize="yes"> 8.227710241e-06 2.480817653e-06 -5.354068112e-06 -1.112644787e-05 -2.208006078e-06 5.213121933e-06 -1.537865869e-05 8.899030233e-06 6.257255156e-06 3.214580988e-06 -7.716743107e-06 -5.275682077e-06 -1.778457637e-06 7.926231121e-06 1.767406868e-06 5.451359059e-08 2.801423724e-06 4.577282736e-06 7.634608083e-06 -9.510673173e-07 -2.344131575e-06 -1.878777219e-06 3.937363358e-07 5.065353773e-07 5.086724869e-07 -1.358768154e-07</coefficients>
      </correlation>
      <correlation ispecies="O" especies1="u" especies2="d" isize="3" esize="3" rcut="10">
        <coefficients id="udO" type="Array" optimize="yes"> -6.939530224e-06 2.634169299e-05 4.046077477e-05 -8.002682388e-06 -5.396795988e-06 6.697370507e-06 5.433953051e-05 -6.336849668e-06 3.680471431e-05 -2.996059772e-05 1.99365828e-06 -3.222705626e-05 -8.091669063e-06 4.15738535e-06 4.843939112e-06 3.563650208e-07 3.786332474e-05 -1.418336941e-05 2.282691374e-05 1.29239286e-06 -4.93580873e-06 -3.052539228e-06 9.870288001e-08 1.844286407e-06 2.970561871e-07 -4.364303677e-08</coefficients>
      </correlation>
      <correlation ispecies="H" especies="u" isize="3" esize="3" rcut="10">
        <coefficients id="uuH" type="Array" optimize="yes"> 1.219830043e-05 1.702845879e-05 -1.609439186e-05 -1.214612351e-05 5.897940525e-08 -7.849710627e-07 7.750177331e-06 -2.745564294e-05 -1.377748171e-05 -1.144278387e-05 -1.063881762e-05 2.731172787e-05 8.303762559e-07 1.584233731e-05 -2.025336133e-06 1.236535704e-07 1.058216977e-05 1.778243902e-05 -2.153644462e-05 2.194588793e-06 -8.919902601e-06 3.229494541e-06 -5.140144143e-07 2.928140965e-06 -7.97264584e-07 1.411162821e-07</coefficients>
      </correlation>
      <correlation ispecies="H" especies1="u" especies2="d" isize="3" esize="3" rcut="10">
        <coefficients id="udH" type="Array" optimize="yes"> -2.543486543e-06 -8.337322309e-06 3.043858765e-06 -3.54249411e-06 -2.701334061e-06 1.458779551e-06 7.950427574e-06 -1.870327066e-05 -2.241681146e-06 -4.868766889e-06 -6.174409643e-06 1.517313537e-05 -9.529020051e-07 9.686796173e-06 -1.640051752e-06 2.576670867e-07 1.392568679e-05 8.676193156e-06 -1.647876036e-05 2.494934689e-06 -7.726225558e-06 3.431064869e-06 -6.601600775e-07 2.390204413e-06 -9.169324979e-07 1.902158654e-07</coefficients>
      </correlation>
    </jastrow>
  </wavefunction>
</qmcsystem>
```

### 3.6.单线程

单线程运行测试时间对比（五次运行取平均值）

|             | arm        | x86      |
| ----------- | ---------- | -------- |
| 实际CPU时间 | 1m50.7302s | 1m6.834s |
| 用户时间    | 1m51.064s  | 1m8.174s |

### 3.7.多线程

多线程运行测试时间对比（五次运行取平均值）

|             | arm        | x86       |
| ----------- | ---------- | --------- |
| 线程数      | 4          | 4         |
| 实际CPU时间 | 3m47.1098s | 2m29.582s |
| 用户时间    | 57.2396s   | 38.743s   |

arm多线程时间耗费数据表：

| 线程          | 1        | 2       | 3       | 4        | 5       | 6        | 7       | 8       | 9       | 10      | 11      | 12      | 13      | 14      | 15      | 16      |
| :------------ | -------- | ------- | ------- | -------- | ------- | -------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- |
| 用户时间(s)   | 110.7302 | 56.5265 | 55.9635 | 57.2396s | 57.631  | 58. 635  | 57.517  | 57.6935 | 57.608  | 57.231  | 58.506  | 57.639  | 58.143  | 57.809  | 57.266  | 57.566  |
| 用户态时间(s) | 111.064  | 112.000 | 166.186 | 227.1098 | 285.241 | 347.1895 | 339.129 | 457.494 | 512.555 | 566.857 | 635.991 | 685.102 | 754.138 | 801.482 | 850.152 | 911.592 |
| 内核态时间(s) | 0.114s   | 0.194   | 0.177   | 0.176s   | 0.220   | 0.237    | 0.303   | 0.339   | 0.321   | 0.361   | 0.432   | 0.361   | 0.455   | 0.527   | 0.529   | 0.557   |

x86多线程时间耗费数据表：

| 线程            | 1      | 2      | 3       | 4       |
| --------------- | ------ | ------ | ------- | ------- |
| 用户时间 （s）  | 66.834 | 39.255 | 39.380  | 38.743  |
| 用户态时间（s） | 68.174 | 75.962 | 114.212 | 149.582 |
| 内核态时间（s） | 1.335  | 1.317  | 1.845   | 2.753   |

由上表可知，在线程逐渐增加的情况下，所减少的用户时间并非线性关系，线程数增加后，运算用时并未显著下降，且系统调用的时间有较为明显的上升趋势。

### 3.8.测试总结

性能测试arm平台均在x86平台50%以上,且随着线程数的增加，两个平台的对于同一个应用的所耗费的时间差距逐渐减少。

且线程增加并不会无限制减少应用的实际耗费时间，在合理的范围内分配线程数才能更好的利用算力资源。

## 4.精度测试

### 4.1.所选测试案例

examples/molecules/H2O 目录下的文件 simple-H2O.xml

对水分子进行一个简短的扩散蒙特卡罗计算

测试文件（部分）如下

```xml
<?xml version="1.0"?>
<simulation>
  <project id="H2O" series="1">
    <application name="qmcapp" role="molecu" class="serial" version="0.2">
      Simple Example of moleculear H2O
    </application>
  </project>

  <particleset name="e">
    <group name="u" size="4">
      <parameter name="charge">-1</parameter>
      <attrib name="position" datatype="posArray">
        2.9151687332e-01 -6.5123272502e-01 -1.2188463918e-01
        5.8423636048e-01  4.2730406357e-01 -4.5964306231e-03
        3.5228575807e-01 -3.5027014639e-01  5.2644808295e-01
       -5.1686250912e-01 -1.6648002292e+00  6.5837023441e-01
      </attrib>
    </group>
    <group name="d" size="4">
      <parameter name="charge">-1</parameter>
      <attrib name="position" datatype="posArray">
        3.1443445436e-01  6.5068682609e-01 -4.0983449009e-02
       -3.8686061749e-01 -9.3744432997e-02 -6.0456005388e-01
        2.4978241724e-02 -3.2862514649e-02 -7.2266047173e-01
       -4.0352404772e-01  1.1927734805e+00  5.5610824921e-01
      </attrib>
    </group>
  </particleset>
  <particleset name="ion0" size="3">
    <group name="O">
      <parameter name="charge">6</parameter>
      <parameter name="valence">4</parameter>
      <parameter name="atomicnumber">8</parameter>
    </group>
    <group name="H">
      <parameter name="charge">1</parameter>
      <parameter name="valence">1</parameter>
      <parameter name="atomicnumber">1</parameter>
    </group>
    <attrib name="position" datatype="posArray">
      0.0000000000e+00  0.0000000000e+00  0.0000000000e+00
      0.0000000000e+00 -1.4308249289e+00  1.1078707576e+00
      0.0000000000e+00  1.4308249289e+00  1.1078707576e+00
    </attrib>
    <attrib name="ionid" datatype="stringArray">
      O H H
    </attrib>
  </particleset>

  <include href="H2O.HF.wfs.xml"/>

  <!--  Hamiltonian -->
  <hamiltonian name="h0" type="generic" target="e">
    <pairpot name="ElecElec" type="coulomb" source="e" target="e"/>
    <pairpot name="ELEMENT-ECP" type="pseudo" source="ion0" target="e" format="xml" wavefunction="psi0" >
       <pseudo elementType="O" format="xml" href="O.BFD.xml" />
       <pseudo elementType="H" format="xml" href="H.BFD.xml" />
    </pairpot>
    <constant name="IonIon" type="coulomb" source="ion0" target="ion0"/>
  </hamiltonian>

 <init source="ion0" target="e"/>

  <qmc method="vmc" move="pbyp" gpu="yes">
    <estimator name="LocalEnergy" hdf5="no"/>
    <parameter name="walkers">    1 </parameter>
    <parameter name="samplesperthread">      64 </parameter>
    <parameter name="stepsbetweensamples">    1 </parameter>
    <parameter name="substeps">  5 </parameter>
    <parameter name="warmupSteps">  100 </parameter>
    <parameter name="blocks">  1 </parameter>
    <parameter name="timestep">  0.3 </parameter>
    <parameter name="usedrift">   no </parameter>
  </qmc>
  <qmc method="dmc" move="pbyp" checkpoint="-1" gpu="yes">
    <estimator name="LocalEnergy" hdf5="no"/>
    <parameter name="minimumtargetwalkers"> 128 </parameter>
    <parameter name="reconfiguration">   no </parameter>
    <parameter name="warmupSteps">  100 </parameter>
    <parameter name="timestep">  0.005 </parameter>
    <parameter name="steps">   10 </parameter>
    <parameter name="blocks">  200 </parameter>
    <parameter name="nonlocalmoves">  yes </parameter>
  </qmc>

</simulation>
```

### 4.2.获得对比数据

arm 运行结果(部分)

```bash
#   index    LocalEnergy         LocalEnergy_sq      LocalPotential      Kinetic             ElecElec            LocalECP            NonLocalECP         IonIon              BlockWeight         BlockCPU            AcceptRatio         
         0   -1.7251748941e+01    2.9780930427e+02   -3.0321758135e+01    1.3070009194e+01    1.6922502723e+01   -5.6033330543e+01    1.8083064395e+00    6.9807632464e+00    1.0235000000e+04    2.8510037065e-01    9.9755671551e-01
         1   -1.7254378564e+01    2.9794438925e+02   -3.0732629796e+01    1.3478251232e+01    1.6970980348e+01   -5.6448184166e+01    1.7638107764e+00    6.9807632464e+00    1.0236000000e+04    2.8689712286e-01    9.9722817648e-01
         2   -1.7254960922e+01    2.9799146449e+02   -3.0586764583e+01    1.3331803662e+01    1.6957286527e+01   -5.6378082165e+01    1.8532678078e+00    6.9807632464e+00    1.0248000000e+04    2.8743383288e-01    9.9759685817e-01
         3   -1.7260889624e+01    2.9827035835e+02   -3.0870865462e+01    1.3609975838e+01    1.6991658073e+01   -5.6664430579e+01    1.8211437969e+00    6.9807632464e+00    1.0240000000e+04    2.9344955087e-01    9.9724200114e-01
         4   -1.7254983526e+01    2.9797387957e+02   -3.0813376997e+01    1.3558393471e+01    1.7081807051e+01   -5.6765983508e+01    1.8900362132e+00    6.9807632464e+00    1.0231000000e+04    2.9056759179e-01    9.9706914978e-01
         5   -1.7258395487e+01    2.9806276266e+02   -3.0728088443e+01    1.3469692955e+01    1.7022399033e+01   -5.6523300191e+01    1.7920494691e+00    6.9807632464e+00    1.0237000000e+04    2.8760950267e-01    9.9728868456e-01
         6   -1.7259831659e+01    2.9812129350e+02   -3.0887221586e+01    1.3627389927e+01    1.7010071038e+01   -5.6732993106e+01    1.8549372357e+00    6.9807632464e+00    1.0243000000e+04    2.8602902591e-01    9.9748598639e-01
         7   -1.7260057350e+01    2.9812688940e+02   -3.0827300398e+01    1.3567243048e+01    1.6942785291e+01   -5.6613550449e+01    1.8627015133e+00    6.9807632464e+00    1.0243000000e+04    2.8570312262e-01    9.9754640916e-01
         8   -1.7257019994e+01    2.9800689538e+02   -3.0761039562e+01    1.3504019568e+01    1.6930915741e+01   -5.6351115475e+01    1.6783969253e+00    6.9807632464e+00    1.0239000000e+04    2.8279878199e-01    9.9725519823e-01
         9   -1.7269100607e+01    2.9843640415e+02   -3.0739797595e+01    1.3470696988e+01    1.6967970657e+01   -5.6449074549e+01    1.7605430503e+00    6.9807632464e+00    1.0233000000e+04    2.8251166642e-01    9.9750758093e-01
        10   -1.7266364082e+01    2.9832712716e+02   -3.0741109457e+01    1.3474745375e+01    1.6983093278e+01   -5.6441772173e+01    1.7368061921e+00    6.9807632464e+00    1.0262000000e+04    2.8374005854e-01    9.9734308536e-01
        11   -1.7249111343e+01    2.9773777453e+02   -3.0840509240e+01    1.3591397898e+01    1.6947542684e+01   -5.6496922514e+01    1.7281073437e+00    6.9807632464e+00    1.0245000000e+04    2.8586304188e-01    9.9748762301e-01
        12   -1.7267388558e+01    2.9843582638e+02   -3.0886991472e+01    1.3619602914e+01    1.6984531066e+01   -5.6705585410e+01    1.8532996258e+00    6.9807632464e+00    1.0269000000e+04    2.8569912910e-01    9.9706468743e-01
        13   -1.7262354365e+01    2.9827227135e+02   -3.0962551249e+01    1.3700196884e+01    1.7000049621e+01   -5.6808620568e+01    1.8652564511e+00    6.9807632464e+00    1.0292000000e+04    2.9240232706e-01    9.9708541787e-01
        14   -1.7254449991e+01    2.9795227354e+02   -3.0715917797e+01    1.3461467806e+01    1.7016759381e+01   -5.6514033433e+01    1.8005930084e+00    6.9807632464e+00    1.0316000000e+04    2.8663556278e-01    9.9728261050e-01
        15   -1.7263269215e+01    2.9827853984e+02   -3.0814527650e+01    1.3551258434e+01    1.6986999069e+01   -5.6597134869e+01    1.8148449045e+00    6.9807632464e+00    1.0313000000e+04    2.8761474788e-01    9.9715083304e-01
        16   -1.7282948477e+01    2.9893807333e+02   -3.0969268690e+01    1.3686320213e+01    1.7023810883e+01   -5.6904826725e+01    1.9309839054e+00    6.9807632464e+00    1.0337000000e+04    2.8743173182e-01    9.9737375004e-01
        17   -1.7269383438e+01    2.9846827389e+02   -3.0974982299e+01    1.3705598861e+01    1.7026007859e+01   -5.6853165226e+01    1.8714118213e+00    6.9807632464e+00    1.0362000000e+04    2.8772860765e-01    9.9738132877e-01
```

```bash
  LocalEnergy           =          -17.2610 +/-           0.0015 
  Variance              =            0.2413 +/-           0.0035 
  Kinetic               =            13.591 +/-            0.044 
  LocalPotential        =           -30.852 +/-            0.043 
  ElecElec              =            17.091 +/-            0.028 
  LocalECP              =           -56.847 +/-            0.078 
  NonLocalECP           =             1.922 +/-            0.019 
  IonIon                =              6.98 +/-             0.00 
  LocalEnergy_sq        =           298.183 +/-            0.052 
  BlockWeight           =           6386.52 +/-            37.52 
  BlockCPU              =            0.3599 +/-           0.0093 
  AcceptRatio           =          0.997401 +/-         0.000018 
  Efficiency            =           3283.67 +/-             0.00 
  TotalTime             =             71.99 +/-             0.00 
  TotalSamples          =           1277304 +/-                0 
```

x86运行结果(部分)

```bash
#   index    LocalEnergy         LocalEnergy_sq      LocalPotential      Kinetic             ElecElec            LocalECP            NonLocalECP         IonIon              BlockWeight         BlockCPU            AcceptRatio         
         0   -1.7268849940e+01    2.9851151223e+02   -3.0856126596e+01    1.3587276655e+01    1.7156641397e+01   -5.6938180878e+01    1.9446496382e+00    6.9807632464e+00    6.3940000000e+03    3.6842778230e-01    9.9743813848e-01
         1   -1.7251896990e+01    2.9786319035e+02   -3.0852506275e+01    1.3600609285e+01    1.7081640098e+01   -5.6818800222e+01    1.9038906024e+00    6.9807632464e+00    6.4050000000e+03    3.5483685300e-01    9.9752147148e-01
         2   -1.7261439178e+01    2.9819545326e+02   -3.0975337578e+01    1.3713898401e+01    1.7046614552e+01   -5.6801712405e+01    1.7989970282e+00    6.9807632464e+00    6.4000000000e+03    3.3844754110e-01    9.9753886799e-01
         3   -1.7257839550e+01    2.9812312076e+02   -3.0564668263e+01    1.3306828714e+01    1.7076057995e+01   -5.6618641665e+01    1.9971521601e+00    6.9807632464e+00    6.3990000000e+03    3.3261741190e-01    9.9763676613e-01
         4   -1.7268972763e+01    2.9838641361e+02   -3.0596045496e+01    1.3327072733e+01    1.7058914847e+01   -5.6647316809e+01    2.0115932194e+00    6.9807632464e+00    6.4000000000e+03    3.4153313080e-01    9.9769490724e-01
         5   -1.7251548939e+01    2.9788130659e+02   -3.1016097044e+01    1.3764548106e+01    1.7125875285e+01   -5.7228304148e+01    2.1055685727e+00    6.9807632464e+00    6.3970000000e+03    3.6634872540e-01    9.9765621772e-01
         6   -1.7251548939e+01    2.9788130659e+02   -3.1016097044e+01    1.3764548106e+01    1.7125875285e+01   -5.7228304148e+01    2.1055685727e+00    6.9807632464e+00    6.3970000000e+03    3.6634872540e-01    9.9765621772e-01
         7   -1.7258583729e+01    2.9806285035e+02   -3.1049331965e+01    1.3790748235e+01    1.7065965011e+01   -5.7082849352e+01    1.9867891294e+00    6.9807632464e+00    6.3980000000e+03    3.3856879510e-01    9.9781169945e-01
         8   -1.7238412856e+01    2.9734166887e+02   -3.0961629140e+01    1.3723216284e+01    1.7107028848e+01   -5.7001240368e+01    1.9518191330e+00    6.9807632464e+00    6.4050000000e+03    3.4281490280e-01    9.9687893842e-01
         9   -1.7248368547e+01    2.9772773099e+02   -3.1032445363e+01    1.3784076815e+01    1.7112552177e+01   -5.7036353119e+01    1.9105923330e+00    6.9807632464e+00    6.3930000000e+03    3.4533171000e-01    9.9704825793e-01
        10   -1.7241744333e+01    2.9748011526e+02   -3.1103956093e+01    1.3862211760e+01    1.7130644687e+01   -5.7269929785e+01    2.0545657585e+00    6.9807632464e+00    6.4510000000e+03    3.5838037360e-01    9.9770839207e-01
        11   -1.7260696741e+01    2.9817091788e+02   -3.1074802582e+01    1.3814105840e+01    1.7248040963e+01   -5.7319083785e+01    2.0154769937e+00    6.9807632464e+00    6.4940000000e+03    3.3498866640e-01    9.9711099821e-01
        12   -1.7244198440e+01    2.9764295806e+02   -3.1164015134e+01    1.3919816695e+01    1.7264626593e+01   -5.7365741445e+01    1.9563364719e+00    6.9807632464e+00    6.5040000000e+03    3.4800547790e-01    9.9707779436e-01
        13   -1.7235693590e+01    2.9748236777e+02   -3.0994678661e+01    1.3758985071e+01    1.7336820489e+01   -5.7248528478e+01    1.9362660817e+00    6.9807632464e+00    6.4900000000e+03    3.5201157280e-01    9.9749780177e-01
        14   -1.7238257546e+01    2.9740547571e+02   -3.1021451908e+01    1.3783194362e+01    1.7324570091e+01   -5.7322767833e+01    1.9959825878e+00    6.9807632464e+00    6.4410000000e+03    3.3521611110e-01    9.9683835524e-01
        15   -1.7259725186e+01    2.9811443934e+02   -3.1092436972e+01    1.3832711786e+01    1.7295988463e+01   -5.7326657188e+01    1.9574685063e+00    6.9807632464e+00    6.4180000000e+03    3.5945300430e-01    9.9742655869e-01
        16   -1.7254042493e+01    2.9791059401e+02   -3.1089870084e+01    1.3835827591e+01    1.7284890947e+01   -5.7415493176e+01    2.0599688984e+00    6.9807632464e+00    6.4350000000e+03    3.6604276070e-01    9.9720182633e-01
        17   -1.7232522955e+01    2.9715525163e+02   -3.1307092348e+01    1.4074569393e+01    1.7212126876e+01   -5.7618548530e+01    2.1185660601e+00    6.9807632464e+00    6.4180000000e+03    3.7182227810e-01    9.9762451560e-01
```

```bash
H2O  series 2 
  LocalEnergy           =          -17.2627 +/-           0.0018 
  Variance              =             0.249 +/-            0.013 
  Kinetic               =            13.697 +/-            0.028 
  LocalPotential        =           -30.959 +/-            0.028 
  ElecElec              =            17.130 +/-            0.022 
  LocalECP              =           -56.973 +/-            0.048 
  NonLocalECP           =             1.903 +/-            0.012 
  IonIon                =              6.98 +/-             0.00 
  LocalEnergy_sq        =           298.248 +/-            0.065 
  BlockWeight           =          10279.63 +/-            43.88 
  BlockCPU              =            0.2879 +/-           0.0014 
  AcceptRatio           =          0.997359 +/-         0.000018 
  Efficiency            =           2804.68 +/-             0.00 
  TotalTime             =             38.29 +/-             0.00 
  TotalSamples          =           1367191 +/-                0 
```

使用以上数据进行误差计算

```python

x86 = [-1.7268849940e+01,-1.7251896990e+01,-1.7261439178e+01,-1.7257839550e+01,-1.7268972763e+01,-1.7251548939e+01,-1.7258583729e+01,-1.7248368547e+01,-1.7238412856e+01,-1.7248368547e+01,-1.7241744333e+01,-1.7260696741e+01,-1.7244198440e+01,-1.7235693590e+01,-1.7238257546e+01,-1.7259725186e+01,-1.7254042493e+01,-1.7232522955e+01]
arm = [-1.7251748941e+01,-1.7254378564e+01,-1.7254960922e+01,-1.7260889624e+01,-1.7254983526e+01,-1.7258395487e+01,-1.7259831659e+01,-1.7260057350e+01,-1.7257019994e+01,-1.7269100607e+01,-1.7266364082e+01,-1.7249111343e+01,-1.7267388558e+01,-1.7262354365e+01,-1.7254449991e+01,-1.7263269215e+01,-1.7282948477e+01,-1.7269383438e+01]

for i in range(len(arm)):
    print(abs((x86[i]-arm[i]) / x86[i]) * 100, '%')
```

### 4.3.误差运算结果

```bash
0.09902801321116915 %
0.01438435437818377 %
0.03753021942838827 %
0.017673556363552997 %
0.08100792787150302 %
0.0396865697347582 %
0.007230778722017583 %
0.06776758606561081 %
0.10793997194192816 %
0.1201972229634796 %
0.14279152111586588 %
0.06712010629606793 %
0.13448069552601774 %
0.1546835052548637 %
0.09393318876221818 %
0.02053351928728903 %
0.1675316611265369 %
0.213900675462632 %
```

### 4.4.测试总结

所有运算结果偏差在1%以内，偏差较小。
