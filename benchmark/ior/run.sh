#!/bin/bash
set -x
np=`nproc`
download_dir=${JARVIS_DOWNLOAD}
dpc_dir=${dpc_dir:=/workspace}
run_dir=$JARVIS_ROOT/bench_run
download(){
	. ${DOWNLOAD_TOOL} -u https://mirrors.huaweicloud.com/kunpeng/archive/HPC/benchmark/Benchmark24.0.0.sif
}


check(){
	
	
	#if ! $CHECK_DEPS  gcc singularity; then 
	if ! type singularity >/dev/null 2>&1; then
		echo "==================请检查当前环境是否已经加载singularity=================="
		exit 1
	fi
	if ! type mpicc >/dev/null 2>&1;then
		echo "==================请检查当前环境是否已经加载mpi=================="
		exit 1
	fi
	if ! echo `mpicc -v 2>&1` | grep -i "Bisheng";then
                echo "==================请检查当前mpi是否由毕昇编译器编译生成=================="
	fi
}

check_file(){
        if [ "$#" -ne 1 ];then
                echo "Usage: check_file <filename>"
                return 1
        fi
        local dir=$JARVIS_ROOT
        local filename=$1

        if [ ! -d "$dir" ];then
                echo "Directory '$dir' does not exist"
                return 1
        fi

        if [ ! -e "$dir/$filename" ];then
                echo "File '$dir/$filename' does not exist"
                return 1
        fi
}



ior_test(){
	#单节点
	mkdir -p $run_dir
	echo "当前DPC挂载目录设置为$dpc_dir,如需修改,可通过export dpc_dir=...指定其他目录"
	mkdir -p ${dpc_dir}/test_data/ior
	mpirun --allow-run-as-root -np 1 -mca pml ucx -mca btl ^vader,tcp,openib,uct -mca io romio321 -x UCX_TLS=self,sm,rc -x UCX_NET_DEVICES=mlx5_0:1 singularity exec --bind=${dpc_dir} ${download_dir}/Benchmark24.0.0.sif ior -i 3 -w -r -t 1M -b 1024g -F -e -k -o ${dpc_dir}/test_data/ior/ior1M1T1.data
	rm -rf ${dpc_dir}/test_data/ior/ior1M1T1.data
	mpirun --allow-run-as-root -np 8 -mca pml ucx -mca btl ^vader,tcp,openib,uct -mca io romio321 -x UCX_TLS=self,sm,rc -x UCX_NET_DEVICES=mlx5_0:1 singularity exec --bind=${dpc_dir} ${download_dir}/Benchmark24.0.0.sif ior -i 3 -w -r -t 1M -b 128g -F -e -k -o ${dpc_dir}/test_data/ior/ior1M1T8P.data
	rm -rf ${dpc_dir}/test_data/ior/ior1M1T8P.data
	#多节点
	if ! check_file "hostfile";then
		echo "==================ior多节点测试:缺少hostfile文件，请在$JARVIS_ROOT下编写hostfile=================="
		return 1
	fi
	
	mpirun --allow-run-as-root  -N 8 -hostfile hostfile -x LD_LIBRARY_PATH -x PATH -mca pml ucx -mca btl ^vader,tcp,openib,uct -mca io romio321 -x UCX_TLS=self,sm,rc -x UCX_NET_DEVICES=mlx5_0:1 singularity exec --bind=${dpc_dir} ${download_dir}/Benchmark24.0.0.sif ior -i 3 -w -r -t 1M -b 16g -F -e -k -o ${dpc_dir}/test_data/ior/ior1M1T8P8N.data
	rm -rf ${dpc_dir}/test_data/ior/ior1M1T8P8N.data
}


download
check
ior_test
