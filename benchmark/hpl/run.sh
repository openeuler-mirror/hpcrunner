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


hpl_test(){
	mkdir -p $run_dir
	#根据核数生成HPL.dat
	if [[ np -eq 160 ]];then
		singularity run ${download_dir}/Benchmark24.0.0.sif  cat /hpcrunner/tools/hpl/open/HPL.dat > $run_dir/HPL.dat
	else
		singularity run ${download_dir}/Benchmark24.0.0.sif  cat /hpcrunner/tools/hpl/optimize/HPL.dat > $run_dir/HPL.dat
	fi
	
	#单节点
        mpirun --allow-run-as-root -np $((np/4)) -mca pml ucx -mca btl ^vader,tcp,openib -mca io romio321 -x UCX_TLS=self,sm,rc_x -x UCX_NET_DEVICES=mlx5_0:1 -x OMP_NUM_THREADS=4 -x OMP_WAIT_POLICY=active -x OMP_PLACES=cores -x OMP_PROC_BIND=close -map-by ppr:$((np/16)):numa:pe=4 singularity exec --bind=$run_dir --pwd=$run_dir ${download_dir}/Benchmark24.0.0.sif xhpl
	
	#多节点
	if ! check_file "hostfile";then
		echo "==================hpl多节点测试:缺少hostfile文件，请在$JARVIS_ROOT下编写hostfile=================="
		return 1
	fi
	#\cp $JARVIS_ROOT/hostfile $run_dir
	node_num=`grep -v "^$"  $JARVIS_ROOT/hostfile | wc -l`
	mpirun --allow-run-as-root -np $((np*node_num/4)) -N $((np/4)) --hostfile $JARVIS_ROOT/hostfile -mca pml ucx -mca btl ^vader,tcp,openib -mca io romio321 -x UCX_TLS=self,sm,rc_x -x UCX_NET_DEVICES=mlx5_0:1 -x PATH -x LD_LIBRARY_PATH -x OMP_NUM_THREADS=4 -x OMP_WAIT_POLICY=active -x OMP_PLACES=cores -x OMP_PROC_BIND=close -map-by ppr:$((np/16)):numa:pe=4 singularity exec --bind=$run_dir --pwd=$run_dir  ${download_dir}/Benchmark24.0.0.sif xhpl
}

download
check
hpl_test
