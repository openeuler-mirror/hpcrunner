#!/bin/bash

install_dir=/share/install/lammps/
case_dir=/share/cases/
case_name=equ.in
log_file=${case_dir}/run_`date +%Y%m%d-%H%M%S`.log

hostfile=${case_dir}/hostfile
cat > "$hostfile" << EOF
localhost
EOF

nodes=`cat $hostfile |wc -l`
np=124
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
    (time -p mpirun --allow-run-as-root --hostfile ${hostfile} -np ${np} -N ${ppn} -x PATH -x LD_LIBRARY_PATH -mca pml ucx -mca btl ^vader,tcp,openib,uct -x UCX_TLS=self,sm --bind-to core --map-by socket --rank-by core ${install_dir}/bin/lmp_omp -in ${case_name} ) 2>&1 |tee ${log_file}
}
run