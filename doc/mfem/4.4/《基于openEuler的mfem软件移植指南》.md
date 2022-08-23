# 《基于openEuler的mfem软件移植指南》

# 1.介绍

- MFEM 是一个用于有限元方法的免费、轻量级、可扩展的 C++ 库。

- MFEM 用于许多项目，包括百亿亿次计算项目中的 BLAST、Cardioid、VisIt、RF-SciDAC、FASTMath、xSDK 和 CEED。

- 官网地址：https://mfem.org/

- GITHUB托管地址：https://github.com/mfem/mfem

- 特性：
  
  - 任意高阶有限元网格和空间。
  - 多种有限元离散化方法。
  - 协调和非协调自适应网格细化。
  - 可从笔记本电脑扩展到GPU加速的超级计算机。
  - 还有很多。。。

# 2.环境要求

- 操作系统：openeuler arm/x86 (本文档以鲲鹏arm服务器为例)

# 3.配置编译环境

配置环境指导，手动进行配置依赖环境。

## 3.1.环境总览

- 编译器： bisheng

- MPI：hmpi

- 其他类库：hypre 、 metis

  具体版本和下载地址如下

| 名称    | 版本   | 软件下载地址                                                 |
| ------- | ------ | ------------------------------------------------------------ |
| hmpi    | 1.1.1  | https://github.com/kunpengcompute/hmpi/archive/refs/tags/v1.1.1-huawei.zip |
| hypre   | 2.25.0 | https://github.com/hypre-space/hypre/archive/refs/tags/v2.25.0.tar.gz |
| metis   | 4.0.3  | http://coin-or-tools.github.io/ThirdParty-Metis/metis-4.0.3.tar.gz |
| bisheng | 2.1.0  | https://mirrors.huaweicloud.com/kunpeng/archive/compiler/bisheng_compiler/bisheng-compiler-2.1.0-aarch64-linux.tar.gz |



## 3.2.创建文件夹

```bash
mkdir -p $HOME/build
mkdir -p $HOME/install
mkdir -p $HOME/tmp
```

## 3.3.安装预设

设置环境变量，方便修改自定义安装目录

- 编译目录为 $HOME/build , 根据实际情况进行修改
- 软件安装目录为 $HOME/install , 根据实际情况进行修改
- 下载目录为 $HOME/tmp , 根据实际情况进行修改

```bash
#为了方便自定义软件安装目录
#环境变量DEP_INSTALL_DIR将在后文中作为软件安装目录的根目录
export DEP_INSTALL_DIR=$HOME/install
#环境变量DEP_BUILD_DIR将在后文中作为编译的根目录
export DEP_BUILD_DIR=$HOME/build
#环境变量DEP_DOWNLOAD_DIR将在后文中作为下载文件的保存目录
export DEP_DOWNLOAD_DIR=$HOME/tmp

#注： 以上变量只在一次会话中有效。如果中途断开ssh会话，则在后续的安装过程中不会生效，需要重新运行
```

## 3.4.安装环境依赖和bisheng 

```bash
#环境依赖
yum -y install wget tar libatomic

#安装bisheng编译器
wget -P $DEP_DOWNLOAD_DIR https://mirrors.huaweicloud.com/kunpeng/archive/compiler/bisheng_compiler/bisheng-compiler-2.1.0-aarch64-linux.tar.gz
tar -xf $DEP_DOWNLOAD_DIR/bisheng-compiler-2.1.0-aarch64-linux.tar.gz -C $DEP_INSTALL_DIR
#设置环境变量
echo "export PATH=$DEP_INSTALL_DIR/bisheng-compiler-2.1.0-aarch64-linux/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
export CC=`which clang`
export CXX=`which clang++`
```

## 3.5.下载并编译hmpi

```bash
yum -y install libstdc++ libstdc++-devel
yum -y install unzip make autoconf automake git libtool
#下载解压源码文件
wget https://github.com/kunpengcompute/hucx/archive/refs/tags/v1.1.1-huawei.zip -O $DEP_DOWNLOAD_DIR/hucx-1.1.1-huawei.zip
wget https://github.com/kunpengcompute/xucg/archive/refs/tags/v1.1.1-huawei.zip -O $DEP_DOWNLOAD_DIR/xucg-1.1.1-huawei.zip
wget https://github.com/kunpengcompute/hmpi/archive/refs/tags/v1.1.1-huawei.zip -O $DEP_DOWNLOAD_DIR/hmpi-1.1.1-huawei.zip

cd $DEP_BUILD_DIR
unzip -q $DEP_DOWNLOAD_DIR/hucx-1.1.1-huawei.zip
unzip -q $DEP_DOWNLOAD_DIR/xucg-1.1.1-huawei.zip
unzip -q $DEP_DOWNLOAD_DIR/hmpi-1.1.1-huawei.zip
cp -rf xucg-1.1.1-huawei/* hucx-1.1.1-huawei/src/ucg/

#编译hucx
cd $DEP_BUILD_DIR/hucx-1.1.1-huawei
./autogen.sh
./contrib/configure-opt --prefix=$DEP_INSTALL_DIR/hmpi/hucx CFLAGS="-DHAVE___CLEAR_CACHE=1" --disable-numa --without-java
for file in `find . -name Makefile`;do sed -i "s/-Werror//g" $file;done
for file in `find . -name Makefile`;do sed -i "s/-implicit-function-declaration//g" $file;done
make -j
make install

yum -y install flex
#编译hmpi
cd $DEP_BUILD_DIR/hmpi-1.1.1-huawei
./autogen.pl
./configure --prefix=$DEP_INSTALL_DIR/hmpi --with-platform=contrib/platform/mellanox/optimized --enable-mpi1-compatibility --with-ucx=$DEP_INSTALL_DIR/hmpi/hucx
make -j
make install

echo "export PATH=$DEP_INSTALL_DIR/hmpi/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
export CC=mpicc CXX=mpicxx FC=mpifort F77=mpifort
```

## 3.6.下载并编译hypre 、 metis

```bash
# 下载并编译hypre
wget https://github.com/hypre-space/hypre/archive/refs/tags/v2.25.0.tar.gz -O $DEP_DOWNLOAD_DIR/hypre-2.25.0.tar.gz
tar -xf $DEP_DOWNLOAD_DIR/hypre-2.25.0.tar.gz -C $DEP_BUILD_DIR
cd $DEP_BUILD_DIR/hypre-2.25.0/src
./configure --disable-fortran
make -j

# 下载并编译metis
wget http://coin-or-tools.github.io/ThirdParty-Metis/metis-4.0.3.tar.gz -O $DEP_DOWNLOAD_DIR/metis-4.0.3.tar.gz
tar -xf $DEP_DOWNLOAD_DIR/metis-4.0.3.tar.gz -C $DEP_BUILD_DIR
cd $DEP_BUILD_DIR/metis-4.0.3
make

cd $DEP_BUILD_DIR
# 创建软连接，适配mfem Makefile
ln -sf hypre-2.25.0 hypre
ln -sf metis-4.0.3 metis-4.0
```

# 4.编译mfem

## 4.1.下载并编译mfem

获取mfem软件源码并解压文件

```bash

# 下载源码文件
cd /root/build
wget https://github.com/mfem/mfem/archive/refs/tags/v4.4.tar.gz -O $DEP_DOWNLOAD_DIR/mfem-4.4.tar.gz
# 解压源码文件
tar -xf $DEP_DOWNLOAD_DIR/mfem-4.4.tar.gz -C $DEP_BUILD_DIR
# 修改测试代码，适配openeuler本地环境
sed -i 's/>= MINSIGSTKSZ.*/;/' mfem-4.4/tests/unit/catch.hpp
sed -i "s/-march=native/''/g" mfem-4.4/miniapps/performance/makefile

cd $DEP_BUILD_DIR/mfem-4.4
#编译并行版本
make parallel
```

## 4.2. 运行测试文件

运行mfem项目测试文件

```bash
cd $DEP_BUILD_DIR/mfem-4.4
export OMPI_ALLOW_RUN_AS_ROOT=1;
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1;
make test
```

# 附A：使用hpcrunner进行一键安装mfem

推荐使用hpcrunner进行安装mfem

## 1.克隆仓库

```bash
git clone https://gitee.com/openeuler/hpcrunner.git
```

## 2.初始化hpcrunner 和 安装必要软件包

初始化项目助手

```bash
cd hpcrunner
source init.sh
```

安装必要软件包

**arm / x86 需要的软件包不同，根据实际环境进行选择**

```bash
# arm
yum install -y environment-odules git wget unzip make flex tar
# x86
yum install -y environment-modules git wget unzip make flex
yum install -y gcc gcc-c++ gcc-gfortran glibc-devel libgfortran 
yum install -y tcsh tcl lsof tk bc
```

## 3.选择平台对应配置文件

- arm平台的配置文件为 `templates/mfem/4.4/data.mfem.arm.cpu.config`
  
  ```bash
  ./jarvis -use templates/mfem/4.4/data.mfem.arm.cpu.config
  ```

- x86 平台的配置文件为 `templates/mfem/4.4/data.mfem.amd.cpu.config`
  
  ```bash
  ./jarvis -use templates/mfem/4.4/data.mfem.amd.cpu.config
  ```

## 4.一键配置依赖环境

```bash
./jarvis -dp
```

## 5.一键进行编译

```bash
./jarvis -b
```

## 6.一键进行运行测试

```bash
./jarvis -r
```

# 附B：使用singularity运行容器

## 下载容器

通过链接下载：

[百度云盘](https://pan.baidu.com/s/16fiu7aSpGnTUlDddBC-BDA?pwd=5pt6)

或者扫码下载：

![百度云](data:image/png;base64,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)

## 使用教程

### 1.安装singularity

安装singularity，

具体步骤如下

```bash
mkdir -p ~/install
mkdir -p ~/build

#安装编译所需依赖
yum -y install libatomic libstdc++ libstdc++-devel libseccomp-devel glib2-devel gcc squashfs-tools tar

#安装bisheng编译器
cd ~/build
wget https://mirrors.huaweicloud.com/kunpeng/archive/compiler/bisheng_compiler/bisheng-compiler-2.1.0-aarch64-linux.tar.gz
tar -C ~/install -xf bisheng-compiler-2.1.0-aarch64-linux.tar.gz
echo "export PATH=$HOME/install/bisheng-compiler-2.1.0-aarch64-linux/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
export CC=`which clang`
export CXX=`which clang++`

#安装go编译器
cd ~/build
wget https://go.dev/dl/go1.19.linux-arm64.tar.gz
tar -C ~/install -xf go1.19.linux-arm64.tar.gz
echo "export PATH=$HOME/install/go/bin:$PATH" >> ~/.bashrc && source ~/.bashrc

#安装singularity
cd ~/build
wget https://github.com/sylabs/singularity/releases/download/v3.10.2/singularity-ce-3.10.2.tar.gz
tar -xf singularity-ce-3.10.2.tar.gz
cd singularity-ce-3.10.2
./mconfig --prefix=$HOME/install/singularity
make -C ./builddir
make -C ./builddir install
echo "export PATH=$HOME/install/singularity/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
```



### 2.下载云盘上的镜像

请注意arm、x86的区别。本文档以arm版本的镜像文件为例，x86版本与此步骤相同。

下载文件mfem-4.4-arm.sif，并上传到openeuler中

### 3.将镜像转换为沙盒

```shell
#镜像不可写
#将镜像转换为可以写入的沙盒
singularity build --sandbox mfem-sandbox mfem-4.4-arm.sif
```

### 4.在沙盒中运行

```shell
#进入沙盒
singularity shell -w mfem-sandbox
#在沙盒中运行内置的测试案例
cd /hpcrunner
./jarvis -r
```
