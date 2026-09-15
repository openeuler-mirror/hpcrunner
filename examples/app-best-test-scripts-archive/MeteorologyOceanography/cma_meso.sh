#!/bin/bash

install_dir=/share/install/grapes_model/
case_dir=/share/cases/
log_file=${case_dir}/run_`date +%Y%m%d-%H%M%S`.log

hostfile=${case_dir}/hostfile
cat > "$hostfile" << EOF
localhost
EOF

nodes=`cat $hostfile |wc -l`
npx=6
npy=20    #npx*npy=总进程数
np=$(($npx*$npy))
ppn=$(($np/$nodes))
steps=240

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
    sed -i 's/time_step_max = .*,/time_step_max = '${steps}',/' ./namelist.input
    sed -i 's/nproc_x = .*,/nproc_x = '${npx}',/' ./namelist.input
    sed -i 's/nproc_y = .*,/nproc_y = '${npy}',/' ./namelist.input
    (time -p mpirun --allow-run-as-root --hostfile ${hostfile} -np ${np} -N ${ppn} --map-by socket --rank-by core --bind-to core -mca io romio321 -mca pml ucx -mca btl ^vader,tcp,openib,uct -x UCX_TLS=self,sm,ud -mca coll ^ucg -x PATH -x LD_LIBRARY_PATH ./grapes.exe ) 2>&1 |tee ${log_file}
}
run