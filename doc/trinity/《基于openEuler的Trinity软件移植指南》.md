# 《基于openEuler的Trinity软件移植指南》

# 1.介绍

- 由布罗德研究所和耶路撒冷希伯来大学开发的Trinity代表了一种从RNA-seq数据高效、可靠地从头重建转录组的新方法。Trinity结合了三个独立的软件模块：Inchworm，Chrysalis和Butterfly，这些模块依次应用于处理大量RNA-seq读取。Trinity将序列数据划分为许多个独立的de Bruijn图，每个图代表给定基因或基因座的转录复杂性，然后独立处理每个图以提取全长剪接同工型，并挑出源自旁系基因的转录本。

- 官网地址：https://github.com/trinityrnaseq/trinityrnaseq/wiki

- GITHUB托管地址：https://github.com/trinityrnaseq/trinityrnaseq

# 2.环境要求

- 操作系统：openeuler arm/x86 (本文档以 x86 架构为例)

# 3.配置编译环境

配置环境指导，手动进行配置依赖环境。

## 3.1.环境总览

- 编译器：gcc

- 其他类库：`Cmake`, `Zlib`, `Boost`, `Salmon`, `Jellyfish`, `Samtools`, `Bowtie2`

- 具体版本和下载地址如下

具体版本和下载地址如下

| 名称     | 版本   | 软件下载地址                                                                                   |
| -------- | ------ | ---------------------------------------------------------------------------------------------- |
| gcc      | 9.3.0  | <https://ftp.gnu.org/gnu/gcc/gcc-9.3.0/gcc-9.3.0.tar.gz>                                       |
| CMake    | 3.23.1 | <https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-aarch64.tar.gz> |
| Zlib     | 1.2.11 | <http://downloads.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz>               |
| BOOST    | 1.72.0 | <https://boostorg.jfrog.io/artifactory/main/release/1.72.0/source/boost_1_72_0.tar.gz>         |
| Salmon   | 1.9.0  | <https://github.com/COMBINE-lab/salmon/archive/refs/tags/v1.9.0.tar.gz>                        |
| Jellyfish| 2.3.0  | <https://github.com/gmarcais/Jellyfish/releases/download/v2.3.0/jellyfish-2.3.0.tar.gz>        |
| Samtools | 1.15.0 | <https://github.com/samtools/samtools/releases/download/1.15/samtools-1.15.tar.bz2>            |
| Bowtie2  | 2.4.5  | <https://github.com/BenLangmead/bowtie2/archive/refs/tags/v2.4.5.tar.gz>                       |

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

### 3.4.安装环境依赖和gcc编译器

```bash
#环境依赖
yum -y install wget tar libatomic

#安装gcc编译器
wget -P $DEP_DOWNLOAD_DIR https://ftp.gnu.org/gnu/gcc/gcc-9.3.0/gcc-9.3.0.tar.gz
tar -xf $DEP_DOWNLOAD_DIR/gcc-9.3.0.tar.gz -C $DEP_INSTALL_DIR
sed -i "35s/ftp/http/g" ./contrib/download_prerequisites
./contrib/download_prerequisites
./configure --disable-multilib --enable-languages="c,c++,fortran" --prefix=$1 --disable-static --enable-shared
make -j && make install
#设置环境变量
echo "export PATH=$DEP_INSTALL_DIR/gcc-9.3.0/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
export CC=`which gcc`
export CXX=`which g++`
```

### 3.5.下载并编译`Cmake`, `Zlib`, `Boost`, `Salmon`, `Jellyfish`, `Samtools`, `Bowtie2`
```bash
# 下载CMake
wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-x86_64.tar.gz -O $DEP_DOWNLOAD_DIR/cmake-3.23.1.tar.gz
tar -xvf $DEP_DOWNLOAD_DIR/cmake-3.23.1-linux-x86_64.tar.gz -C $DEP_INSTALL_DIR/cmake --strip-components=1
echo "export PATH=$DEP_INSTALL_DIR/cmake/bin:$PATH" >> ~/.bashrc && source ~/.bashrc

# 下载并编译Zlib
wget http://downloads.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz -O $DEP_DOWNLOAD_DIR/zlib-1.2.11.tar.gz
tar -xzvf $DEP_DOWNLOAD_DIR/zlib-1.2.11.tar.gz -C $DEP_BUILD_DIR
cd $DEP_BUILD_DIR/zlib-1.2.11
./configure --prefix=$DEP_INSTALL_DIR/zlib
make -j && make install
echo "export LD_LIBRARY_PATH=$DEP_INSTALL_DIR/zlib/lib:$LD_LIBRARY_PATH" >> ~/.bashrc && source ~/.bashrc

# 下载并编译Boost
wget https://boostorg.jfrog.io/artifactory/main/release/1.72.0/source/boost_1_72_0.tar.gz -O $DEP_DOWNLOAD_DIR/boost_1_72_0.tar.gz
tar -xvf $DEP_DOWNLOAD_DIR/boost_1_72_0.tar.gz -C $DEP_BUILD_DIR
cd $DEP_BUILD_DIR/boost_1_72_0.tar.gz
cd boost_1_72_0
./bootstrap.sh
./b2 install --prefix=$DEP_INSTALL_DIR/boost
echo "export BOOST_ROOT=$DEP_INSTALL_DIR/boost/" >> ~/.bashrc && source ~/.bashrc
echo "export LD_LIBRARY_PATH=$DEP_INSTALL_DIR/boost/lib:$LD_LIBRARY_PATH" >> ~/.bashrc && source ~/.bashrc

# 下载并编译Salmon
wget https://github.com/COMBINE-lab/salmon/archive/refs/tags/v1.9.0.tar.gz -O $DEP_DOWNLOAD_DIR/v1.9.0.tar.gz
tar -xvf $DEP_DOWNLOAD_DIR/v1.9.0.tar.gz -C $DEP_BUILD_DIR
cd $DEP_BUILD_DIR/salmon-1.9.0
CC=`which gcc` CXX=`which g++` cmake -DCMAKE_INSTALL_PREFIX=$DEP_INSTALL_DIR/salmon .
make -j4
make install
echo "export PATH=$DEP_INSTALL_DIR/salmon/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
echo "export LD_LIBRARY_PATH=$DEP_INSTALL_DIR/salmon/lib:$LD_LIBRARY_PATH" >> ~/.bashrc && source ~/.bashrc

# 下载并编译Jellyfish
wget https://github.com/gmarcais/Jellyfish/releases/download/v2.3.0/jellyfish-2.3.0.tar.gz -O $DEP_DOWNLOAD_DIR/jellyfish-2.3.0.tar.gz
tar -zxvf $DEP_DOWNLOAD_DIR/ellyfish-2.3.0.tar.gz -C $DEP_BUILD_DIR
cd $DEP_BUILD_DIR/ellyfish-2.3.0
./configure --prefix=$DEP_INSTALL_DIR/jellyfish
make -j
make install
echo "export PATH=$DEP_INSTALL_DIR/jellyfish/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
echo "export LD_LIBRARY_PATH=$DEP_INSTALL_DIR/jellyfish/lib:$LD_LIBRARY_PATH" >> ~/.bashrc && source ~/.bashrc

# 下载并编译Samtools
wget https://github.com/samtools/samtools/releases/download/1.15/samtools-1.15.tar.bz2 -O $DEP_DOWNLOAD_DIR/samtools-1.15.tar.bz2
tar -xJf $DEP_DOWNLOAD_DIR/samtools-1.15.tar.bz2 -C $DEP_BUILD_DIR
cd $DEP_BUILD_DIR/samtools-1.15
./configure --prefix=$DEP_INSTALL_DIR/samtools
make -j
make install
echo "export PATH=$DEP_INSTALL_DIR/samtools/bin:$PATH" >> ~/.bashrc && source ~/.bashrc

# 下载并编译Bowtie2
wget https://github.com/BenLangmead/bowtie2/archive/refs/tags/v2.4.5.tar.gz -O $DEP_DOWNLOAD_DIR/v2.4.5.tar.gz
tar -xzf $DEP_DOWNLOAD_DIR/v2.4.5.tar.gz -C $DEP_BUILD_DIR
cd $DEP_BUILD_DIR/bowtie2-2.4.5
make -j
make static-libs -j && make STATIC_BUILD=1 -j
mkdir -p $DEP_INSTALL_DIR/bowtie2/bin
mv bowtie2* $DEP_INSTALL_DIR/bowtie2/bin
echo "export PATH=$DEP_INSTALL_DIR/bowtie2/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
```

## 4.编译Trinity

### 4.1.下载并编译Trinity

获取Trinity软件源码并解压文件

```bash

# 下载源码文件
wget https://github.com/trinityrnaseq/trinityrnaseq/releases/download/Trinity-v2.14.0/trinityrnaseq-v2.14.0.FULL_with_extendedTestData.tar.gz -O $DEP_DOWNLOAD_DIR/trinityrnaseq-v2.14.0.FULL_with_extendedTestData.tar.gz
# 解压源码文件
tar -xvf $DEP_DOWNLOAD_DIR/trinityrnaseq-v2.14.0.FULL_with_extendedTestData.tar.gz -C $DEP_BUILD_DIR
cd $DEP_BUILD_DIR/trinityrnaseq-v2.14.0
#编译源码
make -j
mkdir -p $DEP_INSTALL_DIR/trinity/bin
mv Trinity $DEP_INSTALL_DIR/trinity/bin
echo "export PATH=$DEP_INSTALL_DIR/trinity/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
```

### 4.2. 运行测试文件

运行Trinity项目测试文件

```bash
make test_trinity
```

## 附A：使用hpcrunner进行一键安装Trinity

推荐使用hpcrunner进行安装Trinity

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
yum install -y environment-modules git flex wget vim tar unzip coreutils
yum install -y gcc gcc-c++ make cmake automake java python3-devel python3-pip zlib-devel bzip2-devel xz-devel curl-devel openssl-devel ncurses-devel
pip3 install numpy  -i https://pypi.tuna.tsinghua.edu.cn/simple
```

### 3.选择平台对应配置文件

- arm平台的配置文件为 `templates/trinity/2.14.0/data.trinity.arm.cpu.config`
  
  ```bash
  ./jarvis -use templates/trinity/2.14.0/data.trinity.arm.cpu.config
  ```

- x86 平台的配置文件为 `templates/trinity/2.14.0/data.trinity.x86.cpu.config`
  
  ```bash
  ./jarvis -use templates/trinity/2.14.0/data.trinity.x86.cpu.config
  ```

### 4.下载Trinity源码

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
wget https://github.com/sylabs/singularity/releases/download/v3.10.2/singularity-ce-3.10.2.tar.gz
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
singularity build ./name-of-image.sif openeuler-gcc-9.3.0-trinity-2.14.0.def
# arm
singularity build ./name-of-image.sif openeuler-bisheng2-trinity-2.14.0.def
# 转换为沙盒
singularity build --sandbox image-sandbox name-of-image.sif
```

#### 3.在沙盒中运行

```shell
#进入沙盒
singularity shell -w image-sandbox
#在沙盒中运行内置的测试案例
cd /hpcrunner
./jarvis -r
```
