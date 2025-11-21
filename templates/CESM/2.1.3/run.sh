#!/bin/bash
#DSUB -n cesm-1n
#DSUB --job_type cosched
#DSUB -N 1
#DSUB -R "cpu=128;mem=512000"
#DSUB -A root.migration
#DSUB -q root.default
#DSUB -o cesm_%J.log
#DSUB -e cesm_err_%J.log

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
ntask=`cat ${CCSCHEDULER_ALLOC_FILE} | sort | awk -v fff="$HOSTFILE" '{}
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

date
echo $LD_LIBRARY_PATH
cd $case_name
./case.submit
date
exit 0
