# 《基于openEuler的petsc软件测试报告》

## 1.规范性自检

项目使用了Clang-Format对文件进行格式化

Clang-Format是一个广泛使用的C++代码格式化器。我们在使用编辑器的缩进（TAB）功能时，由于不同编辑器的差别，有的插入的是制表符，有的是2个空格，有的是4个空格。这样如果别人用另一个编辑器来阅读程序时，可能会由于缩进的不同，导致阅读效果一团糟。为了解决这个问题，使用C++开发了一个插件，它可以自动重新缩进，并手动指定空格的数量，自动格式化源文件。它是可以通过命令行使用，也可以作为插件，在其他IDE中使用。

文件格式化配置参考文件`.clang-format`，文件内容如下

```clang-format
Language:        Cpp
AccessModifierOffset: -2
AlignAfterOpenBracket: Align
AlignArrayOfStructures: Left
AlignConsecutiveMacros: Consecutive
AlignConsecutiveAssignments: Consecutive
AlignConsecutiveBitFields: Consecutive
AlignConsecutiveDeclarations: Consecutive
AlignEscapedNewlines: DontAlign
AlignOperands: AlignAfterOperator
AlignTrailingComments: true
AllowAllArgumentsOnNextLine: true
AllowAllConstructorInitializersOnNextLine: true
AllowAllParametersOfDeclarationOnNextLine: true
AllowShortEnumsOnASingleLine: false
AllowShortBlocksOnASingleLine: Always
AllowShortCaseLabelsOnASingleLine: false
AllowShortFunctionsOnASingleLine: Inline
AllowShortLambdasOnASingleLine: All
AllowShortIfStatementsOnASingleLine: AllIfsAndElse
AllowShortLoopsOnASingleLine: true
AlwaysBreakAfterDefinitionReturnType: None
AlwaysBreakAfterReturnType: None
AlwaysBreakBeforeMultilineStrings: false
AlwaysBreakTemplateDeclarations: Yes
AttributeMacros:
  - __capability
  - PETSC_EXTERN
  - PETSC_INTERN
  - PETSC_UNUSED
  - PETSC_RESTRICT
  - PETSC_SINGLE_LIBRARY_INTERN
  - PETSC_ATTRIBUTE_FORMAT
  - PETSC_ATTRIBUTE_MPI_TYPE_TAG
  - PETSC_ATTRIBUTE_MPI_POINTER_WITH_TYPE
  - PETSC_ATTRIBUTE_MPI_TYPE_TAG_LAYOUT_COMPATIBLE
  - PETSC_ATTRIBUTE_COLD
BinPackArguments: true
BinPackParameters: true
BreakBeforeBraces: Custom
BraceWrapping:
  AfterCaseLabel:  false
  AfterClass:      false
  AfterControlStatement: Never
  AfterEnum:       false
  AfterFunction:   true
  AfterNamespace:  true
  AfterObjCDeclaration: false
  AfterStruct:     false
  AfterUnion:      true
  AfterExternBlock: false
  BeforeCatch:     false
  BeforeElse:      false
  BeforeLambdaBody: false
  BeforeWhile:     false
  IndentBraces:    false
  SplitEmptyFunction: true
  SplitEmptyRecord: false
  SplitEmptyNamespace: true
BreakBeforeBinaryOperators: None
# BreakBeforeConceptDeclarations: Allowed
BreakBeforeInheritanceComma: false
BreakInheritanceList: AfterColon
BreakBeforeTernaryOperators: true
BreakConstructorInitializersBeforeComma: false
BreakConstructorInitializers: AfterColon
BreakAfterJavaFieldAnnotations: false
BreakStringLiterals: true
ColumnLimit: 250
CompactNamespaces: false
ConstructorInitializerAllOnOneLineOrOnePerLine: false
ConstructorInitializerIndentWidth: 2
ContinuationIndentWidth: 2
Cpp11BracedListStyle: true
DeriveLineEnding: true
DerivePointerAlignment: false
DisableFormat: false
EmptyLineAfterAccessModifier: Never
EmptyLineBeforeAccessModifier: LogicalBlock
ExperimentalAutoDetectBinPacking: false
FixNamespaceComments: true
ForEachMacros:
#  - BOOST_FOREACH
IfMacros:
  #- PetscCheck
  #- PetscAssert
IncludeBlocks: Preserve
IncludeIsMainSourceRegex: ''
IndentAccessModifiers: false
IndentCaseLabels: false
IndentCaseBlocks: false
IndentGotoLabels: true
IndentPPDirectives: BeforeHash
IndentExternBlock: NoIndent
IndentRequires: false
IndentWidth: 2
IndentWrappedFunctionNames: false
InsertTrailingCommas: None
KeepEmptyLinesAtTheStartOfBlocks: false
LambdaBodyIndentation: Signature
MacroBlockBegin: ''
MacroBlockEnd:   ''
MaxEmptyLinesToKeep: 1
NamespaceIndentation: None
PackConstructorInitializers: NextLine
PenaltyBreakAssignment: 1000000
PenaltyBreakBeforeFirstCallParameter: 1000000
PenaltyBreakComment: 300000
PenaltyBreakFirstLessLess: 120
PenaltyBreakString: 1000
PenaltyBreakTemplateDeclaration: 10
PenaltyExcessCharacter: 0
PenaltyReturnTypeOnItsOwnLine: 1000000
PenaltyIndentedWhitespace: 0
PointerAlignment: Right
PPIndentWidth: -1
ReferenceAlignment: Pointer
ReflowComments: false
ShortNamespaceLines: 0
SortIncludes: Never
SortUsingDeclarations: false
SpaceAfterCStyleCast: false
SpaceAfterLogicalNot: false
SpaceAfterTemplateKeyword: true
SpaceBeforeAssignmentOperators: true
SpaceBeforeCaseColon: false
SpaceBeforeCpp11BracedList: false
SpaceBeforeCtorInitializerColon: true
SpaceBeforeInheritanceColon: true
SpaceBeforeParens: ControlStatementsExceptControlMacros
SpaceAroundPointerQualifiers: Default
SpaceBeforeRangeBasedForLoopColon: true
SpaceInEmptyBlock: true
SpaceInEmptyParentheses: false
SpacesBeforeTrailingComments: 1
SpacesInAngles: Never
SpacesInConditionalStatement: false
SpacesInContainerLiterals: true
SpacesInCStyleCastParentheses: false
SpacesInLineCommentPrefix:
  Minimum: 1
  Maximum: -1
SpacesInParentheses: false
SpacesInSquareBrackets: false
SpaceBeforeSquareBrackets: false
SeparateDefinitionBlocks: Leave
BitFieldColonSpacing: Both
Standard: Latest
StatementAttributeLikeMacros:
  - PETSC_EXTERN
  - PETSC_INTERN
  - PETSC_NODISCARD
StatementMacros:
  - PetscKernel_A_gets_transpose_A_DECLARE
  - PETSC_RETURNS
  - PETSC_DECLTYPE_AUTO_RETURNS
  - PETSC_NOEXCEPT_AUTO_RETURNS
  - PETSC_DECLTYPE_NOEXCEPT_AUTO_RETURNS
  - PETSC_UNUSED
TabWidth: 2
UseCRLF: false
UseTab: Never
WhitespaceSensitiveMacros:
  - PetscStringize
  - PetscStringize_
TypenameMacros:
  - khash_t
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

在petsc项目根目录下运行,运行结果如下

```bash
⋊> ~/hpcrunner/tmp/petsc-3.18.1 python3 ../count.py
/root/hpcrunner/tmp/petsc-3.18.1
当前文件夹下共有[.sh]的文件5750个
当前文件夹下共有[.out]的文件5263个
当前文件夹下共有[.c]的文件2682个
当前文件夹下共有[]的文件1963个
当前文件夹下共有[.o]的文件1479个
当前文件夹下共有[.d]的文件1479个
当前文件夹下共有[.py]的文件513个
当前文件夹下共有[.h]的文件450个
当前文件夹下共有[.pyc]的文件204个
当前文件夹下共有[.F90]的文件183个
当前文件夹下共有[.pxd]的文件151个
当前文件夹下共有[.cxx]的文件88个
当前文件夹下共有[.m]的文件60个
当前文件夹下共有[.h90]的文件56个
当前文件夹下共有[.mod]的文件49个
当前文件夹下共有[.pyx]的文件49个
当前文件夹下共有[.pxi]的文件39个
当前文件夹下共有[.hpp]的文件33个
当前文件夹下共有[.cu]的文件30个
当前文件夹下共有[.msh]的文件26个
当前文件夹下共有[.txt]的文件19个
当前文件夹下共有[.exo]的文件17个
当前文件夹下共有[.cpp]的文件16个
当前文件夹下共有[.js]的文件15个
当前文件夹下共有[.geo]的文件13个
当前文件夹下共有[.yaml]的文件12个
当前文件夹下共有[.so]的文件9个
当前文件夹下共有[.log]的文件8个
当前文件夹下共有[.testout]的文件7个
当前文件夹下共有[.patch]的文件7个
当前文件夹下共有[.xib]的文件6个
当前文件夹下共有[.yml]的文件6个
当前文件夹下共有[.inp]的文件6个
当前文件夹下共有[.pbxproj]的文件5个
当前文件夹下共有[.rst]的文件5个
当前文件夹下共有[.opts]的文件5个
当前文件夹下共有[.cfg]的文件4个
当前文件夹下共有[.1]的文件4个
当前文件夹下共有[.plist]的文件4个
当前文件夹下共有[.bin]的文件4个
当前文件夹下共有[.pch]的文件3个
当前文件夹下共有[.tmp]的文件3个
当前文件夹下共有[.err]的文件3个
当前文件夹下共有[.h5m]的文件3个
当前文件夹下共有[.counts]的文件3个
当前文件夹下共有[.dat]的文件3个
当前文件夹下共有[.in]的文件3个
当前文件夹下共有[.mtx]的文件3个
当前文件夹下共有[.cas]的文件3个
当前文件夹下共有[.petsc]的文件3个
当前文件夹下共有[.f90]的文件3个
当前文件夹下共有[.bash]的文件2个
当前文件夹下共有[.swift]的文件2个
当前文件夹下共有[.png]的文件2个
当前文件夹下共有[.pc]的文件2个
当前文件夹下共有[.json]的文件2个
当前文件夹下共有[.data]的文件2个
当前文件夹下共有[.inf]的文件2个
当前文件夹下共有[.mat]的文件2个
当前文件夹下共有[.egads]的文件2个
当前文件夹下共有[.stp]的文件2个
当前文件夹下共有[.h5]的文件2个
当前文件夹下共有[.msh2]的文件2个
当前文件夹下共有[.egadslite]的文件2个
当前文件夹下共有[.cgns]的文件2个
当前文件夹下共有[.med]的文件2个
当前文件夹下共有[.igs]的文件2个
当前文件夹下共有[.msh4]的文件2个
当前文件夹下共有[.user]的文件2个
当前文件夹下共有[.md]的文件2个
当前文件夹下共有[.H]的文件2个
当前文件夹下共有[.tex]的文件2个
当前文件夹下共有[.zig]的文件2个
当前文件夹下共有[.i]的文件2个
当前文件夹下共有[.pyf]的文件2个
当前文件夹下共有[.csh]的文件1个
当前文件夹下共有[.common]的文件1个
当前文件夹下共有[.exe]的文件1个
当前文件夹下共有[.dll]的文件1个
当前文件夹下共有[.mplstyle]的文件1个
当前文件夹下共有[.uni]的文件1个
当前文件夹下共有[.test]的文件1个
当前文件夹下共有[.rtf]的文件1个
当前文件夹下共有[.strings]的文件1个
当前文件夹下共有[.storyboard]的文件1个
当前文件夹下共有[.mode1v3]的文件1个
当前文件夹下共有[.pbxuser]的文件1个
当前文件夹下共有[.db]的文件1个
当前文件夹下共有[.18]的文件1个
当前文件夹下共有[.pkl]的文件1个
当前文件夹下共有[.mk]的文件1个
当前文件夹下共有[.bz2]的文件1个
当前文件夹下共有[.xmf]的文件1个
当前文件夹下共有[.supp]的文件1个
当前文件夹下共有[.bmp]的文件1个
当前文件夹下共有[.xsl]的文件1个
当前文件夹下共有[.3d]的文件1个
当前文件夹下共有[.2d]的文件1个
当前文件夹下共有[.pdf]的文件1个
当前文件夹下共有[.template]的文件1个
当前文件夹下共有[.java]的文件1个
当前文件夹下共有[.options]的文件1个
当前文件夹下共有[.f2py]的文件1个
当前文件夹下共有[.ini]的文件1个
```

查看上述结果可知主要源码文件后缀名为 `cpp`,`c`,`h`,`py`,`sh`,`c`,`csh`,`cc`,`pl`。

### 1.2.统计源码总行数

统计所有源码文件的代码行数

```bash
 find ./ -regex ".*\.hpp\|.*\.h\|.*\.cpp"\|.*\.py"\|.*\.sh"\|.*\.c"\|.*\.csh"\|.*\.cc"\|.*\.pl" \
  | xargs wc -l
```

统计结果

```bash
   96861 total
```

### 1.3.统计不符合要求的总行数

对文件后缀名为 `cpp`,`hpp`,`h`,`py`,`sh`,`c`,`csh`,`cc`,`pl`, 的所有文件进行格式
通过git与clang-format结合的方式进行统计

```bash
[root@host- src]# find . -regex '.*\.\(cpp\|hpp\)' -exec clang-format -style=./src/.clang-format -i {} \; 
[root@host- src]# git commit -m "fomat update"
[main 065d27269a1] fomat update
 29 files changed, 1402 insertions(+), 1393 deletions(-)
 rewrite src/dm/dt/fe/interface/ftn-custom/zfef.c (72%)
 rewrite src/dm/dt/fv/interface/ftn-custom/zfvf.c (82%)
 rewrite src/dm/dt/interface/ftn-custom/zdsf.c (83%)
 rewrite src/dm/dt/interface/ftn-custom/zdtfef.c (69%)
 rewrite src/dm/impls/da/f90-custom/zda1f90.c (81%)
 rewrite src/dm/impls/da/ftn-custom/zda1f.c (63%)
 rewrite src/dm/impls/da/ftn-custom/zda2f.c (68%)
 rewrite src/dm/impls/da/ftn-custom/zda3f.c (70%)
 rewrite src/dm/impls/da/ftn-custom/zdacornf.c (84%)
 rewrite src/dm/impls/da/ftn-custom/zdaf.c (72%)
 rewrite src/dm/impls/da/ftn-custom/zdaghostf.c (80%)
 rewrite src/dm/impls/da/ftn-custom/zdaindexf.c (64%)
 rewrite src/dm/impls/da/ftn-custom/zdasubf.c (71%)
 rewrite src/dm/impls/plex/tests/ex1f90.F90 (95%)
 rewrite src/dm/impls/plex/tests/ex2f90.F90 (97%)
 rewrite src/dm/impls/plex/tests/ex48f90.F90 (92%)
 rewrite src/dm/impls/plex/tests/ex97f90.F90 (87%)
```

### 1.4.统计结果

综上信息，项目中代码规范性自检检查结果为

通过率    : 98.56%           1-1393/96861*100%

不通过率  : 1.44%            1393/96861*100%

## 2.功能性测试

### 2.1.所选测试案例

petsc内置了大量的单元测试，可以使用其进行单元测试文件内容。

单元测试文件列表（部分）如下

```bash
[root@host- build]# root@zubinshuo-PC 11:46:26 ~/petsc |main ↑1 ✓| →  tree src/mat/tests/
src/mat/tests/
├── bench_spmv.c
├── cJSON.c
├── cJSON.h
├── ex100.c
├── ex101.c
├── ex180.c
├── ex181.c
├── ex182.c
├── ex183.c
├── ex184.c
├── ex185.c
├── ex18.c
├── ex190.c
├── ex191.c
├── ex192.c
├── ex193.c
├── ex194.c
├── ex195.c
├── ex196f90.F90
├── ex197.c
├── ex198.c
├── ex199.c
├── ex19.c
├── ex1.c
├── ex1k.kokkos.cxx
├── ex200.c
├── ex201f.F90
├── ex202.c
├── ex203.c
├── ex204.c
├── ex205.c
├── ex206.c
├── ex207.c
├── ex208.c
├── ex209.c
├── ex209f.F90
├── ex20.c
├── ex210.c
├── ex235.c
├── ex236.c
├── ex237.c
├── ex253.c
├── ex254.c
├── ex255.c
├── ex256.c
├── ex257.c
├── ex258.c
├── ex25.c
├── ex26.c
├── ex27.c
├── ex28.c
├── ex29.c
├── ex2.c
├── ex2k.kokkos.cxx
├── ex300.c
├── ex301.c
├── ex30.c
├── ex31.c
├── ex32.c
├── ex33.c
├── ex34.c
├── ex94.c
├── ex95.c
├── ex96.c
├── ex97.c
├── ex98.c
├── ex99.c
├── ex9.c
├── makefile
├── mmio.c
├── mmio.h
├── mmloader.c
├── mmloader.h
└── output
    ├── bench_spmv_1.out
    ├── empty.out
    ├── ex100_1.out
    ├── ex10_1.out
    ├── ex101.out
    ├── ex15_1.out
    ├── ex170_4.out
    ├── ex171_1.out
    ├── ex171f_1.out
    ├── ex17_1.out
    ├── ex172.out
    ├── ex173_1.out
    ├── ex174_dense.out
    ├── ex174_elemental.out
    ├── ex174.out
    ├── ex174_sbaij.out
    ├── ex175.out
    ├── ex177.out
    ├── ex178_1.out
    ├── ex178_2.out
    ├── ex178_5.out
    ├── ex179_1.out
    ├── ex180_1.out
    ├── ex18_0.out
    ├── ex18_10.out
    ├── ex18_11.out
    ├── ex181_1.out
    ├── ex18_12.out
    ├── ex181_2.out
    ├── ex18_13.out
    ├── ex18_14.out
    ├── ex18_15.out
    ├── ex18_16.out
    ├── ex18_17.out
    ├── ex18_1.out
    ├── ex181.out
    ├── ex182_10.out
    ├── ex182_11.out
    ├── ex207_2.out
    ├── ex208_1.out
    ├── ex208_2.out
    ├── ex208_baij_2.out
    ├── ex208_baij.out
    ├── ex208_dense_2.out
    ├── ex208_dense.out
    ├── ex209_1.out
    ├── ex209_2.out
    ├── ex209f_1.out
    ├── ex210_1.out
    ├── ex2_11_A_aijcusparse.out
    ├── ex2_11_A.out
    ├── ex2_11_B.out
    ├── ex21_1.out
    ├── ex212_1.out
    ├── ex2_12_A.out
    ├── ex2_12_B.out
    ├── ex212f_1.out
    ├── ex213_1.out
    ├── ex214_1.out
    ├── ex214_2.out
    ├── ex215.out
    ├── ex218_1.out
    ├── ex219f_1.out
    ├── ex219f_2.out
    ├── ex220_1.out
    ├── ex221_1.out
    ├── ex2_21_aijcusparse.out
    ├── ex2_21.out
    ├── ex22_1.out
    ├── ex222_null.out
    ├── ex2_22.out
    ├── ex2_23.out
    ├── ex2_24.out
    ├── ex225_1.out
    ├── ex226_1.out
    ├── ex226_2.out
    ├── ex226_3.out
...

```

在项目根目录下执行命令来运行单元测试和确定性测试

```bash
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
make test
```

### 2.2.运行结果

```bash
[root@host- build]# make test
     CLINKER arch-linux-c-debug/tests/sys/classes/draw/tests/ex6
        TEST arch-linux-c-debug/tests/counts/sys_classes_draw_tests-ex6_1.counts
 ok sys_classes_draw_tests-ex6_1
 ok diff-sys_classes_draw_tests-ex6_1
        TEST arch-linux-c-debug/tests/counts/sys_classes_draw_tests-ex6_2.counts
 ok sys_classes_draw_tests-ex6_2
 ok diff-sys_classes_draw_tests-ex6_2
        TEST arch-linux-c-debug/tests/counts/sys_classes_draw_tests-ex6_3.counts
 ok sys_classes_draw_tests-ex6_3
 ok diff-sys_classes_draw_tests-ex6_3
        TEST arch-linux-c-debug/tests/counts/sys_classes_draw_tests-ex6_4.counts
 ok sys_classes_draw_tests-ex6_4
 ok diff-sys_classes_draw_tests-ex6_4
        TEST arch-linux-c-debug/tests/counts/sys_classes_draw_tests-ex6_5.counts
 ok sys_classes_draw_tests-ex6_5
 ok diff-sys_classes_draw_tests-ex6_5
        TEST arch-linux-c-debug/tests/counts/sys_classes_draw_tests-ex6_6.counts
 ok sys_classes_draw_tests-ex6_6
 ok diff-sys_classes_draw_tests-ex6_6
        TEST arch-linux-c-debug/tests/counts/sys_classes_draw_tests-ex6_7.counts
 ok sys_classes_draw_tests-ex6_7
 ok diff-sys_classes_draw_tests-ex6_7
        TEST arch-linux-c-debug/tests/counts/sys_classes_draw_tests-ex6_8.counts
 ok sys_classes_draw_tests-ex6_8
 ok diff-sys_classes_draw_tests-ex6_8
          CC arch-linux-c-debug/tests/sys/classes/draw/tests/ex7.o
     CLINKER arch-linux-c-debug/tests/sys/classes/draw/tests/ex7
        TEST arch-linux-c-debug/tests/counts/sys_classes_draw_tests-ex7_1.counts
 ok sys_classes_draw_tests-ex7_1
 ok diff-sys_classes_draw_tests-ex7_1
          CC arch-linux-c-debug/tests/sys/classes/draw/tests/ex9.o
     CLINKER arch-linux-c-debug/tests/sys/classes/draw/tests/ex9
        TEST arch-linux-c-debug/tests/counts/sys_classes_draw_tests-ex9_1.counts
 ok sys_classes_draw_tests-ex9_1
 ok diff-sys_classes_draw_tests-ex9_1
          CC arch-linux-c-debug/tests/sys/classes/random/tests/ex3.o
     CLINKER arch-linux-c-debug/tests/sys/classes/random/tests/ex3
        TEST arch-linux-c-debug/tests/counts/sys_classes_random_tests-ex3_1.counts
 ok sys_classes_random_tests-ex3_1
 ok diff-sys_classes_random_tests-ex3_1
          CC arch-linux-c-debug/tests/sys/classes/random/tutorials/ex1.o
     CLINKER arch-linux-c-debug/tests/sys/classes/random/tutorials/ex1
        TEST arch-linux-c-debug/tests/counts/sys_classes_random_tutorials-ex1_1.counts
 ok sys_classes_random_tutorials-ex1_1
 ok diff-sys_classes_random_tutorials-ex1_1
        TEST arch-linux-c-debug/tests/counts/sys_classes_random_tutorials-ex1_2.counts
 ok sys_classes_random_tutorials-ex1_2
 ok diff-sys_classes_random_tutorials-ex1_2
        TEST arch-linux-c-debug/tests/counts/sys_classes_random_tutorials-ex1_3.counts
 ok sys_classes_random_tutorials-ex1_3
 ok diff-sys_classes_random_tutorials-ex1_3
          CC arch-linux-c-debug/tests/sys/classes/random/tutorials/ex2.o
     CLINKER arch-linux-c-debug/tests/sys/classes/random/tutorials/ex2
        TEST arch-linux-c-debug/tests/counts/sys_classes_random_tutorials-ex2_1.counts
 ok sys_classes_random_tutorials-ex2_1
 ok diff-sys_classes_random_tutorials-ex2_1
          CC arch-linux-c-debug/tests/sys/classes/viewer/tests/ex3.o
     CLINKER arch-linux-c-debug/tests/sys/classes/viewer/tests/ex3
        TEST arch-linux-c-debug/tests/counts/sys_classes_viewer_tests-ex3_1.counts
 ok sys_classes_viewer_tests-ex3_1
 ok diff-sys_classes_viewer_tests-ex3_1
          CC arch-linux-c-debug/tests/sys/classes/viewer/tests/ex4.o
     CLINKER arch-linux-c-debug/tests/sys/classes/viewer/tests/ex4
        TEST arch-linux-c-debug/tests/counts/sys_classes_viewer_tests-ex4_1.counts
 ok sys_classes_viewer_tests-ex4_1
 ok diff-sys_classes_viewer_tests-ex4_1
        TEST arch-linux-c-debug/tests/counts/sys_classes_viewer_tests-ex4_2.counts
 ok sys_classes_viewer_tests-ex4_2
 ok diff-sys_classes_viewer_tests-ex4_2
        TEST arch-linux-c-debug/tests/counts/sys_classes_viewer_tests-ex4_3.counts
 ok sys_classes_viewer_tests-ex4_3
 ok diff-sys_classes_viewer_tests-ex4_3
        TEST arch-linux-c-debug/tests/counts/sys_classes_viewer_tests-ex4_4.counts
 ok sys_classes_viewer_tests-ex4_4
 ok diff-sys_classes_viewer_tests-ex4_4
          CC arch-linux-c-debug/tests/sys/classes/viewer/tests/ex5.o
     CLINKER arch-linux-c-debug/tests/sys/classes/viewer/tests/ex5
        TEST arch-linux-c-debug/tests/counts/sys_classes_viewer_tests-ex5_1.counts
 ok sys_classes_viewer_tests-ex5_1
 ok diff-sys_classes_viewer_tests-ex5_1
          CC arch-linux-c-debug/tests/sys/classes/viewer/tests/ex6.o
     CLINKER arch-linux-c-debug/tests/sys/classes/viewer/tests/ex6
        TEST arch-linux-c-debug/tests/counts/sys_classes_viewer_tests-ex6_nsize-1_stdio.counts
 ok diff-tao_bound_tutorials-plate2f_2
          FC arch-linux-c-debug/tests/tao/leastsquares/tutorials/chwirut1f.o
     FLINKER arch-linux-c-debug/tests/tao/leastsquares/tutorials/chwirut1f
        TEST arch-linux-c-debug/tests/counts/tao_leastsquares_tutorials-chwirut1f_1.counts
 ok tao_leastsquares_tutorials-chwirut1f_1
 ok diff-tao_leastsquares_tutorials-chwirut1f_1
          FC arch-linux-c-debug/tests/tao/leastsquares/tutorials/chwirut2f.o
     FLINKER arch-linux-c-debug/tests/tao/leastsquares/tutorials/chwirut2f
        TEST arch-linux-c-debug/tests/counts/tao_leastsquares_tutorials-chwirut2f_1.counts
 ok tao_leastsquares_tutorials-chwirut2f_1
 ok diff-tao_leastsquares_tutorials-chwirut2f_1
          FC arch-linux-c-debug/tests/tao/unconstrained/tutorials/eptorsion2f.o
     FLINKER arch-linux-c-debug/tests/tao/unconstrained/tutorials/eptorsion2f
        TEST arch-linux-c-debug/tests/counts/tao_unconstrained_tutorials-eptorsion2f_1.counts
 ok tao_unconstrained_tutorials-eptorsion2f_1
 ok diff-tao_unconstrained_tutorials-eptorsion2f_1
        TEST arch-linux-c-debug/tests/counts/tao_unconstrained_tutorials-eptorsion2f_2.counts
 ok tao_unconstrained_tutorials-eptorsion2f_2
 ok diff-tao_unconstrained_tutorials-eptorsion2f_2
        TEST arch-linux-c-debug/tests/counts/tao_unconstrained_tutorials-eptorsion2f_3.counts
 ok tao_unconstrained_tutorials-eptorsion2f_3
 ok diff-tao_unconstrained_tutorials-eptorsion2f_3
          FC arch-linux-c-debug/tests/tao/unconstrained/tutorials/rosenbrock1f.o
     FLINKER arch-linux-c-debug/tests/tao/unconstrained/tutorials/rosenbrock1f
        TEST arch-linux-c-debug/tests/counts/tao_unconstrained_tutorials-rosenbrock1f_1.counts
 ok tao_unconstrained_tutorials-rosenbrock1f_1
 ok diff-tao_unconstrained_tutorials-rosenbrock1f_1
          RM test-rm-tao.F90
          RM test-rm-tao.kokkos.cxx
          RM test-rm-tao.hip.cpp
          RM test-rm-tao.sycl.cxx
          RM test-rm-tao.raja.cxx

# -------------
#   Summary
# -------------
# success 8612/11030 tests (78.1%)
# failed 0/11030 tests (0.0%)
# todo 243/11030 tests (2.2%)
# skip 2175/11030 tests (19.7%)
#
# Wall clock time for tests: 2414 sec
# Approximate CPU time (not incl. build time): 2086.940000000073 sec
#
# Timing summary (actual test time / total CPU time):
#   snes_tutorials-ex56_0: 70.95 sec / 71.15 sec
#   dm_tests-ex36_3dp1: 47.82 sec / 64.56 sec
#   snes_tutorials-ex17_3d_q3_trig_elas: 30.62 sec / 30.74 sec
#   ksp_ksp_tutorials-ex42_tut_3: 28.67 sec / 28.93 sec
#   mat_tests-ex89_allatonce_merged_3D: 27.37 sec / 27.69 sec
total time used: 2416s
SUCCESSFULLY EXECUTED AT 2022-12-13 00:28:48, CONGRADULATIONS!!!
```

测试结果

单元测试运行正常，说明各类型函数和功能都响应正常。测试通过。

## 3.性能测试

### 3.1.测试平台信息对比

|          | arm信息                          | x86信息               |
| -------- | -------------------------------- | --------------------- |
| 操作系统 | openEuler 22.03 (LTS)            | openEuler 22.03 (LTS) |
| 内核版本 | 5.10.0-60.18.0.50.oe2203.aarch64 | 5.15.79.1.oe1.x86_64  |

### 3.2.测试软件环境信息对比

|          | arm信息       | x86信息   |
| -------- | ------------- | --------- |
| gcc      | bisheng 2.1.0 | gcc 9.3.0 |
| mpi      | hmpi1.1.1     | hmpi1.1.1 |
| CMake    | 3.23.1        | 3.23.1    |
| OpenBLAS | 0.3.18        | 0.3.18    |
| lapack   | 3.8.0         | 3.8.0     |
| Python3  | 3.7.10        | 3.7.10    |
| BOOST    | 1.72.0        | 1.72.0    |
| sowing   | 1.1.26        | 1.1.26    |

### 3.3.测试硬件性能信息对比

|        | arm信息     | x86信息  |
| ------ | ----------- | -------- |
| cpu    | Kunpeng 920 |          |
| 核心数 | 16          | 4        |
| 内存   | 32 GB       | 8 GB     |
| 磁盘io | 1.3 GB/s    | 400 MB/s |
| 虚拟化 | KVM         | KVM      |

### 3.4.测试选择的案例

src/ksp/ksp/tutorials/ex10 目录下的文件 KSP Tutorial ex10

该代码从二进制文件中加载矩阵和右侧向量，然后求解得到的线性系统;然后程序对第二个线性系统重复这个过程。

输入文件地址：
`https://ftp.mcs.anl.gov/pub/petsc/Datafiles/matrices/medium`
`https://ftp.mcs.anl.gov/pub/petsc/Datafiles/matrices/arco6`

测试文件（部分）如下

```c
static char help[] = "Solve a small system and a large system through preloading\n\
  Input arguments are:\n\
  -permute <natural,rcm,nd,...> : solve system in permuted indexing\n\
  -f0 <small_sys_binary> -f1 <large_sys_binary> \n\n";

/*
  Include "petscksp.h" so that we can use KSP solvers.  Note that this file
  automatically includes:
     petscsys.h       - base PETSc routines   petscvec.h - vectors
     petscmat.h - matrices
     petscis.h     - index sets            petscksp.h - Krylov subspace methods
     petscviewer.h - viewers               petscpc.h  - preconditioners
*/
#include <petscksp.h>

typedef enum {
  RHS_FILE,
  RHS_ONE,
  RHS_RANDOM
} RHSType;
const char *const RHSTypes[] = {"FILE", "ONE", "RANDOM", "RHSType", "RHS_", NULL};

PetscErrorCode CheckResult(KSP *ksp, Mat *A, Vec *b, Vec *x, IS *rowperm)
{
  PetscReal norm; /* norm of solution error */
  PetscInt  its;
  PetscFunctionBegin;
  PetscCall(KSPGetTotalIterations(*ksp, &its));
  PetscCall(PetscPrintf(PETSC_COMM_WORLD, "Number of iterations = %" PetscInt_FMT "\n", its));

  PetscCall(KSPGetResidualNorm(*ksp, &norm));
  if (norm < 1.e-12) {
    PetscCall(PetscPrintf(PETSC_COMM_WORLD, "Residual norm < 1.e-12\n"));
  } else {
    PetscCall(PetscPrintf(PETSC_COMM_WORLD, "Residual norm %e\n", (double)norm));
  }

  PetscCall(KSPDestroy(ksp));
  PetscCall(MatDestroy(A));
  PetscCall(VecDestroy(x));
  PetscCall(VecDestroy(b));
  PetscCall(ISDestroy(rowperm));
  PetscFunctionReturn(0);
}

PetscErrorCode CreateSystem(const char filename[PETSC_MAX_PATH_LEN], RHSType rhstype, MatOrderingType ordering, PetscBool permute, IS *rowperm_out, Mat *A_out, Vec *b_out, Vec *x_out)
{
  Vec                x, b, b2;
  Mat                A;      /* linear system matrix */
  PetscViewer        viewer; /* viewer */
  PetscBool          same;
  PetscInt           j, len, start, idx, n1, n2;
  const PetscScalar *val;
  IS                 rowperm = NULL, colperm = NULL;

  PetscFunctionBegin;
  /* open binary file. Note that we use FILE_MODE_READ to indicate reading from this file */
  PetscCall(PetscViewerBinaryOpen(PETSC_COMM_WORLD, filename, FILE_MODE_READ, &viewer));

  /* load the matrix and vector; then destroy the viewer */
  PetscCall(MatCreate(PETSC_COMM_WORLD, &A));
  PetscCall(MatSetFromOptions(A));
  PetscCall(MatLoad(A, viewer));
  switch (rhstype) {
  case RHS_FILE:
    /* Vectors in the file might a different size than the matrix so we need a
     * Vec whose size hasn't been set yet.  It'll get fixed below.  Otherwise we
     * can create the correct size Vec. */
    PetscCall(VecCreate(PETSC_COMM_WORLD, &b));
    PetscCall(VecLoad(b, viewer));
    break;
  case RHS_ONE:
    PetscCall(MatCreateVecs(A, &b, NULL));
    PetscCall(VecSet(b, 1.0));
    break;
  case RHS_RANDOM:
    PetscCall(MatCreateVecs(A, &b, NULL));
    PetscCall(VecSetRandom(b, NULL));
    break;
  }
  PetscCall(PetscViewerDestroy(&viewer));

  /* if the loaded matrix is larger than the vector (due to being padded
     to match the block size of the system), then create a new padded vector
   */
  PetscCall(MatGetLocalSize(A, NULL, &n1));
  PetscCall(VecGetLocalSize(b, &n2));
  same = (n1 == n2) ? PETSC_TRUE : PETSC_FALSE;
  PetscCall(MPIU_Allreduce(MPI_IN_PLACE, &same, 1, MPIU_BOOL, MPI_LAND, PETSC_COMM_WORLD));

  if (!same) { /* create a new vector b by padding the old one */
    PetscCall(VecCreate(PETSC_COMM_WORLD, &b2));
    PetscCall(VecSetSizes(b2, n1, PETSC_DECIDE));
    PetscCall(VecSetFromOptions(b2));
    PetscCall(VecGetOwnershipRange(b, &start, NULL));
    PetscCall(VecGetLocalSize(b, &len));
    PetscCall(VecGetArrayRead(b, &val));
    for (j = 0; j < len; j++) {
      idx = start + j;
      PetscCall(VecSetValues(b2, 1, &idx, val + j, INSERT_VALUES));
    }
    PetscCall(VecRestoreArrayRead(b, &val));
    PetscCall(VecDestroy(&b));
    PetscCall(VecAssemblyBegin(b2));
    PetscCall(VecAssemblyEnd(b2));
    b = b2;
  }
  PetscCall(VecDuplicate(b, &x));

  if (permute) {
    Mat Aperm;
    PetscCall(MatGetOrdering(A, ordering, &rowperm, &colperm));
    PetscCall(MatPermute(A, rowperm, colperm, &Aperm));
    PetscCall(VecPermute(b, colperm, PETSC_FALSE));
    PetscCall(MatDestroy(&A));
    A = Aperm; /* Replace original operator with permuted version */
    PetscCall(ISDestroy(&colperm));
  }

  *b_out       = b;
  *x_out       = x;
  *A_out       = A;
  *rowperm_out = rowperm;

  PetscFunctionReturn(0);
}

/* ATTENTION: this is the example used in the Profiling chaper of the PETSc manual,
   where we referenced its profiling stages, preloading and output etc.
   When you modify it, please make sure it is still consistent with the manual.
 */
int main(int argc, char **args)
{
  Vec       x, b;
  Mat       A;   /* linear system matrix */
  KSP       ksp; /* Krylov subspace method context */
  char      file[2][PETSC_MAX_PATH_LEN], ordering[256] = MATORDERINGRCM;
  RHSType   rhstype = RHS_FILE;
  PetscBool flg, preload = PETSC_FALSE, trans = PETSC_FALSE, permute = PETSC_FALSE;
  IS        rowperm = NULL;

  PetscFunctionBeginUser;
  PetscCall(PetscInitialize(&argc, &args, (char *)0, help));

  PetscOptionsBegin(PETSC_COMM_WORLD, NULL, "Preloading example options", "");
  {
    /*
       Determine files from which we read the two linear systems
       (matrix and right-hand-side vector).
    */
    PetscCall(PetscOptionsBool("-trans", "Solve transpose system instead", "", trans, &trans, &flg));
    PetscCall(PetscOptionsString("-f", "First file to load (small system)", "", file[0], file[0], sizeof(file[0]), &flg));
    PetscCall(PetscOptionsFList("-permute", "Permute matrix and vector to solve in new ordering", "", MatOrderingList, ordering, ordering, sizeof(ordering), &permute));

    if (flg) {
      PetscCall(PetscStrcpy(file[1], file[0]));
      preload = PETSC_FALSE;
    } else {
      PetscCall(PetscOptionsString("-f0", "First file to load (small system)", "", file[0], file[0], sizeof(file[0]), &flg));
      PetscCheck(flg, PETSC_COMM_WORLD, PETSC_ERR_USER_INPUT, "Must indicate binary file with the -f0 or -f option");
      PetscCall(PetscOptionsString("-f1", "Second file to load (larger system)", "", file[1], file[1], sizeof(file[1]), &flg));
      if (!flg) preload = PETSC_FALSE; /* don't bother with second system */
    }

    PetscCall(PetscOptionsEnum("-rhs", "Right hand side", "", RHSTypes, (PetscEnum)rhstype, (PetscEnum *)&rhstype, NULL));
  }
  PetscOptionsEnd();

  /*
    To use preloading, one usually has code like the following:

    PetscPreLoadBegin(preload,"first stage);
      lines of code
    PetscPreLoadStage("second stage");
      lines of code
    PetscPreLoadEnd();

    The two macro PetscPreLoadBegin() and PetscPreLoadEnd() implicitly form a
    loop with maximal two iterations, depending whether preloading is turned on or
    not. If it is, either through the preload arg of PetscPreLoadBegin or through
    -preload command line, the trip count is 2, otherwise it is 1. One can use the
    predefined variable PetscPreLoadIt within the loop body to get the current
    iteration number, which is 0 or 1. If preload is turned on, the runtime doesn't
    do profiling for the first iteration, but it will do profiling for the second
    iteration instead.

    One can solve a small system in the first iteration and a large system in
    the second iteration. This process preloads the instructions with the small
    system so that more accurate performance monitoring (via -log_view) can be done
    with the large one (that actually is the system of interest).

    But in this example, we turned off preloading and duplicated the code for
    the large system. In general, it is a bad practice and one should not duplicate
    code. We do that because we want to show profiling stages for both the small
    system and the large system.
  */

  /*=========================
      solve a small system
    =========================*/

  PetscPreLoadBegin(preload, "Load System 0");
  PetscCall(CreateSystem(file[0], rhstype, ordering, permute, &rowperm, &A, &b, &x));

  PetscPreLoadStage("KSPSetUp 0");
  PetscCall(KSPCreate(PETSC_COMM_WORLD, &ksp));
  PetscCall(KSPSetOperators(ksp, A, A));
  PetscCall(KSPSetFromOptions(ksp));

  /*
    Here we explicitly call KSPSetUp() and KSPSetUpOnBlocks() to
    enable more precise profiling of setting up the preconditioner.
    These calls are optional, since both will be called within
    KSPSolve() if they haven't been called already.
  */
  PetscCall(KSPSetUp(ksp));
  PetscCall(KSPSetUpOnBlocks(ksp));

  PetscPreLoadStage("KSPSolve 0");
  if (trans) PetscCall(KSPSolveTranspose(ksp, b, x));
  else PetscCall(KSPSolve(ksp, b, x));

  if (permute) PetscCall(VecPermute(x, rowperm, PETSC_TRUE));

  PetscCall(CheckResult(&ksp, &A, &b, &x, &rowperm));

  /*=========================
    solve a large system
    =========================*/

  PetscPreLoadStage("Load System 1");

  PetscCall(CreateSystem(file[1], rhstype, ordering, permute, &rowperm, &A, &b, &x));

  PetscPreLoadStage("KSPSetUp 1");
  PetscCall(KSPCreate(PETSC_COMM_WORLD, &ksp));
  PetscCall(KSPSetOperators(ksp, A, A));
  PetscCall(KSPSetFromOptions(ksp));

  /*
    Here we explicitly call KSPSetUp() and KSPSetUpOnBlocks() to
    enable more precise profiling of setting up the preconditioner.
    These calls are optional, since both will be called within
    KSPSolve() if they haven't been called already.
  */
  PetscCall(KSPSetUp(ksp));
  PetscCall(KSPSetUpOnBlocks(ksp));

  PetscPreLoadStage("KSPSolve 1");
  if (trans) PetscCall(KSPSolveTranspose(ksp, b, x));
  else PetscCall(KSPSolve(ksp, b, x));

  if (permute) PetscCall(VecPermute(x, rowperm, PETSC_TRUE));

  PetscCall(CheckResult(&ksp, &A, &b, &x, &rowperm));

  PetscPreLoadEnd();
  /*
     Always call PetscFinalize() before exiting a program.  This routine
       - finalizes the PETSc libraries as well as MPI
       - provides summary and diagnostic information if certain runtime
         options are chosen (e.g., -log_view).
  */
  PetscCall(PetscFinalize());
  return 0;
}

/*TEST

   test:
      TODO: Matrix row/column sizes are not compatible with block size
      suffix: 1
      nsize: 4
      output_file: output/ex10_1.out
      requires: datafilespath double !complex !defined(PETSC_USE_64BIT_INDICES)
      args: -f0 ${DATAFILESPATH}/matrices/medium -f1 ${DATAFILESPATH}/matrices/arco6 -ksp_gmres_classicalgramschmidt -mat_type baij -matload_block_size 3 -pc_type bjacobi

   test:
      TODO: Matrix row/column sizes are not compatible with block size
      suffix: 2
      nsize: 4
      output_file: output/ex10_2.out
      requires: datafilespath double !complex !defined(PETSC_USE_64BIT_INDICES)
      args: -f0 ${DATAFILESPATH}/matrices/medium -f1 ${DATAFILESPATH}/matrices/arco6 -ksp_gmres_classicalgramschmidt -mat_type baij -matload_block_size 3 -pc_type bjacobi -trans

   test:
      suffix: 3
      requires: double complex !defined(PETSC_USE_64BIT_INDICES)
      args: -f ${wPETSC_DIR}/share/petsc/datafiles/matrices/nh-complex-int32-float64 -ksp_type bicg

   test:
      suffix: 4
      args: -f ${DATAFILESPATH}/matrices/medium -ksp_type bicg -permute rcm
      requires: datafilespath double !complex !defined(PETSC_USE_64BIT_INDICES)

TEST*/
```

### 3.5.单线程

单线程运行测试时间对比（五次运行取平均值）

|             | arm    | x86    |
| ----------- | ------ | ------ |
| 实际CPU时间 | 3.133s | 1.266s |
| 用户时间    | 3.248s | 1.670s |

### 3.6.多线程

多线程运行测试时间对比（五次运行取平均值）

|             | arm    | x86    |
| ----------- | ------ | ------ |
| 线程数      | 4      | 4      |
| 实际CPU时间 | 5.600s | 2.734s |
| 用户时间    | 1.536s | 0.871s |

arm多线程时间耗费数据表：

| 线程          | 1     | 2     | 4     | 8     |
| :------------ | ----- | ----- | ----- | ----- |
| 用户时间(s)   | 3.243 | 2.256 | 1.536 | 1.191 |
| 用户态时间(s) | 3.074 | 4.230 | 5.600 | 8.344 |
| 内核态时间(s) | 0.121 | 0.143 | 0.222 | 0.452 |

x86多线程时间耗费数据表：

| 线程            | 1     | 2     | 3     | 4     |
| --------------- | ----- | ----- | ----- | ----- |
| 用户时间 （s）  | 1.383 | 1.064 | 0.848 | 0.895 |
| 用户态时间（s） | 1.243 | 1.849 | 2.098 | 2.963 |
| 内核态时间（s） | 0.100 | 0.127 | 0.156 | 0.240 |

由上表可知，在线程逐渐增加的情况下，所减少的用户时间并非线性关系，线程数增加后，运算用时并未显著下降，且系统调用的时间有较为明显的上升趋势。

### 3.7.测试总结

性能测试arm平台均在x86平台50%以上,且随着线程数的增加，两个平台的对于同一个应用的所耗费的时间差距逐渐减少。

且线程增加并不会无限制减少应用的实际耗费时间，在合理的范围内分配线程数才能更好的利用算力资源。

## 4.精度测试

### 4.1.所选测试案例

src/ksp/ksp/tutorials/ex50.c 目录下的文件 ex50.c

二维网格上的线性泊松方程

测试文件如下

```c
/*   DMDA/KSP solving a system of linear equations.
     Poisson equation in 2D:

     div(grad p) = f,  0 < x,y < 1
     with
       forcing function f = -cos(m*pi*x)*cos(n*pi*y),
       Neuman boundary conditions
        dp/dx = 0 for x = 0, x = 1.
        dp/dy = 0 for y = 0, y = 1.

     Contributed by Michael Boghosian <boghmic@iit.edu>, 2008,
         based on petsc/src/ksp/ksp/tutorials/ex29.c and ex32.c

     Compare to ex66.c

     Example of Usage:
          ./ex50 -da_grid_x 3 -da_grid_y 3 -pc_type mg -da_refine 3 -ksp_monitor -ksp_view -dm_view draw -draw_pause -1
          ./ex50 -da_grid_x 100 -da_grid_y 100 -pc_type mg  -pc_mg_levels 1 -mg_levels_0_pc_type ilu -mg_levels_0_pc_factor_levels 1 -ksp_monitor -ksp_view
          ./ex50 -da_grid_x 100 -da_grid_y 100 -pc_type mg -pc_mg_levels 1 -mg_levels_0_pc_type lu -mg_levels_0_pc_factor_shift_type NONZERO -ksp_monitor
          mpiexec -n 4 ./ex50 -da_grid_x 3 -da_grid_y 3 -pc_type mg -da_refine 10 -ksp_monitor -ksp_view -log_view
*/

static char help[] = "Solves 2D Poisson equation using multigrid.\n\n";

#include <petscdm.h>
#include <petscdmda.h>
#include <petscksp.h>
#include <petscsys.h>
#include <petscvec.h>

extern PetscErrorCode ComputeJacobian(KSP, Mat, Mat, void *);
extern PetscErrorCode ComputeRHS(KSP, Vec, void *);

typedef struct {
  PetscScalar uu, tt;
} UserContext;

int main(int argc, char **argv)
{
  KSP         ksp;
  DM          da;
  UserContext user;

  PetscFunctionBeginUser;
  PetscCall(PetscInitialize(&argc, &argv, (char *)0, help));
  PetscCall(KSPCreate(PETSC_COMM_WORLD, &ksp));
  PetscCall(DMDACreate2d(PETSC_COMM_WORLD, DM_BOUNDARY_NONE, DM_BOUNDARY_NONE, DMDA_STENCIL_STAR, 11, 11, PETSC_DECIDE, PETSC_DECIDE, 1, 1, NULL, NULL, &da));
  PetscCall(DMSetFromOptions(da));
  PetscCall(DMSetUp(da));
  PetscCall(KSPSetDM(ksp, (DM)da));
  PetscCall(DMSetApplicationContext(da, &user));

  user.uu = 1.0;
  user.tt = 1.0;

  PetscCall(KSPSetComputeRHS(ksp, ComputeRHS, &user));
  PetscCall(KSPSetComputeOperators(ksp, ComputeJacobian, &user));
  PetscCall(KSPSetFromOptions(ksp));
  PetscCall(KSPSolve(ksp, NULL, NULL));

  PetscCall(DMDestroy(&da));
  PetscCall(KSPDestroy(&ksp));
  PetscCall(PetscFinalize());
  return 0;
}

PetscErrorCode ComputeRHS(KSP ksp, Vec b, void *ctx)
{
  UserContext  *user = (UserContext *)ctx;
  PetscInt      i, j, M, N, xm, ym, xs, ys;
  PetscScalar   Hx, Hy, pi, uu, tt;
  PetscScalar **array;
  DM            da;
  MatNullSpace  nullspace;

  PetscFunctionBeginUser;
  PetscCall(KSPGetDM(ksp, &da));
  PetscCall(DMDAGetInfo(da, 0, &M, &N, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
  uu = user->uu;
  tt = user->tt;
  pi = 4 * atan(1.0);
  Hx = 1.0 / (PetscReal)(M);
  Hy = 1.0 / (PetscReal)(N);

  PetscCall(DMDAGetCorners(da, &xs, &ys, 0, &xm, &ym, 0)); /* Fine grid */
  PetscCall(DMDAVecGetArray(da, b, &array));
  for (j = ys; j < ys + ym; j++) {
    for (i = xs; i < xs + xm; i++) array[j][i] = -PetscCosScalar(uu * pi * ((PetscReal)i + 0.5) * Hx) * PetscCosScalar(tt * pi * ((PetscReal)j + 0.5) * Hy) * Hx * Hy;
  }
  PetscCall(DMDAVecRestoreArray(da, b, &array));
  PetscCall(VecAssemblyBegin(b));
  PetscCall(VecAssemblyEnd(b));

  /* force right hand side to be consistent for singular matrix */
  /* note this is really a hack, normally the model would provide you with a consistent right handside */
  PetscCall(MatNullSpaceCreate(PETSC_COMM_WORLD, PETSC_TRUE, 0, 0, &nullspace));
  PetscCall(MatNullSpaceRemove(nullspace, b));
  PetscCall(MatNullSpaceDestroy(&nullspace));
  PetscFunctionReturn(0);
}

PetscErrorCode ComputeJacobian(KSP ksp, Mat J, Mat jac, void *ctx)
{
  PetscInt     i, j, M, N, xm, ym, xs, ys, num, numi, numj;
  PetscScalar  v[5], Hx, Hy, HydHx, HxdHy;
  MatStencil   row, col[5];
  DM           da;
  MatNullSpace nullspace;

  PetscFunctionBeginUser;
  PetscCall(KSPGetDM(ksp, &da));
  PetscCall(DMDAGetInfo(da, 0, &M, &N, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
  Hx    = 1.0 / (PetscReal)(M);
  Hy    = 1.0 / (PetscReal)(N);
  HxdHy = Hx / Hy;
  HydHx = Hy / Hx;
  PetscCall(DMDAGetCorners(da, &xs, &ys, 0, &xm, &ym, 0));
  for (j = ys; j < ys + ym; j++) {
    for (i = xs; i < xs + xm; i++) {
      row.i = i;
      row.j = j;

      if (i == 0 || j == 0 || i == M - 1 || j == N - 1) {
        num  = 0;
        numi = 0;
        numj = 0;
        if (j != 0) {
          v[num]     = -HxdHy;
          col[num].i = i;
          col[num].j = j - 1;
          num++;
          numj++;
        }
        if (i != 0) {
          v[num]     = -HydHx;
          col[num].i = i - 1;
          col[num].j = j;
          num++;
          numi++;
        }
        if (i != M - 1) {
          v[num]     = -HydHx;
          col[num].i = i + 1;
          col[num].j = j;
          num++;
          numi++;
        }
        if (j != N - 1) {
          v[num]     = -HxdHy;
          col[num].i = i;
          col[num].j = j + 1;
          num++;
          numj++;
        }
        v[num]     = ((PetscReal)(numj)*HxdHy + (PetscReal)(numi)*HydHx);
        col[num].i = i;
        col[num].j = j;
        num++;
        PetscCall(MatSetValuesStencil(jac, 1, &row, num, col, v, INSERT_VALUES));
      } else {
        v[0]     = -HxdHy;
        col[0].i = i;
        col[0].j = j - 1;
        v[1]     = -HydHx;
        col[1].i = i - 1;
        col[1].j = j;
        v[2]     = 2.0 * (HxdHy + HydHx);
        col[2].i = i;
        col[2].j = j;
        v[3]     = -HydHx;
        col[3].i = i + 1;
        col[3].j = j;
        v[4]     = -HxdHy;
        col[4].i = i;
        col[4].j = j + 1;
        PetscCall(MatSetValuesStencil(jac, 1, &row, 5, col, v, INSERT_VALUES));
      }
    }
  }
  PetscCall(MatAssemblyBegin(jac, MAT_FINAL_ASSEMBLY));
  PetscCall(MatAssemblyEnd(jac, MAT_FINAL_ASSEMBLY));

  PetscCall(MatNullSpaceCreate(PETSC_COMM_WORLD, PETSC_TRUE, 0, 0, &nullspace));
  PetscCall(MatSetNullSpace(J, nullspace));
  PetscCall(MatNullSpaceDestroy(&nullspace));
  PetscFunctionReturn(0);
}

/*TEST

   build:
      requires: !complex !single

   test:
      args: -pc_type mg -pc_mg_type full -ksp_type cg -ksp_monitor_short -da_refine 3 -mg_coarse_pc_type svd -ksp_view

   test:
      suffix: 2
      nsize: 4
      args: -pc_type mg -pc_mg_type full -ksp_type cg -ksp_monitor_short -da_refine 3 -mg_coarse_pc_type redundant -mg_coarse_redundant_pc_type svd -ksp_view

   test:
      suffix: 3
      nsize: 2
      args: -pc_type mg -pc_mg_type full -ksp_monitor_short -da_refine 5 -mg_coarse_ksp_type cg -mg_coarse_ksp_converged_reason -mg_coarse_ksp_rtol 1e-2 -mg_coarse_ksp_max_it 5 -mg_coarse_pc_type none -pc_mg_levels 2 -ksp_type pipefgmres -ksp_pipefgmres_shift 1.5

   test:
      suffix: tut_1
      nsize: 1
      args: -da_grid_x 4 -da_grid_y 4 -mat_view

   test:
      suffix: tut_2
      requires: superlu_dist parmetis
      nsize: 4
      args: -da_grid_x 120 -da_grid_y 120 -pc_type lu -pc_factor_mat_solver_type superlu_dist -ksp_monitor -ksp_view

   test:
      suffix: tut_3
      nsize: 4
      args: -da_grid_x 1025 -da_grid_y 1025 -pc_type mg -pc_mg_levels 9 -ksp_monitor

TEST*/
```

### 4.2.获取对比数据

arm 运行结果(部分)

```bash
  0 KSP Residual norm 3.039809126331e+00 
  1 KSP Residual norm 2.315114032714e-13 
KSP Object: 4 MPI processes
  type: gmres
    restart=30, using Classical (unmodified) Gram-Schmidt Orthogonalization with no iterative refinement
    happy breakdown tolerance 1e-30
  maximum iterations=10000, initial guess is zero
  tolerances:  relative=1e-05, absolute=1e-50, divergence=10000.
  left preconditioning
  using PRECONDITIONED norm type for convergence test
PC Object: 4 MPI processes
  type: lu
    out-of-place factorization
    tolerance for zero pivot 2.22045e-14
    matrix ordering: external
    factor fill ratio given 0., needed 0.
      Factored matrix follows:
        Mat Object: 4 MPI processes
          type: superlu_dist
          rows=14400, cols=14400
          package used to perform factorization: superlu_dist
          total: nonzeros=0, allocated nonzeros=0
            SuperLU_DIST run parameters:
              Process grid nprow 2 x npcol 2 
              Equilibrate matrix TRUE 
              Replace tiny pivots FALSE 
              Use iterative refinement FALSE 
              Processors in row 2 col partition 2 
              Row permutation LargeDiag_MC64
              Column permutation MMD_AT_PLUS_A
              Parallel symbolic factorization FALSE 
              Repeated factorization SamePattern
  linear system matrix = precond matrix:
  Mat Object: 4 MPI processes
    type: mpiaij
    rows=14400, cols=14400
    total: nonzeros=71520, allocated nonzeros=71520
    total number of mallocs used during MatSetValues calls=0
      has attached null space
```

### 4.3.测试总结

从arm输出结果可以看出测试通过，结果在公差之内，所有运算结果偏差在1%以内，偏差较小。