#!/bin/bash
module load bisheng/compiler4.2.0/bishengmodule 
module load bisheng/hmpi25.0.0/hmpi
module load bisheng/kml25.0.0/kml
module load bisheng/kml25.0.0/kblas/multi
ulimit -s unlimited

export LD_LIBRARY_PATH=${HPCKIT_KML}/bisheng/lib/neon/kblas/multi:${HPCKIT_KML}/bisheng/lib/noarch:${HPCKIT_KML}/bisheng/lib/neon::$LD_LIBRARY_PATH
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

CESM_VER=2.2.2
CORE_LIMIT=128

CESM_2_2_2_ROOT=$(realpath ..)
echo "CESM_2_2_2_ROOT:$CESM_2_2_2_ROOT"

export CESM_2_2_2_CASE_DIR=${CESM_2_2_2_ROOT}/cesm${CESM_VER}/CESM/mycase_tr_$CORE_LIMIT
export TEST_DIR_SCRATCH_DIR=${CESM_2_2_2_ROOT}/cesm${CESM_VER}/scratch/mycase_tr_$CORE_LIMIT
export CESM_2_2_2_CASE_INPUTDATA=${CESM_2_2_2_ROOT}/F09_G17_B1850/inputdata


export CAES_ROOT=${CESM_2_2_2_CASE_DIR}

cd ${CAES_ROOT}

#rm -rf ${CAES_ROOT}/timing/cesm_timing.mycase_tr_128.*
if true; then
# here CESM_2_2_2_CASE_INPUTDATA data is full and complete, so no need for check_input_data again	
#./check_input_data --download -i ${CESM_2_2_2_CASE_INPUTDATA}

./preview_run --debug --verbose

./case.submit
fi

FN=$(ls ${CAES_ROOT}/timing/cesm_timing.mycase_tr_128.* 2>/dev/null | sort | tail -1)
echo "FN:${FN}"
### Overall Metrics samples
: << 'COMMENT'
  Overall Metrics: 
    Model Cost:            1253.64   pe-hrs/simulated_year 
    Model Throughput:         2.45   simulated_years/day 

    Init Time   :      50.650 seconds 
    Run Time    :    1352.390 seconds       96.599 seconds/day 
    Final Time  :       0.010 seconds 

    Actual Ocn Init Wait Time     :       0.078 seconds 
    Estimated Ocn Init Run Time   :      10.014 seconds 
    Estimated Run Time Correction :       9.936 seconds 
      (This correction has been applied to the ocean and total run times)
COMMENT
echo "LOGFILE:${FN}"
[ "ABBA" != "AB${FN}BA" ] && [ -f ${FN} ] &&  grep -A 30 -B 10 "Overall Metrics" ${FN}


