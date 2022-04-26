# LAMMPS

## Description 

Lammps is a classical molecular dynamics software, which is often used to simulate materials. See [LAMMPS Home](https://lammps.sandia.gov/) for details.

The current code repository is a series of patches and scripts for performance optimization of Lammps on Kunpeng chips.

## Software Stack Used

Compiler: Bisheng Compiler, see [Bisheng Home](https://support.huaweicloud.com/intl/en-us/ug-bisheng-kunpengdevps/kunpengbisheng_06_0001.html).

MPI: Hyper MPI, see [Hyper MPI Home](https://support.huaweicloud.com/intl/en-us/usermanual-kunpenghpcs/userg_huaweimpi_0003.html).

FFT: KML FFT, see [KML FFT Home](https://support.huaweicloud.com/intl/en-us/devg-kml-kunpengaccel/kunpengaccel_kml_16_0010.html).

Lammps: lammps-5Jun2019.tar.gz

- <https://lammps.sandia.gov/tars/>

## How to Build

### Installation Dependencies

Install BiSheng compiler.

Install Hyper MPI.

Install KML FFT.

### Unzip Lammps & Config USER-OMP

```
tar xvf lammps-5Jun2019.tar.gz

cd lammps-5Jun19/

cp src/USER-OMP/hack_openmp_for_pgi_gcc9.sh ./src/

cp src/USER-OMP/hack_openmp_for_pgi_gcc9.sh ./src/SNAP/

cd src

./hack_openmp_for_pgi_gcc9.sh

cd USER-OMP/

./hack_openmp_for_pgi_gcc9.sh

cd ../SNAP/

./hack_openmp_for_pgi_gcc9.sh

cd ../
```



### Install Patches

```
cp lammps-5Jun2019-aarch64-kunpeng-001.patch lammps-5Jun19/../

patch -p1 < lammps-5Jun2019-aarch64-kunpeng-001.patch
```



### Modify the KML FFT Path

```
vim lammps-5Jun19/src/MAKE/OPTIONS/Makefile.omp
```

FFT_INC =       -DFFT_KML -I***/PATH/to/kml***/include
FFT_PATH =      -L***/PATH/to/kml***/lib
FFT_LIB =       -lkfft -lkm

Change “***/PATH/to/kml***” to the real path of KML FFT.



### Build Lammps

```
make no-all

make clean-all

make yes-std

make yes-USER-OMP

make no-lib

make -j64 omp
```



## How to Run

```
mpirun --allow-run-as-root -mca pml ucx -mca btl ^vader,tcp,openib,uct -x UCX_TLS=self,sm --bind-to core --map-by socket --rank-by core -x UCX_BUILTIN_BCAST_ALGORITHM=3 -x UCX_BUILTIN_BARRIER_ALGORITHM=5 -x UCX_BUILTIN_ALLREDUCE_ALGORITHM=10 -np 128 /PATH/TO/lammps-5Jun19/src/lmp_omp -in equ.in
```

/PATH/TO/lammps-5Jun19/src/lmp_omp: path to the lmp_omp file.

equ.in: input file to be calculated.