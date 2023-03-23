# 《基于openEuler的opencoarrays软件测试报告》

## 1.规范性自检
使用对项目Clang-Format对文件进行格式化

Clang-Format是一个广泛使用的C代码格式化器。我们在使用编辑器的缩进（TAB）功能时，由于不同编辑器的差别，有的插入的是制表符，有的是2个空格，有的是4个空格。这样如果别人用另一个编辑器来阅读程序时，可能会由于缩进的不同，导致阅读效果一团糟。为了解决这个问题，使用Clang-Format，它可以自动重新缩进，并手动指定空格的数量，自动格式化源文件。它是可以通过命令行使用，也可以作为插件，在其他IDE中使用。

文件格式化配置参考文件`.clang-format`，文件内容如下

```clang-format
---
Language:        Cpp
# BasedOnStyle:  LLVM
AccessModifierOffset: -2
AlignAfterOpenBracket: Align
AlignConsecutiveMacros: false
AlignConsecutiveAssignments: false
AlignConsecutiveDeclarations: false
AlignEscapedNewlines: Right
AlignOperands:   true
AlignTrailingComments: true
AllowAllArgumentsOnNextLine: true
AllowAllConstructorInitializersOnNextLine: true
AllowAllParametersOfDeclarationOnNextLine: true
AllowShortBlocksOnASingleLine: Never
AllowShortCaseLabelsOnASingleLine: false
AllowShortFunctionsOnASingleLine: All
AllowShortLambdasOnASingleLine: All
AllowShortIfStatementsOnASingleLine: Never
AllowShortLoopsOnASingleLine: false
AlwaysBreakAfterDefinitionReturnType: None
AlwaysBreakAfterReturnType: None
AlwaysBreakBeforeMultilineStrings: false
AlwaysBreakTemplateDeclarations: MultiLine
BinPackArguments: true
BinPackParameters: true
BraceWrapping:
  AfterCaseLabel:  false
  AfterClass:      false
  AfterControlStatement: false
  AfterEnum:       false
  AfterFunction:   false
  AfterNamespace:  false
  AfterObjCDeclaration: false
  AfterStruct:     false
  AfterUnion:      false
  AfterExternBlock: false
  BeforeCatch:     false
  BeforeElse:      false
  IndentBraces:    false
  SplitEmptyFunction: true
  SplitEmptyRecord: true
  SplitEmptyNamespace: true
BreakBeforeBinaryOperators: None
BreakBeforeBraces: Attach
BreakBeforeInheritanceComma: false
BreakInheritanceList: BeforeColon
BreakBeforeTernaryOperators: true
BreakConstructorInitializersBeforeComma: false
BreakConstructorInitializers: BeforeColon
BreakAfterJavaFieldAnnotations: false
BreakStringLiterals: true
ColumnLimit:     80
CommentPragmas:  '^ IWYU pragma:'
CompactNamespaces: false
ConstructorInitializerAllOnOneLineOrOnePerLine: false
ConstructorInitializerIndentWidth: 4
ContinuationIndentWidth: 4
Cpp11BracedListStyle: true
DeriveLineEnding: true
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
    SortPriority:    0
  - Regex:           '^(<|"(gtest|gmock|isl|json)/)'
    Priority:        3
    SortPriority:    0
  - Regex:           '.*'
    Priority:        1
    SortPriority:    0
IncludeIsMainRegex: '(Test)?$'
IncludeIsMainSourceRegex: ''
IndentCaseLabels: false
IndentGotoLabels: true
IndentPPDirectives: None
IndentWidth:     2
IndentWrappedFunctionNames: false
JavaScriptQuotes: Leave
JavaScriptWrapImports: true
KeepEmptyLinesAtTheStartOfBlocks: true
MacroBlockBegin: ''
MacroBlockEnd:   ''
MaxEmptyLinesToKeep: 1
NamespaceIndentation: None
ObjCBinPackProtocolList: Auto
ObjCBlockIndentWidth: 2
ObjCSpaceAfterProperty: false
ObjCSpaceBeforeProtocolList: true
PenaltyBreakAssignment: 2
PenaltyBreakBeforeFirstCallParameter: 19
PenaltyBreakComment: 300
PenaltyBreakFirstLessLess: 120
PenaltyBreakString: 1000
PenaltyBreakTemplateDeclaration: 10
PenaltyExcessCharacter: 1000000
PenaltyReturnTypeOnItsOwnLine: 60
PointerAlignment: Right
ReflowComments:  true
SortIncludes:    true
SortUsingDeclarations: true
SpaceAfterCStyleCast: false
SpaceAfterLogicalNot: false
SpaceAfterTemplateKeyword: true
SpaceBeforeAssignmentOperators: true
SpaceBeforeCpp11BracedList: false
SpaceBeforeCtorInitializerColon: true
SpaceBeforeInheritanceColon: true
SpaceBeforeParens: ControlStatements
SpaceBeforeRangeBasedForLoopColon: true
SpaceInEmptyBlock: false
SpaceInEmptyParentheses: false
SpacesBeforeTrailingComments: 1
SpacesInAngles:  false
SpacesInConditionalStatement: false
SpacesInContainerLiterals: true
SpacesInCStyleCastParentheses: false
SpacesInParentheses: false
SpacesInSquareBrackets: false
SpaceBeforeSquareBrackets: false
Standard:        Latest
StatementMacros:
  - Q_UNUSED
  - QT_REQUIRE_VERSION
TabWidth:        8
UseCRLF:         false
UseTab:          Never
...
```

### 1.1.选择统计文件类型

统计项目文件类型及其文件数量

使用python编写脚本文件

```python
# -*- coding: utf-8 -*-

import os

print (os.getcwd())

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

all_files=getAllFiles(os.curdir)
type_dict=dict()

for each_file in all_files:
    if os.path.isdir(each_file):
        type_dict.setdefault("文件夹",0)
        type_dict["文件夹"]+=1
    else:
        ext=os.path.splitext(each_file)[1]
        type_dict.setdefault(ext,0)
        type_dict[ext]+=1

for each_type in type_dict.keys():
    print ("当前文件夹下共有[%s]的文件%d个" %(each_type,type_dict[each_type]))
```

在opencoarrays项目根目录下运行,运行结果如下

```bash
/root/hpcrunner/tmp/OpenCoarrays-2.10.1
当前文件夹下共有[]的文件128个
当前文件夹下共有[.inst]的文件1个
当前文件夹下共有[.in]的文件10个
当前文件夹下共有[.ts]的文件101个
当前文件夹下共有[.x64]的文件2个
当前文件夹下共有[.md]的文件9个
当前文件夹下共有[.f90]的文件91个
当前文件夹下共有[.py]的文件1个
当前文件夹下共有[.smod]的文件2个
当前文件夹下共有[.cmake]的文件302个
当前文件夹下共有[.mod]的文件13个
当前文件夹下共有[.log]的文件3个
当前文件夹下共有[.marks]的文件26个
当前文件夹下共有[.1]的文件2个
当前文件夹下共有[.3]的文件1个
当前文件夹下共有[.stamp]的文件11个
当前文件夹下共有[.out]的文件2个
当前文件夹下共有[.sh]的文件42个
当前文件夹下共有[.internal]的文件16个
当前文件夹下共有[.so]的文件1个
当前文件夹下共有[.with_modules]的文件1个
当前文件夹下共有[.diff]的文件1个
当前文件夹下共有[.pbs]的文件3个
当前文件夹下共有[.F]的文件1个
当前文件夹下共有[.sh-usage]的文件7个
当前文件夹下共有[.bin]的文件5个
当前文件夹下共有[.check_cache]的文件1个
当前文件夹下共有[.make]的文件321个
当前文件夹下共有[.h]的文件3个
当前文件夹下共有[.F90]的文件40个
当前文件夹下共有[.o]的文件20个
当前文件夹下共有[.a]的文件5个
当前文件夹下共有[.c]的文件10个
当前文件夹下共有[.d]的文件4个
当前文件夹下共有[.build]的文件11个
当前文件夹下共有[.txt]的文件65个
```

主要源码文件后缀名为F，h，c以及部分C语言文件。由此判断该项目主要语言为C++/C。

### 1.2.统计源码总行数

统计所有源码文件的代码行数

```bash
find ./ -regex ".*\.c\|.*\.h|.*\.hpp\|.*\.cpp\|.*\.py\|.*\.sh\|.*\.F90" | xargs wc -l
```

统计结果

```bash
24788 total
```

### 1.3.统计不符合要求的总行数

对文件后缀名为c, h, 的所有文件进行格式, 的所有文件进行格式 通过git与clang-format结合的方式进行统计

```bash
[root@host-10-208-134-176 OpenCoarrays-2.10.1]# find . -regex '.*\.\(c\|h\)' | xargs clang-format -style=LLVM -i
[root@host-10-208-134-176 OpenCoarrays-2.10.1]# git add .
[root@host-10-208-134-176 OpenCoarrays-2.10.1]# git commit -m "format"
[master fb93b05] format
 12 files changed, 9716 insertions(+), 10912 deletions(-)
 rewrite OpenCoarrys/OpenCoarrays-2.10.1/doc/sample-compiler-output.c (75%)
 rewrite OpenCoarrys/OpenCoarrays-2.10.1/opencoarrays-build/CMakeFiles/3.23.1/CompilerIdC/CMakeCCompilerId.c (72%)
 rewrite OpenCoarrys/OpenCoarrays-2.10.1/src/runtime-libraries/gasnet/gasnet.c (68%)
 rewrite OpenCoarrys/OpenCoarrays-2.10.1/src/runtime-libraries/openshmem/openshmem_caf.c (71%)
```

### 1.4.统计结果

综上信息，项目中代码规范性自检检查结果为

通过率 : 55.979% 1-10912/24788*100%

不通过率 : 44.021% 10912/24788*100%

## 2.功能性测试

### 2.1.所选测试案例

opencoarrays内置了大量的单元测试，可以使用其进行单元测试文件内容。

单元测试文件列表（部分）如下

```bash
[root@host-10-208-134-176 src]# tree tests
tests
├── CMakeLists.txt
├── installation
│   ├── CMakeLists.txt
│   ├── installation-scripts.sh
│   ├── installation-scripts.sh-usage
│   └── test-stack.sh
├── integration
│   ├── CMakeLists.txt
│   ├── coarrayHelloWorld
│   │   ├── CMakeLists.txt
│   │   └── hello_multiverse.F90
│   ├── dist_transpose
│   │   ├── CMakeLists.txt
│   │   ├── coarray_distributed_transpose.F90
│   │   ├── Makefile_NS_GASNET
│   │   ├── walltime.o
│   │   └── walltime.x64
│   ├── events
│   │   ├── async-hello.F90
│   │   └── CMakeLists.txt
│   └── pde_solvers
│       ├── CMakeLists.txt
│       ├── coarrayBurgers
│       │   ├── CMakeLists.txt
│       │   ├── global_field.F90
│       │   ├── include-files
│       │   │   ├── cray_capabilities.txt
│       │   │   ├── gfortran4.8_capabilities.txt
│       │   │   ├── gfortran_capabilities.txt
│       │   │   ├── ibm_capabilities.txt
│       │   │   ├── intel_capabilities.txt
│       │   │   ├── nag_capabilities.txt
│       │   │   ├── portlandgroup_capabilities.txt
│       │   │   ├── tau_cray_capabilities.txt
│       │   │   └── tau_intel_capabilities.txt
│       │   ├── library
│       │   │   ├── co_object_interface.F90
│       │   │   ├── ForTrilinos_assertion_utility.F90
│       │   │   ├── ForTrilinos_error.F90
│       │   │   └── object_interface.F90
│       │   ├── local_field.F90
│       │   ├── main.F90
│       │   ├── Makefile.inst
│       │   ├── run.sh
│       │   └── scripts
│       │       ├── coarrayBurgers_cce_multiple.pbs
│       │       ├── coarrayBurgers_cce.pbs
│       │       ├── coarrayBurgers_cce_tau.pbs
│       │       ├── run.sh
│       │       ├── run.sh.with_modules
│       │       └── run_troubleshooting.sh
│       ├── coarrayHeatSimplified
│       │   ├── CMakeLists.txt
│       │   ├── global_field.f90
│       │   ├── local_field.f90
│       │   └── main.f90
│       ├── include-files
│       │   ├── cray_capabilities.txt
│       │   ├── gfortran_capabilities.txt
│       │   ├── ibm_capabilities.txt
│       │   ├── intel_capabilities.txt
│       │   ├── nag_capabilities.txt
│       │   ├── portlandgroup_capabilities.txt
│       │   ├── tau_cray_capabilities.txt
│       │   └── tau_intel_capabilities.txt
│       ├── library
│       │   ├── CMakeLists.txt
│       │   ├── co_object_interface.F90
│       │   ├── ForTrilinos_assertion_utility.F90
│       │   ├── ForTrilinos_error.F90
│       │   ├── object_interface.F90
│       │   └── parse_command_line.f90
│       ├── navier-stokes
│       │   ├── CMakeLists.txt
│       │   ├── coarray-shear_coll.F90
│       │   ├── coarray-shear_coll_lock.f90
│       │   ├── coarray-shear.f90
│       │   ├── libfft_avx.a
│       │   ├── libfft_sse.a
│       │   ├── Makefile_NS_GASNET
│       │   ├── mpi-shear.f90
│       │   └── walltime.o
│       └── README.md
├── performance
│   ├── BurgersMPI
│   │   ├── CMakeLists.txt
│   │   ├── input_file.F90
│   │   ├── kind_parameters.F90
│   │   ├── main.F90
│   │   ├── mpi_module.F90
│   │   ├── mpi_share.F90
│   │   ├── periodic_2nd_order.F90
│   │   └── shared.F90
│   ├── CMakeLists.txt
│   ├── mpi_dist_transpose
│   │   ├── CMakeLists.txt
│   │   ├── mpi_distributed_transpose.F90
│   │   ├── walltime.o
│   │   └── walltime.x64
│   └── psnap
│       ├── cafpsnap.f90
│       ├── CMakeLists.txt
│       └── timemeasure.c
├── regression
│   ├── CMakeLists.txt
│   └── reported
│       ├── CMakeLists.txt
│       ├── issue-172-wrong-co_reduce.F90
│       ├── issue-172-wrong-co_reduce-int64.F90
│       ├── issue-172-wrong-co_reduce-int8.F90
│       ├── issue-243-source-allocation-no-sync.f90
│       ├── issue-292-convert-type-before-put.f90
│       ├── issue-322-non-coarray-vector-idx-lhs.f90
│       ├── issue-422-send.F90
│       ├── issue-422-send-get.F90
│       ├── issue-488-multi-dim-cobounds.f90
│       ├── issue-493-coindex-slice.f90
│       ├── issue-503-multidim-array-broadcast.f90
│       ├── issue-503-non-contig-red-ndarray.f90
│       ├── issue-511-incorrect-shape.f90
│       ├── issue-515-mimic-mpi-gatherv.f90
│       ├── issue-552-send_by_ref-singleton.f90
│       ├── issue-700-allow-multiple-scalar-dim-array-gets.f90
│       └── issue-762-mpi-crashing-on-exit.f90
├── UH_CAF_perf_validation_suite_v1.0.1.txt
├── unit
│   ├── CMakeLists.txt
│   ├── collectives
│   │   ├── CMakeLists.txt
│   │   ├── co_broadcast_allocatable_components.f90
│   │   ├── co_broadcast_alloc_mixed.f90
│   │   ├── co_broadcast_derived_type.f90
│   │   ├── co_broadcast.F90
│   │   ├── co_max.F90
│   │   ├── co_min.F90
│   │   ├── co_reduce.F90
│   │   ├── co_reduce_res_im.F90
│   │   ├── co_reduce_string.f90
│   │   └── co_sum.F90
│   ├── events
│   │   ├── allocatable_p2p_event_post.f90
│   │   ├── CMakeLists.txt
│   │   └── static_event_post_issue_293.f90
│   ├── extensions
│   │   └── CMakeLists.txt
│   ├── fail_images
│   │   ├── CMakeLists.txt
│   │   ├── image_fail_and_failed_images_test_1.f90
│   │   ├── image_fail_and_get_test_1.f90
│   │   ├── image_fail_and_status_test_1.f90
│   │   ├── image_fail_and_stopped_images_test_1.f90
│   │   ├── image_fail_and_sync_test_1.f90
│   │   ├── image_fail_and_sync_test_2.f90
│   │   ├── image_fail_and_sync_test_3.f90
│   │   ├── image_fail_test_1.f90
│   │   └── image_status_test_1.f90
│   ├── init_register
│   │   ├── allocate_as_barrier.f90
│   │   ├── allocate_as_barrier_proc.f90
│   │   ├── async_comp_alloc_2.f90
│   │   ├── async_comp_alloc.f90
│   │   ├── CMakeLists.txt
│   │   ├── comp_allocated_1.f90
│   │   ├── comp_allocated_2.f90
│   │   ├── initialize_mpi.F90
│   │   ├── register_alloc_comp_1.f90
│   │   ├── register_alloc_comp_2.f90
│   │   ├── register_alloc_comp_3.f90
│   │   ├── register_alloc_vector.f90
│   │   ├── register.f90
│   │   └── register_vector.f90
│   ├── send-get
│   │   ├── alloc_comp_get_convert_nums.f90
│   │   ├── alloc_comp_multidim_shape.F90
│   │   ├── alloc_comp_send_convert_nums.f90
│   │   ├── CMakeLists.txt
│   │   ├── get_array_test.f90
│   │   ├── get_convert_char_array.f90
│   │   ├── get_convert_nums.f90
│   │   ├── get_static_array.f90
│   │   ├── get_with_offset_1d.f90
│   │   ├── get_with_vector_index.f90
│   │   ├── old_get_array_test.f90
│   │   ├── sameloc.f90
│   │   ├── send_array_test.f90
│   │   ├── send_convert_char_array.f90
│   │   ├── send_convert_nums.f90
│   │   ├── sendget_convert_char_array.f90
│   │   ├── sendget_convert_nums.f90
│   │   ├── send-strided-self.f90
│   │   ├── send_with_vector_index.f90
│   │   ├── strided_get.f90
│   │   ├── strided_sendget.f90
│   │   └── whole_get_array.f90
│   ├── simple
│   │   ├── CMakeLists.txt
│   │   ├── increment_neighbor.f90
│   │   ├── random_init.f90
│   │   ├── syncimages2.c
│   │   └── testAtomics.f90
│   ├── sync
│   │   ├── CMakeLists.txt
│   │   ├── duplicate_syncimages.f90
│   │   ├── syncall.f90
│   │   ├── sync_image_ring_abort_on_stopped_image.f90
│   │   ├── syncimages2.f90
│   │   ├── syncimages.f90
│   │   └── syncimages_status.f90
│   └── teams
│       ├── CMakeLists.txt
│       ├── get-communicator.F90
│       ├── sync-team.f90
│       ├── team-number.f90
│       ├── teams_coarray_get_by_ref.f90
│       ├── teams_coarray_get.f90
│       ├── teams_coarray_send_by_ref.f90
│       ├── teams_coarray_send.f90
│       ├── teams_coarray_sendget.f90
│       ├── teams_send.f90
│       └── teams_subset.f90
└── utilities
    ├── CMakeLists.txt
    ├── oc_assertions_implementation.F90
    ├── oc_assertions_interface.F90
    └── opencoarrays_object_interface.f90
```

在项目根目录下执行命令来运行单元测试和确定性测试

```bash
 export OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 && ctest --output-on-failure --repeat-until-fail 1 --timeout 200
```

### 2.2.运行结果

```bash
Test project /root/hpcrunner/tmp/OpenCoarrays-2.10.1/opencoarrays-build
      Start  1: initialize_mpi
 1/81 Test  #1: initialize_mpi ...................................   Passed    0.13 sec
      Start  2: register
 2/81 Test  #2: register .........................................   Passed    0.12 sec
      Start  3: register_vector
 3/81 Test  #3: register_vector ..................................   Passed    0.12 sec
      Start  4: register_alloc_vector
 4/81 Test  #4: register_alloc_vector ............................   Passed    0.12 sec
      Start  5: allocate_as_barrier
 5/81 Test  #5: allocate_as_barrier ..............................   Passed    1.12 sec
      Start  6: allocate_as_barrier_proc
 6/81 Test  #6: allocate_as_barrier_proc .........................   Passed    1.13 sec
      Start  7: register_alloc_comp_1
 7/81 Test  #7: register_alloc_comp_1 ............................   Passed    0.12 sec
      Start  8: register_alloc_comp_2
 8/81 Test  #8: register_alloc_comp_2 ............................   Passed    0.12 sec
      Start  9: register_alloc_comp_3
 9/81 Test  #9: register_alloc_comp_3 ............................   Passed    0.12 sec
      Start 10: async_comp_alloc
10/81 Test #10: async_comp_alloc .................................   Passed    0.13 sec
      Start 11: async_comp_alloc_2
11/81 Test #11: async_comp_alloc_2 ...............................   Passed    0.12 sec
      Start 12: comp_allocated_1
12/81 Test #12: comp_allocated_1 .................................   Passed    0.12 sec
      Start 13: comp_allocated_2
13/81 Test #13: comp_allocated_2 .................................   Passed    0.12 sec
      Start 14: alloc_comp_get_convert_nums
14/81 Test #14: alloc_comp_get_convert_nums ......................   Passed    0.13 sec
      Start 15: team_number
15/81 Test #15: team_number ......................................   Passed    0.13 sec
      Start 16: teams_subset
16/81 Test #16: teams_subset .....................................   Passed    0.12 sec
      Start 17: get_communicator
17/81 Test #17: get_communicator .................................   Passed    0.12 sec
      Start 18: teams_coarray_get
18/81 Test #18: teams_coarray_get ................................   Passed    0.13 sec
      Start 19: teams_coarray_get_by_ref
19/81 Test #19: teams_coarray_get_by_ref .........................   Passed    0.13 sec
      Start 20: teams_coarray_send
20/81 Test #20: teams_coarray_send ...............................   Passed    0.13 sec
      Start 21: teams_coarray_send_by_ref
21/81 Test #21: teams_coarray_send_by_ref ........................   Passed    0.13 sec
      Start 22: teams_coarray_sendget
22/81 Test #22: teams_coarray_sendget ............................   Passed    0.13 sec
      Start 23: sync_team
23/81 Test #23: sync_team ........................................   Passed    0.13 sec
      Start 24: alloc_comp_multidim_shape
24/81 Test #24: alloc_comp_multidim_shape ........................   Passed    0.51 sec
      Start 25: send_convert_nums
25/81 Test #25: send_convert_nums ................................   Passed    0.13 sec
      Start 26: sendget_convert_nums
26/81 Test #26: sendget_convert_nums .............................   Passed    0.13 sec
      Start 27: sendget_convert_char_array
27/81 Test #27: sendget_convert_char_array .......................   Passed    0.13 sec
      Start 28: send_convert_char_array
28/81 Test #28: send_convert_char_array ..........................   Passed    0.12 sec
      Start 29: alloc_comp_send_convert_nums
29/81 Test #29: alloc_comp_send_convert_nums .....................   Passed    0.13 sec
      Start 30: get_array
30/81 Test #30: get_array ........................................   Passed    0.96 sec
      Start 31: get_self
31/81 Test #31: get_self .........................................   Passed    0.13 sec
      Start 32: get_convert_nums
32/81 Test #32: get_convert_nums .................................   Passed    0.13 sec
      Start 33: get_convert_char_array
33/81 Test #33: get_convert_char_array ...........................   Passed    0.12 sec
      Start 34: get_with_offset_1d
34/81 Test #34: get_with_offset_1d ...............................   Passed    0.12 sec
      Start 35: whole_get_array
35/81 Test #35: whole_get_array ..................................   Passed    0.13 sec
      Start 36: strided_get
36/81 Test #36: strided_get ......................................   Passed    0.13 sec
      Start 37: get_static_array
37/81 Test #37: get_static_array .................................   Passed    0.12 sec
      Start 38: send_array
38/81 Test #38: send_array .......................................   Passed    0.99 sec
      Start 39: convert-before-put
39/81 Test #39: convert-before-put ...............................   Passed    0.12 sec
      Start 40: send_with_vector_index
40/81 Test #40: send_with_vector_index ...........................   Passed    0.13 sec
      Start 41: strided_sendget
41/81 Test #41: strided_sendget ..................................   Passed    0.13 sec
      Start 42: get_with_vector_index
42/81 Test #42: get_with_vector_index ............................   Passed    0.13 sec
      Start 43: co_sum
43/81 Test #43: co_sum ...........................................   Passed    0.13 sec
      Start 44: co_broadcast
44/81 Test #44: co_broadcast .....................................   Passed    0.13 sec
      Start 45: co_broadcast_derived_type
45/81 Test #45: co_broadcast_derived_type ........................   Passed    0.12 sec
      Start 46: co_min
46/81 Test #46: co_min ...........................................   Passed    0.13 sec
      Start 47: co_max
47/81 Test #47: co_max ...........................................   Passed    0.12 sec
      Start 48: co_reduce
48/81 Test #48: co_reduce ........................................   Passed    0.13 sec
      Start 49: co_reduce_res_im
49/81 Test #49: co_reduce_res_im .................................   Passed    0.13 sec
      Start 50: co_reduce_string
50/81 Test #50: co_reduce_string .................................   Passed    0.13 sec
      Start 51: syncimages_status
51/81 Test #51: syncimages_status ................................   Passed    0.13 sec
      Start 52: sync_ring_abort_np3
52/81 Test #52: sync_ring_abort_np3 ..............................   Passed    0.12 sec
      Start 53: sync_ring_abort_np7
53/81 Test #53: sync_ring_abort_np7 ..............................   Passed    0.13 sec
      Start 54: simpleatomics
54/81 Test #54: simpleatomics ....................................   Passed    0.13 sec
      Start 55: syncall
55/81 Test #55: syncall ..........................................   Passed    1.14 sec
      Start 56: syncimages
56/81 Test #56: syncimages .......................................   Passed    0.14 sec
      Start 57: syncimages2
57/81 Test #57: syncimages2 ......................................   Passed    0.13 sec
      Start 58: duplicate_syncimages
58/81 Test #58: duplicate_syncimages .............................   Passed    0.14 sec
      Start 59: hello_multiverse
59/81 Test #59: hello_multiverse .................................   Passed    0.13 sec
      Start 60: coarray_burgers_pde
60/81 Test #60: coarray_burgers_pde ..............................   Passed    0.25 sec
      Start 61: co_heat
61/81 Test #61: co_heat ..........................................   Passed    0.61 sec
      Start 62: asynchronous_hello_world
62/81 Test #62: asynchronous_hello_world .........................   Passed    0.13 sec
      Start 63: source-alloc-no-sync
63/81 Test #63: source-alloc-no-sync .............................   Passed    0.14 sec
      Start 64: put-allocatable-coarray-comp
64/81 Test #64: put-allocatable-coarray-comp .....................   Passed    0.13 sec
      Start 65: get-put-allocatable-comp
65/81 Test #65: get-put-allocatable-comp .........................   Passed    0.12 sec
      Start 66: allocatable_p2p_event_post
66/81 Test #66: allocatable_p2p_event_post .......................   Passed    0.12 sec
      Start 67: static_event_post_issue_293
67/81 Test #67: static_event_post_issue_293 ......................   Passed    0.12 sec
      Start 68: co_reduce-factorial
68/81 Test #68: co_reduce-factorial ..............................   Passed    0.13 sec
      Start 69: co_reduce-factorial-int8
69/81 Test #69: co_reduce-factorial-int8 .........................   Passed    0.13 sec
      Start 70: co_reduce-factorial-int64
70/81 Test #70: co_reduce-factorial-int64 ........................   Passed    0.13 sec
      Start 71: issue-493-coindex-slice
71/81 Test #71: issue-493-coindex-slice ..........................   Passed    0.14 sec
      Start 72: issue-488-multi-dim-cobounds-true
72/81 Test #72: issue-488-multi-dim-cobounds-true ................   Passed    0.14 sec
      Start 73: issue-488-multi-dim-cobounds-false
73/81 Test #73: issue-488-multi-dim-cobounds-false ...............   Passed    0.14 sec
      Start 74: issue-503-multidim-array-broadcast
74/81 Test #74: issue-503-multidim-array-broadcast ...............   Passed    0.13 sec
      Start 75: issue-503-non-contig-red-ndarray
75/81 Test #75: issue-503-non-contig-red-ndarray .................   Passed    0.14 sec
      Start 76: issue-552-send_by_ref-singleton
76/81 Test #76: issue-552-send_by_ref-singleton ..................   Passed    0.13 sec
      Start 77: issue-511-incorrect-shape
77/81 Test #77: issue-511-incorrect-shape ........................   Passed    0.12 sec
      Start 78: issue-515-mimic-mpi-gatherv
78/81 Test #78: issue-515-mimic-mpi-gatherv ......................   Passed    0.12 sec
      Start 79: issue-700-allow-multiple-scalar-dim-array-gets
79/81 Test #79: issue-700-allow-multiple-scalar-dim-array-gets ...   Passed    0.12 sec
      Start 80: issue-762-mpi-crashing-on-exit
80/81 Test #80: issue-762-mpi-crashing-on-exit ...................   Passed    0.12 sec
      Start 81: test-installation-scripts.sh
81/81 Test #81: test-installation-scripts.sh .....................   Passed    0.36 sec

100% tests passed, 0 tests failed out of 81
```

测试结果

单元测试运行正常，说明各类型函数和功能都响应正常。测试通过。

## 3.性能测试

### 3.1.测试平台信息对比

|          | arm信息                          | x86信息               |
| -------- | -------------------------------- | --------------------- |
| 操作系统 | openEuler 22.03 (LTS)            | openEuler 22.03 (LTS) |
| 内核版本 | 4.19.90-2012.4.0.0053.oe1.aarch64 | 4.19.90-2109.1.0.0108.oe1.x86_64  |

### 3.2.测试软件环境信息对比

|     | arm信息       | x86信息   |
| --- | ------------- | --------- |
| gcc | kgcc 9.3.1 | gcc 9.3.0 |
| mpi | openmpi 4.1.2 | openmpi 4.1.2 |
| cmake | 3.23.1 | 3.23.1 |
| opencoarrays | 2.10.1 | 2.10.1 |


### 3.3.测试硬件性能信息对比

|        | arm信息     | x86信息  |
| ------ | ----------- | -------- |
| cpu    | Kunpeng 920 |          |
| 核心数 | 16          | 4        |
| 内存   | 32 GB       | 8 GB     |
| 磁盘io | 1.3 GB/s    | 400 MB/s |
| 虚拟化 | KVM         | KVM      |

### 3.4.测试选择的案例

src/tests下的performance目录，它包含BurgersMPI, mpi_dist_transpose, psnap.

```bash
[root@host-10-208-134-176 BurgersMPI]# ls
CMakeLists.txt  input_file.F90  kind                 kind_parameters.mod  mpi_module.F90  periodic_2nd_order.F90
input           input_file.mod  kind_parameters.F90  main.F90             mpi_share.F90   shared.F90
```

```bash
[root@host-10-208-134-176 psnap]# ls
cafpsnap.f90  CMakeLists.txt  timemeasure.c
```

```bash
[root@host-10-208-134-176 mpi_dist_transpose]# ls
CMakeLists.txt  mpi_distributed_transpose.F90  walltime.o  walltime.x64
```

### 3.5.单线程

单线程运行测试时间对比（五次运行取平均值）

|             | arm        | x86      |
| ----------- | ---------- | -------- |
| 实际CPU时间 | 0m0.004s |  0m0.050s |
| 用户时间    |  0m0.0018s  | 0m0.040s |

### 3.6.多线程

多线程运行测试时间对比（五次运行取平均值）

|             | arm        | x86       |
| ----------- | ---------- | --------- |
| 线程数      | 4          | 4         |
| 实际CPU时间 | 0m0.004s |  0m0.055s |
| 用户时间    |  0m0.0016s   | 0m0.009s   |

arm多线程时间耗费数据表：

| 线程          | 1        | 2       | 3       | 4        |
| :------------ | -------- | ------- | ------- | -------- |
| 用户时间(s)   | 0m0.004s | 0m0.004s | 0m0.004s | 0m0.004s |
| 用户态时间(s) | 0m0.0018s  | 0m0.0022s | 0m0.003s | 0m0.0016s |
| 内核态时间(s) | 0m0.0016s   | 0m0.0016s   | 0m0.000s   | 0m0.0024s   | 

x86多线程时间耗费数据表：

| 线程            | 1      | 2      | 3       | 4       |
| --------------- | ------ | ------ | ------- | ------- |
| 用户时间 （s）  | 0m0.050s | 0m0.052s | 0m0.053s  | 0m0.055s  |
| 用户态时间（s） | 0m0.009s | 0m0.010s | 0m0.011s | 0m0.015s |
| 内核态时间（s） | 0m0.040s  | 0m0.038s  | 0m0.042s   | 0m0.040s   |

由上表可知，在线程逐渐增加的情况下，用户时间线性减少，线程数增加后，用户态时间增多，内核态时间并未显著下降。

### 3.9.测试总结

性能测试arm平台与x86平台相差较多,且随着线程数的增加，两个平台的对于同一个应用的所耗费的时间差距逐渐减少。

且线程增加并不会过多减少应用的实际耗费时间，在合理的范围内分配线程数才能更好的利用算力资源。

## 4.精度测试

### 4.1.所选测试案例

选择OpenCoarrays-2.10.1中send-get目录下的测试用例。

```bash
!! Thoroughly test get, i.e. foo = bar[N] in all variants
!!
!! Do simple tests for get(). These test comprise
!!
!! FOO = BAR [N]
!!
!! where
!!
!!  FOO                BAR              images
!! scalar            scalar            N == me
!!  int(k e [1,4])    int(k e [1,4])
!!  real(k e [4,8])   real(k e [4,8])
!!  int(k e [1,4])    real(k e [4,8])
!!  real(k e [4,8])   int(k e [1,4])
!!
!! array(1:5)        scalar
!!  int(k e [1,4])    int(k e [1,4])
!!  real(k e [4,8])   real(k e [4,8])
!!  int(k e [1,4])    real(k e [4,8])
!!  real(k e [4,8])   int(k e [1,4])
!!
!! array(1:5)        array(1:5)
!!  int(k e [1,4])    int(k e [1,4])
!!  real(k e [4,8])   real(k e [4,8])
!!  int(k e [1,4])    real(k e [4,8])
!!  real(k e [4,8])   int(k e [1,4])
!!
!! array(1:3)       array(::2)
!!  int(k e [1,4])    int(k e [1,4])
!!  real(k e [4,8])   real(k e [4,8])
!!  int(k e [1,4])    real(k e [4,8])
!!  real(k e [4,8])   int(k e [1,4])
!!
!! array(4:5)       array(2::2)
!!  int(k e [1,4])    int(k e [1,4])
!!  real(k e [4,8])   real(k e [4,8])
!!  int(k e [1,4])    real(k e [4,8])
!!  real(k e [4,8])   int(k e [1,4])
!!
!! array(1:3)      array(3:1:-1)
!!  int(k e [1,4])    int(k e [1,4])
!!  real(k e [4,8])   real(k e [4,8])
!!  int(k e [1,4])    real(k e [4,8])
!!  real(k e [4,8])   int(k e [1,4])
!!
!! all of the above but for            N != me
!!
!! And may be some other, I've forgotten.
!!
!! Author: Andre Vehreschild, 2017

program get_convert_nums

  implicit none

  real(kind=4), parameter :: tolerance4 = 1.0e-4
  real(kind=8), parameter :: tolerance4to8 = 1.0E-4
  real(kind=8), parameter :: tolerance8 = 1.0E-6

  type t
    integer(kind=1), allocatable :: int_scal_k1
    integer(kind=4), allocatable :: int_scal_k4
    real(kind=4)   , allocatable :: real_scal_k4
    real(kind=8)   , allocatable :: real_scal_k8
    integer(kind=1), allocatable, dimension(:) :: int_k1
    integer(kind=4), allocatable, dimension(:) :: int_k4
    real(kind=4)   , allocatable, dimension(:) :: real_k4
    real(kind=8)   , allocatable, dimension(:) :: real_k8
  end type t

  integer(kind=1)                              :: int_scal_k1
  integer(kind=4)                              :: int_scal_k4
  real(kind=4)                                 :: real_scal_k4
  real(kind=8)                                 :: real_scal_k8

  integer(kind=1), dimension(1:5)                            :: int_k1
  integer(kind=4), dimension(1:5)                            :: int_k4
  real(kind=4)   , dimension(1:5)                            :: real_k4
  real(kind=8)   , dimension(1:5)                            :: real_k8

  type(t), save, codimension[*] :: obj

  logical :: error_printed=.false.

  associate(me => this_image(), np => num_images())
    if (np < 2) error stop 'Can not run with less than 2 images.'

    allocate(obj%int_scal_k1, SOURCE=INT(42, 1)) ! allocate syncs here
    allocate(obj%int_scal_k4, SOURCE=42) ! allocate syncs here
    allocate(obj%int_k1(5), SOURCE=INT([ 5, 4, 3, 2, 1], 1)) ! allocate syncs here
    allocate(obj%int_k4(5), SOURCE=[ 5, 4, 3, 2, 1]) ! allocate syncs here

    allocate(obj%real_scal_k4, SOURCE=37.042) ! allocate syncs here
    allocate(obj%real_scal_k8, SOURCE=REAL(37.042, 8)) ! allocate syncs here
    allocate(obj%real_k4(1:5), SOURCE=[ 5.1, 4.2, 3.3, 2.4, 1.5]) ! allocate syncs here
    allocate(obj%real_k8(1:5), SOURCE=REAL([ 5.1, 4.2, 3.3, 2.4, 1.5], 8)) ! allocate syncs here

    ! First check send/copy to self
    if (me == 1) then
      int_scal_k1 = obj[1]%int_scal_k1
      print *, int_scal_k1
      if (obj%int_scal_k1 /= int_scal_k1) call print_and_register('get scalar int kind=1 from kind=1 self failed.')

      int_scal_k4 = obj[1]%int_scal_k4
      print *, int_scal_k4
      if (obj%int_scal_k4 /= int_scal_k4) call print_and_register( 'get scalar int kind=4 to kind=4 self failed.')

      int_scal_k4 = obj[1]%int_scal_k1
      print *, int_scal_k4
      if (obj%int_scal_k4 /= int_scal_k4) call print_and_register( 'get scalar int kind=1 to kind=4 self failed.')

      int_scal_k1 = obj[1]%int_scal_k4
      print *, int_scal_k1
      if (obj%int_scal_k1 /= int_scal_k1) call print_and_register( 'get scalar int kind=4 to kind=1 self failed.')

      int_k1(:) = obj[1]%int_k1(:)
      print *, int_k1
      if (any(obj%int_k1 /= int_k1)) call print_and_register( 'get int kind=1 to kind=1 self failed.')

      int_k4(:) = obj[1]%int_k4(:)
      print *, int_k4
      if (any(obj%int_k4 /= int_k4)) call print_and_register( 'get int kind=4 to kind=4 self failed.')

      int_k4(:) = obj[1]%int_k1(:)
      print *, int_k4
      if (any(obj%int_k4 /= int_k4)) call print_and_register( 'get int kind=1 to kind=4 self failed.')

      int_k1(:) = obj[1]%int_k4(:)
      print *, int_k1
      if (any(obj%int_k1 /= int_k1)) call print_and_register( 'get int kind=4 to kind=1 self failed.')
    else if (me == 2) then ! Do the real copy to self checks on image 2
      real_scal_k4 = obj[2]%real_scal_k4
      print *, real_scal_k4
      if (abs(obj%real_scal_k4 - real_scal_k4) > tolerance4) &
        call print_and_register( 'get scalar real kind=4 to kind=4 self failed.')


      real_scal_k8 = obj[2]%real_scal_k8
      print *, real_scal_k8
      if (abs(obj%real_scal_k8 - real_scal_k8) > tolerance8) &
        call print_and_register( 'get scalar real kind=8 to kind=8 self failed.')


      real_scal_k8 = obj[2]%real_scal_k4
      print *, real_scal_k8
      if (abs(obj%real_scal_k8 - real_scal_k8) > tolerance4to8) &
        call print_and_register( 'get scalar real kind=4 to kind=8 self failed.')


      real_scal_k4 = obj[2]%real_scal_k8
      print *, real_scal_k4
      if (abs(obj%real_scal_k4 - real_scal_k4) > tolerance4) &
        call print_and_register( 'get scalar real kind=8 to kind=4 self failed.')

      real_k4(:) = obj[2]%real_k4(:)
      print *, real_k4
      if (any(abs(obj%real_k4 - real_k4) > tolerance4)) call print_and_register( 'get real kind=4 to kind=4 self failed.')

      real_k8(:) = obj[2]%real_k8(:)
      print *, real_k8
      if (any(abs(obj%real_k8 - real_k8) > tolerance8)) call print_and_register( 'get real kind=8 to kind=8 self failed.')

      real_k8(:) = obj[2]%real_k4(:)
      print *, real_k8
      if (any(abs(obj%real_k8 - real_k8) > tolerance4to8)) call print_and_register( 'get real kind=4 to kind=8 self failed.')

      real_k4(:) = obj[2]%real_k8(:)
      print *, real_k4
      if (any(abs(obj%real_k4 - real_k4) > tolerance4)) call print_and_register( 'get real kind=8 to kind=4 self failed.')
    end if

    sync all
    if (me == 1) then
      int_scal_k1 = obj[2]%int_scal_k1
      print *, int_scal_k1
      if (obj%int_scal_k1 /= int_scal_k1) call print_and_register( 'get scalar int kind=1 to kind=1 to image 2 failed.')

      int_scal_k4 = obj[2]%int_scal_k4
      print *, int_scal_k4
      if (obj%int_scal_k4 /= int_scal_k4) call print_and_register( 'get scalar int kind=4 to kind=4 to image 2 failed.')

      int_k1(:) = obj[2]%int_k1(:)
      print *, int_k1
      if (any(obj%int_k1 /= int_k1)) call print_and_register( 'get int kind=1 to kind=1 to image 2 failed.')

      int_k4(:) = obj[2]%int_k4(:)
      print *, int_k4
      if (any(obj%int_k4 /= int_k4)) call print_and_register( 'get int kind=4 to kind=4 to image 2 failed.')

    else if (me == 2) then
      real_scal_k4 = obj[1]%real_scal_k4
      print *, real_scal_k4
      if (abs(obj%real_scal_k4 - real_scal_k4) > tolerance4) &
        call print_and_register( 'get scalar real kind=4 to kind=4 to image 2 failed.')

      real_scal_k8 = obj[1]%real_scal_k8
      print *, real_scal_k8
      if (abs(obj%real_scal_k8 - real_scal_k8) > tolerance8) &
        call print_and_register( 'get scalar real kind=8 to kind=8 to image 2 failed.')

      real_k4(:) = obj[1]%real_k4(:)
      print *, real_k4
      if (any(abs(obj%real_k4 - real_k4) > tolerance4)) call print_and_register( 'get real kind=4 to kind=4 to image 2 failed.')

      real_k8(:) = obj[1]%real_k8(:)
      print *, real_k8
      if (any(abs(obj%real_k8 - real_k8) > tolerance8)) call print_and_register( 'get real kind=8 to kind=8 to image 2 failed.')
    end if

    sync all
    if (me == 1) then
      int_scal_k4 = obj[2]%int_scal_k1
      print *, int_scal_k4
      if (obj%int_scal_k4 /= int_scal_k4) call print_and_register( 'get scalar int kind=1 to kind=4 to image 2 failed.')

      int_scal_k1 = obj[2]%int_scal_k4
      print *, int_scal_k1
      if (obj%int_scal_k1 /= int_scal_k1) call print_and_register( 'get scalar int kind=4 to kind=1 to image 2 failed.')

      int_k4(:) = obj[2]%int_k1(:)
      print *, int_k4
      if (any(obj%int_k4 /= int_k4)) call print_and_register( 'get int kind=1 to kind=4 to image 2 failed.')

      int_k1(:) = obj[2]%int_k4(:)
      print *, int_k1
      if (any(obj%int_k1 /= int_k1)) call print_and_register( 'get int kind=4 to kind=1 to image 2 failed.')

    elseif (me == 2) then
      real_scal_k8 = obj[1]%real_scal_k4
      print *, real_scal_k8
      if (abs(obj%real_scal_k8 - real_scal_k8) > tolerance4to8) &
        call print_and_register( 'get scalar real kind=4 to kind=8 to image 2 failed.')

      real_scal_k4 = obj[1]%real_scal_k8
      print *, real_scal_k4
      if (abs(obj%real_scal_k4 - real_scal_k4) > tolerance4) &
        call print_and_register( 'get scalar real kind=8 to kind=4 to image 2 failed.')

      real_k8(:) = obj[1]%real_k4(:)
      print *, real_k8
      if (any(abs(obj%real_k8 - real_k8) > tolerance4to8)) &
        call print_and_register( 'get real kind=4 to kind=8 to image 2 failed.')

      real_k4(:) = obj[1]%real_k8(:)
      print *, real_k4
      if (any(abs(obj%real_k4 - real_k4) > tolerance4)) call print_and_register( 'get real kind=8 to kind=4 to image 2 failed.')
    end if

    ! Scalar to array replication
    sync all
    if (me == 1) then
      int_k4(:) = obj[2]%int_scal_k4
      print *, int_k4
      if (any(obj%int_scal_k4 /= int_k4)) call print_and_register( 'get int scal kind=4 to array kind=4 to image 2 failed.')

      int_k1(:) = obj[2]%int_scal_k1
      print *, int_k1
      if (any(obj%int_scal_k1 /= int_k1)) call print_and_register( 'get int scal kind=1 to array kind=1 to image 2 failed.')

    else if (me == 2) then
      real_k8(:) = obj[1]%real_scal_k8
      print *, real_k8
      if (any(abs(obj%real_scal_k8 - real_k8) > tolerance8)) &
        call print_and_register( 'get real kind=8 to array kind=8 to image 2 failed.')

      real_k4(:) = obj[1]%real_scal_k4
      print *, real_k4
      if (any(abs(obj%real_scal_k4 - real_k4) > tolerance4)) &
        call print_and_register( 'get real kind=4 to array kind=4 to image 2 failed.')
    end if

    ! and with kind conversion
    sync all
    if (me == 1) then
      int_k4(:) = obj[2]%int_scal_k1
      print *, int_k4
      if (any(obj%int_scal_k4 /= int_k4)) call print_and_register( 'get int scal kind=1 to array kind=4 to image 2 failed.')

      int_k1(:) = obj[2]%int_scal_k4
      print *, int_k1
      if (any(obj%int_scal_k1 /= int_k1)) call print_and_register( 'get int scal kind=4 to array kind=1 to image 2 failed.')

    else if (me == 2) then
      real_k8(:) = obj[1]%real_scal_k4
      print *, real_k8
      if (any(abs(obj%real_scal_k8 - real_k8) > tolerance8)) &
        call print_and_register( 'get real kind=4 to array kind=8 to image 2 failed.')

      real_k4(:) = obj[1]%real_scal_k8
      print *, real_k4
      if (any(abs(obj%real_scal_k4 - real_k4) > tolerance4)) &
        call print_and_register( 'get real kind=8 to array kind=4 to image 2 failed.')
    end if

    ! and with type conversion
    sync all
    if (me == 1) then
      int_k4(:) = obj[2]%real_scal_k4
      print *, int_k4
      if (any(int_k4 /= INT(obj%real_scal_k4, 4))) &
        call print_and_register( 'get real scal kind=4 to int array kind=4 to image 2 failed.')

      int_k1(:) = obj[2]%real_scal_k4
      print *, int_k1
      if (any(int_k1 /= INT(obj%real_scal_k4, 1))) &
        call print_and_register( 'get real scal kind=1 to int array kind=1 to image 2 failed.')

    else if (me == 2) then
      real_k8(:) = obj[1]%int_scal_k4
      print *, real_k8
      if (any(abs(real_k8 - obj%int_scal_k4) > tolerance4to8)) &
        call print_and_register( 'get int kind=4 to real array kind=8 to image 2 failed.')


      real_k4(:) = obj[1]%int_scal_k4
      print *, real_k4
      if (any(abs(real_k4 - obj%int_scal_k4) > tolerance4)) &
        call print_and_register( 'get int kind=4 to real array kind=4 to image 2 failed.')
    end if

    sync all

    ! Now with strides

    ! Transfer to other image now.
    sync all
    int_k4 = -1
    int_k1 = INT(-1, 1)
    real_k8 = -1.0
    real_k4 = REAL(-1.0, 4)

    sync all
    if (me == 1) then
      int_k4(1:3) = obj[2]%int_k4(::2)
      print *, int_k4
      if (any(int_k4 /= [obj%int_k4(1), obj%int_k4(3), obj%int_k4(5), -1, -1])) &
        & call print_and_register( 'strided get int kind=4 to kind=4 to image 2 failed.')

      int_k1(3:5) = obj[2]%int_k1(::2)
      print *, int_k1
      if (any(int_k1 /= [INT(-1, 1), INT(-1, 1), obj%int_k1(1), obj%int_k1(3), obj%int_k1(5)])) &
        & call print_and_register( 'strided get int kind=1 to kind=1 to image 2 failed.')

      real_k8(1:3) = obj[2]%real_k8(::2)
      print *, real_k8
      if (any(abs(real_k8 - [obj%real_k8(1), obj%real_k8(3), obj%real_k8(5), REAL(-1.0, 8), REAL(-1.0, 8)]) > tolerance8)) &
        & call print_and_register( 'strided get real kind=8 to kind=8 to image 2 failed.')

      real_k4(3:5) = obj[2]%real_k4(::2)
      print *, real_k4
      if (any(abs(real_k4 - [-1.0, -1.0, obj%real_k4(1), obj%real_k4(3), obj%real_k4(5)]) > tolerance4)) &
        & call print_and_register( 'strided get real kind=4 to kind=4 to image 2 failed.')
    end if

    ! now with strides and kind conversion
    sync all
    int_k4 = -1
    int_k1 = -1
    real_k4 = -1.0
    real_k8 = -1.0
    obj%int_k4 = [105, 104, 103, 102, 101]
    obj%int_k1 = INT([15, 14, 13, 12, 11], 1)
    obj%real_k8 = [5.1, 4.2, 3.3, 2.4, 1.5]
    obj%real_k4 = REAL([-5.1, -4.2, -3.3, -2.4, -1.5], 4)
    sync all
    if (me == 1) then
      int_k4(1:3) = obj[2]%int_k1(::2)
      print *, int_k4
      if (any(int_k4 /= [15, 13, 11, -1, -1])) call print_and_register( 'strided get int kind=1 to kind=4 to image 2 failed.')

      int_k1(1:3) = obj[2]%int_k4(::2)
      print *, int_k1
      if (any(int_k1 /= INT([105, 103, 101, -1, -1], 1))) &
        & call print_and_register( 'strided get int kind=4 to kind=1 to image 2 failed.')

      real_k8(1:3) = obj[2]%real_k4(::2)
      print *, real_k8
      if (any(abs(real_k8 - [-5.1, -3.3, -1.5, -1.0, -1.0]) > tolerance8)) &
        & call print_and_register( 'strided get real kind=4 to kind=8 to image 2 failed.')

      real_k4(1:3) = obj[2]%real_k8(::2)
      print *, real_k4
      if (any(abs(real_k4 - REAL([5.1, 3.3, 1.5, -1.0, -1.0], 4)) > tolerance4)) &
        & call print_and_register( 'strided get real kind=8 to kind=4 to image 2 failed.')

    else if (me == 2) then
      ! now with strides and type conversion
      int_k4(1:3) = obj[1]%real_k8(::2)
      print *, int_k4
      if (any(int_k4 /= [5, 3, 1, -1, -1])) call print_and_register( 'strided get real kind=4 to int kind=4 to image 2 failed.')

      int_k1(1:3) = obj[1]%real_k4(::2)
      print *, int_k1
      if (any(int_k1 /= INT([-5, -3, -1, -1, -1], 1))) &
        & call print_and_register( 'strided get real kind=4 to int kind=1 to image 2 failed.')

      real_k8(1:3) = obj[1]%int_k4(::2)
      print *, real_k8
      if (any(abs(real_k8 - [105.0, 103.0, 101.0, -1.0, -1.0]) > tolerance8)) &
        & call print_and_register( 'strided get int kind=4 to real kind=8 to image 2 failed.')

      real_k4(1:3) = obj[1]%int_k1(::2)
      print *, real_k4
      if (any(abs(real_k4 - [15.0, 13.0, 11.0, -1.0, -1.0]) > tolerance4)) &
        & call print_and_register( 'strided get int kind=1 to real kind=4 to image 2 failed.')
    end if

    if (error_printed) error stop
    if (me==2) sync images(1)
    if (me==1) then
      sync images(2)
      print *, "Test passed."
    end if
  end associate


contains

  subroutine print_and_register(error_message)
    use iso_fortran_env, only : error_unit
    character(len=*), intent(in) :: error_message
    write(error_unit,*) error_message
    error_printed=.true.
  end subroutine

end program get_convert_nums

! vim:ts=2:sts=2:sw=2:
```

```bash
cafrun -np 2 alloc_comp_get_convert_nums
Test passed.
```

```bash
program comp_allocated_1

    implicit none
    integer, parameter :: success = 0
    type :: subType
        real, allocatable :: r_comp
    end type

    type :: T
        type(subType), dimension(:), allocatable :: arr
    end type

    type(T), codimension[*] :: obj

    call assert(num_images() .GE. 2, 'Need at least two images.')

    associate(me => this_image())
        if (me == 1) then
            call assert(.NOT. allocated(obj[2]%arr), 'obj%arr on image 2 allocated.')
        end if

        sync all

        if (me == 2) then
            allocate(obj%arr(3))
            allocate(obj%arr(2)%r_comp, source=13.7)
            print *, 'Image 2: memory allocated.'
        end if

        sync all

        if (me == 1) then
            call assert(allocated(obj[2]%arr), 'obj%arr on image 2 not allocated.')
            call assert(.NOT. allocated(obj[2]%arr(1)%r_comp), 'obj%arr(1)%r_comp should not be allocated')
            call assert(allocated(obj[2]%arr(2)%r_comp), 'obj%arr(2)%r_comp should be allocated')
            call assert(.NOT. allocated(obj[2]%arr(3)%r_comp), 'obj%arr(3)%r_comp should not be allocated')
            print *,'Test passed.'
        end if
        sync all
    end associate
contains
  subroutine assert(assertion,description,stat)
    logical, intent(in) :: assertion
    character(len=*), intent(in) :: description
    integer, intent(out), optional:: stat
    integer, parameter :: failure=1
    if (assertion) then
       if (present(stat)) stat=success
    else
      if (present(stat)) then
        stat=failure
      else
        error stop "Assertion "// description //" failed."
      end if
    end if
  end subroutine
end program

! vim:sw=4:ts=4:sts=4:
```

```bash
cafrun -n 2 comp_allocated_1
Test passed.
```

从输出结果可以看出测试通过，满足opencoarrays所要求的精度范围。