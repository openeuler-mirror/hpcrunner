#!/bin/bash

lic_file=/share/install/license/license.dat
install_dir=/share/install/18.04.009-R8
case_dir=/share/cases/
case_name="3-1-TutorialGuideSets.sim"
log_file=${case_dir}/run_`date +%Y%m%d-%H%M%S`.log

hostfile=${case_dir}/hostfile
cat > "$hostfile" << EOF
localhost
EOF

nodes=`cat $hostfile |wc -l`
np_per_node=120
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
    if ! grep -q "STARCCM" "/opt/exagear/etc/exagear.conf.d/starccm.conf" 2>/dev/null; then
    cat > "/opt/exagear/etc/exagear.conf.d/starccm.conf" << 'EOF'
if [ "$EXAGEAR_APP_NAME" == "STARCCM" ];then
    EXAGEAR_USE_OPT="y"
    EXAGEAR_FAST_MATH="y"
fi
EOF
        while read -r host ; do
            [ -z "$host" ] && continue
            [ "$host" = "$(hostname -s)" ] && { continue; }
            scp /opt/exagear/etc/exagear.conf.d/starccm.conf "$host":/opt/exagear/etc/exagear.conf.d/starccm.conf 
        done < ${hostfile}
    fi
    
}

run()
{
    gen_hostlist
    cd ${case_dir}
    export EXAGEAR_APP_NAME="STARCCM"
    #( time -p ${run_flag} ${install_dir}/STAR-CCM+18.04.009-R8/star/bin/starccm+ -licpath ${lic_file} -batch -time -pio -np ${np} -on ${hostlist} -mpi openmpi4 -mpiflags "--allow-run-as-root -mca pml ucx -bind-to core -rank-by core -x EXAGEAR_APP_NAME" -rsh ssh ${case_dir}/${case_name} ) 2>&1 |tee ${log_file}
    ( time -p ${run_flag} ${install_dir}/STAR-CCM+18.04.009-R8/star/bin/starccm+ -licpath ${lic_file} -batch -time -pio -np ${np} -on ${hostlist} -mpi intel -mpiflags "-genv I_MPI_PIN 1 -genv I_MPI_PIN_DOMAIN core -genv UCX_TLS sm,self,rc -genv EXAGEAR_APP_NAME STARCCM" -rsh ssh ${case_dir}/${case_name} ) 2>&1 |tee ${log_file}
}

run