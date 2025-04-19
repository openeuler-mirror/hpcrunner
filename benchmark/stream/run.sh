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



stream_test(){
	mkdir -p $run_dir
	if ! type tuned-adm >/dev/null 2>&1;then
		echo "==================stream测试：安装tuned=================="
		. $CHECK_ROOT && yum install -y tuned
	fi
	#tuned-adm profile throughput-performance
	cd $run_dir
	tuned-adm profile throughput-performance
	singularity run ${download_dir}/Benchmark24.0.0.sif stream.sh
}


download
check
stream_test

