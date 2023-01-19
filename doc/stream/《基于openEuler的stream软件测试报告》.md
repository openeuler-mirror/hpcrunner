# 《基于openEuler的imb软件测试报告》

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

在imb项目根目录下运行,运行结果如下

```bash
[root@192 stream-1.8]# python ../count.py 
/root/stream-1.8
当前文件夹下共有[]的文件3个
当前文件夹下共有[.c]的文件2个
当前文件夹下共有[.f]的文件1个
当前文件夹下共有[.o]的文件2个

### 1.3.统计不符合要求的总行数

对文件后缀名为`c`的所有文件进行格式，后缀名为`f`的文件的代码是由Fortran77编写，现网支持的fortran格式化工具fprettify只支持f90以及更高的版本，所以无法对其进行格式。
通过git与clang-format结合的方式进行统计

```bash
[root@host- src]# [root@192 stream]# find . -regex '.*\.\(c\|h\)' | xargs clang-format -style=LLVM -i
[root@host- src]#  git commit -m "format"
[master aff8b23] format
 2 files changed, 873 insertions(+), 858 deletions(-)
 rewrite stream/mysecond.c (68%)
 rewrite stream/stream_mpi.c (63%)
```

### 1.4.统计结果

综上信息，项目中代码规范性自检检查结果为

通过率    : 40.13%           1-858/1433*100%

不通过率  : 59.87%             858/1433*100%

## 2.功能性测试

### 2.1.所选测试案例

stream提供了运行的不同二进制文件，本次选取stream_mpi_c对MPI以及程序的运行情况进行检测。

在项目根目录下执行命令来运行Benchmark

```bash
export OMP_NUM_THREADS=4;
./stream_mpi_c
```

### 2.2.运行结果

```bash
[root@host-10-208-220-226 Stream-1.8]# ./stream_mpi_c
-------------------------------------------------------------
STREAM version $Revision: 1.8 $
-------------------------------------------------------------
This system uses 8 bytes per array element.
-------------------------------------------------------------
Total Aggregate Array size = 34603008 (elements)
Total Aggregate Memory per array = 264.0 MiB (= 0.3 GiB).
Total Aggregate memory required = 792.0 MiB (= 0.8 GiB).
Data is distributed across 1 MPI ranks
   Array size per MPI rank = 34603008 (elements)
   Memory per array per MPI rank = 264.0 MiB (= 0.3 GiB).
   Total memory per MPI rank = 792.0 MiB (= 0.8 GiB).
-------------------------------------------------------------
Each kernel will be executed 20 times.
 The *best* time for each kernel (excluding the first iteration)
 will be used to compute the reported bandwidth.
The SCALAR value used for this run is 0.420000
-------------------------------------------------------------
Your timer granularity/precision appears to be 1 microseconds.
Each test below will take on the order of 35916 microseconds.
   (= 35916 timer ticks)
Increase the size of the arrays if this shows that
you are not getting at least 20 timer ticks per test.
-------------------------------------------------------------
WARNING -- The above is only a rough guideline.
For best results, please be sure you know the
precision of your system timer.
-------------------------------------------------------------
VERBOSE: total setup time for rank 0 = 0.095054 seconds
-------------------------------------------------------------
Function    Best Rate MB/s  Avg time     Min time     Max time
Copy:          15488.3     0.037941     0.035746     0.042000
Scale:         15173.8     0.037793     0.036487     0.041473
Add:           12718.6     0.065584     0.065296     0.066783
Triad:         12637.4     0.066013     0.065715     0.067098
-------------------------------------------------------------
VERBOSE: rank 0, AvgErrors 1.332268e-15 4.440892e-16 1.776357e-15
Solution Validates: avg error less than 1.000000e-13 on all three arrays
Results Validation Verbose Results:
    Expected a(1), b(1), c(1): 2.769001 1.144215 3.868538
    Observed a(1), b(1), c(1): 2.769001 1.144215 3.868538
    Rel Errors on a, b, c:     4.811366e-16 3.881168e-16 4.591805e-16
-------------------------------------------------------------
VERBOSE: total shutdown time for rank 0 = 0.281207 seconds
```

测试结果

运行正常，说明各类型函数和功能都响应正常。测试通过。

## 3.性能测试

### 3.1.测试平台信息对比

|          | arm信息                          | x86信息               |
| -------- | -------------------------------- | --------------------- |
| 操作系统 | openEuler 22.03 (LTS)            | openEuler 22.03 (LTS) |
| 内核版本 | 4.19.90-2012.4.0.0053.oe1.aarch64 | 4.19.90-2109.1.0.0108.oe1.x86_64  |

### 3.2.测试软件环境信息对比

|     | arm信息       | x86信息   |
| --- | ------------- | --------- |
| gcc | bisheng 2.1.0 | gcc 10.3.0 |
| mpi | hmpi 1.2.0     | oneapi 2021.1.0 |
| stream | 1.8        | 1.8    |

### 3.3.测试硬件性能信息对比

|        | arm信息     | x86信息  |
| ------ | ----------- | -------- |
| cpu    | Kunpeng 920 |          |
| 核心数 | 16          | 4        |
| 内存   | 32 GB       | 8 GB     |
| 磁盘io | 1.3 GB/s    | 400 MB/s |
| 虚拟化 | KVM         | KVM      |

### 3.4.测试选择的案例

stream进行内存带宽测试

### 3.6.ARM运行结果

#### stream_mpi_c

```shell
-------------------------------------------------------------
STREAM version $Revision: 1.8 $
-------------------------------------------------------------
This system uses 8 bytes per array element.
-------------------------------------------------------------
/*-----------------------------------------------------------------------*/
/* License:                                                              */
/*  1. You are free to use this program and/or to redistribute           */
/*     this program.                                                     */
/*  2. You are free to modify this program for your own use,             */
/*     including commercial use, subject to the publication              */
/*     restrictions in item 3.                                           */
/*  3. You are free to publish results obtained from running this        */
/*     program, or from works that you derive from this program,         */
/*     with the following limitations:                                   */
/*     3a. In order to be referred to as "STREAM benchmark results",     */
/*         published results must be in conformance to the STREAM        */
/*         Run Rules, (briefly reviewed below) published at              */
/*         http://www.cs.virginia.edu/stream/ref.html                    */
/*         and incorporated herein by reference.                         */
/*         As the copyright holder, John McCalpin retains the            */
/*         right to determine conformity with the Run Rules.             */
/*     3b. Results based on modified source code or on runs not in       */
/*         accordance with the STREAM Run Rules must be clearly          */
/*         labelled whenever they are published.  Examples of            */
/*         proper labelling include:                                     */
/*           "tuned STREAM benchmark results"                            */
/*           "based on a variant of the STREAM benchmark code"           */
/*         Other comparable, clear, and reasonable labelling is          */
/*         acceptable.                                                   */
/*     3c. Submission of results to the STREAM benchmark web site        */
/*         is encouraged, but not required.                              */
/*  4. Use of this program or creation of derived works based on this    */
/*     program constitutes acceptance of these licensing restrictions.   */
/*  5. Absolutely no warranty is expressed or implied.                   */
/*-----------------------------------------------------------------------*/

# define _XOPEN_SOURCE 600

# include <stdio.h>
# include <stdlib.h>
# include <unistd.h>
# include <math.h>
# include <float.h>
# include <string.h>
# include <limits.h>
# include <sys/time.h>
# include "mpi.h"

/*-----------------------------------------------------------------------
 * INSTRUCTIONS:
 *
 *	1) STREAM requires different amounts of memory to run on different
 *           systems, depending on both the system cache size(s) and the
 *           granularity of the system timer.
 *     You should adjust the value of 'STREAM_ARRAY_SIZE' (below)
 *           to meet *both* of the following criteria:
 *       (a) Each array must be at least 4 times the size of the
 *           available cache memory. I don't worry about the difference
 *           between 10^6 and 2^20, so in practice the minimum array size
 *           is about 3.8 times the cache size.
 *           Example 1: One Xeon E3 with 8 MB L3 cache
 *               STREAM_ARRAY_SIZE should be >= 4 million, giving
 *               an array size of 30.5 MB and a total memory requirement
 *               of 91.5 MB.  
 *           Example 2: Two Xeon E5's with 20 MB L3 cache each (using OpenMP)
 *               STREAM_ARRAY_SIZE should be >= 20 million, giving
 *               an array size of 153 MB and a total memory requirement
 *               of 458 MB.  
 *       (b) The size should be large enough so that the 'timing calibration'
 *           output by the program is at least 20 clock-ticks.  
 *           Example: most versions of Windows have a 10 millisecond timer
 *               granularity.  20 "ticks" at 10 ms/tic is 200 milliseconds.
 *               If the chip is capable of 10 GB/s, it moves 2 GB in 200 msec.
 *               This means the each array must be at least 1 GB, or 128M elements.
 *
 *      Version 5.10 increases the default array size from 2 million
 *          elements to 10 million elements in response to the increasing
 *          size of L3 caches.  The new default size is large enough for caches
 *          up to 20 MB. 
 *      Version 5.10 changes the loop index variables from "register int"
 *          to "ssize_t", which allows array indices >2^32 (4 billion)
 *          on properly configured 64-bit systems.  Additional compiler options
 *          (such as "-mcmodel=medium") may be required for large memory runs.
 *
 *      Array size can be set at compile time without modifying the source
 *          code for the (many) compilers that support preprocessor definitions
 *          on the compile line.  E.g.,
 *                gcc -O -DSTREAM_ARRAY_SIZE=100000000 stream.c -o stream.100M
 *          will override the default size of 10M with a new size of 100M elements
 *          per array.
 */

// ----------------------- !!! NOTE CHANGE IN DEFINITION !!! ------------------
// For the MPI version of STREAM, the three arrays with this many elements
// each will be *distributed* across the MPI ranks.  
//
// Be careful when computing the array size needed for a particular target
// system to meet the minimum size requirement to ensure overflowing the caches.
//
// Example:
//    Assume 4 nodes with two Intel Xeon E5-2680 processors (20 MiB L3) each.
//    The *total* L3 cache size is 4*2*20 = 160 MiB, so each array must be
//    at least 640 MiB, or at least 80 million 8 Byte elements. 
// Note that it does not matter whether you use one MPI rank per node or 
//    16 MPI ranks per node -- only the total array size and the total
//    cache size matter.
//
#ifndef STREAM_ARRAY_SIZE
#   define STREAM_ARRAY_SIZE	10000000
#endif

/*  2) STREAM runs each kernel "NTIMES" times and reports the *best* result
 *         for any iteration after the first, therefore the minimum value
 *         for NTIMES is 2.
 *      There are no rules on maximum allowable values for NTIMES, but
 *         values larger than the default are unlikely to noticeably
 *         increase the reported performance.
 *      NTIMES can also be set on the compile line without changing the source
 *         code using, for example, "-DNTIMES=7".
 */
#ifdef NTIMES
#if NTIMES<=1
extern void checkSTREAMresults(STREAM_TYPE *AvgErrByRank, int numranks);
extern void computeSTREAMerrors(STREAM_TYPE *aAvgErr, STREAM_TYPE *bAvgErr, STREAM_TYPE *cAvgErr);
#ifdef TUNED
extern void tuned_STREAM_Copy();
extern void tuned_STREAM_Scale(STREAM_TYPE scalar);
extern void tuned_STREAM_Add();
extern void tuned_STREAM_Triad(STREAM_TYPE scalar);
#endif
#ifdef _OPENMP
extern int omp_get_num_threads();
#endif
int
main()
    {
    int			quantum, checktick();
    int			BytesPerWord;
    int			i,k;
    ssize_t		j;
    STREAM_TYPE		scalar;
    double		t, times[4][NTIMES];
	double		*TimesByRank;
	double		t0,t1,tmin;
	int         rc, numranks, myrank;
	STREAM_TYPE	AvgError[3] = {0.0,0.0,0.0};
	STREAM_TYPE *AvgErrByRank;

    /* --- SETUP --- call MPI_Init() before anything else! --- */

    rc = MPI_Init(NULL, NULL);
	t0 = MPI_Wtime();
    if (rc != MPI_SUCCESS) {
       printf("ERROR: MPI Initialization failed with return code %d\n",rc);
       exit(1);
    }
	// if either of these fail there is something really screwed up!
	MPI_Comm_size(MPI_COMM_WORLD, &numranks);
	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);

    /* --- NEW FEATURE --- distribute requested storage across MPI ranks --- */
	array_elements = STREAM_ARRAY_SIZE / numranks;		// don't worry about rounding vs truncation
    array_alignment = 64;						// Can be modified -- provides partial support for adjusting relative alignment

	// Dynamically allocate the three arrays using "posix_memalign()"
	// NOTE that the OFFSET parameter is not used in this version of the code!
    array_bytes = array_elements * sizeof(STREAM_TYPE);
    k = posix_memalign((void **)&a, array_alignment, array_bytes);
    if (k != 0) {
        printf("Rank %d: Allocation of array a failed, return code is %d\n",myrank,k);
		MPI_Abort(MPI_COMM_WORLD, 2);
        exit(1);
    }
    k = posix_memalign((void **)&b, array_alignment, array_bytes);
    if (k != 0) {
        printf("Rank %d: Allocation of array b failed, return code is %d\n",myrank,k);
		MPI_Abort(MPI_COMM_WORLD, 2);
        exit(1);
    }
    k = posix_memalign((void **)&c, array_alignment, array_bytes);
    if (k != 0) {
        printf("Rank %d: Allocation of array c failed, return code is %d\n",myrank,k);
		MPI_Abort(MPI_COMM_WORLD, 2);
        exit(1);
    }

	// Initial informational printouts -- rank 0 handles all the output
	if (myrank == 0) {
		printf(HLINE);
		printf("STREAM version $Revision: 1.8 $\n");
		printf(HLINE);
		BytesPerWord = sizeof(STREAM_TYPE);
		printf("This system uses %d bytes per array element.\n",
		BytesPerWord);

		printf(HLINE);
#ifdef N
		printf("*****  WARNING: ******\n");
		printf("      It appears that you set the preprocessor variable N when compiling this code.\n");
		printf("      This version of the code uses the preprocesor variable STREAM_ARRAY_SIZE to control the array size\n");
		printf("      Reverting to default value of STREAM_ARRAY_SIZE=%llu\n",(unsigned long long) STREAM_ARRAY_SIZE);
		printf("*****  WARNING: ******\n");
#endif
		if (OFFSET != 0) {
			printf("*****  WARNING: ******\n");
			printf("   This version ignores the OFFSET parameter.\n");
			printf("*****  WARNING: ******\n");
		}

		printf("Total Aggregate Array size = %llu (elements)\n" , (unsigned long long) STREAM_ARRAY_SIZE);
		printf("Total Aggregate Memory per array = %.1f MiB (= %.1f GiB).\n", 
			BytesPerWord * ( (double) STREAM_ARRAY_SIZE / 1024.0/1024.0),
			BytesPerWord * ( (double) STREAM_ARRAY_SIZE / 1024.0/1024.0/1024.0));
		printf("Total Aggregate memory required = %.1f MiB (= %.1f GiB).\n",
			(3.0 * BytesPerWord) * ( (double) STREAM_ARRAY_SIZE / 1024.0/1024.),
			(3.0 * BytesPerWord) * ( (double) STREAM_ARRAY_SIZE / 1024.0/1024./1024.));
		printf("Data is distributed across %d MPI ranks\n",numranks);
		printf("   Array size per MPI rank = %llu (elements)\n" , (unsigned long long) array_elements);
		printf("   Memory per array per MPI rank = %.1f MiB (= %.1f GiB).\n", 
			BytesPerWord * ( (double) array_elements / 1024.0/1024.0),
			BytesPerWord * ( (double) array_elements / 1024.0/1024.0/1024.0));
		printf("   Total memory per MPI rank = %.1f MiB (= %.1f GiB).\n",
			(3.0 * BytesPerWord) * ( (double) array_elements / 1024.0/1024.),
			(3.0 * BytesPerWord) * ( (double) array_elements / 1024.0/1024./1024.));

		printf(HLINE);
		printf("Each kernel will be executed %d times.\n", NTIMES);
		printf(" The *best* time for each kernel (excluding the first iteration)\n"); 
		printf(" will be used to compute the reported bandwidth.\n");
		printf("The SCALAR value used for this run is %f\n",SCALAR);

#ifdef _OPENMP
		printf(HLINE);
#pragma omp parallel 
		{
#pragma omp master
		{
			k = omp_get_num_threads();
			printf ("Number of Threads requested for each MPI rank = %i\n",k);
			}
		}
#endif

#ifdef _OPENMP
		k = 0;
#pragma omp parallel
#pragma omp atomic 
			k++;
		printf ("Number of Threads counted for rank 0 = %i\n",k);
#endif

	}

    /* --- SETUP --- initialize arrays and estimate precision of timer --- */

#pragma omp parallel for
    for (j=0; j<array_elements; j++) {
	    a[j] = 1.0;
	    b[j] = 2.0;
	    c[j] = 0.0;
	}

	// Rank 0 needs to allocate arrays to hold error data and timing data from
	// all ranks for analysis and output.
		printf("   (= %d timer ticks)\n", (int) (t/quantum) );
		printf("Increase the size of the arrays if this shows that\n");
		printf("you are not getting at least 20 timer ticks per test.\n");

		printf(HLINE);

		printf("WARNING -- The above is only a rough guideline.\n");
		printf("For best results, please be sure you know the\n");
		printf("precision of your system timer.\n");
		printf(HLINE);
#ifdef VERBOSE
		t1 = MPI_Wtime();
		printf("VERBOSE: total setup time for rank 0 = %f seconds\n",t1-t0);
		printf(HLINE);
#endif
	}
    
    /*	--- MAIN LOOP --- repeat test cases NTIMES times --- */

    // This code has more barriers and timing calls than are actually needed, but
    // this should not cause a problem for arrays that are large enough to satisfy
    // the STREAM run rules.
	// MAJOR FIX!!!  Version 1.7 had the start timer for each loop *after* the
	// MPI_Barrier(), when it should have been *before* the MPI_Barrier().
    // 

    scalar = SCALAR;
    for (k=0; k<NTIMES; k++)
	{
		// kernel 1: Copy
		t0 = MPI_Wtime();
		MPI_Barrier(MPI_COMM_WORLD);
#ifdef TUNED
        tuned_STREAM_Copy();
#else
#pragma omp parallel for
		for (j=0; j<array_elements; j++)
			c[j] = a[j];
#endif
		MPI_Barrier(MPI_COMM_WORLD);
		t1 = MPI_Wtime();
		times[0][k] = t1 - t0;

		// kernel 2: Scale
		t0 = MPI_Wtime();
		MPI_Barrier(MPI_COMM_WORLD);
#ifdef TUNED
        tuned_STREAM_Scale(scalar);
#else
#pragma omp parallel for
		for (j=0; j<array_elements; j++)
			b[j] = scalar*c[j];
#endif
		MPI_Barrier(MPI_COMM_WORLD);
		t1 = MPI_Wtime();
		times[1][k] = t1-t0;
	
		// kernel 3: Add
		t0 = MPI_Wtime();
		MPI_Barrier(MPI_COMM_WORLD);
#ifdef TUNED
        tuned_STREAM_Add();
#else
#pragma omp parallel for
		for (j=0; j<array_elements; j++)
			c[j] = a[j]+b[j];
#endif
		MPI_Barrier(MPI_COMM_WORLD);
		t1 = MPI_Wtime();
		times[2][k] = t1-t0;
	
		// kernel 4: Triad
		t0 = MPI_Wtime();
		MPI_Barrier(MPI_COMM_WORLD);
#ifdef TUNED
        tuned_STREAM_Triad(scalar);
#else
#pragma omp parallel for
		for (j=0; j<array_elements; j++)
			a[j] = b[j]+scalar*c[j];
#endif
		MPI_Barrier(MPI_COMM_WORLD);
		t1 = MPI_Wtime();
		times[3][k] = t1-t0;
	}

	t0 = MPI_Wtime();

    /*	--- SUMMARY --- */

	// Because of the MPI_Barrier() calls, the timings from any thread are equally valid. 
    // The best estimate of the maximum performance is the minimum of the "outside the barrier"
    // timings across all the MPI ranks.

	// Gather all timing data to MPI rank 0
	MPI_Gather(times, 4*NTIMES, MPI_DOUBLE, TimesByRank, 4*NTIMES, MPI_DOUBLE, 0, MPI_COMM_WORLD);

	// Rank 0 processes all timing data
	if (myrank == 0) {
		// for each iteration and each kernel, collect the minimum time across all MPI ranks
		// and overwrite the rank 0 "times" variable with the minimum so the original post-
		// processing code can still be used.
		for (k=0; k<NTIMES; k++) {
			for (j=0; j<4; j++) {
				tmin = 1.0e36;
				for (i=0; i<numranks; i++) {
					// printf("DEBUG: Timing: iter %d, kernel %lu, rank %d, tmin %f, TbyRank %f\n",k,j,i,tmin,TimesByRank[4*NTIMES*i+j*NTIMES+k]);
					tmin = MIN(tmin, TimesByRank[4*NTIMES*i+j*NTIMES+k]);
				}
				// printf("DEBUG: Final Timing: iter %d, kernel %lu, final tmin %f\n",k,j,tmin);
				times[j][k] = tmin;
			}
		}

	// Back to the original code, but now using the minimum global timing across all ranks
		for (k=1; k<NTIMES; k++) /* note -- skip first iteration */
		{
		for (j=0; j<4; j++)
			{
			avgtime[j] = avgtime[j] + times[j][k];
			mintime[j] = MIN(mintime[j], times[j][k]);
			maxtime[j] = MAX(maxtime[j], times[j][k]);
			}
		}
    
		// note that "bytes[j]" is the aggregate array size, so no "numranks" is needed here
		printf("Function    Best Rate MB/s  Avg time     Min time     Max time\n");
		for (j=0; j<4; j++) {
			avgtime[j] = avgtime[j]/(double)(NTIMES-1);

			printf("%s%11.1f  %11.6f  %11.6f  %11.6f\n", label[j],
			   1.0E-06 * bytes[j]/mintime[j],
			   avgtime[j],
			   mintime[j],
			   maxtime[j]);
		}
		printf(HLINE);
	}

    /* --- Every Rank Checks its Results --- */
#ifdef INJECTERROR
	a[11] = 100.0 * a[11];
#endif
	computeSTREAMerrors(&AvgError[0], &AvgError[1], &AvgError[2]);
	for (j=0; j<array_elements; j++) {
		aSumErr += abs(a[j] - aj);
		bSumErr += abs(b[j] - bj);
		cSumErr += abs(c[j] - cj);
	}
	*aAvgErr = aSumErr / (STREAM_TYPE) array_elements;
	*bAvgErr = bSumErr / (STREAM_TYPE) array_elements;
	*cAvgErr = cSumErr / (STREAM_TYPE) array_elements;
}



void checkSTREAMresults (STREAM_TYPE *AvgErrByRank, int numranks)
{
	STREAM_TYPE aj,bj,cj,scalar;
	STREAM_TYPE aSumErr,bSumErr,cSumErr;
	STREAM_TYPE aAvgErr,bAvgErr,cAvgErr;
	double epsilon;
	ssize_t	j;
	int	k,ierr,err;

	// Repeat the computation of aj, bj, cj because I am lazy
    /* reproduce initialization */
	aj = 1.0;
	bj = 2.0;
	cj = 0.0;
    /* a[] is modified during timing check */
	aj = 2.0E0 * aj;
    /* now execute timing loop */
	scalar = SCALAR;
	for (k=0; k<NTIMES; k++)
        {
            cj = aj;
            bj = scalar*cj;
            cj = aj+bj;
            aj = bj+scalar*cj;
        }

	// Compute the average of the average errors contributed by each MPI rank
	aSumErr = 0.0;
	bSumErr = 0.0;
	cSumErr = 0.0;
	for (k=0; k<numranks; k++) {
		aSumErr += AvgErrByRank[3*k + 0];
		bSumErr += AvgErrByRank[3*k + 1];
		cSumErr += AvgErrByRank[3*k + 2];
	}
	aAvgErr = aSumErr / (STREAM_TYPE) numranks;
	bAvgErr = bSumErr / (STREAM_TYPE) numranks;
	cAvgErr = cSumErr / (STREAM_TYPE) numranks;

	if (sizeof(STREAM_TYPE) == 4) {
		epsilon = 1.e-6;
	}
	else if (sizeof(STREAM_TYPE) == 8) {
		epsilon = 1.e-13;
	}
	else {
		printf("WEIRD: sizeof(STREAM_TYPE) = %lu\n",sizeof(STREAM_TYPE));
		epsilon = 1.e-6;
	}

	err = 0;
	if (abs(aAvgErr/aj) > epsilon) {
		err++;
		printf ("Failed Validation on array a[], AvgRelAbsErr > epsilon (%e)\n",epsilon);
		printf ("     Expected Value: %e, AvgAbsErr: %e, AvgRelAbsErr: %e\n",aj,aAvgErr,abs(aAvgErr)/aj);
		ierr = 0;
		for (j=0; j<array_elements; j++) {
			if (abs(a[j]/aj-1.0) > epsilon) {
				ierr++;
#ifdef VERBOSE
				if (ierr < 10) {
					printf("         array a: index: %ld, expected: %e, observed: %e, relative error: %e\n",
						j,aj,a[j],abs((aj-a[j])/aAvgErr));
				}
#endif
			}
		}
		printf("     For array a[], %d errors were found.\n",ierr);
	}
	if (abs(bAvgErr/bj) > epsilon) {
		err++;
		printf ("Failed Validation on array b[], AvgRelAbsErr > epsilon (%e)\n",epsilon);
		printf ("     Expected Value: %e, AvgAbsErr: %e, AvgRelAbsErr: %e\n",bj,bAvgErr,abs(bAvgErr)/bj);
		printf ("     AvgRelAbsErr > Epsilon (%e)\n",epsilon);
		ierr = 0;
		for (j=0; j<array_elements; j++) {
			if (abs(b[j]/bj-1.0) > epsilon) {
				ierr++;
#ifdef VERBOSE
				if (ierr < 10) {
					printf("         array b: index: %ld, expected: %e, observed: %e, relative error: %e\n",
						j,bj,b[j],abs((bj-b[j])/bAvgErr));
				}
#endif
			}
		}
		printf("     For array b[], %d errors were found.\n",ierr);
	}
	if (abs(cAvgErr/cj) > epsilon) {
		err++;
		printf ("Failed Validation on array c[], AvgRelAbsErr > epsilon (%e)\n",epsilon);
		printf ("     Expected Value: %e, AvgAbsErr: %e, AvgRelAbsErr: %e\n",cj,cAvgErr,abs(cAvgErr)/cj);
		printf ("     AvgRelAbsErr > Epsilon (%e)\n",epsilon);
		ierr = 0;
		for (j=0; j<array_elements; j++) {
			if (abs(c[j]/cj-1.0) > epsilon) {
				ierr++;
#ifdef VERBOSE
				if (ierr < 10) {
					printf("         array c: index: %ld, expected: %e, observed: %e, relative error: %e\n",
						j,cj,c[j],abs((cj-c[j])/cAvgErr));
				}
#endif
			}
		}
		printf("     For array c[], %d errors were found.\n",ierr);
	}
	if (err == 0) {
		printf ("Solution Validates: avg error less than %e on all three arrays\n",epsilon);
	}
#ifdef VERBOSE
	printf ("Results Validation Verbose Results: \n");
	printf ("    Expected a(1), b(1), c(1): %f %f %f \n",aj,bj,cj);
	printf ("    Observed a(1), b(1), c(1): %f %f %f \n",a[1],b[1],c[1]);
	printf ("    Rel Errors on a, b, c:     %e %e %e \n",abs(aAvgErr/aj),abs(bAvgErr/bj),abs(cAvgErr/cj));
#endif
}

#ifdef TUNED
/* stubs for "tuned" versions of the kernels */
void tuned_STREAM_Copy()
{
	ssize_t j;
#pragma omp parallel for
        for (j=0; j<array_elements; j++)
            c[j] = a[j];
}

void tuned_STREAM_Scale(STREAM_TYPE scalar)
{
	ssize_t j;
#pragma omp parallel for
	for (j=0; j<array_elements; j++)
	    b[j] = scalar*c[j];
}

void tuned_STREAM_Add()
{
	ssize_t j;
#pragma omp parallel for
	for (j=0; j<array_elements; j++)
	    c[j] = a[j]+b[j];
}

void tuned_STREAM_Triad(STREAM_TYPE scalar)
{
	ssize_t j;
#pragma omp parallel for
	for (j=0; j<array_elements; j++)
	    a[j] = b[j]+scalar*c[j];
}
/* end of stubs for the "tuned" versions of the kernels */
#endif
```
    Observed a(1), b(1), c(1): 2.769001 1.144215 3.868538 
    Rel Errors on a, b, c:     0.000000e+00 0.000000e+00 0.000000e+00 
-------------------------------------------------------------
VERBOSE: total shutdown time for rank 0 = 0.000448 seconds
```

测试数组大小为8650752

```bash
-------------------------------------------------------------
STREAM version $Revision: 1.8 $
-------------------------------------------------------------
This system uses 8 bytes per array element.
-------------------------------------------------------------
Total Aggregate Array size = 8650752 (elements)
Total Aggregate Memory per array = 66.0 MiB (= 0.1 GiB).
Total Aggregate memory required = 198.0 MiB (= 0.2 GiB).
Data is distributed across 1 MPI ranks
   Array size per MPI rank = 8650752 (elements)
   Memory per array per MPI rank = 66.0 MiB (= 0.1 GiB).
   Total memory per MPI rank = 198.0 MiB (= 0.2 GiB).
-------------------------------------------------------------
Each kernel will be executed 20 times.
 The *best* time for each kernel (excluding the first iteration)
 will be used to compute the reported bandwidth.
The SCALAR value used for this run is 0.420000
-------------------------------------------------------------
Number of Threads requested for each MPI rank = 8
Number of Threads counted for rank 0 = 8
-------------------------------------------------------------
Your timer granularity/precision appears to be 1 microseconds.
Each test below will take on the order of 16215 microseconds.
   (= 16215 timer ticks)
Increase the size of the arrays if this shows that
you are not getting at least 20 timer ticks per test.
-------------------------------------------------------------
WARNING -- The above is only a rough guideline.
For best results, please be sure you know the
precision of your system timer.
-------------------------------------------------------------
VERBOSE: total setup time for rank 0 = 1.352866 seconds
-------------------------------------------------------------
Function    Best Rate MB/s  Avg time     Min time     Max time
Copy:          25856.7     0.008502     0.005353     0.018346
Scale:         25752.7     0.007350     0.005375     0.025473
Add:           25418.7     0.011061     0.008168     0.019069
Triad:         26502.3     0.010125     0.007834     0.023758
-------------------------------------------------------------
VERBOSE: rank 0, AvgErrors 0.000000e+00 0.000000e+00 0.000000e+00
Solution Validates: avg error less than 1.000000e-13 on all three arrays
Results Validation Verbose Results: 
    Expected a(1), b(1), c(1): 2.769001 1.144215 3.868538 
    Observed a(1), b(1), c(1): 2.769001 1.144215 3.868538 
    Rel Errors on a, b, c:     0.000000e+00 0.000000e+00 0.000000e+00 
-------------------------------------------------------------
VERBOSE: total shutdown time for rank 0 = 0.012194 seconds
```

测试数组大小为30000000

```bash
-------------------------------------------------------------
STREAM version $Revision: 1.8 $
-------------------------------------------------------------
This system uses 8 bytes per array element.
-------------------------------------------------------------
Total Aggregate Array size = 30000000 (elements)
Total Aggregate Memory per array = 228.9 MiB (= 0.2 GiB).
Total Aggregate memory required = 686.6 MiB (= 0.7 GiB).
Data is distributed across 1 MPI ranks
   Array size per MPI rank = 30000000 (elements)
   Memory per array per MPI rank = 228.9 MiB (= 0.2 GiB).
   Total memory per MPI rank = 686.6 MiB (= 0.7 GiB).
-------------------------------------------------------------
Each kernel will be executed 20 times.
 The *best* time for each kernel (excluding the first iteration)
 will be used to compute the reported bandwidth.
The SCALAR value used for this run is 0.420000
-------------------------------------------------------------
Number of Threads requested for each MPI rank = 8
Number of Threads counted for rank 0 = 8
-------------------------------------------------------------
Your timer granularity/precision appears to be 1 microseconds.
Each test below will take on the order of 19844 microseconds.
   (= 19844 timer ticks)
Increase the size of the arrays if this shows that
you are not getting at least 20 timer ticks per test.
-------------------------------------------------------------
WARNING -- The above is only a rough guideline.
For best results, please be sure you know the
precision of your system timer.
-------------------------------------------------------------
VERBOSE: total setup time for rank 0 = 4.558776 seconds
-------------------------------------------------------------
Function    Best Rate MB/s  Avg time     Min time     Max time
Copy:          25849.6     0.019387     0.018569     0.024146
Scale:         25779.3     0.020390     0.018620     0.033088
Add:           25472.4     0.031174     0.028266     0.059286
Triad:         25525.6     0.029798     0.028207     0.035848
-------------------------------------------------------------
VERBOSE: rank 0, AvgErrors 0.000000e+00 0.000000e+00 0.000000e+00
Solution Validates: avg error less than 1.000000e-13 on all three arrays
Results Validation Verbose Results: 
    Expected a(1), b(1), c(1): 2.769001 1.144215 3.868538 
    Observed a(1), b(1), c(1): 2.769001 1.144215 3.868538 
    Rel Errors on a, b, c:     0.000000e+00 0.000000e+00 0.000000e+00 
-------------------------------------------------------------
VERBOSE: total shutdown time for rank 0 = 0.041864 seconds
```

测试数组为100000000

```bash
-------------------------------------------------------------
STREAM version $Revision: 1.8 $
-------------------------------------------------------------
This system uses 8 bytes per array element.
-------------------------------------------------------------
Total Aggregate Array size = 100000000 (elements)
Total Aggregate Memory per array = 762.9 MiB (= 0.7 GiB).
Total Aggregate memory required = 2288.8 MiB (= 2.2 GiB).
Data is distributed across 1 MPI ranks
   Array size per MPI rank = 100000000 (elements)
   Memory per array per MPI rank = 762.9 MiB (= 0.7 GiB).
   Total memory per MPI rank = 2288.8 MiB (= 2.2 GiB).
-------------------------------------------------------------
Each kernel will be executed 20 times.
 The *best* time for each kernel (excluding the first iteration)
 will be used to compute the reported bandwidth.
The SCALAR value used for this run is 0.420000
-------------------------------------------------------------
Number of Threads requested for each MPI rank = 8
Number of Threads counted for rank 0 = 8
-------------------------------------------------------------
Your timer granularity/precision appears to be 1 microseconds.
Each test below will take on the order of 73044 microseconds.
   (= 73044 timer ticks)
Increase the size of the arrays if this shows that
you are not getting at least 20 timer ticks per test.
-------------------------------------------------------------
WARNING -- The above is only a rough guideline.
For best results, please be sure you know the
precision of your system timer.
-------------------------------------------------------------
VERBOSE: total setup time for rank 0 = 15.462137 seconds
-------------------------------------------------------------
Function    Best Rate MB/s  Avg time     Min time     Max time
Copy:          26002.5     0.064959     0.061533     0.094795
Scale:         25825.7     0.067524     0.061954     0.083622
Add:           25399.6     0.099048     0.094490     0.126383
Triad:         25192.1     0.101478     0.095268     0.139541
-------------------------------------------------------------
VERBOSE: rank 0, AvgErrors 0.000000e+00 0.000000e+00 0.000000e+00
Solution Validates: avg error less than 1.000000e-13 on all three arrays
Results Validation Verbose Results: 
    Expected a(1), b(1), c(1): 2.769001 1.144215 3.868538 
    Observed a(1), b(1), c(1): 2.769001 1.144215 3.868538 
    Rel Errors on a, b, c:     0.000000e+00 0.000000e+00 0.000000e+00 
-------------------------------------------------------------
VERBOSE: total shutdown time for rank 0 = 0.186201 seconds
```

## 4.3.测试总结

两平台在测试数组的大小趋于单颗CPU最后一级Cache的8.25倍时，结果趋于稳定,， 过高或过低带宽偏高。
