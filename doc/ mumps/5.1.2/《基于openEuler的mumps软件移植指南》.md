# 《基于openEuler的MUMPS软件移植指南》

## 1.介绍

- MUMPS（"MUltifrontal Massively Parallel Solver"）是一个用于求解线性方程组的软件包。

- 官网地址：<https://mumps-solver.org/>

- 特性：

  - 实数或复数算术（单精度或双精度）
  - 平行因式分解和求解阶段
  - (也可使用单处理器版本)
  - 脱离核心的数值阶段
  - 迭代细化和逆向误差分析
  - 各种矩阵输入格式集合式、分布式、元素式格式
  - 部分因式分解和Schur互补矩阵（集中式或二维块状循环式），具有减少/压缩的右手边

## 2.环境要求

- 操作系统：OpenEuler arm/x86 (本文档以 x86 架构为例)

## 3.配置编译环境

配置环境指导，手动进行配置依赖环境。

### 3.1.环境总览

- 编译器： gcc

- MPI：hmpi

- 其他类库：`CMake`, `OpenBLAS`, `zlib`, `lapack`, `scalapack`

  具体版本和下载地址如下

| 名称      | 版本   | 软件下载地址                                                                                   |
| --------- | ------ | ---------------------------------------------------------------------------------------------- |
| hmpi      | 1.1.1  | <https://github.com/kunpengcompute/hmpi/archive/refs/tags/v1.1.1-huawei.zip>                   |
| gcc       | 9.3.0  | <https://ftp.gnu.org/gnu/gcc/gcc-9.3.0/gcc-9.3.0.tar.gz>                                       |
| CMake     | 3.23.1 | <https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-aarch64.tar.gz> |
| OpenBLAS  | 0.3.18 | <https://github.com/xianyi/OpenBLAS/archive/refs/tags/v0.3.18.tar.gz>                          |
| zlib      | 1.2.12 | <https://zlib.net/fossils/zlib-1.2.12.tar.gz>                                                  |
| lapack    | 3.8.0  | <https://www.cp2k.org/static/downloads/lapack-3.8.0.tgz>                                       |
| scalapack | 2.1.0  | <http://www.netlib.org/scalapack/scalapack-2.1.0.tgz>                                          |

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

#安装bisheng编译器
wget -P $DEP_DOWNLOAD_DIR https://ftp.gnu.org/gnu/gcc/gcc-9.3.0/gcc-9.3.0.tar.gz
tar -xf $DEP_DOWNLOAD_DIR/gcc-9.3.0.tar.gz -C $DEP_INSTALL_DIR
sed -i "35s/ftp/http/g" ./contrib/download_prerequisites
./contrib/download_prerequisites
./configure --disable-multilib --enable-languages="c,c++,fortran" --prefix=$1 --disable-static --enable-shared
make -j && make install
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

## 3.6.下载并编译`CMake`, `OpenBLAS`, `zlib`, `lapack`, `scalapack`

```bash
# 下载CMake
wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-x86_64.tar.gz -O $DEP_DOWNLOAD_DIR/cmake-3.23.1.tar.gz
tar -xvf $DEP_DOWNLOAD_DIR/cmake-3.23.1-linux-x86_64.tar.gz -C $DEP_INSTALL_DIR/cmake --strip-components=1
echo "export PATH=$DEP_INSTALL_DIR/cmake/bin:$PATH" >> ~/.bashrc && source ~/.bashrc

# 下载并编译OpenBLAS
wget https://github.com/xianyi/OpenBLAS/archive/refs/tags/v0.3.18.tar.gz -O $DEP_DOWNLOAD_DIR/OpenBLAS-0.3.18.tar.gz
tar -xzvf $DEP_DOWNLOAD_DIR/OpenBLAS-0.3.18.tar.gz -C $DEP_BUILD_DIR
cd $DEP_BUILD_DIR/OpenBLAS-0.3.18
make -j 
make PREFIX=$DEP_INSTALL_DIR/OpenBLAS install
echo "export LD_LIBRARY_PATH=$DEP_INSTALL_DIR/OpenBLAS/lib:$LD_LIBRARY_PATH" >> ~/.bashrc && source ~/.bashrc

# 下载并编译zlib
wget https://zlib.net/fossils/zlib-1.2.12.tar.gz -O $DEP_DOWNLOAD_DIR/zlib-1.2.12.tar.gz
tar -xvf $DEP_DOWNLOAD_DIR/zlib-1.2.12.tar.gz -C $DEP_BUILD_DIR
cd $DEP_BUILD_DIR/zlib-1.2.12
CC= CXX= ./configure --prefix=$DEP_INSTALL_DIR/zlib
make -j
make install
echo "export LD_LIBRARY_PATH=$DEP_INSTALL_DIR/zlib/lib:$LD_LIBRARY_PATH" >> ~/.bashrc && source ~/.bashrc

# 下载并编译lapack
wget https://www.cp2k.org/static/downloads/lapack-3.8.0.tgz -O $DEP_DOWNLOAD_DIR/lapack-3.8.0.tgz
tar -xvf $DEP_DOWNLOAD_DIR/lapack-3.8.0.tgz -C $DEP_BUILD_DIR
cd $DEP_BUILD_DIR/lapack-3.8.0
./bootstrap.sh
mkdir build && cd build 
cmake .. -DCMAKE_BUILD_TYPE=RELEASE -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_LIBDIR=$DEP_INSTALL_DIR/lapack
make -j
make install -j 
echo "export LD_LIBRARY_PATH=$DEP_INSTALL_DIR/lapack/lib:$LD_LIBRARY_PATH" >> ~/.bashrc && source ~/.bashrc

# 下载并编译scalapack
wget http://www.netlib.org/scalapack/scalapack-2.1.0.tgz -O $DEP_DOWNLOAD_DIR/scalapack-2.1.0.tgz
tar -xvf $DEP_DOWNLOAD_DIR/scalapack-2.1.0.tgz -C $DEP_BUILD_DIR
cd $DEP_BUILD_DIR/scalapack-2.1.0
mkdir build && cd build 
cmake \
-DCMAKE_INSTALL_PREFIX=$DEP_INSTALL_DIR/scalapack \
-DBUILD_SHARED_LIBS=ON \
-DBLAS_LIBRARIES=$DEP_INSTALL_DIR/OpenBLAS/lib/libopenblas.so \
-DLAPACK_LIBRARIES=$DEP_INSTALL_DIR/lapack/lib/liblapack.so \
-DCMAKE_C_COMPILER=mpicc -DCMAKE_Fortran_COMPILER=mpif90 \
.. /
make -j 
make install
echo "export LD_LIBRARY_PATH=$DEP_INSTALL_DIR/scalapack/lib:$LD_LIBRARY_PATH" >> ~/.bashrc && source ~/.bashrc

```

## 4.编译MUMPS

### 4.1.下载并编译 MUMPS

获取 MUMPS软件源码并解压文件

```bash

# 下载源码文件
wget http://graal.ens-lyon.fr/MUMPS/MUMPS_5.1.2.tar.gz -O $DEP_DOWNLOAD_DIR/MUMPS_5.1.2.tar.gz
# 解压源码文件
tar -xvf $DEP_DOWNLOAD_DIR/MUMPS_5.1.2.tar.gz -C $DEP_BUILD_DIR
cd $DEP_BUILD_DIR/MUMPS_5.1.2
#编译源码
mkdir -p lib
cp Make.inc/Makefile.inc.generic ./Makefile.inc
sed -i 's/f90/mpifort/g' ./Makefile.inc
sed -i 's/CC      = cc/CC = mpicc/g' ./Makefile.inc
sed -i '94c LIBEXT  = .so' ./Makefile.inc
sed -i '107c AR = $(CC) -shared $(OPTC) -o' ./Makefile.inc
sed -i '115c LAPACK = -Wl,-rpath,$DEP_INSTALL_DIR/lapack/ -L$DEP_INSTALL_DIR/lapack/ -llapack' ./Makefile.inc
sed -i '118c SCALAP = -Wl,-rpath,$DEP_INSTALL_DIR/scalapack/lib/ -L$DEP_INSTALL_DIR/scalapack/lib/ -lscalapack' ./Makefile.inc
sed -i '121c INCPAR = -I$DEP_INSTALL_DIR/hmpi/include' ./Makefile.inc
sed -i '124c LIBPAR = $(SCALAP) $(LAPACK) -L$DEP_INSTALL_DIR/hmpi/lib -lmpi_usempif08 -lmpi_usempi_ignore_tkr -lmpi_mpifh -lmpi' ./Makefile.inc
sed -i '134c LIBBLAS = -Wl,-rpath,$DEP_INSTALL_DIR/openblas/lib -L$DEP_INSTALL_DIR/openblas/lib -lopenblas' ./Makefile.inc
sed -i '153c OPTF = -DALLOW_NON_INIT ${CFLAGS} -fPIC -Wno-argument-mismatch' ./Makefile.inc
sed -i '154c OPTC = ${CFLAGS} -fPIC' ./Makefile.inc
sed -i '155c OPTL = ${CFLAGS} -fPIC' ./Makefile.inc
sed -i '71c cp $(LPORDDIR)/libpord$(LIBEXT) `pwd`/lib; \\' ./Makefile
make alllib all
```

### 4.2. 运行测试文件

运行MUMPS项目测试文件

```bash
cd $DEP_BUILD_DIR/MUMPS_5.1.2/example
export OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 
make clean all
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$DEP_BUILD_DIR/MUMPS_5.1.2/lib
${MPIRUN} ./ssimpletest < input_simpletest_real 
${MPIRUN} ./dsimpletest < input_simpletest_real
${MPIRUN} ./csimpletest < input_simpletest_cmplx
${MPIRUN} ./zsimpletest < input_simpletest_cmplx
${MPIRUN} ./c_example
${MPIRUN} ./multiple_arithmetics_example
```

## 附A：使用hpcrunner进行一键安装MUMPS

推荐使用hpcrunner进行安装MUMPS

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
yum install -y environment-modules git wget unzip make flex tar
# x86
yum install -y environment-modules git wget unzip make flex tar
yum install -y gcc gcc-c++ gcc-gfortran glibc-devel libgfortran 
yum install -y tcsh tcl lsof tk bc
```

### 3.选择平台对应配置文件

- arm平台的配置文件为 `templates/mumps/5.1.2/data.mumps.arm.cpu.config`
  
  ```bash
  ./jarvis -use templates/mumps/5.1.2/data.mumps.arm.cpu.config
  ```

- x86 平台的配置文件为 `templates/mumps/5.1.2/data.mumps.amd.cpu.config`
  
  ```bash
  ./jarvis -use templates/mumps/5.1.2/data.mumps.amd.cpu.config
  ```

### 4.下载mumps源码

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
singularity build ./name-of-image.sif openeuler-gcc-9.3.0-hmpi1-mumps-5.1.2.def
# arm
singularity build ./name-of-image.sif openeuler-bisheng2-hmpi1-mumps-5.1.2.def
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
