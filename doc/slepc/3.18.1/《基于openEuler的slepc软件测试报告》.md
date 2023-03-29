# 《基于openEuler的slepc软件测试报告》

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
  - slepc_EXTERN
  - slepc_INTERN
  - slepc_UNUSED
  - slepc_RESTRICT
  - slepc_SINGLE_LIBRARY_INTERN
  - slepc_ATTRIBUTE_FORMAT
  - slepc_ATTRIBUTE_MPI_TYPE_TAG
  - slepc_ATTRIBUTE_MPI_POINTER_WITH_TYPE
  - slepc_ATTRIBUTE_MPI_TYPE_TAG_LAYOUT_COMPATIBLE
  - slepc_ATTRIBUTE_COLD
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
  #- slepcCheck
  #- slepcAssert
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
  - slepc_EXTERN
  - slepc_INTERN
  - slepc_NODISCARD
StatementMacros:
  - slepcKernel_A_gets_transpose_A_DECLARE
  - slepc_RETURNS
  - slepc_DECLTYPE_AUTO_RETURNS
  - slepc_NOEXCEPT_AUTO_RETURNS
  - slepc_DECLTYPE_NOEXCEPT_AUTO_RETURNS
  - slepc_UNUSED
TabWidth: 2
UseCRLF: false
UseTab: Never
WhitespaceSensitiveMacros:
  - slepcStringize
  - slepcStringize_
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

在slepc项目根目录下运行,运行结果如下

```bash
⋊> ~/hpcrunner/tmp/slepc-3.18.1 python3 ../count.py
/root/hpcrunner/tmp/slepc-3.18.1
当前文件夹下共有[.out]的文件558个
当前文件夹下共有[.c]的文件452个
当前文件夹下共有[]的文件294个
当前文件夹下共有[.h]的文件84个
当前文件夹下共有[.py]的文件54个
当前文件夹下共有[.F90]的文件23个
当前文件夹下共有[.pyx]的文件15个
当前文件夹下共有[.pxi]的文件14个
当前文件夹下共有[.sample]的文件13个
当前文件夹下共有[.F]的文件13个
当前文件夹下共有[.h90]的文件12个
当前文件夹下共有[.rst]的文件12个
当前文件夹下共有[.tex]的文件9个
当前文件夹下共有[.txt]的文件8个
当前文件夹下共有[.petsc]的文件6个
当前文件夹下共有[.html]的文件5个
当前文件夹下共有[.md]的文件4个
当前文件夹下共有[.png]的文件4个
当前文件夹下共有[.cu]的文件4个
当前文件夹下共有[.sh]的文件3个
当前文件夹下共有[.xml]的文件3个
当前文件夹下共有[.cfg]的文件3个
当前文件夹下共有[.pxd]的文件3个
当前文件夹下共有[.bin]的文件2个
当前文件夹下共有[.cxx]的文件2个
当前文件夹下共有[.pack]的文件1个
当前文件夹下共有[.idx]的文件1个
当前文件夹下共有[.bbl]的文件1个
当前文件夹下共有[.pdf]的文件1个
当前文件夹下共有[.test]的文件1个
当前文件夹下共有[.yml]的文件1个
当前文件夹下共有[.user]的文件1个
当前文件夹下共有[.def]的文件1个
当前文件夹下共有[.bat]的文件1个
当前文件夹下共有[.in]的文件1个
当前文件夹下共有[.i]的文件1个
```

查看上述结果可知主要源码文件后缀名为 `cpp`,`c`,`h`,`py`,`sh`,`c`,`F90`。

### 1.2.统计源码总行数

统计所有源码文件的代码行数

```bash
 find ./ -regex ".*\.hpp\|.*\.h\|.*\.cpp"\|.*\.py"\|.*\.sh"\|.*\.c"\|.*\.F90" \
  | xargs wc -l
```

统计结果

```bash
   166350 total
```

### 1.3.统计不符合要求的总行数

对文件后缀名为 `cpp`,`hpp`,`h`,`py`,`sh`,`c`,`csh`,`cc`,`pl`, 的所有文件进行格式
通过git与clang-format结合的方式进行统计

```bash
[root@host- src]# find . -regex '.*\.\(cpp\|hpp\)' -exec clang-format -style=./src/.clang-format -i {} \; 
[root@host- src]# git commit -m "fomat update"
[main 930608761] fomat update
 34 files changed, 17298 insertions(+), 10425 deletions(-)
 rewrite src/eps/impls/cg/lobpcg/lobpcg.c (84%)
 rewrite src/eps/impls/cg/rqcg/rqcg.c (85%)
 rewrite src/eps/impls/ciss/ciss.c (83%)
 rewrite src/eps/impls/davidson/davidson.c (89%)
 rewrite src/eps/impls/davidson/dvdcalcpairs.c (91%)
 rewrite src/eps/impls/davidson/dvdgd2.c (88%)
 rewrite src/eps/impls/davidson/dvdimprovex.c (91%)
 rewrite src/eps/impls/davidson/dvdinitv.c (82%)
 rewrite src/eps/impls/davidson/dvdschm.c (78%)
 rewrite src/eps/impls/davidson/dvdupdatev.c (92%)
 rewrite src/eps/impls/davidson/dvdutils.c (86%)
 rewrite src/eps/impls/davidson/gd/gd.c (60%)
 rewrite src/eps/impls/davidson/jd/jd.c (61%)
 rewrite src/eps/impls/external/elpa/elpa.c (68%)
 rewrite src/eps/impls/external/evsl/evsl.c (78%)
 rewrite src/eps/impls/external/feast/feast.c (80%)
 rewrite src/eps/impls/external/trlan/trlan.c (88%)
 rewrite src/eps/impls/krylov/arnoldi/arnoldi.c (80%)
 rewrite src/eps/impls/krylov/epskrylov.c (83%)
 rewrite src/eps/impls/krylov/krylovschur/krylovschur.c (71%)
 rewrite src/eps/impls/krylov/krylovschur/krylovschur.h (83%)
 rewrite src/eps/impls/krylov/krylovschur/ks-indef.c (87%)
 rewrite src/eps/impls/krylov/krylovschur/ks-slice.c (93%)
 rewrite src/eps/impls/krylov/krylovschur/ks-twosided.c (90%)
 rewrite src/eps/impls/krylov/lanczos/lanczos.c (85%)
 rewrite src/eps/impls/lapack/lapack.c (89%)
 rewrite src/eps/impls/lyapii/lyapii.c (82%)
 rewrite src/eps/impls/power/power.c (84%)
```

### 1.4.统计结果

综上信息，项目中代码规范性自检检查结果为

通过率    : 93.733%         1-10425/166350*100%

不通过率  : 6.267%            10425/166350*100%

## 2.功能性测试

### 2.1.所选测试案例

slepc内置了大量的单元测试，可以使用其进行单元测试文件内容。

单元测试文件列表（部分）如下

```bash
[root@host- build]# root@zubinshuo-PC 11:46:26 ~/slepc |main ↑1 ✓| → tree tests/
tests/
├── datatest.pkl
├── eps
│   ├── tests
│   │   ├── runtest10_1_gd2.sh
│   │   ├── runtest10_1_lanczos.sh
│   │   ├── runtest10_1_lobpcg.sh
│   │   ├── runtest10_1.sh
│   │   ├── runtest1_10_feast.sh
│   │   ├── runtest11_1_ks_cayley.sh
│   │   ├── runtest11_1.sh
│   │   ├── runtest11_2.sh
│   │   ├── runtest1_1_cholesky.sh
│   │   ├── runtest1_1_ciss_cuda.sh
│   │   ├── runtest1_1_ciss_gnhep.sh
│   │   ├── runtest1_1_ciss_ksps.sh
│   │   ├── runtest1_1_ciss.sh
│   │   ├── runtest1_1_ciss_trapezoidal.sh
│   │   ├── runtest1_1_elemental.sh
│   │   ├── runtest3_1_lanczos.sh
│   │   ├── runtest3_1_power.sh
│   │   ├── runtest3_1_primme.sh
│   │   ├── runtest3_1_scalapack.sh
│   │   ├── runtest3_1.sh
│   │   ├── runtest3_1_trlan.sh
│   │   ├── runtest32_1.sh
│   │   ├── runtest32_2.sh
│   │   ├── runtest32_3_gnhep.sh
│   │   ├── runtest32_3.sh
│   │   ├── runtest32_4_gnhep.sh
│   │   ├── runtest32_4.sh
│   │   ├── runtest32_5_mumps.sh
│   │   ├── runtest32_5_redundant.sh
│   │   ├── runtest32_5_superlu.sh
│   │   ├── runtest3_2_blopex.sh
│   │   ├── runtest3_2_lanczos_delayed.sh
│   │   ├── runtest3_2_lanczos.sh
│   │   ├── runtest3_2_lobpcg.sh
│   │   ├── runtest3_2_rqcg.sh
│   │   ├── runtest3_2_trlan.sh
│   │   ├── runtest34_1.sh
│   │   ├── runtest34_2.sh
│   │   ├── runtest34_3.sh
│   │   ├── runtest35_1.sh
│   │   ├── runtest36_1_elemental.sh
│   │   ├── runtest36_1.sh
│   │   ├── runtest36_2.sh
│   │   ├── runtest37_1.sh
│   │   ├── runtest38_1.sh
│   │   ├── runtest39_1_lanczos.sh
│   │   ├── runtest39_1.sh
│   │   ├── runtest40_1.sh
│   │   ├── runtest41_1.sh
│   │   ├── runtest4_1_arpack.sh
│   │   ├── runtest4_1_primme.sh
│   │   ├── runtest4_1.sh
│   │   ├── runtest4_1_trlan.sh
│   │   ├── runtest42_1_ring.sh
│   │   ├── runtest4_2.sh
│   │   ├── runtest43_1.sh
│   │   ├── runtest5_1_complex.sh
│   │   ├── runtest5_1_gd2_complex.sh
│   │   ├── runtest5_1_gd2.sh
│   │   ├── runtest5_1_gd_complex.sh
│   │   ├── runtest5_1_gd.sh
│   │   ├── runtest5_1_jd_complex.sh
│   │   ├── runtest5_1_jd.sh
│   │   ├── runtest5_1_power_complex.sh
│   │   ├── runtest5_1_power.sh
│   │   ├── runtest5_1.sh
│   │   ├── runtest5_2_arpack.sh
│   │   ├── runtest5_2_blopex_complex.sh
│   │   ├── runtest5_2_blopex.sh
│   │   ├── runtest5_2_trlan.sh
│   │   ├── runtest6_1_arpack.sh
│   │   ├── runtest6_1_gd2.sh
│   │   ├── runtest6_1_power.sh
│   │   ├── runtest6_1.sh
│   │   ├── runtest6_1_trlan.sh
│   │   ├── runtest7f_1.sh
│   │   ├── runtest8_1_elemental.sh
│   │   ├── runtest8_1_gd2.sh
│   │   ├── runtest8_1_gd.sh
│   │   ├── runtest8_1_jd.sh
│   │   ├── runtest8_1_krylovschur_vecs.sh
│   │   ├── runtest8_1_lanczos.sh
│   │   ├── runtest8_1_lapack.sh
│   │   ├── runtest8_1_primme.sh
│   │   ├── runtest8_1.sh
│   │   ├── runtest8_2_arpack.sh
│   │   ├── runtest8_2_lanczos.sh
│   │   ├── runtest8_2_primme.sh
│   │   ├── runtest8_2.sh
│   │   ├── runtest8_3_lanczos.sh
│   │   ├── runtest8_3_lobpcg_quad.sh
│   │   ├── runtest8_3_lobpcg.sh
│   │   ├── runtest8_3_rqcg.sh
│   │   ├── runtest9_1_gd2.sh
│   │   ├── runtest9_1_gd.sh
│   │   ├── runtest9_1.sh
│   │   ├── runtest9_2.sh
│   │   ├── runtest9_3.sh
│   │   ├── runtest9_4.sh
│   │   ├── runtest9_5_arpack.sh
│   │   ├── runtest9_5_ksphpddm.sh
│   │   ├── runtest9_5_pchpddm.sh
│   │   ├── runtest9_5.sh
│   │   ├── runtest9_6_bcgs.sh
│   │   ├── runtest9_6_cheby_interval.sh
│   │   ├── runtest9_6_cheby.sh
│   │   ├── runtest9_6_hankel_cheby.sh
│   │   ├── runtest9_6_hankel.sh
│   │   ├── runtest9_6_refine.sh
│   │   ├── runtest9_6.sh
│   │   ├── runtest9_7_real.sh
│   │   ├── runtest9_7.sh
│   │   └── runtest9_8.sh
│   └── tutorials
│       ├── runex10_1_shell.sh
│       ├── runex10_1_shell_twoside.sh
│       ├── runex10_1_sinvert.sh
│       ├── runex10_1_sinvert_twoside.sh
│       ├── runex2_ciss_1_hpddm.sh
│       ├── runex2_ciss_1.sh
│       ├── runex2_ciss_2_block.sh
│       ├── runex2_ciss_2_hpddm.sh
│       ├── runex2_ciss_2.sh
│       ├── runex2_feast.sh
│       ├── runex30_1.sh
│       ├── runex31_1.sh
│       ├── runex3_1.sh
│       ├── runex34_1.sh
│       ├── runex34_2.sh
│       ├── runex34_3.sh
│       ├── runex34_4.sh
│       ├── runex34_5.sh
│       ├── runex34_6.sh
│       ├── runex35_1.sh
│       ├── runex36_1_quad.sh
│       ├── runex36_1.sh
│       ├── runex36_2.sh
│       ├── runex36_3.sh
│       ├── runex41_1_balance.sh
│       ├── runex41_1.sh
│       ├── runex4_1.sh
│       ├── runex43_1.sh
│       ├── runex43_2.sh
│       ├── runex44_1.sh
│       ├── runex44_2.sh
│       ├── runex46_1.sh
│       ├── runex46_2.sh
│       ├── runex47_1.sh
│       ├── runex49_1_jd.sh
│       ├── runex49_1_lobpcg.sh
│       ├── runex49_1.sh
│       ├── runex49_2_nost.sh
│       ├── runex49_2_par.sh
│       ├── runex49_2.sh
│       ├── runex4_ciss_1.sh
│       ├── runex4_ciss_2.sh
│       ├── runex5_1.sh
│       ├── runex6f90_1.sh
│       ├── runex7_1.sh
│       ├── runex7_3.sh
│       ├── runex7_ciss_1.sh
│       ├── runex9_1.sh
│       ├── runex9_2.sh
│       ├── runex9_3.sh
│       ├── runex9_4_complex.sh
│       ├── runex9_4.sh
│       ├── runex9_5.sh
│       ├── runex9_6.sh
│       ├── runex9_7.sh
│       ├── runex9_8.sh
│       ├── runex9_9.sh
│       ├── X.bin
│       └── Ybus.bin
├── lme
│   ├── tests
│   │   ├── runtest1_1.sh
│   │   ├── runtest1_2.sh
│   │   ├── runtest1_3.sh
│   │   └── runtest2_1.sh
│   └── tutorials
│       ├── runex32_1.sh
│       └── runex32_2.sh
├── mfn
│   ├── tests
│   │   ├── runtest1_1_cuda.sh
│   │   ├── runtest1_1.sh
│   │   ├── runtest1_2_cuda.sh
│   │   ├── runtest1_2.sh
│   │   ├── runtest2_1_cuda.sh
│   │   ├── runtest2_1.sh
│   │   ├── runtest2_3.sh
│   │   ├── runtest3_1.sh
│   │   ├── runtest3_2.sh
│   │   ├── runtest3f_1.sh
│   │   ├── runtest4_1.sh
│   │   └── runtest4_2.sh
│   └── tutorials
│       ├── runex23_1.sh
│       ├── runex23f90_1.sh
│       ├── runex26_1.sh
│       ├── runex37_1.sh
│       ├── runex39_1.sh
│       └── runex39_2.sh
├── nep
│   ├── tests
│   │   ├── runtest10_1_interpol.sh
│   │   ├── runtest10_1_narnoldi.sh
│   │   ├── runtest10_1_narnoldi_sync.sh
│   │   ├── runtest10_1_rii.sh
│   │   ├── runtest10_1.sh
│   │   ├── runtest10_1_slp.sh
│   │   ├── runtest10_2_interpol.sh
│   │   ├── runtest10_2_nleigs_real.sh
│   │   ├── runtest10_2_nleigs.sh
│   │   ├── runtest10_3.sh
│   │   ├── runtest7_2.sh
│   │   ├── runtest8_1.sh
│   │   ├── runtest8_2.sh
│   │   ├── runtest8_3.sh
│   │   ├── runtest8_4.sh
│   │   └── runtest9_1.sh
│   └── tutorials
│       ├── nlevp
│       │   ├── rungun_1.sh
│       │   ├── runloaded_string_1.sh
│       │   ├── runloaded_string_2_mbe.sh
│       │   ├── runloaded_string_2.sh
│       │   ├── runloaded_string_3_explicit.sh
│       │   ├── runloaded_string_3_mbe.sh
│       │   ├── runloaded_string_4.sh
│       │   ├── runloaded_string_5.sh
│       │   ├── runloaded_string_6_complex.sh
│       │   ├── runloaded_string_6.sh
│       │   ├── runloaded_string_7_complex.sh
│       │   ├── runloaded_string_7.sh
│       │   ├── runloaded_string_8_rii_thres.sh
│       │   ├── runloaded_string_8.sh
│       │   ├── runloaded_string_8_slp_thres.sh
│       │   ├── runloaded_string_8_slp_two_thres.sh
│       │   └── runloaded_string_9.sh
│       ├── runex20_1.sh
│       ├── runex20_2_complex.sh
│       ├── runex20_2.sh
│       ├── runex20_3_complex.sh
│       ├── runex20_3.sh
│       ├── runex20_4.sh
│       ├── runex20f90_1.sh
│       ├── runex21_1_rii.sh
│       ├── runex21_1_slp.sh
│       ├── runex22_1_ciss.sh
│       ├── runex22_1.sh
│       ├── runex22_2.sh
│       ├── runex22_3_rii_thres.sh
│       ├── runex22_3.sh
│       ├── runex22_3_simpleu.sh
│       ├── runex22_3_slp_thres.sh
│       ├── runex22_4.sh
│       ├── runex22f90_1.sh
│       ├── runex27_1.sh
│       ├── runex27_2.sh
│       ├── runex27_3.sh
│       ├── runex27_4.sh
│       ├── runex27_5.sh
│       ├── runex27_6.sh
│       ├── runex27_7_par.sh
│       ├── runex27_7.sh
│       ├── runex27_8_hpddm.sh
│       ├── runex27_8_parallel.sh
│       ├── runex27_8.sh
│       ├── runex27_9.sh
│       ├── runex27f90_1.sh
│       ├── runex27f90_2.sh
│       └── runex42_1.sh
├── pep
│   ├── tests
│   │   ├── runtest10_1.sh
│   │   ├── runtest11_1.sh
│   │   ├── runtest1_1_linear_gd.sh
│   │   ├── runtest1_1.sh
│   │   ├── runtest12_1.sh
│   │   ├── runtest13_1.sh
│   │   ├── runtest2_10.sh
│   │   ├── runtest2_11_cuda_linear_gd.sh
│   │   ├── runtest2_11_cuda_qarnoldi.sh
│   │   ├── runtest2_11_cuda.sh
│   │   ├── runtest2_12.sh
│   │   ├── runtest2_13.sh
│   │   ├── runtest2_14.sh
│   │   ├── runtest2_1_linear_gd.sh
│   │   ├── runtest2_1_qarnoldi.sh
│   │   ├── runtest2_1.sh
│   │   ├── runtest2_1_toar_mgs.sh
│   │   ├── runtest2_2_jd.sh
│   │   ├── runtest2_2_linear_explicit_her.sh
│   │   ├── runtest2_2_linear_explicit.sh
│   │   ├── runtest2_2_qarnoldi.sh
│   │   ├── runtest2_2.sh
│   │   ├── runtest2_2_stoar.sh
│   │   ├── runtest2_2_toar_scaleboth.sh
│   │   ├── runtest2_2_toar_transform.sh
│   │   ├── runtest2_3.sh
│   │   ├── runtest2_4_explicit.sh
│   │   ├── runtest2_4_mbe.sh
│   │   ├── runtest2_4_multiple_explicit.sh
│   │   ├── runtest2_4_multiple_mbe.sh
│   │   ├── runtest2_4_multiple_schur.sh
│   │   ├── runtest2_4_schur.sh
│   │   ├── runtest2_5.sh
│   │   ├── runtest2_6.sh
│   │   ├── runtest2_7.sh
│   │   ├── runtest2_8_explicit.sh
│   │   ├── runtest2_8_mbe.sh
│   │   ├── runtest2_8_multiple_explicit.sh
│   │   ├── runtest2_8_multiple_mbe.sh
│   │   ├── runtest2_8_multiple_schur.sh
│   │   ├── runtest2_8_schur.sh
│   │   ├── runtest2_9_explicit.sh
│   │   ├── runtest2_9_mbe.sh
│   │   ├── runtest2_9_multiple_explicit.sh
│   │   ├── runtest2_9_multiple_mbe.sh
│   │   ├── runtest3_1.sh
│   │   ├── runtest3f_1.sh
│   │   ├── runtest4_1_real.sh
│   │   ├── runtest4_1.sh
│   │   ├── runtest5_1.sh
│   │   ├── runtest5_2.sh
│   │   ├── runtest5_3.sh
│   │   ├── runtest5_4.sh
│   │   ├── runtest5_5.sh
│   │   ├── runtest6_1.sh
│   │   ├── runtest6_2.sh
│   │   ├── runtest7_1.sh
│   │   ├── runtest8_1.sh
│   │   └── runtest9_1.sh
│   └── tutorials
│       ├── nlevp
│       │   ├── runacoustic_wave_1d_1.sh
│       │   ├── runacoustic_wave_1d_1_stoar.sh
│       │   ├── runacoustic_wave_1d_2.sh
│       │   ├── runacoustic_wave_1d_3.sh
│       │   ├── runacoustic_wave_1d_4.sh
│       │   ├── runacoustic_wave_2d_1.sh
│       │   ├── runacoustic_wave_2d_1_toar.sh
│       │   ├── runacoustic_wave_2d_2_lin_ab.sh
│       │   ├── runacoustic_wave_2d_2_lin_b.sh
│       │   ├── runacoustic_wave_2d_2.sh
│       │   ├── runbutterfly_1_linear.sh
│       │   ├── runbutterfly_1_toar.sh
│       │   ├── runbutterfly_2.sh
│       │   ├── runbutterfly_4_hankel.sh
│       │   ├── runbutterfly_4.sh
│       │   ├── runbutterfly_ciss_caa.sh
│       │   ├── runbutterfly_ciss_hankel.sh
│       │   ├── runbutterfly_ciss_part.sh
│       │   ├── runbutterfly_ciss_refine.sh
│       │   ├── runbutterfly_ciss_ritz.sh
│       │   ├── rundamped_beam_1_complex.sh
│       │   ├── rundamped_beam_1_jd_complex.sh
│       │   ├── rundamped_beam_1_jd.sh
│       │   ├── rundamped_beam_1_qarnoldi_complex.sh
│       │   ├── rundamped_beam_1_qarnoldi.sh
│       │   ├── rundamped_beam_1.sh
│       │   ├── runloaded_string_1.sh
│       │   ├── runpdde_stability_1.sh
│       │   ├── runplanar_waveguide_1.sh
│       │   ├── runsleeper_1_qarnoldi.sh
│       │   ├── runsleeper_1.sh
│       │   ├── runsleeper_2_jd.sh
│       │   ├── runsleeper_2_toar.sh
│       │   ├── runsleeper_3.sh
│       │   ├── runsleeper_4.sh
│       │   ├── runspring_1_cuda.sh
│       │   ├── runspring_1_qarnoldi.sh
│       │   ├── runspring_1.sh
│       │   ├── runspring_1_stoar.sh
│       │   ├── runspring_2.sh
│       │   ├── runspring_3.sh
│       │   ├── runspring_4.sh
│       │   ├── runspring_5.sh
│       │   ├── runspring_6.sh
│       │   ├── runwiresaw_1_linear_h1.sh
│       │   ├── runwiresaw_1_linear_h2.sh
│       │   └── runwiresaw_1.sh
│       ├── runex16_1_linear.sh
│       ├── runex16_1_linear_symm.sh
│       ├── runex16_1.sh
│       ├── runex16_1_stoar.sh
│       ├── runex16_1_stoar_t.sh
│       ├── runex16f90_1.sh
│       ├── runex17_1.sh
│       ├── runex28_1.sh
│       ├── runex38_1_complex.sh
│       ├── runex38_1.sh
│       ├── runex38_2.sh
│       ├── runex40_1_complex.sh
│       ├── runex40_1.sh
│       ├── runex40_1_transform_complex.sh
│       ├── runex40_1_transform.sh
│       ├── runex50_1_linear.sh
│       ├── runex50_1.sh
│       ├── runex50_2_par.sh
│       └── runex50_2.sh
├── svd
│   ├── tests
│   │   ├── runtest10_1.sh
│   │   ├── runtest3_1_lanczos_one.sh
│   │   ├── runtest3_1_lanczos.sh
│       ├── runex52_4_cross.sh
│       ├── runex52_4_cyclic.sh
│       ├── runex52_5_cross.sh
│       ├── runex52_5_cyclic.sh
│       └── runex8_1.sh
├── sys
│   ├── classes
│   │   ├── bv
│   │   │   └── tests
│   │   │       ├── runtest10_1_cuda.sh
│   │   │       ├── runtest10_1.sh
│   │   │       ├── runtest11_11_cuda.sh
│   │   │       ├── runtest11_11.sh
│   │   │       ├── runtest11_12_cuda.sh
│   │   │       ├── runtest11_12.sh
│   │   │       ├── runtest11_1_cuda.sh
│   │   │       ├── runtest11_1.sh
│   │   │       ├── runtest11_4_cuda.sh
│   │   │       ├── runtest11_4.sh
│   │   │       ├── runtest11_6_cuda.sh
│   │   │       ├── runtest11_6.sh
│   │   │       ├── runtest11_9_cuda.sh
│   │   │       ├── runtest11_9.sh
│   │   │       ├── runtest1_1_bv_type-contiguous.sh
│   │   │       ├── runtest1_1_bv_type-mat.sh
│   │   │       ├── runtest1_1_bv_type-svec.sh
│   │   │       ├── runtest1_1_bv_type-vecs.sh
│   │   │       ├── runtest1_1_cuda_mat.sh
│   │   │       ├── runtest1_1_cuda.sh
│   │   │       ├── runtest12_1.sh
│   │   │       ├── runtest1_2_bv_type-contiguous.sh
│   │   │       ├── runtest1_2_bv_type-mat.sh
│   │   │       ├── runtest1_2_bv_type-svec.sh
│   │   │       ├── runtest1_2_bv_type-vecs.sh
│   │   │       ├── runtest1_2_cuda_mat.sh
│   │   │       ├── runtest1_2_cuda.sh
│   │   │       ├── runtest13_1_cuda.sh
│   │   │       ├── runtest13_1.sh
│   │   │       ├── runtest14_1.sh
│   │   │       ├── runtest15_1_cuda.sh
│   │   │       ├── runtest15_1.sh
│   │   │       ├── runtest15_2_cuda.sh
│   │   │       ├── runtest15_2.sh
│   │   │       ├── runtest8_4_cuda.sh
│   │   │       ├── runtest8_4.sh
│   │   │       ├── runtest9_1_cuda.sh
│   │   │       ├── runtest9_1.sh
│   │   │       ├── runtest9_1_svec_vecs.sh
│   │   │       ├── runtest9_2.sh
│   │   │       └── runtest9_2_svec_vecs.sh
│   │   ├── ds
│   │   │   └── tests
│   │   │       ├── runtest1_1.sh
│   │   │       ├── runtest12_1.sh
│   │   │       ├── runtest12_2.sh
│   │   │       ├── runtest1_2.sh
│   │   │       ├── runtest13_1.sh
│   │   │       ├── runtest13_2.sh
│   │   │       ├── runtest14f_1.sh
│   │   │       ├── runtest15_1.sh
│   │   │       ├── runtest16_1.sh
│   │   │       ├── runtest17_1_complex.sh
│   │   │       ├── runtest17_1.sh
│   │   │       ├── runtest18_1.sh
│   │   │       ├── runtest18_2.sh
│   │   │       ├── runtest19_1.sh
│   │   │       ├── runtest20_1.sh
│   │   │       ├── runtest21_1.sh
│   │   │       ├── runtest21_2.sh
│   │   │       ├── runtest2_1.sh
│   │   │       ├── runtest8_1.sh
│   │   │       ├── runtest8_2.sh
│   │   │       ├── runtest8_3.sh
│   │   │       └── runtest9_1.sh
│   │   ├── fn
│   │   │   └── tests
│   │   │       ├── runtest10_1.sh
│   │   │       ├── runtest11_1_cuda.sh
│   │   │       ├── runtest11_1.sh
│   │   │       ├── runtest11_2_cuda.sh
│   │   │       ├── runtest11_2.sh
│   │   │       ├── runtest5_1.sh
│   │   │       ├── runtest5_2_cuda.sh
│   │   │       ├── runtest5_2.sh
│   │   │       ├── runtest6_1_cuda.sh
│   │   │       ├── runtest6_1.sh
│   │   │       ├── runtest6_2_cuda.sh
│   │   │       ├── runtest6_2.sh
│   │   │       ├── runtest7_1_cuda.sh
│   │   │       ├── runtest7_1_magma.sh
│   │   │       ├── runtest7_1_sadeghi.sh
│   │   │       ├── runtest7_1.sh
│   │   │       ├── runtest7_2_cuda.sh
│   │   │       ├── runtest7_2_magma.sh
│   │   │       ├── runtest7_2_sadeghi.sh
│   │   │       ├── runtest7_2.sh
│   │   │       ├── runtest7_3_inplace.sh
│   │   │       ├── runtest7_3.sh
│   │   │       ├── runtest7f_1.sh
│   │   │       ├── runtest8_1_cuda.sh
│   │   │       ├── runtest8_1_magma.sh
│   │   │       ├── runtest8_1.sh
│   │   │       ├── runtest8_2_cuda.sh
│   │   │       ├── runtest8_2_magma.sh
│   │   │       ├── runtest8_2.sh
│   │   │       └── runtest9_1.sh
│   │   ├── rg
│   │   │   └── tests
│   │   │       ├── runtest1_1_complex.sh
│   │   │       ├── runtest1_1.sh
│   │   │       ├── runtest1_2_complex.sh
│   │   │       ├── runtest3_2.sh
│   │   │       ├── runtest3_3_ellipse.sh
│   │   │       ├── runtest3_3_interval.sh
│   │   │       ├── runtest3_3_ring.sh
│   │   │       ├── runtest3_4_ellipse.sh
│   │   │       ├── runtest3_4_interval.sh
│   │   │       └── runtest3_4_ring.sh
│   │   └── st
│   │       └── tests
│   │           ├── runtest1_1.sh
│   │           ├── runtest2_1.sh
│   │           ├── runtest3_1.sh
│   │           ├── runtest4_1.sh
│   │           ├── runtest4_2.sh
│   │           ├── runtest5_1.sh
│   │           ├── runtest6_1_st_matmode-copy.sh
│   │           ├── runtest6_1_st_matmode-inplace.sh
│   │           ├── runtest6_1_st_matmode-shell.sh
│   │           ├── runtest7_1_st_type-cayley.sh
│   │           ├── runtest7_1_st_type-shift.sh
│   │           ├── runtest7_1_st_type-sinvert.sh
│   │           ├── runtest8_1_st_type-cayley.sh
│   │           ├── runtest8_1_st_type-shift.sh
│   │           ├── runtest8_1_st_type-sinvert.sh
│   │           ├── runtest9_1_st_type-shift.sh
│   │           └── runtest9_1_st_type-sinvert.sh
│   ├── mat
│   │   └── tests
│   │       ├── runtest1_1.sh
│   │       └── runtest1_2.sh
│   ├── tests
│   │   ├── runtest1_1.sh
│   │   ├── runtest2_1.sh
│   │   ├── runtest3_arpack.sh
│   │   ├── runtest3_no-arpack.sh
│   │   ├── runtest3_no-primme.sh
│   │   ├── runtest3_primme.sh
│   │   ├── runtest4_1.sh
│   │   └── runtest4_2.sh
│   ├── tutorials
│   │   └── runex33_1.sh
│   └── vec
│       └── tests
│           ├── runtest1_1.sh
│           └── runtest1_2.sh
└── testfiles

38 directories, 954 files
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
ok svd_tutorials-ex52_3_cross # SKIP PETSC_USE_COMPLEX or SLEPC_USE_COMPLEX requirement not met, Requires DATAFILESPATH
        TEST arch-linux-c-debug/tests/counts/svd_tutorials-ex52_3_cyclic.counts
 ok svd_tutorials-ex52_3_cyclic # SKIP PETSC_USE_COMPLEX or SLEPC_USE_COMPLEX requirement not met, Requires DATAFILESPATH
        TEST arch-linux-c-debug/tests/counts/svd_tutorials-ex52_4_cross.counts
 ok svd_tutorials-ex52_4_cross # SKIP PETSC_USE_COMPLEX or SLEPC_USE_COMPLEX requirement not met, Requires DATAFILESPATH
        TEST arch-linux-c-debug/tests/counts/svd_tutorials-ex52_4_cyclic.counts
 ok svd_tutorials-ex52_4_cyclic # SKIP PETSC_USE_COMPLEX or SLEPC_USE_COMPLEX requirement not met, Requires DATAFILESPATH
        TEST arch-linux-c-debug/tests/counts/svd_tutorials-ex52_5_cross.counts
 ok svd_tutorials-ex52_5_cross
 ok diff-svd_tutorials-ex52_5_cross
        TEST arch-linux-c-debug/tests/counts/svd_tutorials-ex52_5_cyclic.counts
 ok svd_tutorials-ex52_5_cyclic
 ok diff-svd_tutorials-ex52_5_cyclic
          CC arch-linux-c-debug/tests/svd/tutorials/ex8.o
     CLINKER arch-linux-c-debug/tests/svd/tutorials/ex8
        TEST arch-linux-c-debug/tests/counts/svd_tutorials-ex8_1.counts
 ok svd_tutorials-ex8_1
 ok diff-svd_tutorials-ex8_1
          RM test-rm-svd.c
          RM test-rm-svd.cu
          RM test-rm-svd.cxx
          FC arch-linux-c-debug/tests/svd/tests/test4f.o
     FLINKER arch-linux-c-debug/tests/svd/tests/test4f
        TEST arch-linux-c-debug/tests/counts/svd_tests-test4f_1.counts
 ok svd_tests-test4f_1+svd_type-lanczos
 ok diff-svd_tests-test4f_1+svd_type-lanczos
 ok svd_tests-test4f_1+svd_type-trlanczos
 ok diff-svd_tests-test4f_1+svd_type-trlanczos
 ok svd_tests-test4f_1+svd_type-cross
 ok diff-svd_tests-test4f_1+svd_type-cross
 ok svd_tests-test4f_1+svd_type-cyclic
 ok diff-svd_tests-test4f_1+svd_type-cyclic
 ok svd_tests-test4f_1+svd_type-randomized
 ok diff-svd_tests-test4f_1+svd_type-randomized
          FC arch-linux-c-debug/tests/svd/tutorials/ex15f.o
     FLINKER arch-linux-c-debug/tests/svd/tutorials/ex15f
        TEST arch-linux-c-debug/tests/counts/svd_tutorials-ex15f_1.counts
 ok svd_tutorials-ex15f_1
 ok diff-svd_tutorials-ex15f_1
          RM test-rm-svd.F
          RM test-rm-svd.F90
          RM test-rm-svd.kokkos.cxx
          RM test-rm-svd.hip.cpp
          RM test-rm-svd.sycl.cxx
          RM test-rm-svd.raja.cxx
          CC arch-linux-c-debug/tests/pep/tests/test1.o
     CLINKER arch-linux-c-debug/tests/pep/tests/test1
        TEST arch-linux-c-debug/tests/counts/pep_tests-test1_1.counts
 ok pep_tests-test1_1+type-toar
 ok diff-pep_tests-test1_1+type-toar
 ok pep_tests-test1_1+type-qarnoldi
 ok diff-pep_tests-test1_1+type-qarnoldi
 ok pep_tests-test1_1+type-linear
 ok diff-pep_tests-test1_1+type-linear
        TEST arch-linux-c-debug/tests/counts/pep_tests-test1_1_linear_gd.counts
 ok pep_tests-test1_1_linear_gd
 ok diff-pep_tests-test1_1_linear_gd
          CC arch-linux-c-debug/tests/pep/tests/test10.o
     CLINKER arch-linux-c-debug/tests/pep/tests/test10
        TEST arch-linux-c-debug/tests/counts/pep_tests-test10_1.counts
 ok pep_tests-test10_1
 ok diff-pep_tests-test10_1
          CC arch-linux-c-debug/tests/pep/tests/test11.o
     CLINKER arch-linux-c-debug/tests/pep/tests/test11
        TEST arch-linux-c-debug/tests/counts/pep_tests-test11_1.counts
 ok pep_tests-test11_1
 ok diff-pep_tests-test11_1
          CC arch-linux-c-debug/tests/pep/tests/test12.o
     CLINKER arch-linux-c-debug/tests/pep/tests/test12
        TEST arch-linux-c-debug/tests/counts/pep_tests-test12_1.counts
 ok pep_tests-test12_1+pep_type-toar
 ok diff-pep_tests-test12_1+pep_type-toar
 ok pep_tests-test12_1+pep_type-linear
 ok diff-pep_tests-test12_1+pep_type-linear
 ok pep_tests-test12_1+pep_type-qarnoldi
 ok diff-pep_tests-test12_1+pep_type-qarnoldi
        TEST arch-linux-c-debug/tests/counts/pep_tests-test13_1.counts
 ok pep_tests-test13_1 # SKIP PETSC_USE_COMPLEX or SLEPC_USE_COMPLEX requirement not met, PETSC_USE_COMPLEX or SLEPC_USE_COMPLEX requirement not met, PETSC_USE_COMPLEX or SLEPC_USE_COMPLEX requirement not met
          CC arch-linux-c-debug/tests/pep/tests/test2.o
     CLINKER arch-linux-c-debug/tests/pep/tests/test2
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_1.counts
 ok pep_tests-test2_1+pep_type-toar
 ok diff-pep_tests-test2_1+pep_type-toar
 ok pep_tests-test2_1+pep_type-linear
 ok diff-pep_tests-test2_1+pep_type-linear
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_1_toar_mgs.counts
 ok pep_tests-test2_1_toar_mgs
 ok diff-pep_tests-test2_1_toar_mgs
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_1_qarnoldi.counts
 ok pep_tests-test2_1_qarnoldi
 ok diff-pep_tests-test2_1_qarnoldi
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_1_linear_gd.counts
 ok pep_tests-test2_1_linear_gd
 ok diff-pep_tests-test2_1_linear_gd
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_2.counts
 ok pep_tests-test2_2+pep_type-toar
 ok diff-pep_tests-test2_2+pep_type-toar
 ok pep_tests-test2_2+pep_type-linear
 ok diff-pep_tests-test2_2+pep_type-linear
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_2_toar_scaleboth.counts
 ok pep_tests-test2_2_toar_scaleboth
 ok diff-pep_tests-test2_2_toar_scaleboth
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_2_toar_transform.counts
 ok pep_tests-test2_2_toar_transform
 ok diff-pep_tests-test2_2_toar_transform
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_2_qarnoldi.counts
 ok pep_tests-test2_2_qarnoldi
 ok diff-pep_tests-test2_2_qarnoldi
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_2_linear_explicit.counts
 ok pep_tests-test2_2_linear_explicit
 ok diff-pep_tests-test2_2_linear_explicit
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_2_linear_explicit_her.counts
 ok pep_tests-test2_2_linear_explicit_her
 ok diff-pep_tests-test2_2_linear_explicit_her
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_2_stoar.counts
 ok pep_tests-test2_2_stoar
 ok diff-pep_tests-test2_2_stoar
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_2_jd.counts
 ok pep_tests-test2_2_jd
 ok diff-pep_tests-test2_2_jd
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_3.counts
 ok pep_tests-test2_3+pep_extract-none
 ok diff-pep_tests-test2_3+pep_extract-none
 ok pep_tests-test2_3+pep_extract-norm
 ok diff-pep_tests-test2_3+pep_extract-norm
 ok pep_tests-test2_3+pep_extract-residual
 ok diff-pep_tests-test2_3+pep_extract-residual
 ok pep_tests-test2_3+pep_extract-structured
 ok diff-pep_tests-test2_3+pep_extract-structured
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_4_schur.counts
 ok pep_tests-test2_4_schur
 ok diff-pep_tests-test2_4_schur
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_4_mbe.counts
 ok pep_tests-test2_4_mbe
 ok diff-pep_tests-test2_4_mbe
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_4_explicit.counts
 ok pep_tests-test2_4_explicit
 ok diff-pep_tests-test2_4_explicit
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_4_multiple_schur.counts
 ok pep_tests-test2_4_multiple_schur
 ok diff-pep_tests-test2_4_multiple_schur
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_4_multiple_mbe.counts
 ok pep_tests-test2_4_multiple_mbe
 ok diff-pep_tests-test2_4_multiple_mbe
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_4_multiple_explicit.counts
 ok pep_tests-test2_4_multiple_explicit
 ok diff-pep_tests-test2_4_multiple_explicit
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_5.counts
 ok pep_tests-test2_5
 ok diff-pep_tests-test2_5
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_6.counts
 ok pep_tests-test2_6+pep_extract-none
 ok diff-pep_tests-test2_6+pep_extract-none
 ok pep_tests-test2_6+pep_extract-norm
 ok diff-pep_tests-test2_6+pep_extract-norm
 ok pep_tests-test2_6+pep_extract-residual
 ok diff-pep_tests-test2_6+pep_extract-residual
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_7.counts
 ok pep_tests-test2_7+pep_extract-none
 ok diff-pep_tests-test2_7+pep_extract-none
 ok pep_tests-test2_7+pep_extract-norm
 ok diff-pep_tests-test2_7+pep_extract-norm
 ok pep_tests-test2_7+pep_extract-residual
 ok diff-pep_tests-test2_7+pep_extract-residual
 ok pep_tests-test2_7+pep_extract-structured
 ok diff-pep_tests-test2_7+pep_extract-structured
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_8_schur.counts
 ok pep_tests-test2_8_schur
 ok diff-pep_tests-test2_8_schur
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_8_mbe.counts
 ok pep_tests-test2_8_mbe
 ok diff-pep_tests-test2_8_mbe
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_8_explicit.counts
 ok pep_tests-test2_8_explicit
 ok diff-pep_tests-test2_8_explicit
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_8_multiple_schur.counts
 ok pep_tests-test2_8_multiple_schur
 ok diff-pep_tests-test2_8_multiple_schur
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_8_multiple_mbe.counts
 ok pep_tests-test2_8_multiple_mbe
 ok diff-pep_tests-test2_8_multiple_mbe
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_8_multiple_explicit.counts
 ok pep_tests-test2_8_multiple_explicit
 ok diff-pep_tests-test2_8_multiple_explicit
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_9_mbe.counts
 ok pep_tests-test2_9_mbe
 ok diff-pep_tests-test2_9_mbe
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_9_explicit.counts
 ok pep_tests-test2_9_explicit
 ok diff-pep_tests-test2_9_explicit
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_9_multiple_mbe.counts
 ok pep_tests-test2_9_multiple_mbe
 ok diff-pep_tests-test2_9_multiple_mbe
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_9_multiple_explicit.counts
 ok pep_tests-test2_9_multiple_explicit
 ok diff-pep_tests-test2_9_multiple_explicit
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_10.counts
 ok pep_tests-test2_10
 ok diff-pep_tests-test2_10
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_11_cuda.counts
 ok pep_tests-test2_11_cuda # SKIP PETSC_HAVE_CUDA or SLEPC_HAVE_CUDA requirement not met
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_11_cuda_qarnoldi.counts
 ok pep_tests-test2_11_cuda_qarnoldi # SKIP PETSC_HAVE_CUDA or SLEPC_HAVE_CUDA requirement not met
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_11_cuda_linear_gd.counts
 ok pep_tests-test2_11_cuda_linear_gd # SKIP PETSC_HAVE_CUDA or SLEPC_HAVE_CUDA requirement not met
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_12.counts
 ok pep_tests-test2_12
 ok diff-pep_tests-test2_12
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_13.counts
 ok pep_tests-test2_13
 ok diff-pep_tests-test2_13
        TEST arch-linux-c-debug/tests/counts/pep_tests-test2_14.counts
 ok pep_tests-test2_14 # SKIP PETSC_USE_COMPLEX or SLEPC_USE_COMPLEX requirement not met
          CC arch-linux-c-debug/tests/pep/tests/test3.o
     CLINKER arch-linux-c-debug/tests/pep/tests/test3
        TEST arch-linux-c-debug/tests/counts/pep_tests-test3_1.counts
 ok pep_tests-test3_1
 ok diff-pep_tests-test3_1
          CC arch-linux-c-debug/tests/pep/tests/test4.o
     CLINKER arch-linux-c-debug/tests/pep/tests/test4
        TEST arch-linux-c-debug/tests/counts/pep_tests-test4_1_real.counts
 ok pep_tests-test4_1_real
 ok diff-pep_tests-test4_1_real
        TEST arch-linux-c-debug/tests/counts/pep_tests-test4_1.counts
 ok pep_tests-test4_1 # SKIP PETSC_USE_COMPLEX or SLEPC_USE_COMPLEX requirement not met
          CC arch-linux-c-debug/tests/pep/tests/test5.o
     CLINKER arch-linux-c-debug/tests/pep/tests/test5
        TEST arch-linux-c-debug/tests/counts/pep_tests-test5_1.counts
 ok pep_tests-test5_1
 ok diff-pep_tests-test5_1
        TEST arch-linux-c-debug/tests/counts/pep_tests-test5_2.counts
 ok pep_tests-test5_2
 ok diff-pep_tests-test5_2
        TEST arch-linux-c-debug/tests/counts/pep_tests-test5_3.counts
 ok pep_tests-test5_3
 ok diff-pep_tests-test5_3
        TEST arch-linux-c-debug/tests/counts/pep_tests-test5_4.counts
 ok pep_tests-test5_4
 ok diff-pep_tests-test5_4
        TEST arch-linux-c-debug/tests/counts/pep_tests-test5_5.counts
 ok pep_tests-test5_5
 ok diff-pep_tests-test5_5
          CC arch-linux-c-debug/tests/pep/tests/test6.o
     CLINKER arch-linux-c-debug/tests/pep/tests/test6
        TEST arch-linux-c-debug/tests/counts/pep_tests-test6_1.counts
 ok pep_tests-test6_1+pep_type-toar
 ok diff-pep_tests-test6_1+pep_type-toar
 ok pep_tests-test6_1+pep_type-qarnoldi
 ok diff-pep_tests-test6_1+pep_type-qarnoldi
 ok pep_tests-test6_1+pep_type-linear
 ok diff-pep_tests-test6_1+pep_type-linear
        TEST arch-linux-c-debug/tests/counts/pep_tests-test6_2.counts
 ok pep_tests-test6_2
 ok diff-pep_tests-test6_2
          CC arch-linux-c-debug/tests/pep/tests/test7.o
     CLINKER arch-linux-c-debug/tests/pep/tests/test7
        TEST arch-linux-c-debug/tests/counts/pep_tests-test7_1.counts
 ok pep_tests-test7_1
 ok diff-pep_tests-test7_1
          CC arch-linux-c-debug/tests/pep/tests/test8.o
     CLINKER arch-linux-c-debug/tests/pep/tests/test8
        TEST arch-linux-c-debug/tests/counts/pep_tests-test8_1.counts
 ok pep_tests-test8_1
 ok diff-pep_tests-test8_1
          CC arch-linux-c-debug/tests/pep/tests/test9.o
     CLINKER arch-linux-c-debug/tests/pep/tests/test9
        TEST arch-linux-c-debug/tests/counts/pep_tests-test9_1.counts
 ok pep_tests-test9_1
         CC arch-linux-c-debug/tests/mfn/tutorials/ex26.o
     CLINKER arch-linux-c-debug/tests/mfn/tutorials/ex26
        TEST arch-linux-c-debug/tests/counts/mfn_tutorials-ex26_1.counts
 ok mfn_tutorials-ex26_1
 ok diff-mfn_tutorials-ex26_1
          CC arch-linux-c-debug/tests/mfn/tutorials/ex37.o
     CLINKER arch-linux-c-debug/tests/mfn/tutorials/ex37
        TEST arch-linux-c-debug/tests/counts/mfn_tutorials-ex37_1.counts
 ok mfn_tutorials-ex37_1
 ok diff-mfn_tutorials-ex37_1
          CC arch-linux-c-debug/tests/mfn/tutorials/ex39.o
     CLINKER arch-linux-c-debug/tests/mfn/tutorials/ex39
        TEST arch-linux-c-debug/tests/counts/mfn_tutorials-ex39_1.counts
 ok mfn_tutorials-ex39_1
 ok diff-mfn_tutorials-ex39_1
        TEST arch-linux-c-debug/tests/counts/mfn_tutorials-ex39_2.counts
 ok mfn_tutorials-ex39_2
 ok diff-mfn_tutorials-ex39_2
          RM test-rm-mfn.c
          RM test-rm-mfn.cu
          RM test-rm-mfn.cxx
          FC arch-linux-c-debug/tests/mfn/tests/test3f.o
     FLINKER arch-linux-c-debug/tests/mfn/tests/test3f
        TEST arch-linux-c-debug/tests/counts/mfn_tests-test3f_1.counts
 ok mfn_tests-test3f_1
 ok diff-mfn_tests-test3f_1
          RM test-rm-mfn.F
          FC arch-linux-c-debug/tests/mfn/tutorials/ex23f90.o
     FLINKER arch-linux-c-debug/tests/mfn/tutorials/ex23f90
        TEST arch-linux-c-debug/tests/counts/mfn_tutorials-ex23f90_1.counts
 ok mfn_tutorials-ex23f90_1
 ok diff-mfn_tutorials-ex23f90_1
          RM test-rm-mfn.F90
          RM test-rm-mfn.kokkos.cxx
          RM test-rm-mfn.hip.cpp
          RM test-rm-mfn.sycl.cxx
          RM test-rm-mfn.raja.cxx
          CC arch-linux-c-debug/tests/lme/tests/test1.o
     CLINKER arch-linux-c-debug/tests/lme/tests/test1
        TEST arch-linux-c-debug/tests/counts/lme_tests-test1_1.counts
 ok lme_tests-test1_1
 ok diff-lme_tests-test1_1
        TEST arch-linux-c-debug/tests/counts/lme_tests-test1_2.counts
 ok lme_tests-test1_2
 ok diff-lme_tests-test1_2
        TEST arch-linux-c-debug/tests/counts/lme_tests-test1_3.counts
 ok lme_tests-test1_3
 ok diff-lme_tests-test1_3
          CC arch-linux-c-debug/tests/lme/tests/test2.o
     CLINKER arch-linux-c-debug/tests/lme/tests/test2
        TEST arch-linux-c-debug/tests/counts/lme_tests-test2_1.counts
 ok lme_tests-test2_1
 ok diff-lme_tests-test2_1
          CC arch-linux-c-debug/tests/lme/tutorials/ex32.o
     CLINKER arch-linux-c-debug/tests/lme/tutorials/ex32
        TEST arch-linux-c-debug/tests/counts/lme_tutorials-ex32_1.counts
 ok lme_tutorials-ex32_1
 ok diff-lme_tutorials-ex32_1
        TEST arch-linux-c-debug/tests/counts/lme_tutorials-ex32_2.counts
 ok lme_tutorials-ex32_2
 ok diff-lme_tutorials-ex32_2
          RM test-rm-lme.c
          RM test-rm-lme.cu
          RM test-rm-lme.cxx
          RM test-rm-lme.F
          RM test-rm-lme.F90
          RM test-rm-lme.kokkos.cxx
          RM test-rm-lme.hip.cpp
          RM test-rm-lme.sycl.cxx
          RM test-rm-lme.raja.cxx

# -------------
#   Summary    
# -------------
# success 2348/2605 tests (90.1%)
# failed 0/2605 tests (0.0%)
# todo 2/2605 tests (0.1%)
# skip 255/2605 tests (9.8%)
#
# Wall clock time for tests: 482 sec
# Approximate CPU time (not incl. build time): 307.07000000000045 sec
#
# Timing summary (actual test time / total CPU time): 
#   nep_tests-test17_1: 9.84 sec / 28.62 sec
#   eps_tutorials-ex2_4_filter: 7.94 sec / 10.97 sec
#   svd_tutorials-ex52_5_cyclic: 3.74 sec / 3.79 sec
#   nep_tests-test7_2: 3.53 sec / 4.47 sec
#   svd_tutorials-ex51_2: 2.09 sec / 2.19 sec
total time used: 482s
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
| slepc    | 3.18.1        | 3.18.1    |

### 3.3.测试硬件性能信息对比

|        | arm信息     | x86信息  |
| ------ | ----------- | -------- |
| cpu    | Kunpeng 920 |          |
| 核心数 | 16          | 4        |
| 内存   | 32 GB       | 8 GB     |
| 磁盘io | 1.3 GB/s    | 400 MB/s |
| 虚拟化 | KVM         | KVM      |

### 3.4.测试选择的案例

src/eps/tutorials 目录下的文件 eps Tutorial ex5

使用用户提供的 PEP 测试 INTERPOL 求解器。

测试文件如下

```c
/*
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   SLEPc - Scalable Library for Eigenvalue Problem Computations
   Copyright (c) 2002-, Universitat Politecnica de Valencia, Spain

   This file is part of SLEPc.
   SLEPc is distributed under a 2-clause BSD license (see LICENSE).
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/

static char help[] = "Test the INTERPOL solver with a user-provided PEP.\n\n"
  "This is based on ex22.\n"
  "The command line options are:\n"
  "  -n <n>, where <n> = number of grid subdivisions.\n"
  "  -tau <tau>, where <tau> is the delay parameter.\n\n";

/*
   Solve parabolic partial differential equation with time delay tau

            u_t = u_xx + a*u(t) + b*u(t-tau)
            u(0,t) = u(pi,t) = 0

   with a = 20 and b(x) = -4.1+x*(1-exp(x-pi)).

   Discretization leads to a DDE of dimension n

            -u' = A*u(t) + B*u(t-tau)

   which results in the nonlinear eigenproblem

            (-lambda*I + A + exp(-tau*lambda)*B)*u = 0
*/

#include <slepcnep.h>

int main(int argc,char **argv)
{
  NEP            nep;
  PEP            pep;
  Mat            Id,A,B;
  FN             f1,f2,f3;
  RG             rg;
  Mat            mats[3];
  FN             funs[3];
  PetscScalar    coeffs[2],b;
  PetscInt       n=128,nev,Istart,Iend,i,deg;
  PetscReal      tau=0.001,h,a=20,xi,tol;
  PetscBool      terse;

  PetscFunctionBeginUser;
  PetscCall(SlepcInitialize(&argc,&argv,(char*)0,help));
  PetscCall(PetscOptionsGetInt(NULL,NULL,"-n",&n,NULL));
  PetscCall(PetscOptionsGetReal(NULL,NULL,"-tau",&tau,NULL));
  PetscCall(PetscPrintf(PETSC_COMM_WORLD,"\n1-D Delay Eigenproblem, n=%" PetscInt_FMT ", tau=%g\n\n",n,(double)tau));
  h = PETSC_PI/(PetscReal)(n+1);

  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      Create a standalone PEP and RG objects with appropriate settings
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  PetscCall(PEPCreate(PETSC_COMM_WORLD,&pep));
  PetscCall(PEPSetType(pep,PEPTOAR));
  PetscCall(PEPSetFromOptions(pep));

  PetscCall(RGCreate(PETSC_COMM_WORLD,&rg));
  PetscCall(RGSetType(rg,RGINTERVAL));
  PetscCall(RGIntervalSetEndpoints(rg,5,20,-0.1,0.1));
  PetscCall(RGSetFromOptions(rg));

  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     Create nonlinear eigensolver context
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  PetscCall(NEPCreate(PETSC_COMM_WORLD,&nep));

  /* Identity matrix */
  PetscCall(MatCreateConstantDiagonal(PETSC_COMM_WORLD,PETSC_DECIDE,PETSC_DECIDE,n,n,1.0,&Id));
  PetscCall(MatSetOption(Id,MAT_HERMITIAN,PETSC_TRUE));

  /* A = 1/h^2*tridiag(1,-2,1) + a*I */
  PetscCall(MatCreate(PETSC_COMM_WORLD,&A));
  PetscCall(MatSetSizes(A,PETSC_DECIDE,PETSC_DECIDE,n,n));
  PetscCall(MatSetFromOptions(A));
  PetscCall(MatSetUp(A));
  PetscCall(MatGetOwnershipRange(A,&Istart,&Iend));
  for (i=Istart;i<Iend;i++) {
    if (i>0) PetscCall(MatSetValue(A,i,i-1,1.0/(h*h),INSERT_VALUES));
    if (i<n-1) PetscCall(MatSetValue(A,i,i+1,1.0/(h*h),INSERT_VALUES));
    PetscCall(MatSetValue(A,i,i,-2.0/(h*h)+a,INSERT_VALUES));
  }
  PetscCall(MatAssemblyBegin(A,MAT_FINAL_ASSEMBLY));
  PetscCall(MatAssemblyEnd(A,MAT_FINAL_ASSEMBLY));
  PetscCall(MatSetOption(A,MAT_HERMITIAN,PETSC_TRUE));

  /* B = diag(b(xi)) */
  PetscCall(MatCreate(PETSC_COMM_WORLD,&B));
  PetscCall(MatSetSizes(B,PETSC_DECIDE,PETSC_DECIDE,n,n));
  PetscCall(MatSetFromOptions(B));
  PetscCall(MatSetUp(B));
  PetscCall(MatGetOwnershipRange(B,&Istart,&Iend));
  for (i=Istart;i<Iend;i++) {
    xi = (i+1)*h;
    b = -4.1+xi*(1.0-PetscExpReal(xi-PETSC_PI));
    PetscCall(MatSetValues(B,1,&i,1,&i,&b,INSERT_VALUES));
  }
  PetscCall(MatAssemblyBegin(B,MAT_FINAL_ASSEMBLY));
  PetscCall(MatAssemblyEnd(B,MAT_FINAL_ASSEMBLY));
  PetscCall(MatSetOption(B,MAT_HERMITIAN,PETSC_TRUE));

  /* Functions: f1=-lambda, f2=1.0, f3=exp(-tau*lambda) */
  PetscCall(FNCreate(PETSC_COMM_WORLD,&f1));
  PetscCall(FNSetType(f1,FNRATIONAL));
  coeffs[0] = -1.0; coeffs[1] = 0.0;
  PetscCall(FNRationalSetNumerator(f1,2,coeffs));

  PetscCall(FNCreate(PETSC_COMM_WORLD,&f2));
  PetscCall(FNSetType(f2,FNRATIONAL));
  coeffs[0] = 1.0;
  PetscCall(FNRationalSetNumerator(f2,1,coeffs));

  PetscCall(FNCreate(PETSC_COMM_WORLD,&f3));
  PetscCall(FNSetType(f3,FNEXP));
  PetscCall(FNSetScale(f3,-tau,1.0));

  /* Set the split operator */
  mats[0] = A;  funs[0] = f2;
  mats[1] = Id; funs[1] = f1;
  mats[2] = B;  funs[2] = f3;
  PetscCall(NEPSetSplitOperator(nep,3,mats,funs,SUBSET_NONZERO_PATTERN));

  /* Customize nonlinear solver; set runtime options */
  PetscCall(NEPSetType(nep,NEPINTERPOL));
  PetscCall(NEPSetRG(nep,rg));
  PetscCall(NEPInterpolSetPEP(nep,pep));
  PetscCall(NEPInterpolGetInterpolation(nep,&tol,&deg));
  PetscCall(NEPInterpolSetInterpolation(nep,tol,deg+2));  /* increase degree of interpolation */
  PetscCall(NEPSetFromOptions(nep));

  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      Solve the eigensystem
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  PetscCall(NEPSolve(nep));
  PetscCall(NEPGetDimensions(nep,&nev,NULL,NULL));
  PetscCall(PetscPrintf(PETSC_COMM_WORLD," Number of requested eigenvalues: %" PetscInt_FMT "\n",nev));

  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                    Display solution and clean up
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  /* show detailed info unless -terse option is given by user */
  PetscCall(PetscOptionsHasName(NULL,NULL,"-terse",&terse));
  if (terse) PetscCall(NEPErrorView(nep,NEP_ERROR_RELATIVE,NULL));
  else {
    PetscCall(PetscViewerPushFormat(PETSC_VIEWER_STDOUT_WORLD,PETSC_VIEWER_ASCII_INFO_DETAIL));
    PetscCall(NEPConvergedReasonView(nep,PETSC_VIEWER_STDOUT_WORLD));
    PetscCall(NEPErrorView(nep,NEP_ERROR_RELATIVE,PETSC_VIEWER_STDOUT_WORLD));
    PetscCall(PetscViewerPopFormat(PETSC_VIEWER_STDOUT_WORLD));
  }
  PetscCall(NEPDestroy(&nep));
  PetscCall(PEPDestroy(&pep));
  PetscCall(RGDestroy(&rg));
  PetscCall(MatDestroy(&Id));
  PetscCall(MatDestroy(&A));
  PetscCall(MatDestroy(&B));
  PetscCall(FNDestroy(&f1));
  PetscCall(FNDestroy(&f2));
  PetscCall(FNDestroy(&f3));
  PetscCall(SlepcFinalize());
  return 0;
}

/*TEST

   testset:
      args: -nep_nev 3 -nep_target 5 -terse
      output_file: output/test5_1.out
      filter: sed -e "s/[+-]0\.0*i//g"
      requires: !single
      test:
         suffix: 1
      test:
         suffix: 2_cuda
         args: -mat_type aijcusparse
         requires: cuda
      test:
         suffix: 3
         args: -nep_view_values draw
         requires: x

TEST*/
```

### 3.5.单线程

单线程运行测试时间对比（五次运行取平均值）

|             | arm    | x86    |
| ----------- | ------ | ------ |
| 实际CPU时间 | 1.233s | 0.725s |
| 用户时间    | 1.336s | 0.825s |

### 3.6.多线程

多线程运行测试时间对比（五次运行取平均值）

|             | arm    | x86    |
| ----------- | ------ | ------ |
| 线程数      | 4      | 4      |
| 实际CPU时间 | 0.422s | 0.750s |
| 用户时间    | 1.209s | 2.515s |

arm多线程时间耗费数据表：

| 线程          | 1     | 2     | 4     | 8     |
| :------------ | ----- | ----- | ----- | ----- |
| 用户时间(s)   | 1.336 | 1.172 | 0.422 | 1.355 |
| 用户态时间(s) | 1.233 | 2.123 | 1.209 | 9.783 |
| 内核态时间(s) | 0.058 | 0.087 | 0.166 | 0.334 |

x86多线程时间耗费数据表：

| 线程            | 1     | 2     | 3     | 4     |
| --------------- | ----- | ----- | ----- | ----- |
| 用户时间 （s）  | 1.336 | 0.729 | 0.699 | 0.750 |
| 用户态时间（s） | 1.233 | 1.250 | 1.737 | 2.515 |
| 内核态时间（s） | 0.058 | 0.061 | 0.112 | 0.125 |

由上表可知，在线程逐渐增加的情况下，所减少的用户时间并非线性关系，线程数增加后，运算用时并未显著下降，且系统调用的时间有较为明显的上升趋势。

### 3.7.测试总结

性能测试arm平台均在x86平台50%以上,且随着线程数的增加，两个平台的对于同一个应用的所耗费的时间差距逐渐减少。

且线程增加并不会无限制减少应用的实际耗费时间，在合理的范围内分配线程数才能更好的利用算力资源。

## 4.精度测试

### 4.1.所选测试案例

src/pep/tutorials/ 目录下的文件 pep tutorials ex16.c

使用 PEP 求解器求解二次特征值问题。要解决的问题被表述为(λ2M+λC+K)x=0。在示例中，M 是对角矩阵，C 是三对角矩阵，K 是二维拉普拉斯算子。

测试文件如下

```c
/*
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   SLEPc - Scalable Library for Eigenvalue Problem Computations
   Copyright (c) 2002-, Universitat Politecnica de Valencia, Spain

   This file is part of SLEPc.
   SLEPc is distributed under a 2-clause BSD license (see LICENSE).
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/

static char help[] = "Simple quadratic eigenvalue problem.\n\n"
  "The command line options are:\n"
  "  -n <n>, where <n> = number of grid subdivisions in x dimension.\n"
  "  -m <m>, where <m> = number of grid subdivisions in y dimension.\n\n";

#include <slepcpep.h>

int main(int argc,char **argv)
{
  Mat            M,C,K,A[3];      /* problem matrices */
  PEP            pep;             /* polynomial eigenproblem solver context */
  PetscInt       N,n=10,m,Istart,Iend,II,nev,i,j,nconv;
  PetscBool      flag,terse;
  PetscReal      error,re,im;
  PetscScalar    kr,ki;
  Vec            xr,xi;
  BV             V;
  PetscRandom    rand;

  PetscFunctionBeginUser;
  PetscCall(SlepcInitialize(&argc,&argv,(char*)0,help));

  PetscCall(PetscOptionsGetInt(NULL,NULL,"-n",&n,NULL));
  PetscCall(PetscOptionsGetInt(NULL,NULL,"-m",&m,&flag));
  if (!flag) m=n;
  N = n*m;
  PetscCall(PetscPrintf(PETSC_COMM_WORLD,"\nQuadratic Eigenproblem, N=%" PetscInt_FMT " (%" PetscInt_FMT "x%" PetscInt_FMT " grid)\n\n",N,n,m));

  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     Compute the matrices that define the eigensystem, (k^2*M+k*C+K)x=0
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  /* K is the 2-D Laplacian */
  PetscCall(MatCreate(PETSC_COMM_WORLD,&K));
  PetscCall(MatSetSizes(K,PETSC_DECIDE,PETSC_DECIDE,N,N));
  PetscCall(MatSetFromOptions(K));
  PetscCall(MatSetUp(K));
  PetscCall(MatGetOwnershipRange(K,&Istart,&Iend));
  for (II=Istart;II<Iend;II++) {
    i = II/n; j = II-i*n;
    if (i>0) PetscCall(MatSetValue(K,II,II-n,-1.0,INSERT_VALUES));
    if (i<m-1) PetscCall(MatSetValue(K,II,II+n,-1.0,INSERT_VALUES));
    if (j>0) PetscCall(MatSetValue(K,II,II-1,-1.0,INSERT_VALUES));
    if (j<n-1) PetscCall(MatSetValue(K,II,II+1,-1.0,INSERT_VALUES));
    PetscCall(MatSetValue(K,II,II,4.0,INSERT_VALUES));
  }
  PetscCall(MatAssemblyBegin(K,MAT_FINAL_ASSEMBLY));
  PetscCall(MatAssemblyEnd(K,MAT_FINAL_ASSEMBLY));

  /* C is the 1-D Laplacian on horizontal lines */
  PetscCall(MatCreate(PETSC_COMM_WORLD,&C));
  PetscCall(MatSetSizes(C,PETSC_DECIDE,PETSC_DECIDE,N,N));
  PetscCall(MatSetFromOptions(C));
  PetscCall(MatSetUp(C));
  PetscCall(MatGetOwnershipRange(C,&Istart,&Iend));
  for (II=Istart;II<Iend;II++) {
    i = II/n; j = II-i*n;
    if (j>0) PetscCall(MatSetValue(C,II,II-1,-1.0,INSERT_VALUES));
    if (j<n-1) PetscCall(MatSetValue(C,II,II+1,-1.0,INSERT_VALUES));
    PetscCall(MatSetValue(C,II,II,2.0,INSERT_VALUES));
  }
  PetscCall(MatAssemblyBegin(C,MAT_FINAL_ASSEMBLY));
  PetscCall(MatAssemblyEnd(C,MAT_FINAL_ASSEMBLY));

  /* M is a diagonal matrix */
  PetscCall(MatCreate(PETSC_COMM_WORLD,&M));
  PetscCall(MatSetSizes(M,PETSC_DECIDE,PETSC_DECIDE,N,N));
  PetscCall(MatSetFromOptions(M));
  PetscCall(MatSetUp(M));
  PetscCall(MatGetOwnershipRange(M,&Istart,&Iend));
  for (II=Istart;II<Iend;II++) PetscCall(MatSetValue(M,II,II,(PetscReal)(II+1),INSERT_VALUES));
  PetscCall(MatAssemblyBegin(M,MAT_FINAL_ASSEMBLY));
  PetscCall(MatAssemblyEnd(M,MAT_FINAL_ASSEMBLY));

  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                Create the eigensolver and set various options
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  /*
     Create eigensolver context
  */
  PetscCall(PEPCreate(PETSC_COMM_WORLD,&pep));

  /*
     Set matrices and problem type
  */
  A[0] = K; A[1] = C; A[2] = M;
  PetscCall(PEPSetOperators(pep,3,A));
  PetscCall(PEPSetProblemType(pep,PEP_HERMITIAN));

  /*
     In complex scalars, use a real initial vector since in this example
     the matrices are all real, then all vectors generated by the solver
     will have a zero imaginary part. This is not really necessary.
  */
  PetscCall(PEPGetBV(pep,&V));
  PetscCall(BVGetRandomContext(V,&rand));
  PetscCall(PetscRandomSetInterval(rand,-1,1));

  /*
     Set solver parameters at runtime
  */
  PetscCall(PEPSetFromOptions(pep));

  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                      Solve the eigensystem
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  PetscCall(PEPSolve(pep));

  /*
     Optional: Get some information from the solver and display it
  */
  PetscCall(PEPGetDimensions(pep,&nev,NULL,NULL));
  PetscCall(PetscPrintf(PETSC_COMM_WORLD," Number of requested eigenvalues: %" PetscInt_FMT "\n",nev));

  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                    Display solution and clean up
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  /* show detailed info unless -terse option is given by user */
  PetscCall(PetscOptionsHasName(NULL,NULL,"-terse",&terse));
  if (terse) PetscCall(PEPErrorView(pep,PEP_ERROR_BACKWARD,NULL));
  else {
    PetscCall(PEPGetConverged(pep,&nconv));
    if (nconv>0) {
      PetscCall(MatCreateVecs(M,&xr,&xi));
      /* display eigenvalues and relative errors */
      PetscCall(PetscPrintf(PETSC_COMM_WORLD,
           "\n           k          ||P(k)x||/||kx||\n"
           "   ----------------- ------------------\n"));
      for (i=0;i<nconv;i++) {
        /* get converged eigenpairs */
        PetscCall(PEPGetEigenpair(pep,i,&kr,&ki,xr,xi));
        /* compute the relative error associated to each eigenpair */
        PetscCall(PEPComputeError(pep,i,PEP_ERROR_BACKWARD,&error));
#if defined(PETSC_USE_COMPLEX)
        re = PetscRealPart(kr);
        im = PetscImaginaryPart(kr);
#else
        re = kr;
        im = ki;
#endif
        if (im!=0.0) PetscCall(PetscPrintf(PETSC_COMM_WORLD," %9f%+9fi   %12g\n",(double)re,(double)im,(double)error));
        else PetscCall(PetscPrintf(PETSC_COMM_WORLD,"   %12f       %12g\n",(double)re,(double)error));
      }
      PetscCall(PetscPrintf(PETSC_COMM_WORLD,"\n"));
      PetscCall(VecDestroy(&xr));
      PetscCall(VecDestroy(&xi));
    }
  }
  PetscCall(PEPDestroy(&pep));
  PetscCall(MatDestroy(&M));
  PetscCall(MatDestroy(&C));
  PetscCall(MatDestroy(&K));
  PetscCall(SlepcFinalize());
  return 0;
}

/*TEST

   testset:
      args: -pep_nev 4 -pep_ncv 21 -n 12 -terse
      output_file: output/ex16_1.out
      test:
         suffix: 1
         args: -pep_type {{toar qarnoldi}}
      test:
         suffix: 1_linear
         args: -pep_type linear -pep_linear_explicitmatrix
         requires: !single
      test:
         suffix: 1_linear_symm
         args: -pep_type linear -pep_linear_explicitmatrix -pep_linear_eps_gen_indefinite -pep_scale scalar -pep_linear_bv_definite_tol 1e-12
         requires: !single
      test:
         suffix: 1_stoar
         args: -pep_type stoar -pep_scale scalar
         requires: double !cuda
      test:
         suffix: 1_stoar_t
         args: -pep_type stoar -pep_scale scalar -st_transform
         requires: double !cuda

TEST*/
```

通过Makefile进行编译：

```Makefile
ex16: ex16.o
        -${CLINKER} -o ex16 ex16.o ${SLEPC_PEP_LIB} 
        ${RM} ex16.o

include ${SLEPC_DIR}/lib/slepc/conf/slepc_common
```

运行选项如下：

```bash
mpirun ./ex16 -pep_nev 4 -pep_ncv 24 -pep_smallest_magnitude -pep_tol 1e-5 -pep_view
```

### 4.2.获取对比数据

arm 运行结果

```bash
Quadratic Eigenproblem, N=100 (10x10 grid)

PEP Object: 16 MPI processes
  type: toar
    50% of basis vectors kept after restart
    using the locking variant
  problem type: symmetric polynomial eigenvalue problem
  polynomial represented in MONOMIAL basis
  selected portion of the spectrum: smallest eigenvalues in magnitude
  number of eigenvalues (nev): 4
  number of column vectors (ncv): 24
  maximum dimension of projected problem (mpd): 24
  maximum number of iterations: 100
  tolerance: 1e-05
  convergence test: relative to the eigenvalue
  extraction type: NORM
BV Object: 16 MPI processes
  type: svec
  26 columns of global length 100
  vector orthogonalization method: classical Gram-Schmidt
  orthogonalization refinement: if needed (eta: 0.7071)
  block orthogonalization method: GS
  doing matmult as a single matrix-matrix product
DS Object: 16 MPI processes
  type: nhep
  parallel operation mode: REDUNDANT
ST Object: 16 MPI processes
  type: shift
  shift: 0.
  number of matrices: 3
  nonzero pattern of the matrices: UNKNOWN
  KSP Object: (st_) 16 MPI processes
    type: preonly
    maximum iterations=10000, initial guess is zero
    tolerances:  relative=1e-08, absolute=1e-50, divergence=10000.
    left preconditioning
    using NONE norm type for convergence test
  PC Object: (st_) 16 MPI processes
    type: lu
      out-of-place factorization
      tolerance for zero pivot 2.22045e-14
      matrix ordering: external
      factor fill ratio given 0., needed 0.
        Factored matrix follows:
          Mat Object: (st_) 16 MPI processes
            type: superlu_dist
            rows=100, cols=100
            package used to perform factorization: superlu_dist
            total: nonzeros=0, allocated nonzeros=0
              SuperLU_DIST run parameters:
                Process grid nprow 4 x npcol 4 
                Equilibrate matrix TRUE 
                Replace tiny pivots FALSE 
                Use iterative refinement FALSE 
                Processors in row 4 col partition 4 
                Row permutation LargeDiag_MC64
                Column permutation MMD_AT_PLUS_A
                Parallel symbolic factorization FALSE 
                Repeated factorization SamePattern
    linear system matrix = precond matrix:
    Mat Object: (st_) 16 MPI processes
      type: mpiaij
      rows=100, cols=100
      total: nonzeros=100, allocated nonzeros=1000
      total number of mallocs used during MatSetValues calls=0
        not using I-node (on process 0) routines
 Number of requested eigenvalues: 4

           k          ||P(k)x||/||kx||
   ----------------- ------------------
 -0.000679+0.054139i    1.40857e-06
 -0.000679-0.054139i    1.40857e-06
 -0.002339+0.081364i    2.75912e-07
 -0.002339-0.081364i    2.75912e-07
 -0.000813+0.090021i    1.44831e-06
 -0.000813-0.090021i    1.44831e-06
```

### 4.3.测试总结

从arm输出结果可以看出测试通过，结果在公差之内，所有运算结果偏差在1%以内，偏差较小。
