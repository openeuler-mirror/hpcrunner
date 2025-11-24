#!/usr/bin/bash
WORK_PATH="$(dirname $(realpath ${BASH_SOURCE[0]}))"

function run_only()
{
	cd $WORK_PATH/source/cesm1_2_2/scripts/mycase
	sed -i '/mpirun/c mpirun --allow-run-as-root --map-by ppr:32:numa:pe=1 --bind-to core --mca btl ^openib,tcp,vader,uct -np 128 -x OMP_PROC_BIND=true -x UCX_TLS=rc,posix,sm,self   -mca pml ucx  numactl --localalloc $EXEROOT/cesm.exe >&! cesm.log.$LID' ./mycase.run
	ulimit -s unlimited
	free && sync && echo 3 > /proc/sys/vm/drop_caches && free
	echo "Case Run................"
	./mycase.run
}
	

#Main Function
function main()
{
    run_only
}

main $*

exit 0


