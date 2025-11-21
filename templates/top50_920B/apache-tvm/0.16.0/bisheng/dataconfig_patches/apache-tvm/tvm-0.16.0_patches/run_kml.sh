#!/bin/bash
source ./env.sh 
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
ulimit -s unlimited

old_ddr_size=0
old_hbm_size=0
new_ddr_size=2044
new_hbm_size=0
export MEMKIND_HBW_NODES=0-15
cache_mod_ddr_size_start () {
ddr_size=${new_ddr_size}
hbm_size=${new_hbm_size}
 
for i in $(seq 0 15);
do
	old_ddr_size=$(cat /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages)
        echo ${ddr_size} > /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages
done

echo "reserve ${ddr_size} x 2M huge page for DDR done, old_ddr_size=${old_ddr_size}"

for i in $(seq 16 31);
do
	if [ -e /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages ] ; then
	old_hbm_size=$(cat /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages)
        echo ${hbm_size} > /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages
	fi
done
i=16
if [ -e /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages ] ; then
echo "reserve ${hbm_size} x 2M huge page for HBM done,old_hbm_size=${old_hbm_size}"
fi
}


cache_mod_ddr_size_restore () {
ddr_size=${old_ddr_size}
hbm_size=${old_hbm_size}
 
for i in $(seq 0 15);
do
        echo ${ddr_size} > /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages
done

echo "restore ${ddr_size} x 2M huge page for DDR done"

for i in $(seq 16 31);
do
	if [ -e /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages ] ; then
        	echo ${hbm_size} > /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages
	fi
done
i=16
if [ -e /sys/devices/system/node/node${i}/hugepages/hugepages-2048kB/nr_hugepages ] ; then
echo "restore  ${hbm_size} x 2M huge page for HBM done"
fi
}
### end cache mode optimization

cache_mod_ddr_size_start
echo "start ..."
sleep 5
{ time  mpirun -np 16 --allow-run-as-root --map-by ppr:1:numa:PE=36 -x OMP_PROC_BIND=close -x OMP_PLACES=cores -x KML_BLAS_THREAD_TYPE=OMP -x KML_BLAS_NOT_USE_HBM=0 -x OMP_NUM_THREADS=36 -x UCX_TLS=sm  -x PATH -x LD_LIBRARY_PATH ./kscalapack_pdgetrf_cpp_kml -nb 512 -grid 1x16 -size 120000;} 2>&1 | tee tee_kscalapack_pdgetrf_cpp_kml.txt

cache_mod_ddr_size_restore
