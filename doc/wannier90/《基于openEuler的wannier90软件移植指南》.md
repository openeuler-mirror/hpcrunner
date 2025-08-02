# 《基于openEuler的QMCPACK软件移植指南》

## 1.介绍

- wannier90 Wannier90是一个构建局域轨道基组的有力工具，一般用来计算紧束缚模型中的占位能和跳跃积分，再结合杂化泛函或GW方法，插值得到更为准确的能带结构，或者计算极化、输运、拓扑不变量等物理性质

- 官网地址：<http://www.wannier.org/>

- GITHUB托管地址：<$JARVIS_PROXY/wannier-developers/wannier90>

- 特性：

  - Marzari和Vanderbilt的方法(MV)
  - 最大局域化瓦尼尔函数计算
  - 使用Souza，Marzari，Vanderbilt的方法(SMV)
  - FLAPW的电子结构代码结合使用
  - 还有很多。。。

## 2.环境要求

- 操作系统：OpenEuler arm/x86 (本文档以 arm 架构为例)

## 3.配置编译环境

配置环境指导，手动进行配置依赖环境。

### 3.1.环境总览

- 编译器： gcc for openeuler

- MPI：openmpi

- 其他类库：`BLAS``Python3`, `lapack`

  具体版本和下载地址如下

| 名称     | 版本   | 软件下载地址                                                                                   |
| -------- | ------ | ---------------------------------------------------------------------------------------------- |
| hmpi     | 1.2.0  | <$JARVIS_PROXY/kunpengcompute/hmpi/archive/refs/tags/v1.2.0-huawei.zip>                   |
| kgcc     | 10.3.1  | <https://mirrors.huaweicloud.com/kunpeng/archive/compiler/kunpeng_gcc/gcc-10.3.1-2021.09-aarch64-linux.tar.gz>                                       |
| BLAS      | 3.10.1 | <http://www.netlib.org/blas/blas-3.10.0.tgz >                          |
| Python3  | 3.7.10 | <https://repo.huaweicloud.com/python/3.7.10/Python-3.7.10.tgz>                                 |
| lapack | 3.10.1 | <$JARVIS_PROXY/Reference-LAPACK/lapack/archive/refs/tags/v3.10.1.tar.gz >                                      |

### 3.2.创建文件夹

```bash
mkdir -p $HOME/build
mkdir -p $HOME/install
mkdir -p $HOME/tmp
```

### 3.3.安装预设

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

### 3.4.安装环境依赖和kgcc编译器

```bash
#环境依赖
yum -y install wget tar libatomic

#安装kgcc编译器
wget -P $DEP_DOWNLOAD_DIR https://mirrors.huaweicloud.com/kunpeng/archive/compiler/kunpeng_gcc/gcc-10.3.1-2021.09-aarch64-linux.tar.gz
tar -xf $DEP_DOWNLOAD_DIR/gcc-10.3.1-2021.09-aarch64-linux.tar.gz -C $DEP_INSTALL_DIR



#设置环境变量
echo "export PATH=$DEP_INSTALL_DIR/gcc-9.3.0/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
export CC=`which clang`
export CXX=`which clang++`
```

## 3.5.下载并编译hmpi

```bash
yum -y install libstdc++ libstdc++-devel
yum -y install unzip make autoconf automake git libtool
#下载解压源码文件
wget $JARVIS_PROXY/kunpengcompute/hucx/archive/refs/tags/v1.2.0-huawei.zip -O $DEP_DOWNLOAD_DIR/hucx-1.2.0-huawei.zip
wget $JARVIS_PROXY/kunpengcompute/xucg/archive/refs/tags/v1.2.0-huawei.zip -O $DEP_DOWNLOAD_DIR/xucg-1.2.0-huawei.zip
wget $JARVIS_PROXY/kunpengcompute/hmpi/archive/refs/tags/v1.2.0-huawei.zip -O $DEP_DOWNLOAD_DIR/hmpi-1.2.0-huawei.zip

cd $DEP_BUILD_DIR
unzip -q $DEP_DOWNLOAD_DIR/hucx-1.2.0-huawei.zip
unzip -q $DEP_DOWNLOAD_DIR/xucg-1.2.0-huawei.zip
unzip -q $DEP_DOWNLOAD_DIR/hmpi-1.2.0-huawei.zip
cp -rf xucg-1.2.0-huawei/* hucx-1.2.0-huawei/src/ucg/

#编译hucx
cd $DEP_BUILD_DIR/hucx-1.2.0-huawei
./autogen.sh
./contrib/configure-opt --prefix=$DEP_INSTALL_DIR/hmpi/hucx CFLAGS="-DHAVE___CLEAR_CACHE=1" --disable-numa --without-java
for file in `find . -name Makefile`;do sed -i "s/-Werror//g" $file;done
for file in `find . -name Makefile`;do sed -i "s/-implicit-function-declaration//g" $file;done
make -j
make install

yum -y install flex
#编译hmpi
cd $DEP_BUILD_DIR/hmpi-1.2.0-huawei
./autogen.pl
./configure --prefix=$DEP_INSTALL_DIR/hmpi --with-platform=contrib/platform/mellanox/optimized --enable-mpi1-compatibility --with-ucx=$DEP_INSTALL_DIR/hmpi/hucx
make -j
make install

echo "export PATH=$DEP_INSTALL_DIR/hmpi/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
export CC=mpicc CXX=mpicxx FC=mpifort F77=mpifort
```

## 3.6.下载并编译`BLAS`, `lapack`, `python3`

```bash


# 下载并编译BLAS
wget -u http://www.netlib.org/blas/blas-3.10.0.tgz $DEP_DOWNLOAD_DIR/blas-3.10.0.tgz
cd $DEP_DOWNLOAD_DIR
tar -xzvf $DEP_DOWNLOAD_DIR/blas-3.10.0.tgz
cd BLAS-3.10.0
gfortran -c -O3 ./*.f
ar rv libblas.a ./*.o
cp libblas.a /usr/local/lib

# 下载并编译Python3
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make libffi-devel
wget https://repo.huaweicloud.com/python/3.7.10/Python-3.7.10.tgz -O $DEP_DOWNLOAD_DIR/Python-3.7.10.tgz
tar -zxvf $DEP_DOWNLOAD_DIR/Python-3.7.10.tgz -C $DEP_BUILD_DIR
cd $DEP_BUILD_DIR/Python-3.7.10
./configure --prefix=$DEP_INSTALL_DIR/python3
make -j
make install
echo "export PATH=$DEP_INSTALL_DIR/python3/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
echo "export LD_LIBRARY_PATH=$DEP_INSTALL_DIR/python3/lib:$LD_LIBRARY_PATH" >> ~/.bashrc && source ~/.bashrc

# 下载并编译lapack
wget -u $JARVIS_PROXY/Reference-LAPACK/lapack/archive/refs/tags/v3.10.1.tar.gz -O $DEP_DOWNLOAD_DIR/lapack=3.10.1.tar.gz
cd $DEP_DOWNLOAD_DIR
tar -xvf $DEP_DOWNLOAD_DIR/lapack-3.10.1.tar.gz
cd lapack-3.10.1
cp make.inc.example make.inc
make -j
cd LAPACKE
make -j
cd .. 
cp *.a /usr/local/lib

```

## 4.编译wannier90

### 4.1.下载并编译wannier90

获取QMCPACK软件源码并解压文件

```bash

# 下载源码文件
cd $DEP_DOWNLOAD_DIR
git clone $JARVIS_PROXY/wannier-developers/wannier90.git
# 解压源码文件
cd $DEP_BUILD_DIR/wannier90
#编译源码
cp config/make.inc.gfortran ./make.inc
sed -i '4c F90 = gfortran' make.inc
sed -i '8c MPIF90 = mpif90'  make.inc
sed -i '7c COMMS= mpi' make.inc
sed -i '14c FCOPTS = -fstrict-aliasing  -fno-omit-frame-pointer -fno-realloc-lhs -fcheck=bounds,do,recursion,pointer -ffree-form -Wall -Waliasing -Wsurprising -Wline-truncation -Wno-tabs -Wno-uninitialized -Wno-unused-dummy-argument -Wno-unused -Wno-character-truncation -O1 -g -fbacktrace' make.inc
sed -i '15c LDOPTS = -fstrict-aliasing  -fno-omit-frame-pointer -fno-realloc-lhs -fcheck=bounds,do,recursion,pointer -ffree-form -Wall -Waliasing -Wsurprising -Wline-truncation -Wno-tabs -Wno-uninitialized -Wno-unused-dummy-argument -Wno-unused -Wno-character-truncation -O1 -g -fbacktrace' make.inc

make 
make install
```

### 4.2. 运行测试文件

运行wannier90项目测试文件

```bash
export OMPI_ALLOW_RUN_AS_ROOT=1;
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1;
make tests
make test-serial
make test-parallel
```

## 附A：使用hpcrunner进行一键安装wannier90

推荐使用hpcrunner进行安装wannier90

### 1.克隆仓库

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
yum install -y environment-modules git wget unzip make flex tar
yum install -y gcc gcc-c++ gcc-gfortran glibc-devel libgfortran
yum install -y tcsh tcl lsof tk bc
```

### 3.选择平台对应配置文件

- arm平台的配置文件为 `templates/wannier90/3.1.0/data.wannier90.arm.cpu.config`
  
  ```bash
  ./jarvis -use templates/wannier90/3.1.0/data.wannier90.arm.cpu.config
  ```

- x86 平台的配置文件为 `templates/wannier90/3.1.0/data.wannier90.amd.cpu.config`
  
  ```bash
  ./jarvis -use templates/wannier90/3.1.0/data.wannier90.amd.cpu.config
  ```

### 4.下载QMCPACK源码

```bash
./jarvis -d
```

### 5.一键配置依赖环境

```bash
./jarvis -dp
```

### 6.一键进行编译

```bash
./jarvis -b
```

### 7.一键进行运行测试

```bash
./jarvis -r
```

## 附B：使用singularity运行容器

### 使用教程

### 下载容器镜像

通过链接下载：

[百度云盘](https://pan.baidu.com/s/1UjHiv6DN_oOVXcuohP5Uqg?pwd=vxit)

或者扫码下载：

![百度云](data:image/png;base64,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)

#### 1.安装singularity

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
wget $JARVIS_PROXY/sylabs/singularity/releases/download/v3.10.2/singularity-ce-3.10.2.tar.gz
tar -xf singularity-ce-3.10.2.tar.gz
cd singularity-ce-3.10.2
./mconfig --prefix=$HOME/install/singularity
make -C ./builddir
make -C ./builddir install
echo "export PATH=$HOME/install/singularity/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
```

#### 2.构建镜像

```shell
# x86
singularity build ./name-of-image.sif openeuler-gcc-9.3.0-hmpi1-qmcpack-3.13.0.def
# arm
singularity build ./name-of-image.sif openeuler-bisheng2-hmpi1-qmcpack-3.13.0.def
# 转换为沙盒
singularity build --sandbox image-sandbox name-of-image.sif
```

#### 3.在沙盒中运行

```shell
#进入沙盒
singularity shell -w image-sandbox
#在沙盒中运行内置的测试案例
cd $JARVIS_ROOT
./jarvis -r
```
