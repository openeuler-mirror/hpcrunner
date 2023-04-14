#!/bin/sh
#DSUB -n gromacs_job
#DSUB -A default
#DSUB -N 1
#DSUB -R cpu=128;gpu=1
#DSUB --job_type cosched
#DSUB -oo out_%J.log
#DSUB -eo err_%J.log

ddd=`date "+%Y-%m-%d-%H:%M:%S"`

cat $CCSCHEDULER_ALLOC_FILE |awk '{print $1}'|awk NF > hostfile
export CUDA_VISIBLE_DEVICES=0
$JARVIS_ROOT/gromacs/bin/gmx mdrun -dlb yes -pin on -pinoffset 0 -pinstride 1  -ntmpi 1 -ntomp 64 -v -nsteps 100000  -resetstep 80000 -noconfout -nb gpu -nstlist 400 -s ./topol.tpr
