#!/bin/bash

install_dir=/share/install/ansysem
case_dir=/share/cases/
case_name="test.aedt"
log_file=${case_dir}/run_`date +%Y%m%d-%H%M%S`.log
np=124

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
    if ! grep -q "HFSS" "/opt/exagear/etc/exagear.conf.d/hfss.conf" 2>/dev/null; then
    cat > "/opt/exagear/etc/exagear.conf.d/hfss.conf" << 'EOF'
if [ "$EXAGEAR_APP_NAME" == "HFSS" ];then
    EXAGEAR_USE_OPT="y"
    EXAGEAR_FAST_MATH="y"
fi
EOF
    fi
}
lic_start()
{
    lic_lines=$(lsof -i:1055 | wc -l)
    if [ ${lic_lines} -ne 5 ];then
        echo "HFSS's license not found. Starting license server..."
        ${run_flag} ${install_dir}/shared_files/licensing/linx64/lmgrd -c ${install_dir}/shared_files/licensing/license_files/ansyslmd.lic -l ${install_dir}/lmgrd.log
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
    export EXAGEAR_APP_NAME="HFSS"
    export ANSYSLMD_LICENSE_FILE=1055@`hostname`
    (time -p ${run_flag} ${install_dir}/v241/Linux64/ansysedt -ng -monitor -distributed -machinelist list='$(hostname):${np}' -BatchSolve '${case_name}') 2>&1 |tee ${log_file}
}
lic_start
run