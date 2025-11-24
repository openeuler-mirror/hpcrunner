#!/bin/bash
#DSUB -n precise-exp
#DSUB --job_type cosched:hmpi
#DSUB -N 16
#DSUB -R "cpu=128"
#DSUB -A root.default
#DSUB -q root.default
#DSUB -o precise_%J.log
#DSUB -e precise_err_%J.log

echo " HOSTFILE generated:"
echo "-----------------------"
cat $CCS_HOST_FILE
echo "-----------------------"
mpif90 -o all_reduce_example allreduce-exp.F90
EXEC_CMD="mpirun $CCS_MPI_OPTIONS -x OMP_NUM_THREADS=1 --map-by ppr:16:node:pe=1 -x UCX_BUILTIN_ALLREDUCE_ALGORITHM=1 ./all_reduce_example"
date
echo "$EXEC_CMD"
$EXEC_CMD
ret=$?
date
exit $ret
