# HPCRunner : 智能助手，一站式部署调优HPC应用

![贾维斯](./images/jarvis-logo.png)

# 1 概述

## 1.1 项目背景

HPC被喻为是IT行业“金字塔上的明珠”，其部署、编译、运行及性能分析门槛较高。在不同机器上部署HPC应用往往耗时费力，且常需同时维护ARM和X86两套环境进行验证，导致大量重复工作，影响核心算法的优化效率。本项目旨在提供一套跨架构的统一部署工具，简化多环境部署流程，提升整体开发效率。

## 1.2 部署场景说明

### 1.2.1 网络环境
- 推荐使用具备外网访问能力的服务器（可ping通百度、GitHub等），便于自动下载应用安装包与算例，安装步骤请参考[2.1](https://atomgit.com/wmrd/hpcrunner/blob/master/README.md#21-%E5%9C%BA%E6%99%AF1%E5%9C%A8%E5%85%B7%E5%A4%87%E5%A4%96%E7%BD%91%E8%AE%BF%E9%97%AE%E8%83%BD%E5%8A%9B%E7%9A%84%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%8A%E4%BD%BF%E7%94%A8hpcrunner)；

- 若服务器无法访问外网，则需要自行下载安装包上传到服务器，详细步骤请参考[2.2](https://atomgit.com/wmrd/hpcrunner/blob/master/README.md#22-%E5%9C%BA%E6%99%AF2%E5%9C%A8%E4%B8%8D%E5%85%B7%E5%A4%87%E5%A4%96%E7%BD%91%E8%AE%BF%E9%97%AE%E8%83%BD%E5%8A%9B%E7%9A%84%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%8A%E4%BD%BF%E7%94%A8hpcrunner)。

### 1.2.2 执行环境

使用工具部署时需根据配置文件（config）名称中的关键字段匹配对应的执行环境，示例如下：

| 配置文件示例 | 关键字段 | 执行说明 |
|--|--|--|
| data.qe.arm.cpu.config | arm | 需在 ARM 环境执行 |
| data.qe.arm-sve.cpu.config | arm-sve | 需在支持 SVE 的 ARM 服务器执行 |
| data.qe.arm.gpu.config | arm+gpu | 需在配备 GPU 的 ARM 服务器执行 |
| data.qe.x86.gpu.config | x86 | 需在 x86 架构服务器上执行 |
| data.qe.x86.gpu.config | x86+gpu | 需在配备 GPU 的 x86 服务器执行 |

### 1.2.3 内存和磁盘要求
- 内存：建议在32G空闲内存的设备上进行安装；
- 磁盘：建议/tmp目录剩余可用磁盘空间大于100G。

### 1.2.4 OS和内核要求
- 已验证环境：当前应用已在ARM服务器 搭配openEuler 22.03 SP4系统（内核版本 5.10）上完成编译部署验证；
- 其他环境：如需在其他操作系统或内核版本中部署，请根据实际编译与安装需求对相关脚本进行相应修改。

# 2 hpcrunner使用指导

请根据目标服务器的网络环境，选择对应的使用指导。

## 2.1 场景1：在具备外网访问能力的服务器上使用hpcrunner

### 2.1.1 使用流程

若用户的目标服务器具备外网访问能力，请按照以下流程操作。

![image.png](https://raw.atomgit.com/user-images/assets/8782283/71280310-5bbc-471f-b0f9-68ca3ac72b8e/image.png 'image.png')

### 2.1.2 安装基础依赖

使用hpcrunner需要安装基础依赖，执行如下命令进行安装：
```
yum -y install git time zlib zlib-devel gcc gcc-c++ environment-modules python python3 python3-devel python3-libs python3-pip cmake make numactl numactl-devel numactl-libs rpmdevtools wget libtirpc libtirpc-devel unzip flex tar patch glibc-devel rpcbind csh perl-XML-LibXML xorg-x11-xauth curl curl-devel libcurl-devel
```

### 2.1.3 下载hpcrunner

执行如下命令下载hpcrunner并完成安装：
```
git clone https://atomgit.com/openeuler/hpcrunner.git
```

![图片1.png](https://raw.atomgit.com/user-images/assets/8782283/a1e81840-a09b-45dc-8776-763325e6bf0e/图片1.png '图片1.png')

### 2.1.4 使用hpcrunner安装应用 (以WRF应用为例)

![image.png](https://raw.atomgit.com/user-images/assets/8782283/cd792f94-257c-4bf0-b474-c20a89035c7f/image.png 'image.png')

本章节以WRF为例，介绍如何使用hpcrunner安装应用：

（1）	进入hpcrunner目录

```
cd hpcrunner
```

（2）	加载环境变量，编译安装WRF

```
source init.sh
./jarvis -use templates/wrf/4.7.1/data.wrf.arm.cpu.config 
./jarvis -d
./jarvis -dp
./jarvis -b
./jarvis -r
```

详细解释请参考：[WRF-hpcrunner工具自动化构建与跨平台安装](https://www.hikunpeng.com/zh/developer/techArticles/20251223-1)

注：应用模板(即templates/wrf/4.7.1/data.wrf.arm.cpu.config)根据实际需要安装的软件进行选择替换，其他应用模板请[参考链接](https://atomgit.com/openeuler/hpcrunner/tree/master/templates)。

（3）	配置网络代理（可选）

如具备外网访问能力的服务器下载软件安装包失败，可尝试切换下载源，执行proxy.sh脚本，输入数字选择合适的源。

```
./proxy.sh
```

![图片2.png](https://raw.atomgit.com/user-images/assets/8782283/925da12e-4499-4981-a191-7e357563800d/图片2.png '图片2.png')

## 2.2 场景2：在不具备外网访问能力的服务器上使用hpcrunner

### 2.2.1 使用流程

若目标服务器无法访问外网，请按照以下流程操作：



### 2.2.2 操作步骤(以WRF应用为例)

1、	找到一台可联网的服务器，在该服务器上执行以下步骤：

（1）	安装基础依赖并下载hpcrunner，详细步骤请参考[2.1.2](https://atomgit.com/wmrd/hpcrunner/blob/master/README.md#212-%E5%AE%89%E8%A3%85%E5%9F%BA%E7%A1%80%E4%BE%9D%E8%B5%96)和[2.1.3](https://atomgit.com/wmrd/hpcrunner/blob/master/README.md#213-%E4%B8%8B%E8%BD%BDhpcrunner)

（2）	执行以下步骤，下载所有的源码包：

  切换到hpcrunner目录，加载环境变量，指定应用模板

```
cd hpcrunner && source init.sh && ./jarvis -use templates/wrf/4.7.1/data.wrf.arm.cpu.config
```

下载应用和依赖软件源码

```
./jarvis -d && ./jarvis -dp
```

2、将整个hpcrunner目录拷贝至不具备外网访问能力的目标服务器

3、在不可访问外网的目标服务器上，继续执行以下步骤：

（1）	登录目标服务器，进入压缩包所在目录并解压

（2）	配置本地yum源：

由于目标机无法连接外部yum仓库，必须预先设置好本地或内部软件源，以安装基础系统依赖，详细步骤请参考[链接](https://www.hikunpeng.com/document/detail/zh/kunpengdbs/ecosystemEnable/MariaDB/openmind_mariadb1039_02_0005.html)。

（3）	在目标服务器上安装基础依赖，详细步骤请参考[2.1.2](https://atomgit.com/wmrd/hpcrunner/blob/master/README.md#212-%E5%AE%89%E8%A3%85%E5%9F%BA%E7%A1%80%E4%BE%9D%E8%B5%96)

（4）	在目标服务器上使用hpcrunner安装应用参考[2.1.4](https://atomgit.com/wmrd/hpcrunner/blob/master/README.md#214-%E4%BD%BF%E7%94%A8hpcrunner%E5%AE%89%E8%A3%85%E5%BA%94%E7%94%A8-%E4%BB%A5wrf%E5%BA%94%E7%94%A8%E4%B8%BA%E4%BE%8B)


## 3 hpcrunner详细功能介绍 

### 3.1 贾维斯目录结构

| 目录/文件     | 说明                                  | 备注                                                   |
|-----------|-------------------------------------|------------------------------------------------------|
| benchmark | HPL、Stream、矩阵运算、OpenMP、MPI、P2P等性能测试 |                                                      |
| doc       | 文档                                  |                                                      |
| downloads | 存放依赖库源码包/压缩包                        |                                                      |
| examples  | 性能小实验                               |                                                      |
| package   | 存放安装脚本和FAQ                          |                                                      |
| software  | 软件安装目录(内置精度分析工具)                    | 自动生成<br>apps为应用软件安装目录<br>其他目录参考[option介绍](#option介绍) |
| src       | 贾维斯源码                               |                                                      |
| templates | 常用HPC应用的配置模板                        |                                                      |
| test      | 贾维斯测试用例                             |                                                      |
| workloads | 常用HPC应用的算例合集和测试目录                   |                                                      |
| init.sh   | 贾维斯初始化文件                            |                                                      |
| jarvis    | 贾维斯启动入口                             |                                                      |
| tmp       | 软件编译目录和解压后源码存放目录                    |                                                      |

### 3.2 配置文件（config文件）

| **配置项**      | **说明**                                                                                        | **示例**                                                                                                                                  |
|--------------|-----------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| [SERVER]     | 指定节点列表，按行书写，用于自动生成hostfile                                                                    | 11.11.11.11<br>22.22.22.22                                                                                                              |
| [DOWNLOAD]   | 格式：app/appversion download_url [alias]<br>**注：**在没有网络场景下，可提前将下载好的安装包放置在hpcrunner/downloads目录下 | cp2k/8.2 https://github.com/extdomains/github.com/cp2k/cp2k/releases/download/v8.2.0/cp2k-8.2.tar.bz2                                   |
| [DEPENDENCY] | HPC应用所需安装的依赖软件                                                                                | ./jarvis -install gmp/6.2.0 clang<br>./jarvis -install boost/1.72.0 clang                                                               |
| [ENV]        | HPC应用编译运行所需的环境配置                                                                              | module use ./software/modulefiles<br>module load bisheng/3.2.0<br>module load boost/1.72.0                                              |
| [APP]        | HPC应用信息，包括应用名、构建路径、二进制路径、算例路径                                                                 | app_name = CP2K <br>build_dir = /home/cp2k-8.2/ <br>binary_dir = /home/CP2K/cp2k-8.2/bin/ case_dir = /home/CP2K/cp2k-8.2/benchmarks/QS/ |
| [BUILD]      | HPC应用构建脚本                                                                                     | ./configure <br>make -j<br>make install                                                                                                 |
| [CLEAN]      | HPC应用编译清理脚本                                                                                   | make clean                                                                                                                              |
| [RUN]        | HPC应用运行配置，包括前置命令、应用命令和节点个数                                                                    | run = mpirun -np 2 <br>binary = cp2k.psmp H2O-256.inp <br>nodes = 1                                                                     |
| [JOB]        | HPC应用作业调度运行配置                                                                                 | 多瑙作业调度脚本                                                                                                                                |
| [BATCH]      | HPC应用批量运行命令****                                                                               | #!/bin/bash <br>mpirun -np 2 cp2k.psmp H2O-256.inp mpirun -np 2 cp2k.psmp H2O-512.inp                                                   |
| [PERF]       | 性能分析采集工具额外参数配置                                                                                | perf= -o <br>nsys= <br>ncu=--target-processes all --launch-skip 71434 --launch-count 1                                                  |

### 3.3 运行指令

| **功能**                | **命令**                                                                           | **示例/说明**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
|-----------------------|----------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 帮助信息                  | ./jarvis -h                                                                      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| 生效应用模板                | ./jarvis -use /path/app.config                                                   | 由高到低，模板使用优先级顺序：<br>1.通过环境变量JARVIS_CONFIG指定模板, 支持多用户并行使用贾维斯。<br>export JARVIS_CONFIG=/path/app.config<br>2.通过命令”./jarvis -use /path/app.config”指定模板。<br>3.贾维斯根目录下默认模板data.config。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| 一键下载HPC应用             | ./jarvis -d                                                                      | 应用将自动下载[DOWNLOAD]中指定的安装包到downloads目录。<br>**注：**在没有网络场景下，可提前将下载好的安装包放置到downloads目录下                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| 安装依赖                  | ./jarvis -install [package/][name/version/other] [option]                        | 支持安装的软件清单位于package目录下，可在package目录下获取[name/version/other]各字段信息，精确到”install.sh”的上一层目录<br>各参数具体含义：<br>package：可选<br>name：软件名<br>version：软件版本<br>other：子版本，”install.sh”的上一层目录<br>option：指定依赖的编译工具，支持的选项如下表<br>示例如下：<br>1. 安装编译器<br>./jarvis -install hpckit/x.x.x any<br>module use xxx<br>module load bisheng/xxx<br>2. 安装mpi<br>./jarvis -install hpckit/x.x.x any<br>module use xxx<br>module load hmpi/xxx<br>3. 安装依赖<br>module use software/module*<br>module load bisheng/x.x.x<br>module load hmpi/x.x.x<br>export CC=mpicc CXX=mpicxx FC=mpifort <br>./jarvis -install hdf5/1.8.20/clang bisheng+mpi<br>4. 安装工具<br>./jarvis -install hpckit/2025.3.30 any<br>./jarvis -install go/1.18 any |
| 一键卸载依赖                | ./jarvis -remove xxx                                                             | 支持模糊查询 ./jarvis -remove openblas/0.3.18                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| 一键下载并安装所有依赖           | ./jarvis -dp                                                                     | 需要提前指定应用模板./jarvis -use app.config<br>读取配置文件中的[DEPENDENCY]字段内容并按顺序执行                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| 输出已安装的软件清单            | ./jarvis -l                                                                      | 输出清单以相对路径列出                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 查询已安装的软件              | ./jarvis -f xxx                                                                  | 查询openblas安装路径 ./jarvis -f openblas                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| 一键生成环境变量              | ./jarvis -e                                                                      | 读取配置文件中的[ENV]字段内容并生成env.sh脚本，执行./jarvis -b或./jarvis -r会自动生成并生效                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| 一键编译                  | ./jarvis -b                                                                      | 自动进入[APP]字段中的build_dir目录，读取配置文件中的[BUILD]字段内容并生成build.sh脚本执行                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 一键运行                  | ./jarvis -r                                                                      | 自动进入[APP]字段中的case_dir目录，读取配置文件中的[RUN]字段下内容并组装生成run.sh脚本执行                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| 一键运行                  | ./jarvis -rb                                                                     | 自动进入[APP]字段中的case_dir目录，读取配置文件中的[BATCH]字段下内容并直接生成batch_run.sh脚本执行                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| 一键CPU性能采集             | ./jarvis -p                                                                      | 读取配置文件中的[PERF]字段下的perf选项内容，然后使用perf工具进行采集信息                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 一键GPU性能采集             | ./jarvis -gp                                                                     | 读取配置文件中的[PERF]字段下的nsys选项内容，然后使用nsys工具进行采集信息                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 一键输出服务器信息             | ./jarvis -i                                                                      | 输出CPU、网卡、OS、内存等信息                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| 一键评测服务器性能             | ./jarvis -bench all ./jarvis -bench mpi ./jarvis -bench omp ./jarvis -bench gemm | 包括HPL、Stream、MPI、OMP、P2P等评测benchmark支持清单位于目录“hpcrunner/benchmark”                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| 一键生成Singularity容器定义文件 | ./jarvis -container docker-hub-address                                           | 需要事先指定应用配置./jarvis -use data.config <br>参数"docker-hub-address"指定基础镜像<br>示例：./jarvis -container openeuler/openeuler                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| 更新依赖库的路径              | ./jarvis -u                                                                      | 如果移动了贾维斯的路径，将自动更新software/modulefiles的路径                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |

### 3.4 option介绍

./jarvis -install [package/][name/version/other] [option]命令中[option]的使用介绍

| **选项值**     | **解释**             | **安装目录**                  |
|-------------|--------------------|---------------------------|
| com         | 安装编译器              | software/compiler         |
| gcc         | 使用gcc进行编译          | software/libs/gcc         |
| gcc+mpi     | 使用gcc和当前生效的mpi进行编译 | software/libs/gcc-mpi     |
| bisheng     | 使用毕昇进行编译           | software/libs/bisheng     |
| bisheng+mpi | 使用毕昇和当前生效的mpi进行编译  | software/libs/bisheng-mpi |
| any         | 安装工具软件             | software/utils            |

# 4 贾维斯支持软件列表

1. [应用列表](doc/support/templates.md)
2. [依赖列表](doc/support/packages.md)

# 5 FAQ

Q1：如何在没有网络的环境或者网速很慢的环境下，使用贾维斯完成软件安装部署？

A：参考[2.2](https://atomgit.com/wmrd/hpcrunner/blob/master/README.md#22-%E5%9C%BA%E6%99%AF2%E5%9C%A8%E4%B8%8D%E5%85%B7%E5%A4%87%E5%A4%96%E7%BD%91%E8%AE%BF%E9%97%AE%E8%83%BD%E5%8A%9B%E7%9A%84%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%8A%E4%BD%BF%E7%94%A8hpcrunner)

Q2：软件安装目录在哪里？

A：
> package中的依赖软件：参考[option介绍](#option介绍)的安装目录
>
> templates中的应用软件：安装到software/apps，命名规范：使用BiSheng编译器+HMPI编译templates/wrf/4.7.1/data.wrf.arm.cpu.config的安装路径为software/apps/bisheng${BISHENG_VERSION}-hmpi${HMPI_VERSION}/wrf/4.7.1

# 欢迎贡献

小的改进或修复总是值得赞赏的，可以提交一个issue或者在hpc.openeuler.org进行讨论。
[查看Jarvis贡献方法](README_CONTRIBUTING.md)


