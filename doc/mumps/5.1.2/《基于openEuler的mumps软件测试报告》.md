# 《基于openEuler的mumps软件测试报告》

## 1. 规范性自检

对项目使用fprettify对文件进行格式化

fprettify是一个现代Fortran代码的自动格式化程序，它采用严格的空白格式，用Python编写。

对于当前项目，检查代码规范性，可以通过使用fprettify对所有源码进行重新格式化，然后使用git工具查看文件修改。

### 1.1 选择统计文件类型

统计项目文件类型及其文件数量，通过Python脚本自动进行统计并进行排序：

```python
# -*- coding: utf-8 -*-

import os

me = __file__
print("分析文件夹：" + os.getcwd())

def getAllFiles(targetDir):
    files = []
    listFiles = os.listdir(targetDir)
    for file in listFiles:
        path = os.path.join(targetDir, file)
        if os.path.isdir(path):
            files.extend(getAllFiles(path))
        elif os.path.isfile(path) and path != me:
            files.append(path)
    return files

all_files=getAllFiles(os.curdir)
type_dict=dict()

for file in all_files:
    if os.path.isdir(file):
        type_dict.setdefault("文件夹", 0)
        type_dict["文件夹"]+=1
    else:
        ext=os.path.splitext(file)[1]
        type_dict.setdefault(ext, 0)
        type_dict[ext]+=1

type_dict["空"] = type_dict.pop("")
sort_dict = sorted(type_dict.items(), key = lambda a: a[1], reverse = True)

for each_type in sort_dict:
    print("当前文件夹下共有后缀名为[%s]的文件%d个" %(each_type[0], each_type[1]))
```

在mumps项目根目录下运行，得到统计结果如下（排除自身）：

```shell
/root/MUMPS_5.1.2
当前文件夹下共有[]的文件579个
当前文件夹下共有[.F]的文件385个
当前文件夹下共有[.h]的文件40个
当前文件夹下共有[.c]的文件36个
当前文件夹下共有[.sample]的文件13个
当前文件夹下共有[.SEQ]的文件12个
当前文件夹下共有[.m]的文件11个
当前文件夹下共有[.PAR]的文件9个
当前文件夹下共有[.sce]的文件6个
当前文件夹下共有[.sci]的文件5个
当前文件夹下共有[.xml]的文件3个
当前文件夹下共有[.html]的文件3个
当前文件夹下共有[.pdf]的文件1个
当前文件夹下共有[.f]的文件1个
当前文件夹下共有[.dtd]的文件1个
当前文件夹下共有[.htm]的文件1个
当前文件夹下共有[.generic]的文件1个
当前文件夹下共有[.inc]的文件1个
当前文件夹下共有[.mat]的文件1个
```

主要源码文件后缀名为`F`，`h`，`c`以及部分C语言文件。由此判断该项目主要语言为C++/C。

### 1.2 统计源码代码量

统计行数：

```shell
find ./ -regex ".*\.F\|.*\.cpp|.*\.c" | xargs wc -l
```

行数统计后结果输出如下：

```shell
350231 total
```

### 1.3 统计不符合要求的总行数

对源代码文件（后缀名为`F`，`h`，`c`）进行fprettify代码样式格式化，格式化结果如下：

```shell
[root@host- src]# fprettify -r src/
[root@host- src]# git commit -m "fomat update"
[master b0a0ea8] fomat update
 44 files changed, 1044 insertions(+), 1044 deletions(-)
 rewrite src/ana_omp_m.F (97%)
 rewrite src/cfac_omp_m.F (97%)
 rewrite src/cfac_process_bf.F (97%)
 rewrite src/clr_type.F (94%)
 rewrite src/cmumps_iXamax.F (99%)
 rewrite src/cmumps_save_restore.F (97%)
 rewrite src/cmumps_save_restore_files.F (97%)
 rewrite src/cmumps_struc_def.F (97%)
 rewrite src/comp_tps_m.F (97%)
 rewrite src/cstatic_ptr_m.F (71%)
 rewrite src/dfac_omp_m.F (97%)
 rewrite src/dfac_process_bf.F (97%)
 rewrite src/dlr_type.F (94%)
 rewrite src/dmumps_iXamax.F (98%)
 rewrite src/dmumps_save_restore.F (97%)
 rewrite src/dmumps_save_restore_files.F (97%)
 rewrite src/dmumps_struc_def.F (97%)
 rewrite src/domp_tps_m.F (97%)
 rewrite src/dstatic_ptr_m.F (70%)
 rewrite src/fac_future_niv2_mod.F (97%)
 rewrite src/fac_ibct_data_m.F (97%)
 rewrite src/mumps_comm_ibcast.F (97%)
 rewrite src/mumps_l0_omp_m.F (90%)
 rewrite src/mumps_type_size.F (92%)
 rewrite src/mumps_version.F (98%)
 rewrite src/omp_tps_common_m.F (97%)
 rewrite src/sfac_omp_m.F (97%)
 rewrite src/sfac_process_bf.F (97%)
 rewrite src/slr_type.F (94%)
 rewrite src/smumps_iXamax.F (98%)
 rewrite src/smumps_save_restore.F (97%)
 rewrite src/smumps_save_restore_files.F (97%)
 rewrite src/smumps_struc_def.F (97%)
 rewrite src/somp_tps_m.F (97%)
 rewrite src/sstatic_ptr_m.F (72%)
 rewrite src/zfac_omp_m.F (97%)
 rewrite src/zfac_process_bf.F (97%)
 rewrite src/zlr_type.F (94%)
 rewrite src/zmumps_iXamax.F (99%)
 rewrite src/zmumps_save_restore.F (97%)
 rewrite src/zmumps_save_restore_files.F (97%)
 rewrite src/zmumps_struc_def.F (97%)
 rewrite src/zomp_tps_m.F (97%)
 rewrite src/zstatic_ptr_m.F (70%)
```

### 1.4.统计结果

综上信息，项目中代码规范性自检检查结果为

通过率    : 99.702%         1-1044/350231*100%

不通过率  : 0.628%            1044/166350*100%

## 2. 功能性测试

### 2.1 测试案例

mumps提供了运行的不同example，需要用户在编译后自行进入各个测试案例目录运行。部分测试程序需要外部输入文件，mumps已在对应目录提供。

example文件如下：

```shell
~/MUMPS_5.1.2 |master ✓| →  tree examples/
examples/
├── c_example.c
├── csimpletest.F
├── dsimpletest.F
├── input_simpletest_cmplx
├── input_simpletest_real
├── Makefile
├── multiple_arithmetics_example.F
├── README
├── ssimpletest.F
└── zsimpletest.F
```

案例测试程序对应程序如下：

```fortran
C
C  This file is part of MUMPS 5.1.2, released
C  on Mon Oct  2 07:37:01 UTC 2017
C
      PROGRAM MUMPS_TEST
      IMPLICIT NONE
      INCLUDE 'mpif.h'
      INCLUDE 'smumps_struc.h'
      TYPE (SMUMPS_STRUC) mumps_par
      INTEGER IERR, I
      INTEGER(8) I8
      CALL MPI_INIT(IERR)
C Define a communicator for the package.
      mumps_par%COMM = MPI_COMM_WORLD
C  Initialize an instance of the package
C  for L U factorization (sym = 0, with working host)
      mumps_par%JOB = -1
      mumps_par%SYM = 0
      mumps_par%PAR = 1
      CALL SMUMPS(mumps_par)
      IF (mumps_par%INFOG(1).LT.0) THEN
       WRITE(6,'(A,A,I6,A,I9)') " ERROR RETURN: ",
     &            "  mumps_par%INFOG(1)= ", mumps_par%INFOG(1), 
     &            "  mumps_par%INFOG(2)= ", mumps_par%INFOG(2) 
       GOTO 500
      END IF
C  Define problem on the host (processor 0)
      IF ( mumps_par%MYID .eq. 0 ) THEN
        READ(5,*) mumps_par%N
        READ(5,*) mumps_par%NNZ
        ALLOCATE( mumps_par%IRN ( mumps_par%NNZ ) )
        ALLOCATE( mumps_par%JCN ( mumps_par%NNZ ) )
        ALLOCATE( mumps_par%A( mumps_par%NNZ ) )
        ALLOCATE( mumps_par%RHS ( mumps_par%N  ) )
        DO I8 = 1, mumps_par%NNZ
          READ(5,*) mumps_par%IRN(I8),mumps_par%JCN(I8),mumps_par%A(I8)
        END DO
        DO I = 1, mumps_par%N
          READ(5,*) mumps_par%RHS(I)
        END DO
      END IF
C  Call package for solution
      mumps_par%JOB = 6
      CALL SMUMPS(mumps_par)
      IF (mumps_par%INFOG(1).LT.0) THEN
       WRITE(6,'(A,A,I6,A,I9)') " ERROR RETURN: ",
     &            "  mumps_par%INFOG(1)= ", mumps_par%INFOG(1), 
     &            "  mumps_par%INFOG(2)= ", mumps_par%INFOG(2) 
       GOTO 500
      END IF
C  Solution has been assembled on the host
      IF ( mumps_par%MYID .eq. 0 ) THEN
        WRITE( 6, * ) ' Solution is ',(mumps_par%RHS(I),I=1,mumps_par%N)
      END IF
C  Deallocate user data
      IF ( mumps_par%MYID .eq. 0 )THEN
        DEALLOCATE( mumps_par%IRN )
        DEALLOCATE( mumps_par%JCN )
        DEALLOCATE( mumps_par%A   )
        DEALLOCATE( mumps_par%RHS )
      END IF
C  Destroy the instance (deallocate internal data structures)
      mumps_par%JOB = -2
      CALL SMUMPS(mumps_par)
      IF (mumps_par%INFOG(1).LT.0) THEN
       WRITE(6,'(A,A,I6,A,I9)') " ERROR RETURN: ",
     &            "  mumps_par%INFOG(1)= ", mumps_par%INFOG(1), 
     &            "  mumps_par%INFOG(2)= ", mumps_par%INFOG(2) 
       GOTO 500
      END IF
 500  CALL MPI_FINALIZE(IERR)
      STOP
      END
```

输入文件：

```shell
5              :N
12             :NZ
1 2 3.0
2 3 -3.0
4 3 2.0
5 5 1.0
2 1 3.0
1 1 2.0
5 2 4.0
3 4 2.0
2 5 6.0
3 2 -1.0
1 3 4.0
3 3 1.0        :values
20.0
24.0
9.0
6.0
13.0           :RHS
```

### 2.2 功能测试

mumps仅作为一个框架，只生成对应的库文件和头文件，而在examples目录中提供了各种方向的测试程序，需要用户在编译后自行进入各个测试案例目录运行。部分测试程序需要外部输入文件，mumps已在对应目录提供。

```shell
make all
```

- 进行测试

```shell
# 测试命令
#!/bin/bash

export OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 
MPIRUN="mpirun -np 3 --mca plm_rsh_agent sh --mca opal_warn_on_missing_libcuda 0 --oversubscribe" 
${MPIRUN} ./ssimpletest < input_simpletest_real 
```

- 测试结果

```shell
Entering SMUMPS 5.1.2 with JOB, N, NNZ =   6           5             12
      executing #MPI =      3, without OMP

 =================================================
 =================================================
L U Solver for unsymmetric matrices
Type of parallelism: Working host

 ****** ANALYSIS STEP ********

 ... Structural symmetry (in percent)=   92
 Average density of rows/columns =    2
 ... No column permutation
 Ordering based on AMF

Leaving analysis phase with  ...
INFOG(1)                                       =               0
INFOG(2)                                       =               0
 -- (20) Number of entries in factors (estim.) =              15
 --  (3) Storage of factors  (REAL, estimated) =              15
 --  (4) Storage of factors  (INT , estimated) =              65
 --  (5) Maximum frontal size      (estimated) =               3
 --  (6) Number of nodes in the tree           =               3
 -- (32) Type of analysis effectively used     =               1
 --  (7) Ordering option effectively used      =               2
ICNTL(6) Maximum transversal option            =               0
ICNTL(7) Pivot order option                    =               7
Percentage of memory relaxation (effective)    =              20
Number of level 2 nodes                        =               0
Number of split nodes                          =               0
RINFOG(1) Operations during elimination (estim)=   1.900D+01
 ** Rank of proc needing largest memory in IC facto        :               0
 ** Estimated corresponding MBYTES for IC facto            :               1
 ** Estimated avg. MBYTES per work. proc at facto (IC)     :               1
 ** TOTAL     space in MBYTES for IC factorization         :               3
 ** Rank of proc needing largest memory for OOC facto      :               0
 ** Estimated corresponding MBYTES for OOC facto           :               1
 ** Estimated avg. MBYTES per work. proc at facto (OOC)    :               1
 ** TOTAL     space in MBYTES for OOC factorization        :               3
 ELAPSED TIME IN ANALYSIS DRIVER=       0.0022

 ****** FACTORIZATION STEP ********


 GLOBAL STATISTICS PRIOR NUMERICAL FACTORIZATION ...
 NUMBER OF WORKING PROCESSES              =               3
 OUT-OF-CORE OPTION (ICNTL(22))           =               0
 REAL SPACE FOR FACTORS                   =              15
 INTEGER SPACE FOR FACTORS                =              65
 MAXIMUM FRONTAL SIZE (ESTIMATED)         =               3
 NUMBER OF NODES IN THE TREE              =               3
 MEMORY ALLOWED (MB -- 0: N/A )           =               0
 RELATIVE THRESHOLD FOR PIVOTING, CNTL(1) =      0.1000D-01
 Convergence error after scaling for ONE-NORM (option 7/8)   = 0.38D+00
 Maximum effective relaxed size of S              =             475
 Average effective relaxed size of S              =             469
 ELAPSED TIME FOR MATRIX DISTRIBUTION      =      0.0000
 ** Memory relaxation parameter ( ICNTL(14)  )            :        20
 ** Rank of processor needing largest memory in facto     :         0
 ** Space in MBYTES used by this processor for facto      :         1
 ** Avg. Space in MBYTES per working proc during facto    :         1

 ELAPSED TIME FOR FACTORIZATION           =      0.0023
 Maximum effective space used in S     (KEEP8(67))               12
 Average effective space used in S     (KEEP8(67))                5
 ** EFF Min: Rank of processor needing largest memory :         0
 ** EFF Min: Space in MBYTES used by this processor   :         1
 ** EFF Min: Avg. Space in MBYTES per working proc    :         1

 GLOBAL STATISTICS
 RINFOG(2)  OPERATIONS IN NODE ASSEMBLY   = 2.000D+00
 ------(3)  OPERATIONS IN NODE ELIMINATION= 1.900D+01
 INFOG (9)  REAL SPACE FOR FACTORS        =              15
 INFOG(10)  INTEGER SPACE FOR FACTORS     =              65
 INFOG(11)  MAXIMUM FRONT SIZE            =               3
 INFOG(29)  NUMBER OF ENTRIES IN FACTORS  =              15
 INFOG(12)  NUMBER OF OFF DIAGONAL PIVOTS =               0
 INFOG(13)  NUMBER OF DELAYED PIVOTS      =               0
 INFOG(14)  NUMBER OF MEMORY COMPRESS     =               0
 ELAPSED TIME IN FACTORIZATION DRIVER=       0.0031


 ****** SOLVE & CHECK STEP ********


 STATISTICS PRIOR SOLVE PHASE     ...........
 NUMBER OF RIGHT-HAND-SIDES                    =           1
 BLOCKING FACTOR FOR MULTIPLE RHS              =           1
 ICNTL (9)                                     =           1
  --- (10)                                     =           0
  --- (11)                                     =           0
  --- (20)                                     =           0
  --- (21)                                     =           0
  --- (30)                                     =           0
 ** Rank of processor needing largest memory in solve     :         0
 ** Space in MBYTES used by this processor for solve      :         0
 ** Avg. Space in MBYTES per working proc during solve    :         0

 Global statistics
 TIME to build/scatter RHS        =       0.000093
 TIME in solution step (fwd/bwd)  =       0.000231
  .. TIME in forward (fwd) step   =          0.000133
  .. TIME in backward (bwd) step  =          0.000090
 TIME to gather solution(cent.sol)=       0.000005
 TIME to copy/scale RHS (dist.sol)=       0.000000
 ELAPSED TIME IN SOLVE DRIVER=       0.0010
  Solution is    1.00000048       2.00000024       3.00000000       4.00000000       4.99999952

Entering SMUMPS 5.1.2 with JOB =  -2
      executing #MPI =      3, without OMP

Entering DMUMPS 5.1.2 with JOB, N, NNZ =   6           5             12
      executing #MPI =      3, without OMP

 =================================================
 =================================================
L U Solver for unsymmetric matrices
Type of parallelism: Working host

 ****** ANALYSIS STEP ********

 ... Structural symmetry (in percent)=   92
 Average density of rows/columns =    2
 ... No column permutation
 Ordering based on AMF

Leaving analysis phase with  ...
INFOG(1)                                       =               0
INFOG(2)                                       =               0
 -- (20) Number of entries in factors (estim.) =              15
 --  (3) Storage of factors  (REAL, estimated) =              15
 --  (4) Storage of factors  (INT , estimated) =              65
 --  (5) Maximum frontal size      (estimated) =               3
 --  (6) Number of nodes in the tree           =               3
 -- (32) Type of analysis effectively used     =               1
 --  (7) Ordering option effectively used      =               2
ICNTL(6) Maximum transversal option            =               0
ICNTL(7) Pivot order option                    =               7
Percentage of memory relaxation (effective)    =              20
Number of level 2 nodes                        =               0
Number of split nodes                          =               0
RINFOG(1) Operations during elimination (estim)=   1.900D+01
 ** Rank of proc needing largest memory in IC facto        :               0
 ** Estimated corresponding MBYTES for IC facto            :               1
 ** Estimated avg. MBYTES per work. proc at facto (IC)     :               1
 ** TOTAL     space in MBYTES for IC factorization         :               3
 ** Rank of proc needing largest memory for OOC facto      :               0
 ** Estimated corresponding MBYTES for OOC facto           :               1
 ** Estimated avg. MBYTES per work. proc at facto (OOC)    :               1
 ** TOTAL     space in MBYTES for OOC factorization        :               3
 ELAPSED TIME IN ANALYSIS DRIVER=       0.0006

 ****** FACTORIZATION STEP ********


 GLOBAL STATISTICS PRIOR NUMERICAL FACTORIZATION ...
 NUMBER OF WORKING PROCESSES              =               3
 OUT-OF-CORE OPTION (ICNTL(22))           =               0
 REAL SPACE FOR FACTORS                   =              15
 INTEGER SPACE FOR FACTORS                =              65
 MAXIMUM FRONTAL SIZE (ESTIMATED)         =               3
 NUMBER OF NODES IN THE TREE              =               3
 MEMORY ALLOWED (MB -- 0: N/A )           =               0
 RELATIVE THRESHOLD FOR PIVOTING, CNTL(1) =      0.1000D-01
 Convergence error after scaling for ONE-NORM (option 7/8)   = 0.38D+00
 Maximum effective relaxed size of S              =             475
 Average effective relaxed size of S              =             469
 ELAPSED TIME FOR MATRIX DISTRIBUTION      =      0.0000
 ** Memory relaxation parameter ( ICNTL(14)  )            :        20
 ** Rank of processor needing largest memory in facto     :         0
 ** Space in MBYTES used by this processor for facto      :         1
 ** Avg. Space in MBYTES per working proc during facto    :         1

 ELAPSED TIME FOR FACTORIZATION           =      0.0012
 Maximum effective space used in S     (KEEP8(67))               12
 Average effective space used in S     (KEEP8(67))                5
 ** EFF Min: Rank of processor needing largest memory :         0
 ** EFF Min: Space in MBYTES used by this processor   :         1
 ** EFF Min: Avg. Space in MBYTES per working proc    :         1

 GLOBAL STATISTICS
 RINFOG(2)  OPERATIONS IN NODE ASSEMBLY   = 2.000D+00
 ------(3)  OPERATIONS IN NODE ELIMINATION= 1.900D+01
 INFOG (9)  REAL SPACE FOR FACTORS        =              15
 INFOG(10)  INTEGER SPACE FOR FACTORS     =              65
 INFOG(11)  MAXIMUM FRONT SIZE            =               3
 INFOG(29)  NUMBER OF ENTRIES IN FACTORS  =              15
 INFOG(12)  NUMBER OF OFF DIAGONAL PIVOTS =               0
 INFOG(13)  NUMBER OF DELAYED PIVOTS      =               0
 INFOG(14)  NUMBER OF MEMORY COMPRESS     =               0
 ELAPSED TIME IN FACTORIZATION DRIVER=       0.0019


 ****** SOLVE & CHECK STEP ********


 STATISTICS PRIOR SOLVE PHASE     ...........
 NUMBER OF RIGHT-HAND-SIDES                    =           1
 BLOCKING FACTOR FOR MULTIPLE RHS              =           1
 ICNTL (9)                                     =           1
  --- (10)                                     =           0
  --- (11)                                     =           0
  --- (20)                                     =           0
  --- (21)                                     =           0
  --- (30)                                     =           0
 ** Rank of processor needing largest memory in solve     :         0
 ** Space in MBYTES used by this processor for solve      :         0
 ** Avg. Space in MBYTES per working proc during solve    :         0

 Global statistics
 TIME to build/scatter RHS        =       0.000062
 TIME in solution step (fwd/bwd)  =       0.000247
  .. TIME in forward (fwd) step   =          0.000170
  .. TIME in backward (bwd) step  =          0.000055
 TIME to gather solution(cent.sol)=       0.000004
 TIME to copy/scale RHS (dist.sol)=       0.000000
 ELAPSED TIME IN SOLVE DRIVER=       0.0006
  Solution is   0.99999999999999989        2.0000000000000000        3.0000000000000004        3.9999999999999996        4.9999999999999991

Entering DMUMPS 5.1.2 with JOB =  -2
      executing #MPI =      3, without OMP
```

模型验证且运行成功，测试通过。

## 3.性能测试

### 3.1.测试平台信息对比

|          | arm信息                          | x86信息               |
| -------- | -------------------------------- | --------------------- |
| 操作系统 | openEuler 22.03 (LTS)            | openEuler 22.03 (LTS) |
| 内核版本 | 5.10.0-60.18.0.50.oe2203.aarch64 | 5.15.79.1.oe1.x86_64  |

### 3.2.测试软件环境信息对比

|           | arm信息       | x86信息   |
| --------- | ------------- | --------- |
| gcc       | bisheng 2.1.0 | gcc 9.3.0 |
| mpi       | hmpi1.1.1     | hmpi1.1.1 |
| CMake     | 3.23.1        | 3.23.1    |
| OpenBLAS  | 0.3.18        | 0.3.18    |
| lapack    | 3.8.0         | 3.8.0     |
| scalapack | 2.1.0         | 2.1.0     |

### 3.3.测试硬件性能信息对比

|        | arm信息     | x86信息  |
| ------ | ----------- | -------- |
| cpu    | Kunpeng 920 |          |
| 核心数 | 16          | 4        |
| 内存   | 32 GB       | 8 GB     |
| 磁盘io | 1.3 GB/s    | 400 MB/s |
| 虚拟化 | KVM         | KVM      |

### 3.4.测试选择的案例

example/ 目录下的文件 csimpletest

测试文件如下

```fortran
C
C  This file is part of MUMPS 5.1.2, released
C  on Mon Oct  2 07:37:01 UTC 2017
C
      PROGRAM MUMPS_TEST
      IMPLICIT NONE
      INCLUDE 'mpif.h'
      INCLUDE 'cmumps_struc.h'
      TYPE (CMUMPS_STRUC) mumps_par
      INTEGER IERR, I
      INTEGER(8) I8
      CALL MPI_INIT(IERR)
C Define a communicator for the package.
      mumps_par%COMM = MPI_COMM_WORLD
C  Initialize an instance of the package
C  for L U factorization (sym = 0, with working host)
      mumps_par%JOB = -1
      mumps_par%SYM = 0
      mumps_par%PAR = 1
      CALL CMUMPS(mumps_par)
      IF (mumps_par%INFOG(1).LT.0) THEN
       WRITE(6,'(A,A,I6,A,I9)') " ERROR RETURN: ",
     &            "  mumps_par%INFOG(1)= ", mumps_par%INFOG(1), 
     &            "  mumps_par%INFOG(2)= ", mumps_par%INFOG(2) 
       GOTO 500
      END IF
C  Define problem on the host (processor 0)
      IF ( mumps_par%MYID .eq. 0 ) THEN
        READ(5,*) mumps_par%N
        READ(5,*) mumps_par%NNZ
        ALLOCATE( mumps_par%IRN ( mumps_par%NNZ ) )
        ALLOCATE( mumps_par%JCN ( mumps_par%NNZ ) )
        ALLOCATE( mumps_par%A( mumps_par%NNZ ) )
        ALLOCATE( mumps_par%RHS ( mumps_par%N  ) )
        DO I8 = 1, mumps_par%NNZ
          READ(5,*) mumps_par%IRN(I8),mumps_par%JCN(I8),mumps_par%A(I8)
        END DO
        DO I = 1, mumps_par%N
          READ(5,*) mumps_par%RHS(I)
        END DO
      END IF
C  Call package for solution
      mumps_par%JOB = 6
      CALL CMUMPS(mumps_par)
      IF (mumps_par%INFOG(1).LT.0) THEN
       WRITE(6,'(A,A,I6,A,I9)') " ERROR RETURN: ",
     &            "  mumps_par%INFOG(1)= ", mumps_par%INFOG(1), 
     &            "  mumps_par%INFOG(2)= ", mumps_par%INFOG(2) 
       GOTO 500
      END IF
C  Solution has been assembled on the host
      IF ( mumps_par%MYID .eq. 0 ) THEN
        WRITE( 6, * ) ' Solution is ',(mumps_par%RHS(I),I=1,mumps_par%N)
      END IF
C  Deallocate user data
      IF ( mumps_par%MYID .eq. 0 )THEN
        DEALLOCATE( mumps_par%IRN )
        DEALLOCATE( mumps_par%JCN )
        DEALLOCATE( mumps_par%A   )
        DEALLOCATE( mumps_par%RHS )
      END IF
C  Destroy the instance (deallocate internal data structures)
      mumps_par%JOB = -2
      CALL CMUMPS(mumps_par)
      IF (mumps_par%INFOG(1).LT.0) THEN
       WRITE(6,'(A,A,I6,A,I9)') " ERROR RETURN: ",
     &            "  mumps_par%INFOG(1)= ", mumps_par%INFOG(1), 
     &            "  mumps_par%INFOG(2)= ", mumps_par%INFOG(2) 
       GOTO 500
      END IF
 500  CALL MPI_FINALIZE(IERR)
      STOP
      END
```

输入文件

```shell
5                                 : N
12                                : NZ
1 2 (3.0,0.0) 
2 3 (-3.0,0.0) 
4 3 (2.0,0.0) 
5 5 (1.0,0.0) 
2 1 (3.0,0.0) 
1 1 (2.0,0.0) 
5 2 (4.0,0.0) 
3 4 (2.0,0.0) 
2 5 (6.0,0.0) 
3 2 (-1.0,0.0) 
1 3 (4.0,0.0) 
3 3 (1.0,0.0)
(20.0,0.0) 
(24.0,0.0) 
(9.0,0.0) 
(6.0,0.0) 
(13.0,0.0) : RHS

```

### 3.5.单线程

单线程运行测试时间对比（五次运行取平均值）

|             | arm    | x86    |
| ----------- | ------ | ------ |
| 实际CPU时间 | 0.160s | 0.188s |
| 用户时间    | 0.064s | 0.063s |

### 3.6.多线程

多线程运行测试时间对比（五次运行取平均值）

|             | arm    | x86   |
| ----------- | ------ | ----- |
| 线程数      | 4      | 4     |
| 实际CPU时间 | 0.159s | 0.204 |
| 用户时间    | 0.197s | 0.168 |

arm多线程时间耗费数据表：

| 线程          | 1     | 2     | 4     | 8     |
| :------------ | ----- | ----- | ----- | ----- |
| 用户时间(s)   | 0.160 | 0.155 | 0.159 | 0.174 |
| 用户态时间(s) | 0.064 | 0.099 | 0.197 | 0.407 |
| 内核态时间(s) | 0.053 | 0.082 | 0.127 | 0.257 |

x86多线程时间耗费数据表：

| 线程            | 1     | 2     | 3     | 4     |
| --------------- | ----- | ----- | ----- | ----- |
| 用户时间 （s）  | 0.188 | 0.195 | 0.216 | 0.204 |
| 用户态时间（s） | 0.063 | 0.079 | 0.150 | 0.168 |
| 内核态时间（s） | 0.163 | 0.281 | 0.424 | 0.520 |

由上表可知，在线程逐渐增加的情况下，所减少的用户时间并非线性关系，线程数增加后，运算用时并未显著下降，且系统调用的时间有较为明显的上升趋势。

### 3.7.测试总结

性能测试arm平台均在x86平台50%以上,且随着线程数的增加，两个平台的对于同一个应用的所耗费的时间差距逐渐减少。

且线程增加并不会无限制减少应用的实际耗费时间，在合理的范围内分配线程数才能更好的利用算力资源。

## 4.精度测试

### 4.1.所选测试案例

example/ 目录下的文件 c_example.c

使用 C 接口的示例程序

- MUMPS 的双实数算术版本，dmumps_c。
- 我们解决系统 A x = RHS 与
- A = diag(1 2) 和 RHS = [1 4]^T
- 解是 [1 2]^T */

测试文件如下

```c
/*
 *
 *  This file is part of MUMPS 5.1.2, released
 *  on Mon Oct  2 07:37:01 UTC 2017
 *
 */
/* Example program using the C interface to the 
 * double real arithmetic version of MUMPS, dmumps_c.
 * We solve the system A x = RHS with
 *   A = diag(1 2) and RHS = [1 4]^T
 * Solution is [1 2]^T */
#include <stdio.h>
#include <string.h>
#include "mpi.h"
#include "dmumps_c.h"
#define JOB_INIT -1
#define JOB_END -2
#define USE_COMM_WORLD -987654

#if defined(MAIN_COMP)
/*
 * Some Fortran compilers (COMPAQ fort) define main inside
 * their runtime library while a Fortran program translates
 * to MAIN_ or MAIN__ which is then called from "main". This
 * is annoying because MAIN__ has no arguments and we must
 * define argc/argv arbitrarily !!
 */
int MAIN__();
int MAIN_()
  {
    return MAIN__();
  }

int MAIN__()
{
  int argc=1;
  char * name = "c_example";
  char ** argv ;
#else
int main(int argc, char ** argv)
{
#endif
  DMUMPS_STRUC_C id;
  MUMPS_INT n = 2;
  MUMPS_INT8 nnz = 2;
  MUMPS_INT irn[] = {1,2};
  MUMPS_INT jcn[] = {1,2};
  double a[2];
  double rhs[2];

  MUMPS_INT myid, ierr;

  int error = 0;
#if defined(MAIN_COMP)
  argv = &name;
#endif
  ierr = MPI_Init(&argc, &argv);
  ierr = MPI_Comm_rank(MPI_COMM_WORLD, &myid);
  /* Define A and rhs */
  rhs[0]=1.0;rhs[1]=4.0;
  a[0]=1.0;a[1]=2.0;

  /* Initialize a MUMPS instance. Use MPI_COMM_WORLD */
  id.comm_fortran=USE_COMM_WORLD;
  id.par=1; id.sym=0;
  id.job=JOB_INIT;
  dmumps_c(&id);

  /* Define the problem on the host */
  if (myid == 0) {
    id.n = n; id.nnz =nnz; id.irn=irn; id.jcn=jcn;
    id.a = a; id.rhs = rhs;
  }
#define ICNTL(I) icntl[(I)-1] /* macro s.t. indices match documentation */
  /* No outputs */
  id.ICNTL(1)=-1; id.ICNTL(2)=-1; id.ICNTL(3)=-1; id.ICNTL(4)=0;

  /* Call the MUMPS package (analyse, factorization and solve). */
  id.job=6;
  dmumps_c(&id);
  if (id.infog[0]<0) {
    printf(" (PROC %d) ERROR RETURN: \tINFOG(1)= %d\n\t\t\t\tINFOG(2)= %d\n",
        myid, id.infog[0], id.infog[1]);
    error = 1;
  }

  /* Terminate instance. */
  id.job=JOB_END;
  dmumps_c(&id);
  if (myid == 0) {
    if (!error) {
      printf("Solution is : (%8.2f  %8.2f)\n", rhs[0],rhs[1]);
    } else {
      printf("An error has occured, please check error code returned by MUMPS.\n");
    }
  }
  ierr = MPI_Finalize();
  return 0;
}
```

通过Makefile进行编译
运行选项如下：

```bash
make clean all
MPIRUN="mpirun -np 3 --mca plm_rsh_agent sh --mca opal_warn_on_missing_libcuda 0 --oversubscribe" 
${MPIRUN} ./c_example
```

### 4.2.获取对比数据

arm 运行结果

```bash
Solution is : (    1.00      2.00)
```

### 4.3.测试总结

从arm输出结果可以看出测试通过，满足example/README中的结果。
