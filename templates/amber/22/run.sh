#!/bin/sh
#DSUB -n Amber22_JAC_NPT_4fs
#DSUB -A default
#DSUB -N 1
#DSUB -R cpu=128;gpu=1
#DSUB --job_type cosched
#DSUB -oo out_%J.log
#DSUB -eo err_%J.log

time -p $JARVIS_ROOT/amber22/bin/pmemd.cuda -O -i mdinOPT.GPU -o mdout -p ../Topologies/JAC.prmtop -c ../Coordinates/JAC.inpcrd
cat mdout
