#!/bin/sh
#===========================================================
#配置DSUB资源
#===========================================================
#DSUB --job_type cosched
#DSUB -n roms_2n
#DSUB -A root.default
#DSUB -q root.default
#DSUB -R cpu=128
#DSUB -N 4
#DSUB -oo log/out_%J.log
#DSUB -eo log/err_%J.log

#===========================================================
#获得hostfile
#===========================================================
if [ "${CCS_ALLOC_FILE}" != "" ]; then
    cat ${CCS_ALLOC_FILE}
fi

export HOSTFILE=/tmp/hostfile.$$
rm -rf $HOSTFILE
touch $HOSTFILE

ntask=`cat ${CCS_ALLOC_FILE} | awk -v fff="$HOSTFILE" '{}
{
    split($0, a, " ")
    if (length(a[1]) >0 && length(a[3]) >0) {
        print a[1]" slots="a[2] >> fff
        total_task+=a[3]
    }
}END{print total_task}'`

echo "HOSTFILE: $HOSTFILE generated:"
cat $HOSTFILE
echo "-----------------------"
echo "Total tasks is $ntask"
#===========================================================
#运行测试脚本
#===========================================================

mpirun -hostfile $HOSTFILE --mca plm_rsh_agent /opt/batch/agent/tools/dstart -mca pml ucx -x UCX_NET_DEVICES=mlx5_0:1 -mca btl ^vader,tcp,openib,uct -x UCX_TLS=self,sm,rc -x PATH -x LD_LIBRARY_PATH --bind-to numa -x OMP_NUM_THREADS=1 -np 256 -N 64 ./romsM ocean_cold_start.in