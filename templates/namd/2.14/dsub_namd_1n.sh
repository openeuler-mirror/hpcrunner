#!/bin/bash
#DSUB -n namd_1n_2card
#DSUB --job_type cosched
#DSUB -N 1
#DSUB -R "cpu=128;mem=256000;gpu=2"
#DSUB -A root.default
#DSUB -q root.default
#DSUB -o namd_%J.log
#DSUB -e namd_err_%J.log


echo ----- print env vars -----
if [ "${CCSCHEDULER_ALLOC_FILE}" != "" ]; then
	echo " "
	ls -la ${CCSCHEDULER_ALLOC_FILE}
	echo ------ cat ${CCSCHEDULER_ALLOC_FILE}
	cat ${CCSCHEDULER_ALLOC_FILE}
fi

export HOSTFILE=/tmp/hostfile.$$
rm -rf $HOSTFILE
touch $HOSTFILE

ntask=`cat ${CCSCHEDULER_ALLOC_FILE} | awk -v fff="$HOSTFILE" '{}
{
	split($0, a, " ")
	if (length(a[1]) >0 && length(a[3]) >0) {
		print a[1]" slots="a[2] >> fff
		total_task+=a[2]
	}
}END{print total_task}'`

echo "openmpi hostfile $HOSTFILE generated:"
echo "-----------------------"
cat $HOSTFILE
echo "-----------------------"
echo "Total tasks is $ntask"
echo "mpirun -hostfile $HOSTFILE -n $ntask <your application>"
ulimit -s unlimited

$JARVIS_ROOT/NAMD_2.14_Source/Linux-ARM64-g++/namd2 +p126 +setcpuaffinity +maffinity +isomalloc_sync +devices 0,1 stmv_nve_cuda.namd 2>&1 | tee namd.log && python2 $JARVIS_ROOT/templates/namd/2.14/ns_per_day.py namd.log
ret=$?

rm -rf $HOSTFILE
exit $ret
