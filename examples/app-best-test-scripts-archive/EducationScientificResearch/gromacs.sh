#!/bin/bash

install_dir=/share/install/gromacs/
case_dir=/share/cases/
case_name=stmv.28M.tpr
log_file=${case_dir}/run_`date +%Y%m%d-%H%M%S`.log

hostfile=${case_dir}/hostfile
cat > "$hostfile" << EOF
localhost
EOF

nodes=`cat $hostfile |wc -l`
np=128
ppn=$(($np/$nodes))

load_path()
{
    module use /share/install/HPCKit/latest/modulefiles
    module load bisheng/compiler5.1.0.2/bishengmodule bisheng/hmpi26.0.RC1/release bisheng/kml26.0.RC1/kml
}
run()
{
    cd ${case_dir}
    load_path
    time -p mpirun --allow-run-as-root --hostfile ${hostfile} -np ${np} -N ${ppn} -x PATH -x LD_LIBRARY_PATH -mca pml ucx -mca btl ^vader,tcp,openib,uct -x UCX_TLS=self,sm ${install_dir}/bin/gmx_mpi mdrun -dlb yes -v -nsteps 5000 -pin on -ntomp 1 -nstlist 40 -npme 40 -resethway -s ${case_name} -g ${log_file}
}
run