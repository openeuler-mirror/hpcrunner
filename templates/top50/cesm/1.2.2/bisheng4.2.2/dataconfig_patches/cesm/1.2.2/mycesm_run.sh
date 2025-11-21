#!/usr/bin/bash
WORK_PATH="$(dirname $(realpath ${BASH_SOURCE[0]}))"

function run_only()
{
	cd $WORK_PATH/source/cesm1_2_2/scripts/mycase
	sed -i 's/iradsw = 2/iradsw = 3/' user_nl_cam
        sed -i 's/iradlw = 2/iradlw = 3/' user_nl_cam
	sed -i '/mpirun/c mpirun --allow-run-as-root --map-by ppr:37:numa:pe=1 --bind-to core --mca btl ^openib -np 592 -x OMP_PROC_BIND=true -x UCX_TLS=rc,posix -x UCX_BCOPY_THRESH=8K -x UCX_RNDV_THRESH=16K -x UCX_RNDV_SEND_NBR_THRESH=64K -x UCX_MAX_RNDV_RAILS=2 -x UCX_MIN_RNDV_CHUNK_SIZE=32K -x UCX_RNDV_SCHEME=get_zcopy -x UCX_RKEY_PTR_SEG_SIZE=512K -x UCX_TIMEOUT_DETECT_ENABLE=n -x UCX_SEG_SIZE=16K -x UCX_IB_GPU_DIRECT_RDMA=no -x UCX_RC_VERBS_SEG_SIZE=8256 -x UCX_RC_VERBS_TX_MAX_BATCH=4 -x UCX_RC_VERBS_TX_MAX_POLL=32 -x UCX_RC_VERBS_RX_MAX_BATCH=8 -x UCX_RC_VERBS_RX_MAX_POLL=4 -x UCX_RC_VERBS_RX_INLINE=128 -x UCX_RC_VERBS_PATH_MTU=2048 -x UCX_RC_VERBS_TX_CQ_MODERATION=128 -x UCX_ZCOPY_THRESH=16K -x UCX_USE_MT_MUTEX=n -x UCX_IB_RCACHE_ADDR_ALIGN=128 -x UCX_IB_REG_MT_THRESH=4G numactl --localalloc $EXEROOT/cesm.exe >&! cesm.log.$LID' ./mycase.run
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


