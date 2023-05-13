# HPCRunner : 贾维斯智能助手
## ***愿景：自动容器化助力极简部署，一站式调优HPC应用***
![贾维斯](./images/logo.png)
### 项目背景

​        HPC被喻为是IT行业“金字塔上的明珠”，其部署、编译、运行、性能采集分析的门槛非常高，不同的机器上部署HPC应用耗费大量精力，而且很多情况下需要同时部署ARM/X86两套环境进行验证，增加了很多的重复性工作，无法聚焦核心算法优化。

![贾维斯功能概览](./images/jarvis.png)

### 项目特色

- 支持ARM/X86,一键部署，采用业界权威依赖目录结构管理海量依赖，自动生成module file
- 根据HPC配置实现一键编译运行、一键CPU/GPU性能采集、一键Benchmark.
- 所有配置仅用一个文件记录，HPC应用部署到不同的机器仅需修改配置文件.
- 日志管理系统自动记录HPC应用部署过程中的所有信息.
- 软件本身无需编译开箱即用，仅依赖Python环境.
- HPC应用容器化-目前QE已经实现，参考container目录.
- (未来) 集成HPC领域常用性能调优手段、核心算法.
- (未来) 集群性能分析工具.
- (未来) 智能调优.

### 目录结构

| 目录/文件 | 说明                               | 备注     |
| --------- | ---------------------------------- | -------- |
| benchmark | 矩阵运算、OpenMP、MPI、P2P性能测试 |          |
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

### 支持安装的依赖列表
| 软件名   | 软件信息        | 类别      |
| ------- | -------------- | --------- |
| antlr   | 代码生成器，用于构建编译器和解释器          | 开发工具  |
| cairo   | 2D图形库，支持多种输出设备和格式           | 图像处理  |
| fftw    | 快速傅里叶变换库，支持多种算法和精度         | 数学库    |
| go      | 编程语言，具有高效的垃圾回收和并发特性       | 开发工具  |
| htslib  | 高通量测序数据处理库，支持多种常见格式的文件操作 | 数据库    |
| kfft    | 快速傅里叶变换库鲲鹏版本                  | 数学库    |
| libxml2 | 轻量级、可移植的XML解析库                 | 开发工具  |
| nvhpc   | NVIDIA HPC SDK，包含CUDA和Fortran编译器     | 开发工具  |
| osu     | 基准测试套件，用于衡量系统性能              | 性能评估  |
| Porting | HPC应用迁移工具，支持将应用迁移到鲲鹏           | 应用迁移  |
| scotch  | 科学计算软件包，包括图划分、矩阵操作等模块   | 科学计算  |
| vis5dplus | 五维数据可视化软件，支持多种数据格式和渲染方式 | 可视化    |
| arpack       | 稀疏矩阵特征值计算库                       | 数学库    |
| automake     | GNU Autotools工具集的一部分，用于生成Makefile   | 开发工具  |
| cmake        | 用于管理C/C++软件构建和依赖关系的跨平台工具     | 开发工具  |
| freetype     | TrueType字体渲染引擎                       | 图像处理  |
| g2clib       | 处理GRIB和GRIB2格式气象数据的库              | 数据库    |
| grads        | 可视化气象数据的软件                        | 可视化    |
| grib_api     | 处理GRIB和BUFR格式气象数据的库               | 数据库    |
| Hyper-tuner  | 高性能计算任务调优工具                | 性能优化  |
| hypre        | 大规模稀疏线性系统求解器                     | 数学库    |
| kgcc         | 基于鲲鹏平台极致优化的GCC编译器          | 开发工具  |
| kml          | 基于鲲鹏平台极致优化的数学库              | 数学库  |
| mesa         | 开源3D图形库                                | 图像处理  |
| metis        | 图划分和重排列库                            | 科学计算  |
| oneapi       | Intel开发的工具包，支持各种体系结构的HPC应用  | 开发工具  |
| openblas     | 线性代数库，实现BLAS接口                    | 数学库    |
| parmetis     | 划分大型稀疏图形的高性能库                   | 科学计算  |
| petsc        | 大规模科学计算软件包                        | 科学计算  |
| precice      | 进程耦合库，用于将不同物理学模型耦合起来     | 应用部署  |
| proj         | 地理空间数据处理库                          | 地理信息  |
| singularity  | 容器化解决方案                              | 应用部署  |
| slepc        | 大规模特征值计算库                           | 数学库    |
| wxWidgets    | 跨平台窗口工具包                            | 开发工具  |
| yaml-cpp     | C++ YAML解析器和生成器                      | 开发工具  |
| bedtools     | 用于基因组特征分析的软件                  | 数据库    |
| ctffind      | 基于图像处理的电子显微镜聚焦软件           | 图像处理  |
| gatk         | 基因组变异分析工具                        | 序列分析  |
| gsl          | GNU科学库，提供多种数学函数和数据结构         | 数学库    |
| ImageMagick  | 处理图像的开源软件                        | 图像处理  |
| lapack       | 线性代数库，主要实现了BLAS接口              | 数学库    |
| mfem         | 可扩展有限元方法库                        | 数学库    |
| opencoarrays | 并行编程库                                | 开发工具  |
| picard       | 处理生物信息数据的Java库                  | 序列分析  |
| python3      | Python编程语言的最新版本                  | 开发工具  |
| spglib       | 空间群处理库                              | 科学计算  |
| zlib         | 压缩库                                    | 工具库    |
| bisheng     | 基于鲲鹏极致优化的毕晟编译器，基于LLVM体系         | 开发工具  |
| blas        | 基本线性代数子程序                          | 数学库    |
| curl        | 数据传输工具                                | 工具库    |
| cuda        | NVIDIA的并行计算平台                        | 并行编程  |
| gcc         | GNU C和C++编译器                            | 开发工具  |
| gdal        | 用于地理空间数据转换和处理的开源库           | 地理信息  |
| hdf4        | HDF4数据文件格式处理库                     | 科学计算  |
| hdf5        | HDF5数据文件格式处理库                     | 科学计算  |
| ioapi       | 常见大气化学模型输出和输入预处理库          | 数据库    |
| IPM         | 描述HPC应用程序的性能测量的套件             | 性能优化  |
| libint      | 提供高精度库令积分的C库                     | 数学库    |
| libjpeg     | JPEG图像压缩/解压缩库                      | 图像处理  |
| mpich       | 高性能消息传递接口库                       | 并行编程  |
| mumps       | 大规模稀疏线性系统求解器                    | 数学库    |
| opencv      | 开源计算机视觉和机器学习软件库              | 图像处理  |
| openjpeg    | 用于压缩JPEG2000数据的开源库                | 图像处理  |
| pio         | 访问并行IO的工具                            | 数据库    |
| pixman      | 图像处理和绘图库                           | 图像处理  |
| R           | 开源统计计算和绘图软件                      | 开发工具  |
| spooles     | 大规模稀疏线性代数Solver                     | 数学库    |
| szip        | 压缩库                                     | 工具库    |
| boost       | 十多年来一直是C++开发人员不可或缺的库        | 开发工具  |
| bowtie2     | 测序匹配工具                                | 序列分析  |
| darshan     | HPC应用程序性能分析工具，IO性能分析          | 性能优化  |
| eigen3      | C++模版实现的线性代数库                     | 数学库    |
| glibc       | GNU C语言库                                 | 工具库    |
| git         | 分布式版本控制系统                          | 开发工具  |
| hdf-eos2    | HDF-EOS2数据集处理库                        | 科学计算  |
| hdf-eos5    | HDF-EOS5数据集处理库                        | 科学计算  |
| jasper      | 图像压缩/解压缩库                          | 图像处理  |
| jellyfish   | 海星组装工具                                | 序列分析  |
| libpng      | PNG图像格式处理库                           | 图像处理  |
| libvori     | 计算相邻格点之间夹角，适用于大尺寸网格      | 科学计算  |
| ncl         | NCAR命令语言                               | 开发工具  |
| ncview      | 可视化海洋和气象数据                        | 可视化    |
| openlb      | 模拟流体现象的软件                          | 科学计算  |
| openmpi     | 高性能消息传递接口库                       | 并行编程  |
| pkg-config  | 安装GNU和Unix的编译器等工具所需的参数      | 工具库    |
| plumed      | 对构象变化进行统计物理和化学分析的软件包     | 序列分析  |
| samtools    | 处理NGS数据的磁盘和内存带索引文件的命令列表 | 数据库    |
| salmon      | 快速准确地从RNA-seq读数估计转录本表达水平  | 数据库    |
| tau         | HPC应用程序性能分析工具                      | 性能优化  |
| udunits     | 单位标准化的C程序中用于解释单位             | 开发工具  |
| bwa                    | 测序匹配工具                              | 序列分析  |
| elpa                   | 提供多种实现和算法的Eigenvalue求解器      | 数学库    |
| gmp                    | 高精度计算库                              | 数学库    |
| hmpi                   | 高性能消息传递接口库                     | 并行编程  |
| kahip                  | 图划分库                                  | 图形计算  |
| libxc                  | C语言库，可用于从交换关联功能获得DFT近似  | 数学库    |
| netcdf                 | 处理气象和海洋科学等领域大型科学数据的C库 | 科学计算  |
| optimized-routines     | BLAS，LAPACK和这些程序中相关库的优化版本 | 数学库    |
| pnetcdf                | 访问并行I/O的工具库                         | 数据库    |
| scalapack              | 大规模稠密线性代数求解器                   | 数学库    |
| valgrind               | 内存调试和性能分析工具                     | 开发工具  |

### 支持安装的HPC应用列表

| 应用名           | 应用信息                                      | 领域      |
| ---------------- | --------------------------------------------- | --------- |
| abinit           | 第一个完全自主实现密度泛函理论的程序         | 科学计算  |
| agcm             | 气象局自主研发的全球大气环流谱模式          | 大气科学  |
| amber            | 分子动力学模拟软件                           | 生命科学  |
| bowtie2          | 测序匹配工具                                  | 序列分析  |
| bwa              | 分析二代测序数据                              | 序列分析  |
| calculix         | 有限元分析代码                                | 工程      |
| duns             | 模拟大气化学反应                              | 大气科学  |
| elmer            | 多物理场模拟系统                              | 数学库    |
| grapes           | 气象预报应用                    | 大气科学  |
| gromacs          | 生物分子动力学软件                            | 生命科学  |
| imb              | Intel MPI Benchmarks                          | 性能优化  |
| ImageMagick      | 图像处理命令行工具                            | 图像处理  |
| ioapi            | I/O API支持emission和achimie模型              | 大气科学  |
| mg-cfd           | 并行计算流体力学软件                          | 科学计算  |
| mfem             | 软件库，解决非线性问题和超大规模的并行问题    | 数学库    |
| nco              | 并行化Unix / Linux命令行工具，可用于处理NetCDF文件 | 科学计算  |
| nwchem           | 高性能计算量子化学模拟软件                    | 化学      |
| ncview           | 可视化海洋和气象数据                          | 可视化    |
| openfoam         | 开源的CFD软件                                | 科学计算  |
| openjpeg         | 图像格式处理库                               | 图像处理  |
| openlb           | 模拟流体现象的软件                            | 科学计算  |
| opencv           | 开源计算机视觉库                              | 计算机视觉 |
| pytorch          | Python语言驱动的深度学习框架                 | 机器学习  |
| qe               | 第一个基于密度泛函理论的自由软件             | 科学计算  |
| qmcpack          | 基于Monte Carlo方法的量子物理仿真程序        | 物理学    |
| samtools         | 处理NGS数据的磁盘和内存带索引文件的命令列表   | 数据库    |
| scotch           | 图划分库                                      | 图形计算  |
| siesta           | 第一性原理计算软件                              | 物理学    |
| SU2              | 开源大规模CFD程序                             | 科学计算  |
| trinity          | RNA-seq transcriptome拼装器                   | 序列分析  |
| udunits          | C程序中用于解释单位的库                       | 开发工具  |
| bcc-esm          | 全球气候系统模型                    | 大气科学  |
| bedtools         | 常见的基因组工具                              | 生命科学  |
| blast            | 序列匹配软件                                  | 序列分析  |
| CMAQ             | 使用化学传输模型的空气质量建模工具            | 大气科学  |
| CP2K             | 高精度物理和化学模拟                         | 科学计算  |
| CESM             | 全球气候模型                                  | 大气科学  |
| ctffind          | 粒子旋转平均程序，用于酶成像等领域            | 生命科学  |
| fvcom            | 具有海洋生态动力学和水质应用的三维浪涌模型      | 海洋科学  |
| gatk             | 基因组变异检测框架                            | 生命科学  |
| grads            | 可视化大气-土壤系统模型                       | 数据可视化 |
| hpcg             | 并行HPC线性求解器性能基准                      | 性能优化  |
| hpl              | HPL CheckRecd性能基准                         | 性能优化  |
| htslib           | 用于高通量序列数据处理的C库                   | 生命科学  |
| jasper           | JPEG-2000图像压缩库                           | 图像处理  |
| lammps           | 大型分子动力学软件                            | 生命科学  |
| libjpeg          | 压缩和解压缩JPEG影象                          | 图像处理  |
| miniFE           | 有限元求解器                                  | 工程      |
| mumps            | 并行稠密和稀疏直接线性求解器                  | 数学库    |
| namd             | 大规模分子动力学仿真软件                      | 生命科学  |
| ncl              | NCAR Command Language，用于气象和大气科学     | 大气科学  |
| octave           | 数值计算软件包                                | 数学库    |
| octopus          | 有限成键密度泛函理论程序                      | 科学计算  |
| OpenCoarrays     | 使用Fortran COARRAYS的并行编程模式            | 并行编程  |
| op2              | 一种快速GPU加速的稠密矩阵操作库               | 数学库    |
| picard           | 工具套件，用于操纵大规模数据集                | 生命科学  |
| petsc            | 并行线性代数工具                              | 数学库    |
| rmaps-now        | 短时预报应用                     | 大气科学  |
| relion           | 单粒子冷冻电镜图像处理软件                    | 生命科学  |
| roms             | 海洋环境建模工具                              | 海洋科学  |
| SPECFEM3D_GLOBE | 全球弹性波地震模拟                           | 地球物理  |
| slepc            | 大型特征值问题求解器                          | 数学库    |
| stream           | 用于衡量计算机系统内存带宽的性能，为数据读写的不同操作提供独立的评估 | 性能优化  |
| wannier90        | 转换Bloch波函数为Wannier函数的程序            | 物理学    |
| wrf              | 天气预报和研究模型                           | 大气科学  |
| wxWidgets        | 用于创建跨平台GUI应用程序的开发工具          | 开发工具  |


### 使用说明

1.下载包解压之后初始化

```
source ./init.sh
```

2.修改data.config或者套用现有模板，各配置项说明如下所示：

|    配置项    | 说明                                                         | 示例                                                         |
| :----------: | :----------------------------------------------------------- | :----------------------------------------------------------- |
|   [SERVER]   | 服务器节点列表，多节点时用于自动生成hostfile，每行一个节点   | 11.11.11.11                                                  |
|  [DOWNLOAD]  | 每行一个软件的版本和下载链接，默认下载到downloads目录(可设置别名) | cp2k/8.2 https://xxx cp2k.8.2.tar.gz                         |
| [DEPENDENCY] | HPC应用依赖安装脚本                                          | ./jarvis -install gcc/9.3.1 com<br>module use ./software/modulefiles<br>module load gcc9 |
|    [ENV]     | HPC应用编译运行环境配置                                      | source env.sh                                                |
|    [APP]     | HPC应用信息，包括应用名、构建路径、二进制路径、算例路径      | app_name = CP2K<br/>build_dir = /home/cp2k-8.2/<br/>binary_dir = /home/CP2K/cp2k-8.2/bin/<br/>case_dir = /home/CP2K/cp2k-8.2/benchmarks/QS/ |
|   [BUILD]    | HPC应用构建脚本                                              | make -j 128                                                  |
|   [CLEAN]    | HPC应用编译清理脚本                                          | make -j 128 clean                                            |
|    [RUN]     | HPC应用运行配置，包括前置命令、应用命令和节点个数            | run = mpirun -np 2 <br/>binary = cp2k.psmp H2O-256.inp<br/>nodes = 1 |
|    [JOB]     | HPC应用作业调度运行配置            | 多瑙作业调度脚本 |
|   [BATCH]    | HPC应用批量运行命令                                          | #!/bin/bash<br/>nvidia-smi -pm 1<br/>nvidia-smi -ac 1215,1410 |
|   [LOOP]    | HPC循环优化工具                                          | 将循环代码自动生成可进行性能分析和精度对比的程序 |
|    [PERF]    | 性能工具额外参数                                             | perf= -o<br/>nsys=<br/>ncu=--target-processes all --launch-skip 71434 --launch-count 1 |

3.贾维斯命令大全
| 功能 | 命令 | 示例/说明 |
| --- | --- | --- |
| 一键下载HPC应用 | ./jarvis -d | 应用将自动下载[DOWNLOAD]中地址到downloads目录 |
| 安装依赖 | ./jarvis -install [package/][name/version/other] [option] | ./jarvis -install bisheng/2.1.0 com |
| 一键卸载依赖 | ./jarvis -remove xxx | 支持模糊查询 ./jarvis -remove openblas/0.3.18 |
| 一键下载并安装所有依赖 | ./jarvis -dp |读取配置文件中的[DEPENDENCY]字段内容并按顺序执行 |
| 输出已安装的软件清单 | ./jarvis -l | 输出清单以相对路径列出 |
| 查询已安装的软件 | ./jarvis -f xxx | 查询openblas安装路径 ./jarvis -f openblas |
| 一键生成环境变量| ./jarvis -e | 读取配置文件中的[ENV]字段内容并生成env.sh脚本执行，执行-b/-r会自动生成 |
| 一键编译 | ./jarvis -b | 自动进入[APP]字段中的build_dir目录，读取配置文件中的[BUILD]字段内容并生成build.sh脚本执行 |
| 一键运行 | ./jarvis -r | 自动进入[APP]字段中的case_dir目录，读取配置文件中的[RUN]字段内容并生成run.sh脚本执行 |
| 一键CPU性能采集 | ./jarvis -p | 读取配置文件中的[PERF]字段内容的perf选项 |
| 一键GPU性能采集 | ./jarvis -gp | 需安装CUDA驱动 |
| 一键输出服务器信息 | ./jarvis -i | 输出CPU、网卡、OS、内存等信息|
| 一键服务器性能评测 | ./jarvis -bench all <br> ./jarvis -bench mpi <br> ./jarvis -bench omp <br> ./jarvis -bench gemm  | 包括MPI、OMP、P2P等评测 |
| 切换配置| ./jarvis -use XXX.config | 优先读取环境变量中的JARVIS_CONFIG，否则读取XXX.config，配置文件路径会保存到.meta文件中 |
| 根据当前配置生成Singularity容器定义文件 | ./jarvis -container docker-hub-address | ./jarvis -container openeuler:openeuler |
| 更新依赖库的路径 | ./jarvis -u | 如果移动了贾维斯的路径，将自动更新software/modulefiles的路径 |
| 生成Fortran循环优化代码 | ./jarvis -loop | |
| 帮助信息 | ./jarvis -h | |

安装依赖的option支持列表如下所示

| 选项值      | 解释                          | 安装目录                  |
| ----------- | ----------------------------- | ------------------------- |
| gcc         | 使用当前gcc进行编译           | software/libs/gcc         |
| gcc+mpi     | 使用当前gcc+当前mpi进行编译   | software/libs/gcc/mpi     |
| clang       | 使用当前clang进行编译         | software/libs/clang       |
| clang+mpi   | 使用当前clang+当前mpi进行编译 | software/libs/clang/mpi   |
| bisheng     | 使用毕晟进行编译              | software/libs/bisheng     |
| bisheng+mpi | 使用毕晟+当前mpi进行编译      | software/libs/bisheng/mpi |
| nvc         | 使用当前nvc进行编译           | software/libs/nvc         |
| nvc+mpi     | 使用当前nvc+当前mpi进行编译   | software/libs/nvc/mpi     |
| icc         | 使用当前icc进行编译           | software/libs/icc         |
| icc+mpi     | 使用当前icc+当前mpi进行编译   | software/libs/icc/mpi     |
| com         | 安装编译器                    | software/compiler         |
| any         | 安装工具软件                  | software/utils   |

### 路标

![RoadMap](./images/roadmap.png)

### 欢迎贡献

贾维斯项目欢迎您的专业技能和热情参与！

小的改进或修复总是值得赞赏的；先从文档开始可能是一个很好的起点。如果您正在考虑做出更大贡献，请提交一个issue或者在hpc.openeuler.org进行讨论。

编写代码并不是为贾维斯做出贡献的唯一方法。您还可以：

- 贡献安装脚本
- 帮助我们测试新的HPC应用
- 开发教程、演示
- 为我们宣传
- 帮助新的贡献者加入

请添加openEuler HPC SIG微信群了解更多HPC部署调优知识

![微信群](./images/wechat-group-qr.png)

### 技术文章

揭开HPC应用的神秘面纱：https://zhuanlan.zhihu.com/p/489828346

我和容器有个约会：https://zhuanlan.zhihu.com/p/499544308

贾维斯：完美而凛然HPC应用管家 https://zhuanlan.zhihu.com/p/518460349
