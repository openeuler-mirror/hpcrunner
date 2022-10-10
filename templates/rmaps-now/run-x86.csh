#!/bin/csh -f
	set install_dir = /v2020
  setenv RUNDIR /NOW3km-040300

  set echo
	
	set ln_name = vdras.inst-3km.start-2022-09-04_03:00:00_UTC.exe
  limit stacksize unlimited

  setenv EXEDIR  $install_dir
  set output_dir = $RUNDIR/output
  set input_dir = $RUNDIR/input

  cd $RUNDIR

  rm -f core* fort.*
  rm -f std.*  
  rm -f new_start_time
  mv -f namelist.input namelist.input.old
#########################################################
sed -i 's/\(.*#\).*/\1/g' namelist.input
sed -i 's/#//g' namelist.input
sed -i 's/\(.*\!\).*/\1/g' namelist.input
sed -i 's/\!//g' namelist.input
sed -i 's/[ \t]*$//g' namelist.input
sed -i '/^$/d' namelist.input

#########################################################
#
# Run the program.
#
#########################################################

  ln -sf $EXEDIR/base_data/vcp.* ./
  ln -sf $EXEDIR/base_data/psadilookup.dat ./
  ln -sf $EXEDIR/base_data/pblh.dat ./
  ln -sf $EXEDIR/base_data/pblh2.dat ./
  ln -sf $EXEDIR/main/rmapsnow-all.exe ./${ln_name}

###########################################################
# use dsub to run 

cat > run.sh << \EOF
#!/bin/bash
#DSUB -n rmapsnow
#DSUB --job_type cosched
#DSUB -N 2
#DSUB -R "cpu=100;mem=320000"
#DSUB -A XXX
#DSUB -q root.default
#DSUB -o rmapsnow-2020_%J.log
#DSUB -e rmapsnow-2020_err_%J.log
#DSUB -l XXX

if [ "${CCSCHEDULER_ALLOC_FILE}" != "" ]; then
    echo "   "
    ls -la ${CCSCHEDULER_ALLOC_FILE}
    echo ------ cat ${CCSCHEDULER_ALLOC_FILE}
    cat ${CCSCHEDULER_ALLOC_FILE}
fi

export HOSTFILE=/tmp/hostfile.$$
rm -rf $HOSTFILE
touch $HOSTFILE
#        print a[1]" slots="a[3] >> fff
ntask=`cat ${CCSCHEDULER_ALLOC_FILE} | awk -v fff="$HOSTFILE" '{}
{
    split($0, a, " ")
    if (length(a[1]) >0 && length(a[3]) >0) {
        print a[1]":"a[2]>> fff
        total_task+=a[3]
    }
}END{print total_task}'`
rm -rf rmapsnow*
rm -rf nc.vg.*
export OMP_NUM_THREADS=1
ulimit -n 1000000
ulimit -s unlimited
echo 3 > /proc/sys/vm/drop_caches
date
#mpirun -hostfile $HOSTFILE -ppn 100 -launcher ssh -launcher-exec /opt/batch/agent/tools/dstart valgrind --leak-check=full --track-origins=yes --log-file=nc.vg.%p ./vdras.inst-3km.start-2022-09-04_03:00:00_UTC.exe
mpirun -hostfile $HOSTFILE -ppn 100 -launcher ssh -launcher-exec /opt/batch/agent/tools/dstart ./vdras.inst-3km.start-2022-09-04_03:00:00_UTC.exe

date
\EOF

dsub -s run.sh
#####################END###END###END#####################