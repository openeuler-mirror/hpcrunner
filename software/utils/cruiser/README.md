

# 悟合精度分析库libcruiser.so

### 工具简介

本项目的核心能力库，提供了底层对变量的hash和NaN/Inf值检测的能力。该库具备多进程场景下分RANK判断的能力，能够准确地识别和处理精度差异问题。此外，输出的日志可以与待优化程序的日志耦合在一起输出，也可以单独输出到单独的日志文件中。

### 工具版本

2.2.0

- **增加对线程的感知：**增加用于非MPI，多线程场景下的使用能力，适配EDA等场景的软件特性
- **增加对老版本编译器的适应能力：**针对一些接口适配了低版本编译器，增加场景适配能力
- **增强版本管理能力：**通过软链接增加用户对分析库的版本感知能力

### 适用变量

- **√ 支持**

  基本变量，基本变量数组，结构体当中的基本变量，结构体当中的数组

- **× 不支持**

  链表，整个结构体变量，结构体变量数组

### 适用场景

1. **双平台精度差异定位：**将变量hash成md5值，对比程序在双平台运行后输出日志中的md5值，递归定位，最终定位导致精度差异的源码。

   ```text
   [FLAG]:Custom Flag [PARAM]:Name of Parameter [MODE]:Mpi Mode [RESULT]: Md5 Value of Parameter
   ```

   

2. **变量异常值（NaN/Inf）定位：**检测传入的变量是否为NaN/Inf值，是否含有或全部为NaN/Inf值。

   ```shell
   # [变量/数组] 全部为NaN值或Inf值
   [FLAG]:Custom Flag [PARAM]:Name of Parameter [MODE]:Mpi Mode [RESULT]:ALL NAN
   
   # [数组] 存在NaN值或Inf值
   [FLAG]:Custom Flag [PARAM]:Name of Parameter [MODE]:Mpi Mode [RESULT]:ALL NAN
   ```

### 结果说明

| 结果项   | 说明                                                |
| -------- | --------------------------------------------------- |
| [FLAG]   | 用户自定义标志位                                    |
| [PARAM]  | 变量名称                                            |
| [MODE]   | MPI模式                                             |
| [RESULT] | 输出结果，结果为32位hash值或者ALL NAN 或者EXIST NAN |

### 目录结构

```shell
/path/to/libcruiser
├── include
│   ├── cruiser.h                                           #适用MPI版本头文件
│   └── cruiser_thr.h                                       #适用多线程版本头文件
└── lib
    ├── libcruiser_mpi.so -> libcruiser_mpi.so.2
    ├── libcruiser_mpi.so.2 -> libcruiser_mpi.so.2.2.0
    ├── libcruiser_mpi.so.2.2.0                             #适用仅MPI场景，mode输出：RANK-1
    ├── libcruiser.so -> libcruiser.so.2
    ├── libcruiser.so.2 -> libcruiser.so.2.2.0
    ├── libcruiser.so.2.2.0                                 #适用MPI-多线程混合场景，mode输出：RANK-1-TID-10001
    ├── libcruiser_thr.so -> libcruiser_thr.so.2
    ├── libcruiser_thr.so.2 -> libcruiser_thr.so.2.2.0
    └── libcruiser_thr.so.2.2.0                             #使用仅多线程场景，mode输出：TID-10001
```

### 快速上手

1. 将工具压缩包`libcruiser.tar.gz`上传至服务器并解压。上传路径一般为项目源码的根目录。此处假设上传路径为：`/path/to/cruiser`。

   ```shell
   cd /path/to/cruiser
   tar -xvf libcruiser.tar.gz
   mv ./cruiser/* .
   ```

   <font color=red>需要注意：</font>若服务器为集群环境，则需要上传至共享目录中。

2. ，在待精度调优的软件源码中插入输出语句，即调用对应API。若源码为C/C++语言，则源码中需要引入头文件cruiser.h。

3. 修改项目源码编译脚本，在程序链接选项中追加以下语句：

   ```shell
   -L/path/to/cruiser/lib -lcruiser -lcrypto
   ```

   若编译器版本为GNU且版本低于4.5：

   ```shell
   -L/path/to/cruiser/lib -lcruiser -lcrypto -lm
   ```

   若源码为C/C++语言，则需额外追加头文件地址：

   ```shell
   -L/path/to/cruiser/lib -lcruiser -lcrypto -I/path/to/cruiser/include
   ```

4. 修改运行脚本，加入以下语句。

   ```shell
   export LD_LIBRARY_PATH=/path/to/cruiser/lib:$LD_LIBRARY_PATH
   ```

   （可选）工具默认将结果输出至标准输出，如需将精度日志重定向到指定文件，则需在运行脚本中指定重定向的路径，工具会将日志重定向到该路径下的`cruiser.log`文件当中。若指定的文件夹没有可写权限时，将自动将日志重定向至`$HOME`目录下。

   ```shell
   # 假定日志需重定向输出至/path/to/，日志将会被重定向至/path/to/cruiser.log
   export CRUISER_LOG=/path/to/
   ```

5. 编译并运行程序。

6. 手动或使用自动化定位工具`cruiser.exe`对比输出的日志，找到差异情况。

7. 递归使用，找到导致精度差异的源码。

### 接口预览

##### 仅多线程场景

- 值差异场景

  ```c
  // C/C++接口
  void Hash(void *data, const char *name_data, int type, int len_data, const char *flag);
  
  // Fortran接口
  void hash(void *data, const char *name_data, const int *type, const int *len_data, const char *flag);
  ```

- NaN/Inf值场景

  ```c
  // C/C++接口
  void Nan(void *data, const char *name_data, int type, int len_data, const char *flag);
  
  // Fortran接口
  void nan(void *data, const char *name_data, const int *type, const int *len_data, const char *flag);
  ```

- 综合场景（即打印hash值，也检测Na/Inf值）

  ```c
  // C/C++接口
  void Cruiser(void *data, const char *name_data, int type, int len_data, const char *flag);
  
  // Fortran接口
  void cruiser(void *data, const char *name_data, const int *type, const int *len_data, const char *flag);
  ```

##### MPI场景

- 值差异场景

  ```c
  // C/C++接口
  void Hash(void *data, const char *name_data, int type, int len_data, const char *flag, int rank);
  
  // Fortran接口
  void hash(void *data, const char *name_data, const int *type, const int *len_data, const char *flag, const int *rank);
  ```
  
- NaN/Inf值场景

  ```c
  // C/C++接口
  void Nan(void *data, const char *name_data, int type, int len_data, const char *flag, int rank);
  
  // Fortran接口
  void nan(void *data, const char *name_data, const int *type, const int *len_data, const char *flag, const int *rank);
  ```
  
- 综合场景（即打印hash值，也检测Na/Inf值）

  ```c
  // C/C++接口
  void Cruiser(void *data, const char *name_data, int type, int len_data, const char *flag, int rank);
  
  // Fortran接口
  void cruiser(void *data, const char *name_data, const int *type, const int *len_data, const char *flag, const int *rank);
  ```
  
##### 额外接口

  为了解决Fortran与C/C++语言间，字符串结构不同带来的字符串变量乱码现象，提供一个字符串修正的Fortran接口进行使用。本接口最大支持256个字符。

  ```fortran
  character correct(string)
  ```

##### 参数含义

  | 变量名    | 类型                                  | 含义               | 备注                                                         |
  | --------- | ------------------------------------- | ------------------ | ------------------------------------------------------------ |
  | data      | void*                                 | 变量地址           | -                                                            |
  | name_data | const char *                          | 变量名称           | -                                                            |
  | type      | C/C++: int, <br>Fortran: const int *  | 变量类型           | 建议接口：<br>C/C++: sizeof(x) or sizeof(x[0]), <br>Fortran: kind(x) |
  | len_data  | C/C++: int, <br/>Fortran: const int * | 变量长度           | 建议接口：<br/>C/C++: 1 or sizeof(x)/sizeof(x[0]), <br/>Fortran: size(x) |
  | flag      | const char *                          | 用户自定义字符串， | 建议此处传入充分的信息<br>filename（文件路径，建议使用绝对路径）<br>\|function（方法名称，包含类信息和方法信息）<br>\|mode（模式位，call function or assign parameter）<br>\|status（状态位，START或者END）\|row（行号） |
  | rank      | C/C++: int, <br/>Fortran: const int * | 指定rank号         | 在rank=-1时，使能全rank打印模式；<br>在rank=0时，使能主进程模式;<br>在rank为正整数时，使能指定rank输出模式；<br>在单进程场景下，指定任何数都无影响。 |



### 使用样例

样例以值差异场景为基础进行介绍，NaN/Inf值场景和综合场景可以通过替换API进行达成。所有接口在不同场景下的参数类型相同，可进行替换进行使用。

##### C/C++

假定初始源码文件：/path/to/source.c。

```c
int function(int param1, float param2){
	double param3[] = {...};
    ...
    function1(param1, param3); 
    ...
    param2 = function2();
    ...
    return 0;
}
```

一般情况

```c
#include<cruiser.h>

int function(int param1, float param2){
	double param3[] = {...};
    	...
    int type = sizeof(param3[0]);
    int length = sizeof(param3)/type;
    Hash(&param1, "param1", sizeof(param1), 1, "/path/to/source.c|function|call function1|START|8", -1);
    Hash(&param3, "param3", type, length, "/path/to/source.c|function|call function1|START|9", -1);
    function1(param1, param3); 
    Hash(&param1, "param1", sizeof(param1), 1, "/path/to/source.c|function|call function1|END|11", -1);
    Hash(&param3, "param3", type, length, "/path/to/source.c|function|call function1|END|12", -1);
    	...
    Hash(&param2, "param2", sizeof(param2), 1, "/path/to/source.c|function|assign param2|START|14", -1);
    param2 = function2();
    Hash(&param2, "param2", sizeof(param2), 1, "/path/to/source.c|function|assign param2|START|16", -1);
    	...
    return 0;
}

// 输出
[FLAG]:/path/to/source.c|function|call function1|START|8 [PARAM]:param1 [MODE]:SINGLE [RESULT]: e58ew9w6w58d4s2s3w8errh135hsey30
[FLAG]:/path/to/source.c|function|call function1|START|9 [PARAM]:param3 [MODE]:SINGLE [RESULT]: 34f6hn1ryt54i3a1v3s8t4i73avdgsh6
[FLAG]:/path/to/source.c|function|call function1|END|11 [PARAM]:param1 [MODE]:SINGLE [RESULT]: df5j4dh1d54hd43215d35fdjh8d2f1hf
[FLAG]:/path/to/source.c|function|call function1|END|12 [PARAM]:param3 [MODE]:SINGLE [RESULT]: fd54h6gasr4h6gs5dh48a4r651dvb8br
[FLAG]:/path/to/source.c|function|assign param2|START|14 [PARAM]:param2 [MODE]:SINGLE [RESULT]: r45ha16fh5b4fhs1gd4fh4rhb4r8h45s
[FLAG]:/path/to/source.c|function|assign param2|END|16 [PARAM]:param2 [MODE]:SINGLE [RESULT]: sr65h46h46d4n6h4r84eh5rh151brh84 
```

指定进程号

```c
#include<cruiser.h>

int function(int param1, float param2){
	double param3[] = {...};
        ... 
    int rank = 66;
    	...
    int type = sizeof(param3[0]);
    int length = sizeof(param3)/type;
    Hash_Rank(&param1, "param1", sizeof(param1), 1, "/path/to/source.c|function|call function1|START|12", rank);
    Hash_Rank(&param3, "param3", type, length, "/path/to/source.c|function|call function1|START|13", rank);
    function1(param1, param3); 
    Hash_Rank(&param1, "param1", sizeof(param1), 1, "/path/to/source.c|function|call function1|END|15", rank);
    Hash_Rank(&param3, "param3", type, length, "/path/to/source.c|function|call function1|END|16", rank);
    	...
    Hash_Rank(&param2, "param2", sizeof(param2), 1, "/path/to/source.c|function|assign param2|START|18", rank);
    param2 = function2();
    Hash_Rank(&param2, "param2", sizeof(param2), 1, "/path/to/source.c|function|assign param2|START|20", rank);
    	...
    return 0;
}
// 输出
[FLAG]:/path/to/source.c|function|call function1|START|8 [PARAM]:param1 [MODE]:RANK-66 [RESULT]: e58ew9w6w58d4s2s3w8errh135hsey30
[FLAG]:/path/to/source.c|function|call function1|START|9 [PARAM]:param3 [MODE]:RANK-66 [RESULT]: 34f6hn1ryt54i3a1v3s8t4i73avdgsh6
[FLAG]:/path/to/source.c|function|call function1|END|11 [PARAM]:param1 [MODE]:RANK-66 [RESULT]: df5j4dh1d54hd43215d35fdjh8d2f1hf
[FLAG]:/path/to/source.c|function|call function1|END|12 [PARAM]:param3 [MODE]:RANK-66 [RESULT]: fd54h6gasr4h6gs5dh48a4r651dvb8br
[FLAG]:/path/to/source.c|function|assign param2|START|14 [PARAM]:param2 [MODE]:RANK-66 [RESULT]: r45ha16fh5b4fhs1gd4fh4rhb4r8h45s
[FLAG]:/path/to/source.c|function|assign param2|END|16 [PARAM]:param2 [MODE]:RANK-66 [RESULT]: sr65h46h46d4n6h4r84eh5rh151brh84 
```

##### Fortran

假定初始源码文件：/path/to/source.F90。

```fortran
subroutine function
	...
	implicit none
	integer param1
	real :: param2
	double :: param3(:)
		...
	call function(param1, param3)
		...
	param2 = call function2()
		...
end subroutine function
```

一般情况

```fortran
subroutine function
	...
	implicit none
	character :: correct
	integer param1
	real :: param2
	double :: param3(:)
		...
    call hash(&param1, correct("param1"), kind(param1), 1, correct("/path/to/source.F90|function|call function1|START|8"), -1)
    call hash(&param3, correct("param3"), kind(param3), size(param3), "/path/to/source.F90|function|call function1|START|9"), -1)
	call function(param1, param3)
	call hash(&param1, correct("param1"), kind(param1), 1, correct("/path/to/source.F90|function|call function1|END|11"), -1)
    call hash(&param3, correct("param3"), kind(param3), size(param3), correct("/path/to/source.F90|function|call function1|END|12"), -1)
		...
	call hash(&param1, correct("param1"), kind(param1), 1, correct("/path/to/source.F90|function|assign param2|START|14"), -1)
	param2 = call function2()
	call hash(&param1, correct("param1"), kind(param1), 1, correct("/path/to/source.F90|function|assign param2|START|16"), -1)
		...
end subroutine function

! 输出
[FLAG]:/path/to/source.F90|function|call function1|START|8 [PARAM]:param1 [MODE]:SINGLE [RESULT]: e58ew9w6w58d4s2s3w8errh135hsey30
[FLAG]:/path/to/source.F90|function|call function1|START|9 [PARAM]:param3 [MODE]:SINGLE [RESULT]: 34f6hn1ryt54i3a1v3s8t4i73avdgsh6
[FLAG]:/path/to/source.F90|function|call function1|END|11 [PARAM]:param1 [MODE]:SINGLE [RESULT]: df5j4dh1d54hd43215d35fdjh8d2f1hf
[FLAG]:/path/to/source.F90|function|call function1|END|12 [PARAM]:param3 [MODE]:SINGLE [RESULT]: fd54h6gasr4h6gs5dh48a4r651dvb8br
[FLAG]:/path/to/source.F90|function|assign param2|START|14 [PARAM]:param2 [MODE]:SINGLE [RESULT]: r45ha16fh5b4fhs1gd4fh4rhb4r8h45s
[FLAG]:/path/to/source.F90|function|assign param2|END|16 [PARAM]:param2 [MODE]:SINGLE [RESULT]: sr65h46h46d4n6h4r84eh5rh151brh84 
```

指定进程号

```fortran
subroutine function
	...
	implicit none
	character :: correct
	integer param1
	real :: param2
	double :: param3(:)
		...
    call hash_rank(&param1, correct("param1"), kind(param1), 1, correct("/path/to/source.F90|function|call function1|START|8"), 66)
    call hash_rank(&param3, correct("param3"), kind(param3), size(param3), correct("/path/to/source.F90|function|call function1|START|9"), 66)
	call function(param1, param3)
	call hash_rank(&param1, correct("param1"), kind(param1), 1, correct("/path/to/source.F90|function|call function1|END|11", 66)
    call hash_rank(&param3, correct("param3"), kind(param3), size(param3), correct("/path/to/source.F90|function|call function1|END|12"), 66)
		...
	call hash_rank(&param1, correct("param1"), kind(param1), 1, correct("/path/to/source.F90|function|assign param2|START|14"), 66)
	param2 = call function2()
	call hash_rank(&param1, correct("param1"), kind(param1), 1, correct("/path/to/source.F90|function|assign param2|START|16"), 66)
		...
end subroutine function

! 输出
[FLAG]:/path/to/source.F90|function|call function1|START|8 [PARAM]:param1 [MODE]:RANK-66 [RESULT]: e58ew9w6w58d4s2s3w8errh135hsey30
[FLAG]:/path/to/source.F90|function|call function1|START|9 [PARAM]:param3 [MODE]:RANK-66 [RESULT]: 34f6hn1ryt54i3a1v3s8t4i73avdgsh6
[FLAG]:/path/to/source.F90|function|call function1|END|11 [PARAM]:param1 [MODE]:RANK-66 [RESULT]: df5j4dh1d54hd43215d35fdjh8d2f1hf
[FLAG]:/path/to/source.F90|function|call function1|END|12 [PARAM]:param3 [MODE]:RANK-66 [RESULT]: fd54h6gasr4h6gs5dh48a4r651dvb8br
[FLAG]:/path/to/source.F90|function|assign param2|START|14 [PARAM]:param2 [MODE]:RANK-66 [RESULT]: r45ha16fh5b4fhs1gd4fh4rhb4r8h45s
[FLAG]:/path/to/source.F90|function|assign param2|END|16 [PARAM]:param2 [MODE]:RANK-66 [RESULT]: sr65h46h46d4n6h4r84eh5rh151brh84 
```
