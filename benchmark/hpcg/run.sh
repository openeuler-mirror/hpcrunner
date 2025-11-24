#!/bin/bash
#set -x
np=`nproc`
download_dir=${JARVIS_DOWNLOAD}
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



hpcg_test(){
	mkdir -p $run_dir
	if ! check_file "hostfile";then
		echo "==================hpcg_test测试:缺少hostfile文件，请在$JARVIS_ROOT下编写hostfile=================="
		return 1
	fi
	cd ${run_dir}
        singularity run ${download_dir}/Benchmark24.0.0.sif cat /hpcrunner/tools/hpcg/hpcg.dat > ${run_dir}/hpcg.dat 
	mpirun --allow-run-as-root -map-by ppr:$((np/8)):node:pe=8 --hostfile $JARVIS_ROOT/hostfile -x OMP_WAIT_POLICY=active -x OMP_DISPLAY_ENV=true -x OMP_DISPLAY_AFFINITY=true -x OMP_PLACES=cores -x OMP_PROC_BIND=close -x UCX_TLS=self,sm,rc -x UCX_NET_DEVICES=mlx5_0:1 singularity exec --bind=${PWD} ${download_dir}/Benchmark24.0.0.sif xhpcg
}


download
check
hpcg_test

