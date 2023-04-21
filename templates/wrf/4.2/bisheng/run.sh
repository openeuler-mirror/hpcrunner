#!/bin/sh
#DSUB -n wrf_test
#DSUB --job_type cosched:hmpi
#DSUB -A root.default
#DSUB -q root.default
#DSUB -N 1
#DSUB -R cpu=128
#DSUB -oo wrf.%J.out
#DSUB -eo wrf.%J.err

##set runtime environment variables

ulimit -s unlimited
ulimit -c unlimited
rm -rf rsl.*
echo "----HOSTFILE generated---"
cat $CCS_HOST_FILE
echo "-------------------------"
EXEC_CMD="time -p mpirun $CCS_MPI_OPTIONS -n 32 -x OMP_NUM_THREADS=1 -x UCX_NET_DEVICES=mlx5_0:1 -mca io romio321 -mca pml ucx -mca btl ^vader,tcp,openib,uct -x UCX_TLS=self,sm,rc -bind-to core -x PATH -x LD_LIBRARY_PATH $WRF_DIR/run/wrf.exe"
echo "$EXEC_CMD"
date
$EXEC_CMD
date