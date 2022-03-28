# HPC容器化技术
## ***把HPC应用装进容器***

### 1.为什么用容器技术？

- 容器技术对分布式系统的管理至关重要
- 开发者可以自定义软件栈
- HPC应用也需要支持日益更新的软件栈
- 但是HPC应用和普通的云上应用又大不相同
  - 基于MPI并行通信
  - 轻松扩展至上千节点的大规模集群
  - 性能至关重要

### 2.HPC应用使用容器有啥价值？

- HPC应用通常需要深度定制：使用yum安装的包为了通用性牺牲了性能，开发者需要自定义OS基础环境和重编依赖库
- 可组合性：开发者可以显式定义软件栈的排列组合，可重现的环境对架构扩展大有益处
- 灵活性：容器可以在多个OS上重建、分层或者共享，可灵活部署到笔记本、云和高性能集群
- 版本控制：容器拥有类似Git的版本控制系统，支持现有容器仓，比如Docker Hub.

### 3.使用Docker？

- 安全问题
  - 集群中的资源使用通常需要由调度管理器来进行分配，例如Slurm/PBS/SGE等系统负责资源分配。调度管理器根据用户需求为每个作业分配一定的资源，实质上是利用cgroups针对每个作业进行配置实现的。而Docker镜像的启动实际上是由Docker Daemon去执行的，如此一来资源限制自然会失效。并且Docker Daemon是由 root 用户启动的，无论是为普通用户设置sudoer还是将普通用户添加到 docker 用户组中都不是一个安全的方式。
- 缺少HPC架构的支持
  - 缺少批量整合
  - 假设资源都在本地
  - 假设应用通过TCP/IP通信
- 包含了不必要的资源开销

### 4.使用Singularity吧！

Singularity拥有容器技术所包含的大多数优势，例如启动迅速、资源开销小、轻松的迁移和扩展等等。除此之外，相较于Docker这样的容器技术，针对HPC应用它还有一些独特的优势：

- 更加轻松的环境打包迁徙：Singularity所依赖的东西都在镜像文件中，不需要再单独打包 / 导入，直接拷贝走镜像即可。没有复杂的缓存机制，并且该镜像已经过压缩，只需占用非常少的磁盘空间。开发态允许直接在笔记本上运行，优化完成后再跑在超算集群上。
- 和现有系统无缝整合：系统用户权限、网络等均直接继承宿主机配置，并且无需进入某个镜像后再执行命令，可以直接在外部调用镜像内的指令，就像执行一个本地安装的指令一样。
- 无需运行 daemon 进程：Singularity提供的完全是一个运行时的环境，在不使用时不需要单独的进程，不占用任何资源。不由 daemon 进程代为执行指令，资源限制和权限问题也得以解决。
- 阿里云使用宿主模式和容器模式对singularity进行了测评，结果显示性能损失<2%，而且对GPU的支持也很好。


### 5.六脉神剑-六步跑通一个HPC容器

5.1 下载HPCRunner包解压之后初始化

```
source ./init.sh
```

5.2 拷贝容器配置

```
cp ./templates/singularity/singularity.config ./
./jarvis -use singularity.config
```

5.3 安装singularity容器

```
./jarvis -d -dp
```

5.4 生成QE容器包

```
cd container && singularity build openeuler-kgcc9-openmpi4-qe-6.4.sif openeuler-kgcc9-openmpi4-qe-6.4.def
```

5.5 安装和容器同版本的MPI库

```
cp ./templates/qe/6.4/data.qe.container.config ./
./jarvis -use data.qe.container.config
./jarvis -d -dp
```

5.6 运行容器(-np 后面的数字为核数，请按实际核数指定)

```
cd container
mpirun --allow-run-as-root -x OMP_NUM_THREADS=1 -np 96 singularity exec openeuler-kgcc9-openmpi4-qe-6.4.sif /hpcrunner/q-e-qe-6.4.1/bin pw.x -input /hpcrunner/workloads/QE/qe-test/test_3.in
```

### 欢迎贡献更多的容器！
