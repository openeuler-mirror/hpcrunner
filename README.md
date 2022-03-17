# HPCRunner : 贾维斯辅助系统
### 项目背景

因为HPC应用的特殊性，其环境配置、编译、运行、CPU/GPU性能采集分析的门槛比较高，导致迁移和调优的工作量大，不同的人在不同的机器上跑同样的软件和算例基本上是重头开始，费时费力，而且很多情况下需要同时部署ARM/X86两套环境进行验证，增加了很多的重复性工作。


### 解决方案

- 提供支持ARM/X86的统一接口,一键生成环境脚本、一键编译、一键运行、一键性能采集、一键Benchmark等功能.
- 所有配置仅用一个文件记录，HPC应用部署到不同的机器仅需修改配置文件.
- 日志管理系统自动记录HPC应用部署过程中的所有信息.
- 常用HPC工具软件开箱即用，提供GCC/毕昇/icc版本，支持一键module加载.
- 软件本身开箱即用，仅依赖Python环境.
- (未来) 集成HPC领域常用性能调优手段、核心算法.
- (未来) 集群性能分析工具.
- (未来) 智能调优.
- (未来) HPC应用[容器化](https://catalog.ngc.nvidia.com/orgs/hpc/containers/quantum_espresso).

### 已验证HPC应用

分子动力学领域：

- [x] CP2K

- [x] Amber

- [x] QE

- [x] VASP

气象领域：

- [x] WRF

流体力学领域：

- [x] OpenFOAM

### 使用说明

1.下载包解压之后初始化

`source init.sh`

2.修改data.config（ARM）或者data.X86.config(X86)

3.一键生成环境变量(或者python3 jarvis.py)

`./jarvis.py -e`
`source env.sh`
4.一键编译

`./jarvis.py -b`

5.一键运行

`./jarvis.py -r`

6.一键性能采集(perf)

`./jarvis.py -p`

7.一键GPU性能采集(使用nsys、ncu)

`./jarvis.py -gp`

8.一键输出服务器信息(包括CPU、网卡、OS、内存等)

`./jarvis.py -i`

9.切换配置

`./jarvis.py -use data.XXX.config`

10.其它功能查看（多线程下载、网络检测）

`./jarvis.py -h`

### 欢迎贡献

贾维斯项目欢迎您的热情参与！

小的改进或修复总是值得赞赏的；先从文档开始可能是一个很好的起点。如果您正在考虑对源代码的更大贡献，请先提交issue讨论。

编写代码并不是为贾维斯做出贡献的唯一方法。您还可以：

- 贡献小而精的工具(小于10MB>)
- 帮助我们测试新的HPC应用
- 开发教程、演示和其他教育材料
- 为我们宣传
- 帮助新的贡献者加入

请添加OpenEuler SIG微信群了解更多HPC迁移调优知识

![微信群](./wechat-group-qr.png)