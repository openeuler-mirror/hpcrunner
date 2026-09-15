#!/bin/bash

install_dir=/share/install/ansys
case_dir=/share/cases/
case_name="aircraft.jou"
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
    while read LINE
    do
       array=(${LINE//././})
       if [ -n "${array[0]}" ]; then
          hostlist=$hostlist${array[0]}:${np_per_node},
       fi
    done < ${hostfile}
    hostlist=${hostlist%?}
    if ! grep -q "FLUENT" "/opt/exagear/etc/exagear.conf.d/fluent.conf" 2>/dev/null; then
    cat > "/opt/exagear/etc/exagear.conf.d/fluent.conf" << 'EOF'
if [ "$EXAGEAR_APP_NAME" == "FLUENT" ];then
    EXAGEAR_USE_OPT="y"
    EXAGEAR_FAST_MATH="y"
fi
EOF
        while read -r host ; do
            [ -z "$host" ] && continue
            [ "$host" = "$(hostname -s)" ] && { continue; }
            scp /opt/exagear/etc/exagear.conf.d/fluent.conf "$host":/opt/exagear/etc/exagear.conf.d/fluent.conf 
        done < ${hostfile}
    fi
    
}
lic_start()
{
    lic_lines=$(lsof -i:1055 | wc -l)
    if [ ${lic_lines} -ne 5 ];then
        echo "ANSYS's license not found. Starting license server..."
        ${run_flag} ${install_dir}/shared_files/licensing/linx64/lmgrd -c ${install_dir}/license.txt -l ${install_dir}/shared_files/licensing/linx64/lmgrd.log
    fi
    sleep 10
    lic_lines=$(lsof -i:1055 | wc -l)
    if [ ${lic_lines} -ne 5 ];then
        echo "ANSYS's license server start failed. Exiting..."
        exit 2
    fi
}

run()
{
    gen_hostlist
    cd ${case_dir}
    export EXAGEAR_APP_NAME="FLUENT"
    export ANSYSLMD_LICENSE_FILE=1055@`hostname`
    (time -p ${run_flag} ${install_dir}/v241/fluent/bin/fluent 3d -g -t${np} -cnf=${hostlist} -tm4 -mpi=intel -mpiopt="-genv EXAGEAR_APP_NAME=FLUENT -genv UCX_TLS=self,sm -genv I_MPI_FABRICS=shm:ofi" -i ${case_dir}/${case_name}) 2>&1 |tee ${log_file}
}
lic_start
run