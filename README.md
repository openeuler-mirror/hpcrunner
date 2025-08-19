# HPCRunner : 贾维斯智能助手，一站式部署调优HPC应用

![贾维斯](./images/jarvis-logo.png)
### 项目背景
HPC被喻为是IT行业“金字塔上的明珠”，其部署、编译、运行、性能采集分析的门槛非常高，不同的机器上部署HPC应用耗费大量精力，而且很多情况下需要同时部署ARM/X86两套环境进行验证，增加了很多的重复性工作，无法聚焦核心算法优化。





## 环境依赖

- X86/ARM架构 + LinuxOS 
- python3
- environment-modules
- cmake

# 贾维斯使用指导
## 下载贾维斯
执行如下命令安装相关依赖并下载贾维斯
```
yum -y install git time zlib zlib-devel gcc gcc-c++ environment-modules python python3 python3-devel python3-libs python3-pip cmake make numactl numactl-devel numactl-libs rpmdevtools wget libtirpc libtirpc-devel unzip flex tar patch glibc-devel rpcbind csh perl-XML-LibXML xorg-x11-xauth curl curl-devel libcurl-devel
git clone https://gitee.com/openeuler/hpcrunner.git
```


## 贾维斯目录结构

| 目录/文件 | 说明                               | 备注     |
| --------- | ---------------------------------- | -------- |
| benchmark | HPL、Stream、矩阵运算、OpenMP、MPI、P2P等性能测试 |          |
| doc       | 文档                               |          |
| downloads | 存放依赖库源码包/压缩包            |          |
| examples  | 性能小实验                         |          |
| package   | 存放安装脚本和FAQ                  |          |
| software  | 依赖库二进制仓库(内置精度分析工具)         | 自动生成 |
| src       | 贾维斯源码                         |          |
| templates | 常用HPC应用的配置模板              |          |
| test      | 贾维斯测试用例                     |          |
| workloads  | 常用HPC应用的算例合集              |          |
| init.sh   | 贾维斯初始化文件                   |          |
| jarvis    | 贾维斯启动入口                     |          |

## 使用贾维斯安装应用流程
以安装 xapp 为例：

步骤1：配置网络代理
```
#执行proxy脚本，并选择合适的源
./proxy.sh
#执行初始化脚本，完成环境变量配置
source init.sh
```


步骤1：生效应用模板
进入hpcrunner根目录执行如下命令：
```
./jarvis -use /path/xapp.config
```

注：贾维斯中包含典型HPC应用模板， 位于目录”hpcrunner/template”中，可直接使用。如要新增应用模板，需遵循一定的格式新建自定义文件app.config。

配置文件格式如下所示

| **配置项**   | **说明**                                                     | **示例**                                                     |
| ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [SERVER]     | 指定节点列表，按行书写，用于自动生成hostfile                 | 11.11.11.11<br>22.22.22.22                                   |
| [DOWNLOAD]   | 格式：app/appversion download_url [alias]<br>**注：**在没有网络场景下，可提前将下载好的安装包放置在hpcrunner/downloads目录下 | cp2k/8.2 https://github.com/extdomains/github.com/cp2k/cp2k/releases/download/v8.2.0/cp2k-8.2.tar.bz2 |
| [DEPENDENCY] | HPC应用所需安装的依赖软件                                    | ./jarvis -install gmp/6.2.0 clang<br>./jarvis -install boost/1.72.0 clang |
| [ENV]        | HPC应用编译运行所需的环境配置                                | module use ./software/modulefiles<br>module load bisheng/3.2.0<br>module load boost/1.72.0 |
| [APP]        | HPC应用信息，包括应用名、构建路径、二进制路径、算例路径      | app_name = CP2K <br>build_dir = /home/cp2k-8.2/ <br>binary_dir = /home/CP2K/cp2k-8.2/bin/ case_dir = /home/CP2K/cp2k-8.2/benchmarks/QS/ |
| [BUILD]      | HPC应用构建脚本                                              | ./configure <br>make -j<br>make install                      |
| [CLEAN]      | HPC应用编译清理脚本                                          | make clean                                                   |
| [RUN]        | HPC应用运行配置，包括前置命令、应用命令和节点个数            | run = mpirun -np 2 <br>binary = cp2k.psmp H2O-256.inp <br>nodes = 1 |
| [JOB]        | HPC应用作业调度运行配置                                      | 多瑙作业调度脚本                                             |
| [BATCH]      | HPC应用批量运行命令****                                      | #!/bin/bash <br>mpirun -np 2 cp2k.psmp H2O-256.inp mpirun -np 2 cp2k.psmp H2O-512.inp |
| [PERF]       | 性能分析采集工具额外参数配置                                 | perf= -o <br>nsys= <br>ncu=--target-processes all --launch-skip 71434 --launch-count 1 |



步骤3：下载安装包以及相关依赖

```
./jarvis -d
```

步骤4：安装应用依赖

```
./jarvis -dp
```

步骤8：编译应用

```
./jarvis -b
```

步骤9：运行应用

```
./jarvis -r
```



## 运行示例

使用默认的应用配置部署运行应用QE-6.4

```
./jarvis -use templates/qe/6.4/data.qe.arm.cpu.config
./jarvis -d
./jarvis -dp
./jarvis -b
./jarvis -r
```



# 贾维斯运行指令
## 功能指令介绍

| **功能**                        | **命令**                                                     | **示例/说明**                                                |
| ------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 帮助信息                        | ./jarvis -h                                                  |                                                              |
| 生效应用模板                    | ./jarvis -use /path/app.config                               | 指定所需的应用模板配置文件                                   |
| 一键下载HPC应用                 | ./jarvis -d                                                  | 应用将自动下载[DOWNLOAD]中指定的安装包到downloads目录。<br>**注：**在没有网络场景下，可提前将下载好的安装包放置到downloads目录下 |
| 安装依赖                        | ./jarvis -install [package/][name/version/other] [option]    | 支持安装的软件清单位于package目录下，可在package目录下获取[name/version/other]各字段信息，精确到”install.sh”的上一层目录<br>各参数具体含义：<br>package：可选<br>name：软件名<br>version：软件版本<br>other：子版本，”install.sh”的上一层目录<br>option：指定依赖的编译工具，支持的选项如下表<br>示例如下：<br>1. 安装编译器<br>./jarvis -install hpckit/x.x.x any<br>module use xxx<br>module load bisheng/xxx<br>2. 安装mpi<br>./jarvis -install hpckit/x.x.x any<br>module use xxx<br>module load hmpi/xxx<br>3. 安装依赖<br>module use software/module*<br>module load bisheng/x.x.x<br>module load hmpi/x.x.x<br>export CC=mpicc CXX=mpicxx FC=mpifort <br>./jarvis -install hdf5/1.8.20/clang bisheng+mpi<br>4. 安装工具<br>./jarvis -install hpckit/2025.3.30 any<br>./jarvis -install go/1.18 any |
| 一键卸载依赖                    | ./jarvis -remove xxx                                         | 支持模糊查询 ./jarvis -remove openblas/0.3.18                |
| 一键下载并安装所有依赖          | ./jarvis -dp                                                 | 需要提前指定应用模板./jarvis -use app.config<br>读取配置文件中的[DEPENDENCY]字段内容并按顺序执行 |
| 输出已安装的软件清单            | ./jarvis -l                                                  | 输出清单以相对路径列出                                       |
| 查询已安装的软件                | ./jarvis -f xxx                                              | 查询openblas安装路径 ./jarvis -f openblas                    |
| 一键生成环境变量                | ./jarvis -e                                                  | 读取配置文件中的[ENV]字段内容并生成env.sh脚本，执行./jarvis -b或./jarvis -r会自动生成并生效 |
| 一键编译                        | ./jarvis -b                                                  | 自动进入[APP]字段中的build_dir目录，读取配置文件中的[BUILD]字段内容并生成build.sh脚本执行 |
| 一键运行                        | ./jarvis -r                                                  | 自动进入[APP]字段中的case_dir目录，读取配置文件中的[RUN]字段下内容并组装生成run.sh脚本执行 |
| 一键运行                        | ./jarvis -rb                                                 | 自动进入[APP]字段中的case_dir目录，读取配置文件中的[BATCH]字段下内容并直接生成batch_run.sh脚本执行 |
| 一键CPU性能采集                 | ./jarvis -p                                                  | 读取配置文件中的[PERF]字段下的perf选项内容，然后使用perf工具进行采集信息 |
| 一键GPU性能采集                 | ./jarvis -gp                                                 | 读取配置文件中的[PERF]字段下的nsys选项内容，然后使用nsys工具进行采集信息 |
| 一键输出服务器信息              | ./jarvis -i                                                  | 输出CPU、网卡、OS、内存等信息                                |
| 一键评测服务器性能              | ./jarvis -bench all ./jarvis -bench mpi ./jarvis -bench omp ./jarvis -bench gemm | 包括HPL、Stream、MPI、OMP、P2P等评测benchmark支持清单位于目录“hpcrunner/benchmark” |
| 一键生成Singularity容器定义文件 | ./jarvis -container docker-hub-address                       | 需要事先指定应用配置./jarvis -use data.config <br>参数"docker-hub-address"指定基础镜像<br>示例：./jarvis -container openeuler/openeuler |
| 更新依赖库的路径                | ./jarvis -u                                                  | 如果移动了贾维斯的路径，将自动更新software/modulefiles的路径 |

## <a id="option介绍"></a>option介绍
option支持列表如下所示

| **选项值**  | **解释**                        | **安装目录**              |
| ----------- | ------------------------------- | ------------------------- |
| com         | 安装编译器                      | software/compiler         |
| gcc         | 使用gcc进行编译                 | software/libs/gcc         |
| gcc+mpi     | 使用gcc和当前生效的mpi进行编译  | software/libs/gcc/mpi     |
| bisheng     | 使用毕昇进行编译                | software/libs/bisheng     |
| bisheng+mpi | 使用毕昇和当前生效的mpi进行编译 | software/libs/bisheng/mpi |
| any         | 安装工具软件                    | software/utils            |



# FAQ

Q1：如何在没有网络的环境或者网速很慢的环境下，使用贾维斯完成软件安装部署？

```
A：
步骤1：寻找一台有外网链接的服务器环境B，执行jarvis -d命令，下载相关依赖
步骤2：将事先下载好的安装包即环境B下downloads目录里所有内容，放置到原环境的downloads目录下
步骤3：在原来环境下进行后续安装操作
```

Q2：软件安装目录在哪里？

A：参考[option介绍](#option介绍)小节中的安装目录

# 欢迎贡献
小的改进或修复总是值得赞赏的，可以提交一个issue或者在hpc.openeuler.org进行讨论。
[查看Jarvis贡献方法](README_CONTRIBUTING.md)


