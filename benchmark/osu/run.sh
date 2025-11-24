#!/bin/bash
#set -x
np=`nproc`
download_dir=${JARVIS_DOWNLOAD}
run_dir=$JARVIS_ROOT/bench_run
download(){
	. ${DOWNLOAD_TOOL} -u https://mirrors.huaweicloud.com/kunpeng/archive/HPC/benchmark/Benchmark24.0.0.sif
}


check(){
	
	
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


osu_test(){
	#单节点
	if ! check_file "rankfile";then
		echo "==================osu测试:缺少rankfile文件，请在$JARVIS_ROOT下编写rankfile=================="
		return 1
	fi
	
        mpirun --allow-run-as-root -np 2 --rankfile $JARVIS_ROOT/rankfile -x PATH -x LD_LIBRARY_PATH -mca pml ucx -mca btl ^vader,tcp,openib,uct -x UCX_TLS=rc_x --bind-to core -x UCX_RNDV_THRESH=64k -x UCX_NET_DEVICES=mlx5_0:1 singularity exec ${download_dir}/Benchmark24.0.0.sif osu_bw -i 5000 -W 128
	
        mpirun --allow-run-as-root -np 2 --rankfile $JARVIS_ROOT/rankfile -x PATH -x LD_LIBRARY_PATH -mca pml ucx -mca btl ^vader,tcp,openib,uct -x UCX_TLS=rc_x --bind-to core -x UCX_RNDV_THRESH=64k -x UCX_NET_DEVICES=mlx5_0:1 singularity exec ${download_dir}/Benchmark24.0.0.sif osu_latency -i 1000
        	
	#多节点
	if ! check_file "hostfile";then
		echo "==================osu多节点测试:缺少hostfile文件，请在$JARVIS_ROOT下编写hostfile=================="
		return 1
	fi
	
        mpirun --allow-run-as-root -N $np -hostfile $JARVIS_ROOT/hostfile -x PATH -x LD_LIBRARY_PATH -mca pml ucx -mca btl ^vader,tcp,openib,uct -x UCX_TLS=self,sm,rc -x UCX_NET_DEVICES=mlx5_0:1 singularity exec ${download_dir}/Benchmark24.0.0.sif osu_bcast -i 1000
	
        mpirun --allow-run-as-root -N $np -hostfile $JARVIS_ROOT/hostfile -x PATH -x LD_LIBRARY_PATH -mca pml ucx -mca btl ^vader,tcp,openib,uct -x UCX_TLS=self,sm,rc -x UCX_NET_DEVICES=mlx5_0:1 singularity exec ${download_dir}/Benchmark24.0.0.sif osu_alltoall -i 1000
}

download
check
osu_test
