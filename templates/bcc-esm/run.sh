#!/bin/bash
#DSUB -n esm-29n
#DSUB --job_type cosched
#DSUB -N 29
#DSUB -R "cpu=128;mem=256000"
#DSUB -A root.default
#DSUB -q root.default
#DSUB -o esm_%J.log
#DSUB -e esm_err_%J.log

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
tmpfs=$HOSTFILE.1
ntask=`cat ${CCSCHEDULER_ALLOC_FILE} | sort | awk -v fff="$HOSTFILE" '{}
{
        split($0, a, " ")
        if (length(a[1]) >0 && length(a[3]) >0) {
                print a[1]" slots="a[2] >> fff
                total_task+=a[2]
        }
}END{print total_task}'`
head -n 28 $HOSTFILE > $tmpfs
sed -i 's/128/96/' $tmpfs
tail -n 1 $HOSTFILE >> $tmpfs
sed -i 's/128/24/' $tmpfs
mv $tmpfs $HOSTFILE
echo "openmpi hostfile $HOSTFILE generated:"
echo "-----------------------"
cat $HOSTFILE
echo "-----------------------"
echo "Total tasks is $ntask"
echo "mpirun -hostfile $HOSTFILE -n $ntask <your application>"
sed -i "15c             layout =20,10," ocn/input.nml
#generate run_roce.sh
cat <<\EOF > run_roce.sh 
#!/bin/bash
rank=$OMPI_COMM_WORLD_RANK

idx=$(expr $rank % 32 / 8)
#           atm  lnd  ice  ocn cpl
NTASKS=(   2304  96  96   200  16 )
NTHRDS=(   1    1   1     1     1  )

lnd_proc=`expr ${NTASKS[0]} + ${NTASKS[1]}`
ice_proc=`expr $lnd_proc + ${NTASKS[2]}`
ocn_proc=`expr $ice_proc + ${NTASKS[3]}`
cpl_proc=`expr $ocn_proc + ${NTASKS[4]}`
if [ $rank -lt ${NTASKS[0]} ]; then
        echo '-----atm------'$rank
        export OMP_NUM_THREADS=${NTHRDS[0]}
        $EXEROOT/atm/atm
elif [ $rank -lt $lnd_proc ]; then
        echo '-----lnd------'$rank
        export OMP_NUM_THREADS=${NTHRDS[1]}
        $EXEROOT/lnd/lnd
elif [ $rank -lt $ice_proc ]; then
        echo '-----ice------'$rank
        export OMP_NUM_THREADS=${NTHRDS[2]}
        $EXEROOT/ice/ice
elif [ $rank -lt $ocn_proc ]; then
        echo '-----ocn------'$rank
        export OMP_NUM_THREADS=${NTHRDS[3]}
        $EXEROOT/ocn/ocn
elif [ $rank -lt $cpl_proc ]; then
        echo '-----cpl------'$rank
        export OMP_NUM_THREADS=${NTHRDS[4]}
        echo "thread distribution --${NTHRDS[0]}, ${NTHRDS[1]},${NTHRDS[2]}"
        echo "rank distribution --$lnd_proc, $ice_proc,$ocn_proc"
        $EXEROOT/cpl/cpl
fi

EOF
chmod +x run_roce.sh
date
mpirun --allow-run-as-root --mca plm_rsh_agent /opt/batch/agent/tools/dstart -mca btl ^vader,tcp,openib,uct -mca coll ^ucx -x UCX_BUILTIN_ALLREDUCE_ALGORITHM=6 -x UCX_BUILTIN_ALLTOALLV_ALGORITHM=1 -hostfile $HOSTFILE -np 2712 -x LD_LIBRARY_PATH -x PATH -x OMP_WAIT_POLICY=ACTIVE --bind-to socket run_roce.sh
date
exit 0
