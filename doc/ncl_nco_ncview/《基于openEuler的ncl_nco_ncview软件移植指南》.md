# 《基于openEuler的NCL/NCO/NCVIEW软件移植指南》
## 鉴于NCL，NCO，NCVIEW依赖相近，因此在本指南中一并介绍

## 1.介绍
## NCL
- NCL(The NCAR Command Language)是一种专门为科学数据处理以及数据可视化设计的高级语言，很适合用在气象数据的处理和可视化上

- 官网地址：<https://ncl.ucar.edu/>

- 特性：

  - 有独特的语法，可以访问数据文件中的变量
  - 数据处理功能，比如求数据的平均值，做线性回归等
## NCO
- netCDF Operators (NCO) 工具用来操作和分析 netCDF 自描述数据存储格式

- 官网地址：<https://github.com/nco/nco>

- 特性：

  - 简单的算术运算(加、减、乘、除、广播)、插值、统计、数据合并等等
  - 提供了大量的命令可以编辑变量和属性信息，比如属性和变量重命名、变量和属性值更改\添加、缺失值处理等。
  ## NCVIEW
- ncview能非常方便的对netCDF文件进行可视化。

- 官网地址：<https://www.linuxlinks.com/ncview/>

- 特性：

  - 提供了非常便捷的方式扩充 ncview 的colormap
## 2.环境要求

- 操作系统：OpenEuler arm/x86 (本文档以 x86 架构为例)

## 3.配置编译环境

配置环境指导，手动进行配置依赖环境。

### 3.1.环境总览

- 编译器： gcc

- MPI：openmpi

- 其他类库：freetype, netcdf,hdf4,hdf5,hdf-eos2,hdf-eos5s,antlr,pkg-config,cairo,jasper,gsl,mesa,vis5d+,libjpeg,libpng

  具体版本和下载地址如下

| 名称     | 版本   | 软件下载地址                                                                                   |
| -------- | ------ | ---------------------------------------------------------------------------------------------- |
| openmpi     | 4.1.2  | <https://github.com/kunpengcompute/hmpi/archive/refs/tags/v1.2.0-huawei.zip>                   |
| gcc     | 10.3.0  | <https://mirrors.huaweicloud.com/kunpeng/archive/compiler/kunpeng_gcc/gcc-10.3.1-2021.09-aarch64-linux.tar.gz>                                       |
| antlr      | 2.7.7 | <https://www.antlr2.org/download/antlr-2.7.7.tar.gz>                          |
| cairo  | 1.16.0 | <https://www.cairographics.org/releases/cairo-1.16.0.tar.xz>                                 |
| freetype | 2.5.1 | <https://sourceforge.net/projects/freetype/files/freetype2/2.5.1/freetype-2.5.1.tar.gz >                                      |
| gdal | 2.2.4 | <http://download.osgeo.org/gdal/2.2.4/gdal-2.2.4.tar.gz>                                      |
| hdf-eos2 | 2.20 | <https://git.earthdata.nasa.gov/rest/git-lfs/storage/DAS/hdfeos/cb0f900d2732ab01e51284d6c9e90d0e852d61bba9bce3b43af0430ab5414903?response-content-disposition=attachment%3B%20filename%3D%22HDF-EOS2.20v1.00.tar.Z%22%3B%20filename*%3Dutf-8%27%27HDF-EOS2.20v1.00.tar.Z>                                      |
| hdf-eos5 | 1.16 | <https://git.earthdata.nasa.gov/rest/git-lfs/storage/DAS/hdfeos5/7054de24b90b6d9533329ef8dc89912c5227c83fb447792103279364e13dd452?response-content-disposition=attachment%3B%20filename%3D%22HDF-EOS5.1.16.tar.Z%22%3B%20filename*%3Dutf-8%27%27HDF-EOS5.1.16.tar.Z>                                      |
| hdf4 | 4.2.14 | <https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.14/src/hdf-4.2.14.tar.gz>                                      |
| hdf5 | 1.12.0 | <https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12.0/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz>                                      |
| jasper | 1.900.2 | <https://mirrors.tuna.tsinghua.edu.cn/ubuntu/pool/main/j/jasper/jasper_1.900.2.orig.tar.gz>                                      |
| libjpeg | v9b | <http://www.ijg.org/files/jpegsrc.v9b.tar.gz>                                      |
| libpng | 1.6.37 | <https://nchc.dl.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.gz>                                      |
| Mesa | 3.1 | <https://archive.mesa3d.org/older-versions/3.x/MesaLib-3.1.tar.gz >                                      |
| pixman | 0.38.0 | <https://www.cairographics.org/releases/pixman-0.38.0.tar.gz >                                      |
| pkg-config | 0.28 | <http://pkgconfig.freedesktop.org/releases/pkg-config-0.29.tar.gz>                                      |
| proj | 5.2.0 | <http://download.osgeo.org/proj/proj-5.2.0.tar.gz>                                      |
| vis5d+ | 1.3.0 | <https://sourceforge.net/projects/vis5d/files/vis5d/vis5d%2B-1.3.0-beta/vis5d%2B-1.3.0-beta.tar.gz>                                      |

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
yum -y install wget tar expat 

#安装gcc编译器
wget -P $DEP_DOWNLOAD_DIR https://ftp.gnu.org/gnu/gcc/gcc-10.3.0/gcc-10.3.0.tar.gz
tar -xf $DEP_DOWNLOAD_DIR/gcc-10.3.0.tar.gz -C $DEP_INSTALL_DIR
./contrib/download_prerequisites
./configure --disable-multilib --enable-languages="c,c++,fortran" --prefix=$1 --disable-static --enable-shared
make -j && make install


#设置环境变量
echo "export PATH=$DEP_INSTALL_DIR/gcc-10.3.0/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
export CC=`which gcc`
export CXX=`which g++`
```

## 3.5.下载并编译openmpi

```bash
yum -y install libstdc++ libstdc++-devel
yum -y install unzip make autoconf automake git libtool
#下载解压源码文件
wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.2.tar.gz -O $DEP_DOWNLOAD_DIR
cd $DEP_BUILD_DIR
tar zxvf $DEP_DOWNLOAD_DIR openmpi-4.1.2.tar.gz
cd openmpi-4.1.2
./configure CC=gcc CXX=g++ FC=gfortran --prefix=$1 --enable-pretty-print-stacktrace --enable-orterun-prefix-by-default --enable-mpi1-compatibility
make -j install

yum -y install flex
```
## 以下是NCL依赖各库
## 3.6.下载并编译各库

```bash

#libjpeg
. wget -u http://www.ijg.org/files/jpegsrc.v9b.tar.gz
cd $DEP_BUILD_DIR
rm -rf jpeg-9b
tar xvf $DEP_DOWNLOAD_DIR/jpegsrc.v9b.tar.gz
cd jpeg-9b
./configure --prefix=$1
make -j
make install

#libpng

#pkg-config
. wget -u http://pkgconfig.freedesktop.org/releases/pkg-config-0.29.tar.gz
cd $DEP_BUILD_DIR
tar xvf $DEP_DOWNLOAD_DIR/pkg-config-0.29.tar.gz 
cd pkg-config-0.29
./configure --prefix=$1 --enable-shared
make -j
make install

#pnetcdf
pnetcdf_version='1.12.1'
. wget -u http://cucis.ece.northwestern.edu/projects/PnetCDF/Release/pnetcdf-${pnetcdf_version}.tar.gz
cd $DEP_BUILD_DIR
tar zxvf $DEP_DOWNLOAD_DIR/pnetcdf-${pnetcdf_version}.tar.gz
cd pnetcdf-${pnetcdf_version}
FCFLAGS=-fallow-argument-mismatch FFLAGS=-fallow-argument-mismatch ./configure --prefix=$1 --enable-shared --enable-fortran --enable-large-file-test
make -j16
make install

#pixman
. wget -u https://www.cairographics.org/releases/pixman-0.38.0.tar.gz
cd $DEP_BUILD_DIR

tar xvf $DEP_DOWNLOAD_DIR/pixman-0.38.0.tar.gz
cd pixman-0.38.0
./configure --prefix=$1
make -j
make install

#freetype
. wget -u https://sourceforge.net/projects/freetype/files/freetype2/2.5.1/freetype-2.5.1.tar.gz
cd $DEP_BUILD_DIR
tar -xvf $DEP_DOWNLOAD_DIR/freetype-2.5.1.tar.gz
cd freetype-2.5.1

./configure --enable-shared --prefix=$1
make -j
make install
cd include
cp -r * $1/include

#gdal
. wget -u http://download.osgeo.org/gdal/2.2.4/gdal-2.2.4.tar.gz
cd $DEP_BUILD_DIR
tar -xvf $DEP_DOWNLOAD_DIR/gdal-2.2.4.tar.gz
cd gdal-2.2.4

./configure --with-static-proj4=${PROJ_PATH} --prefix=$1 --with-png=${LIBPNG_PATH} --with-gif=internal --with-libtiff=internal \
      --with-geotiff=internal --with-jpeg=${LIBJPEG_PATH} --with-libz=/usr/local \
      --with-sqlite3=no --with-expat=no --with-curl=no --without-ld-shared \
      --with-hdf4=no --with-hdf5=no --with-pg=no --without-grib --disable-shared \
      --with-freexl=no --with-geos=no --with-openjpeg=no --with-mysql=no \
      --with-ecw=no --with-fgdb=no --with-odbc=no --with-xml2=no --with-ogdi=no\
      --with-pcraster=no --with-xerces=no
make all install

#gsl
. wget -u http://mirrors.ustc.edu.cn/gnu/gsl/gsl-2.6.tar.gz
cd $DEP_BUILD_DIR
rm -rf gsl-2.6
tar -xvf $DEP_DOWNLOAD_DIR/gsl-2.6.tar.gz
cd gsl-2.6
./configure --prefix=$1  
make -j
make install

#hdf-eos2
. wget -u https://git.earthdata.nasa.gov/rest/git-lfs/storage/DAS/hdfeos/cb0f900d2732ab01e51284d6c9e90d0e852d61bba9bce3b43af0430ab5414903?response-content-disposition=attachment%3B%20filename%3D%22HDF-EOS2.20v1.00.tar.Z%22%3B%20filename*%3Dutf-8%27%27HDF-EOS2.20v1.00.tar.Z
cd $DEP_DOWNLOAD_DIR
cp -f cb0f900d2732ab01e51284d6c9e90d0e852d61bba9bce3b43af0430ab5414903* HDF-EOS2.20v1.00.tar
cd $DEP_BUILD_DIR

tar -xvf $DEP_DOWNLOAD_DIR/HDF-EOS2.20v1.00.tar
cd hdfeos

ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes ./configure --with-hdf4=${HDF4_PATH} --with-jpeg=${LIBJPEG_PATH} --with-zlib=/usr/local --prefix=$1
make -j
make install
cp -r include $1/

#hdf4
. wget -u https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.15/src/hdf-4.2.15.tar.gz
cd $DEP_BUILD_DIR
rm -rf hdf-4.2.15
tar -xvf $DEP_DOWNLOAD_DIR/hdf-4.2.15.tar.gz
cd hdf-4.2.15
FFLAGS+='-fallow-argument-mismatch' ./configure --prefix=$1  --with-zlib=/usr/local --disable-fortran --with-jpeg=${LIBJPEG_PATH} --disable-netcdf
make -j
make install

#hdf5
hdf5_big_version='1.12'
hdf5_version="${hdf5_big_version}.0"
. wget -u https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${hdf5_big_version}/hdf5-${hdf5_version}/src/hdf5-${hdf5_version}.tar.gz
cd $DEP_BUILD_DIR
rm -rf hdf5-${hdf5_version}
tar -xvf $DEP_DOWNLOAD_DIR/hdf5-${hdf5_version}.tar.gz
cd hdf5-${hdf5_version}
./configure --prefix=$1  --enable-fortran --enable-static=yes --enable-parallel --enable-shared
make -j
make install
#netcdf
netcdf_c_version='4.7.4'
netcdf_f_version='4.5.3'
. wget -u https://codeload.github.com/Unidata/netcdf-fortran/tar.gz/refs/tags/v${netcdf_f_version} -f netcdf-fortran-${netcdf_f_version}.tar.gz
. wget -u https://codeload.github.com/Unidata/netcdf-c/tar.gz/refs/tags/v${netcdf_c_version} -f netcdf-c-${netcdf_c_version}.tar.gz 
cd $DEP_BUILD_DIR
rm -rf netcdf-c-${netcdf_c_version} netcdf-fortran-${netcdf_f_version}
tar -xvf $DEP_DOWNLOAD_DIR/netcdf-c-${netcdf_c_version}.tar.gz
tar -xvf $DEP_DOWNLOAD_DIR/netcdf-fortran-${netcdf_f_version}.tar.gz
cd netcdf-c-${netcdf_c_version}
if [ x"$(arch)" = xaarch64 ];then
    build_type='--build=aarch64-unknown-linux-gnu'
else
    build_type=''
fi
HDF5_DIR=${HDF5_PATH}
PNETCDF_DIR=${PNETCDF_PATH}
./configure --prefix=$1 ${build_type} --enable-shared --enable-netcdf-4 --disable-dap --with-pic --disable-doxygen --enable-static --enable-pnetcdf --enable-largefile CPPFLAGS="-O3 -I${HDF5_DIR}/include -I${PNETCDF_DIR}/include" LDFLAGS="-L${HDF5_DIR}/lib -L${PNETCDF_DIR}/lib -Wl,-rpath=${HDF5_DIR}/lib -Wl,-rpath=${PNETCDF_DIR}/lib" CFLAGS="-O3 -L${HDF5_DIR}/lib -L${PNETCDF_DIR}/lib -I${HDF5_DIR}/include -I${PNETCDF_DIR}/include"

make -j16
make install

export PATH=$1/bin:$PATH
export LD_LIBRARY_PATH=$1/lib:$LD_LIBRARY_PATH
export NETCDF=${1}

cd ../netcdf-fortran-${netcdf_f_version}
./configure --prefix=$1 ${build_type} --disable-shared --with-pic --disable-doxygen --enable-largefile --enable-static CPPFLAGS="-O3 -I${HDF5_DIR}/include -I${1}/include" LDFLAGS="-L${HDF5_DIR}/lib -L${1}/lib -Wl,-rpath=${HDF5_DIR}/lib -Wl,-rpath=${1}/lib" CFLAGS="-O3 -L${HDF5_DIR}/HDF5/lib -L${1}/lib -I${HDF5_DIR}/include -I${1}/include" CXXFLAGS="-O3 -L${HDF5_DIR}/lib -L${1}/lib -I${HDF5_DIR}/include -I${1}/include" FCFLAGS="-O3 -L${HDF5_DIR}/lib -L${1}/lib -I${HDF5_DIR}/include -I${1}/include"
make -j16
make install

#hdf-eos5
. wget -u https://git.earthdata.nasa.gov/rest/git-lfs/storage/DAS/hdfeos5/7054de24b90b6d9533329ef8dc89912c5227c83fb447792103279364e13dd452?response-content-disposition=attachment%3B%20filename%3D%22HDF-EOS5.1.16.tar.Z%22%3B%20filename*%3Dutf-8%27%27HDF-EOS5.1.16.tar.Z
cd $DEP_DOWNLOAD_DIR
cp -f 7054de24b90b6d9533329ef8dc89912c5227c83fb447792103279364e13dd452* HDF-EOS5.1.16.tar
cd $DEP_BUILD_DIR
# gzip -d $DEP_DOWNLOAD_DIR/HDF-EOS2.20v1.00.tar
tar -xvf $DEP_DOWNLOAD_DIR/HDF-EOS5.1.16.tar
cd hdfeos5

./configure CC=${HDF5_PATH}/bin/h5pcc --with-hdf4=${HDF5_PATH} --with-zlib=/usr/local --prefix=$1 
make -j
make install
cp -r include $1/
#proj
. wget -u http://download.osgeo.org/proj/proj-5.2.0.tar.gz
cd $DEP_BUILD_DIR
rm -rf proj-5.2.0
tar -xvf $DEP_DOWNLOAD_DIR/proj-5.2.0.tar.gz
cd proj-5.2.0

./configure --enable-shared --enable-static --prefix=$1
make all install

#jasper
. wget -u https://www.ece.uvic.ca/~frodo/jasper/software/jasper_1.900.2.orig.tar.gz
cd $DEP_BUILD_DIR
rm -rf jasper-1.900.2
tar -xvf $DEP_DOWNLOAD_DIR/jasper_1.900.2.orig.tar.gz
cd jasper-1.900.2
./configure --prefix=$1
make -j
make install

#mesa 
. wget -u https://archive.mesa3d.org/older-versions/3.x/MesaLib-3.1.tar.gz
cd $DEP_BUILD_DIR
rm -rf Mesa-3.1
tar -xvf $DEP_DOWNLOAD_DIR/MesaLib-3.1.tar.gz
cd Mesa-3.1
cp -f /usr/share/libtool/build-aux/config.guess ./
cp -f /usr/share/libtool/build-aux/config.sub  ./
./configure --prefix=$1
make
make install

#udunits
. wget -u https://artifacts.unidata.ucar.edu/repository/downloads-udunits/2.2.28/udunits-2.2.28.tar.gz
cd $DEP_BUILD_DIR
tar xvf $DEP_DOWNLOAD_DIR/udunits-2.2.28.tar.gz
cd udunits-2.2.28
./configure --prefix=$1
make -j
make install

#vis5d+
. wget -u https://sourceforge.net/projects/vis5d/files/vis5d/vis5d%2B-1.3.0-beta/vis5d%2B-1.3.0-beta.tar.gz
cd $DEP_BUILD_DIR
rm -rf vis5d+-1.3.0-beta
tar -xvf $DEP_DOWNLOAD_DIR/vis5d%2B-1.3.0-beta.tar.gz
cd vis5d+-1.3.0-beta
sed -i '40c extern float vis_round( float x ); ' src/misc.h
sed -i '150c float vis_round(float x)' src/misc.c

FFLAGS='-fno-range-check -fallow-rank-mismatch' LDFLAGS=-L${MESA_PATH}/lib CFLAGS=-I${MESA_PATH}/include CPPFLAGS=-I${MESA_PATH}/include ./configure --prefix=$1 --disable-fortran --with-netcdf=${NETCDF_PATH} --disable-shared

make
make install 

```

## 以下是NCO依赖各库
NCO依赖为netcdf hdf4 hdf5 gsl udunits antlr

```bash
#antlr
. wget -u https://www.antlr2.org/download/antlr-2.7.7.tar.gz
cd $DEP_BUILD_DIR
tar xvf $DEP_DOWNLOAD_DIR/antlr-2.7.7.tar.gz
cd antlr-2.7.7
sed -i "13a #include <strings.h>" lib/cpp/antlr/CharScanner.hpp
sed -i "14a #include <cstdio>" lib/cpp/antlr/CharScanner.hpp
./configure \
--prefix=$1 \
--disable-csharp \
--disable-java \
--disable-python
make -j
make install
#其余同上
```

## 以下为NCVIEW依赖
ncview依赖为 hdf5 pnetcdf netcdf udunits
```bash
#同上NCL
```

## 4.编译

### 4.1.下载并编译wannier90

获取QMCPACK软件源码并解压文件

```bash

# 下载源码文件
cd $DEP_DOWNLOAD_DIR
git clone https://github.com/wannier-developers/wannier90.git
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

### 4.2. 运行测试

ncl为图形应用，官方并未给出过多用例，所以验证ncl程序是否成功编译，

```bash
export PATH=$PATH:$INSTALL_DIR/bin
ncl -v
```

## 附A：使用hpcrunner进行一键安装ncl、nco、ncview

推荐使用hpcrunner进行安装ncl、nco、ncview

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
## NCL
- arm平台的配置文件为 `templates/ncl/6.6.2/data.NCL.arm.cpu.config`
  
  ```bash
  ./jarvis -use templates/ncl/6.6.2/data.NCL.arm.cpu.config
  ```

- x86 平台的配置文件为 `templates/ncl/6.6.2/data.ncl.x86.cpu.config`
  
  ```bash
  ./jarvis -use templates/wannier90/3.1.0/data.wannier90.amd.cpu.config
  ```
## NCO
- arm平台的配置文件为 `templates/nco/5.1.4/data.NCO.arm.cpu.config`
  
  ```bash
  ./jarvis -use templates/wannier90/3.1.0/data.wannier90.arm.cpu.config
  ```

- x86 平台的配置文件为 `templates/nco/5.1.4/data.NCO.x86.cpu.config`
  
  ```bash
  ./jarvis -use templates/wannier90/3.1.0/data.wannier90.amd.cpu.config
  ```
  ## NCVIEW
  - arm平台的配置文件为 `templates/ncview/2.1.7/data.ncview.arm.cpu.config`
  
  ```bash
  ./jarvis -use templates/wannier90/3.1.0/data.wannier90.arm.cpu.config
  ```

- x86 平台的配置文件为 `templates/ncview/2.1.7/data.ncview.x86.cpu.config`
  
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

[百度云盘](https://pan.baidu.com/s/1fxKHH5cIaKVt2boYUhVxmQ?pwd=ic13)


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
cd /hpcrunner
./jarvis -r
```
