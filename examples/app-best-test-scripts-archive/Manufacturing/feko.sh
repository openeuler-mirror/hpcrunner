#!/bin/bash

install_dir=/share/install/feko/altair
case_dir=/share/cases/
case_name="benchmark_Plane_MLFMM.fek"
log_file=${case_dir}/run_`date +%Y%m%d-%H%M%S`.log

hostfile=${case_dir}/hostfile
cat > "$hostfile" << EOF
localhost
EOF

nodes=`cat $hostfile |wc -l`
np_per_node=124
np=$(($nodes*$np_per_node))

run_flag=""
if [ x"$(arch)" == xaarch64 ];then 
    run_flag="exagear --"
fi

gen_hostlist()
{
    if [ ! x"$(arch)" == xaarch64 ];then 
        echo "[ERROR] please run on aarch64"
        exit 1
    fi
    if ! grep -q "FEKO" "/opt/exagear/etc/exagear.conf.d/feko.conf" 2>/dev/null; then
    cat > "/opt/exagear/etc/exagear.conf.d/feko.conf" << 'EOF'
if [ "$EXAGEAR_APP_NAME" == "FEKO" ];then
    EXAGEAR_USE_OPT="y"
    EXAGEAR_FAST_MATH="y"
fi
EOF
        while read -r host ; do
            [ -z "$host" ] && continue
            [ "$host" = "$(hostname -s)" ] && { continue; }
            scp /opt/exagear/etc/exagear.conf.d/feko.conf "$host":/opt/exagear/etc/exagear.conf.d/feko.conf 
        done < ${hostfile}
    fi
    
}
lic_check()
{
    lic_lines=$(lsof -i:6200 | wc -l)
    if [ ${lic_lines} -ne 5 ];then
        echo "feko's license server start failed. Exiting..."
        exit 2
    fi
}

run()
{
    gen_hostlist
    cd ${case_dir}
    export EXAGEAR_APP_NAME="FEKO"
    export ALTAIR_LICENSE_PATH=6200@`hostname`
    (time -p ${run_flag} ${install_dir}/feko/bin/runfeko ${case_name} --execute-prefeko --machines-file hostfile -np ${np} --mpi-options "-genv EXAGEAR_APP_NAME=FEKO -genv I_MPI_FABRICS=shm:ofi") 2>&1 |tee ${log_file}
}
lic_check
run