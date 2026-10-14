#!/bin/bash

install_dir=/share/install/swan/
case_dir=/share/cases/
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
    export HDF5=/share/install/hdf5
    export PNETCDF=/share/install/pnetcdf
    export NETCDF=/share/install/netcdf
    export PATH=${HDF5}/bin:${PNETCDF}/bin:${NETCDF}/bin:${PATH}
    export LD_LIBRARY_PATH=${HDF5}/lib:${PNETCDF}/lib:${NETCDF}/lib:${LD_LIBRARY_PATH}
}
run()
{
    cd ${case_dir}
    load_path
    (time -p mpirun --allow-run-as-root --hostfile ${hostfile} -np ${np} -N ${ppn} -mca io romio321 -mca pml ucx -mca btl ^vader,tcp,openib,uct -x UCX_TLS=self,sm,ud -x PATH -x LD_LIBRARY_PATH ./swan.exe ) 2>&1 |tee ${log_file}
}
run