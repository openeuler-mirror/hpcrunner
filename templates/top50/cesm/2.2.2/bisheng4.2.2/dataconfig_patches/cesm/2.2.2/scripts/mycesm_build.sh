#!/bin/bash


set -x
export I_MPI_COMPATIBILITY=4

export NETCDF=${NETCDF_PATH}
echo "NETCDF:${NETCDF}"
export NETCDF_FORTRAN_PATH=${NETCDF}
export LD_LIBRARY_PATH=${NETCDF}/lib:$LD_LIBRARY_PATH

export CMAKE_C_COMPILER=mpicc
export CMAKE_CXX_COMPILER=mpicxx
export CMAKE_FORTRAN_COMPILER=mpifort

export CC=mpicc
export FC=mpifort
export CXX=mpicxx

OPENBLAS_PATH=${OPENBLAS_CLANG_PATH}
export LD_LIBRARY_PATH=${OPENBLAS_PATH}/lib:$LD_LIBRARY_PATH

HDF5_PATH=$HDF5_CLANG_PATH

export LIB_HDF5=${HDF5_CLANG_PATH}/lib
export INC_HDF5=${HDF5_CLANG_PATH}/include
export LD_LIBRARY_PATH=${HDF5_PATH}/lib:$LD_LIBRARY_PATH

export LIB_ZLIB=${ZLIB_PATH}/lib
export LD_LIBRARY_PATH=${ZLIB_PATH}/lib/:$LD_LIBRARY_PATH


export PNETCDF_PATH=${PNETCDF_CLANG_PATH}
export LIB_PNETCDF=${PNETCDF_PATH}/lib
export INC_PNETCDF=${PNETCDF_PATH}/include

export LD_LIBRARY_PATH=${LIB_PNETCDF}:$LD_LIBRARY_PATH


export LD_LIBRARY_PATH=${HPCKIT_KML}/bisheng/lib/neon/kblas/multi:${HPCKIT_KML}/bisheng/lib/noarch:${HPCKIT_KML}/bisheng/lib/neon::$LD_LIBRARY_PATH

rm -f tmp_env.sh
echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" >> tmp_env.sh


export SMP=FALSE
CESM_VER=2.2.2
CORE_LIMIT=128


CESM_VER=2.2.2
CORE_LIMIT=608


CESM_2_2_2_ROOT=$(realpath ..)
echo "CESM_2_2_2_ROOT:$CESM_2_2_2_ROOT"
# ${CESM_2_2_2_ROOT}
BUILD_TMP=/tmp/build-cesm${CESM_VER}
if [ ! -d $BUILD_TMP ]; then
    mkdir $BUILD_TMP
fi


# mkdir /tmp/test_cesm_$CESM_VER
# ${CESM_2_2_2_ROOT}
TEST_DIR=/tmp/test_cesm_${CESM_VER}

if [ ! -d ${TEST_DIR} ]; then
    mkdir ${TEST_DIR}
fi


export CESM_2_2_2_CASE_DIR=${CESM_2_2_2_ROOT}/cesm${CESM_VER}/CESM/mycase_tr_$CORE_LIMIT
export TEST_DIR_SCRATCH_DIR=${TEST_DIR}/cesm${CESM_VER}/scratch/mycase_tr_$CORE_LIMIT
export CESM_2_2_2_CASE_INPUTDATA=/tmp/F09_G17_B1850/inputdata
mkdir -p /tmp/F09_G17_B1850
cp ${CESM_2_2_2_ROOT}/F09_G17_B1850/inputdata /tmp/F09_G17_B1850/ -ar

echo "HPCKIT_BASEDIR:${HPCKIT_BASEDIR}"
echo "KREG_MODULES_MODS:${KREG_MODULES_MODS}"
CESM_2_2_2_CODE_ROOT=$BUILD_TMP/CESM-opt-cesm${CESM_VER}

rm -rf ${CESM_2_2_2_CODE_ROOT}
cp -rf ${CESM_2_2_2_ROOT}/source/my_cesm_sandbox ${CESM_2_2_2_CODE_ROOT}

cd ${CESM_2_2_2_CODE_ROOT}/cime/config/cesm/machines
#修改config_machines.xml
if [ ! -f "config_machines.xml.backup" ]; then
    cp config_machines.xml config_machines.xml.backup
else
    echo y | cp config_machines.xml.backup config_machines.xml
fi

sed -i '303s|.*|    <NODENAME_REGEX>N0</NODENAME_REGEX>|' config_machines.xml
sed -i '306s|.*|    <COMPILERS>gnu</COMPILERS>|' config_machines.xml
sed -i '307s|.*|    <MPILIBS>openmpi</MPILIBS>|' config_machines.xml
sed -i "310,315s|\$ENV{HOME}|$TEST_DIR|g" config_machines.xml

echo "HPCKIT_BASEDIR:${HPCKIT_BASEDIR}"
echo "KREG_MODULES_MODS:${KREG_MODULES_MODS}"
[ "ABBA" == "AB${HPCKIT_BASEDIR}BA" ] && exit 1
[ "ABBA" == "AB${KREG_MODULES_MODS}BA" ] && exit 1

module_line1="        <command name=\"use\">${HPCKIT_BASEDIR}/modulefiles ${KREG_MODULES_MODS}</command>"
module_line2="        <command name=\"load\">bisheng/compiler4.2.0.2/bishengmodule  bisheng/kml25.1.0.SPC001/kml bisheng/kml25.1.0.SPC001/kblas/multi</command>" # comp/bisheng/4.1.0
module_line3="        <command name=\"load\">bisheng/%#MYKMPIVER#%/release zlib/1.2.11-%#MYKBSVER#% szip/2.1.1-%#MYKBSVER#% hdf5-clang/1.12.3-%#MYKBSVER#%-%#MYKMPIVER#% pnetcdf-clang/1.14.0-%#MYKBSVER#%-%#MYKMPIVER#% netcdf-clang/4.9.1-%#MYKBSVER#%-%#MYKMPIVER#%-hdf51.12.3-pnetcdf1.14.0</command>"              # mpi/hmpi/2.4.2-bisheng4.1.0
sed -i '339a\
'"$module_line1"'\n'"$module_line2"'\n'"$module_line3"'
' config_machines.xml

echo "$(pwd)"

env_line1="      <env name=\"NETCDF_PATH\">${NETCDF}</env>"
env_line2="      <env name=\"NETCDF_FORTRAN_PATH\">${NETCDF}</env>"
env_line3="      <env name=\"NETCDF_C_PATH\">${NETCDF}</env>"
env_line4="      <env name=\"MPI_PATH\">${HPCKIT_HMPI}/bisheng/release/hmpi</env>"
env_line5="      <env name=\"SMP\">\"FALSE\"</env>"
sed -i '351a\
'"$env_line1"'\n'"$env_line2"'\n'"$env_line3"'\n'"$env_line4"'\n'"$env_line5"'
' config_machines.xml

export LD_LIBRARY_PATH=${HPCKIT_HMPI}/bisheng/release/hmpi/lib:$LD_LIBRARY_PATH

sed -i "317s|8|128|g" config_machines.xml

sed -i "320s|8|$CORE_LIMIT|g" config_machines.xml
sed -i "321s|8|$CORE_LIMIT|g" config_machines.xml
sed -i "324s|mpiexec|mpirun|g" config_machines.xml

sed -i "326s|.*|        <arg name=\"ntasks\"> --allow-run-as-root  -np {{ total_tasks }} --bind-to core --map-by ppr:37:numa:1 --rank-by core -x UCX_TLS=self,sm -x UCX_BCOPY_THRESH=8K -x UCX_RNDV_THRESH=16K -x UCX_RNDV_SEND_NBR_THRESH=64K -x UCX_MAX_RNDV_RAILS=2 -x UCX_MIN_RNDV_CHUNK_SIZE=32K -x UCX_RNDV_SCHEME=get_zcopy -x UCX_RKEY_PTR_SEG_SIZE=512K -x UCX_TIMEOUT_DETECT_ENABLE=n -x UCX_SEG_SIZE=16K -x UCX_IB_GPU_DIRECT_RDMA=no -x UCX_RC_VERBS_SEG_SIZE=8256 -x UCX_RC_VERBS_TX_MAX_BATCH=4 -x UCX_RC_VERBS_TX_MAX_POLL=32 -x UCX_RC_VERBS_RX_MAX_BATCH=8 -x UCX_RC_VERBS_RX_MAX_POLL=4 -x UCX_RC_VERBS_RX_INLINE=128 -x UCX_RC_VERBS_PATH_MTU=2048 -x UCX_RC_VERBS_TX_CQ_MODERATION=128 -x UCX_ZCOPY_THRESH=16K -x UCX_USE_MT_MUTEX=n -x UCX_IB_RCACHE_ADDR_ALIGN=128 -x UCX_IB_REG_MT_THRESH=4G -mca io romio321 -mca orte_allowed_exit_without_sync 1 -mca orte_create_session_dirs 1 -x UCX_RNDV_THRESH=8192 -mca coll_ucg_max_rcache_size 1024 -x UCG_PLANC_UCX_ALLTOALLV_DEFAULT_POLICY=n -x UCG_PLANC_UCX_ALLGATHERV_DEFAULT_POLICY=n -x UCG_PLANC_STARS_IB_ODP_NUMA_POLICY=prefered -x UCG_PLANC_ALLTOALLV_ALGO_SELECT=y -x UCX_REQ_TIMEOUT=30s -x UCX_RC_VERBS_ROCE_LOCAL_SUBNET=y -x UCX_UD_VERBS_ROCE_LOCAL_SUBNET=y --bind-to core numactl --localalloc </arg>|" config_machines.xml

#修改config_compilers.xml
if [ ! -f "config_compilers.xml.backup" ]; then
    cp config_compilers.xml config_compilers.xml.backup
else
    echo y | cp config_compilers.xml.backup config_compilers.xml
fi

sed -i "187s|.*|    <base>  -O3 -ffast-math -mcpu=hip11 -mcmodel=small -dynamic -std=gnu99 -finit-zero -ftrivial-auto-var-init=zero </base>|" config_compilers.xml
sed -i "203s|.*|    <base>  -O3 -ffast-math -fstack-arrays -mcpu=hip11 -mcmodel=small -fGNU-compatibility -fIntel-compatibility -ff2c -fconvert=big-endian -finit-zero -ftrivial-auto-var-init=zero -ffixed-line-length-none -I${NETCDF_PATH}/include -I${INC_HDF5} -I${PNETCDF_PATH}/include  -I${NETCDF_FORTRAN_PATH}/include -lstdc++ -lc -lnetcdff -lnetcdf -lpnetcdf -fno-openmp -I${INC_PNETCDF} -L${LIB_PNETCDF} -L${NETCDF_PATH}/lib/ -I${NETCDF_PATH}/include -L${LIB_HDF5} </base>|" config_compilers.xml

sed -i "224s|.*|    <append compile_threaded=\"FALSE\">  -O3 -ffast-math -mcpu=hip11 -fGNU-compatibility -fIntel-compatibility -mcmodel=small -finit-zero -ftrivial-auto-var-init=zero -lflang -L${HDF5_PATH} -L${LIB_ZLIB} -L${HPCKIT_KML}/bisheng/lib/neon/kblas/multi/ -lkblas -L${HPCKIT_KML}/bisheng/lib/noarch/ -lkm  -L${HPCKIT_KML}/bisheng/lib/neon/ -lklapack_full -lnetcdff -lnetcdf -lpnetcdf -lhdf5_hl -lhdf5 -lm -lz -I${NETCDF_PATH}/include  -L${LIB_PNETCDF} -L${NETCDF_PATH}/lib/ -I${NETCDF_FORTRAN_PATH}/include -lstdc++ -lc -fno-openmp -I${INC_PNETCDF} -L${LIB_HDF5} </append>|" config_compilers.xml
echo "PROJECT:$(pwd)"

sed -i "226s|.*|  <MPICC> mpicc </MPICC>|" config_compilers.xml
sed -i "227s|.*|  <MPICXX> mpicxx </MPICXX>|" config_compilers.xml
sed -i "228s|.*|  <MPIFC> mpifort </MPIFC>|" config_compilers.xml
sed -i "229s|.*|  <SCC> mpicc </SCC>|" config_compilers.xml
sed -i "230s|.*|  <SCXX> mpicxx </SCXX>|" config_compilers.xml
sed -i "231s|.*|  <SFC> mpifort </SFC>|" config_compilers.xml

slib_line1="  <SLIBS>"
slib_line2="    <append>  -O3 -ffast-math -fstack-arrays -mcpu=hip11 -fGNU-compatibility -fIntel-compatibility -mcmodel=small -finit-zero -ftrivial-auto-var-init=zero -L${NETCDF}/lib -L${HDF5_PATH} -L${PNETCDF_PATH}/lib -lflang -L${LIB_ZLIB} -L${HPCKIT_KML}/bisheng/lib/neon/kblas/multi/ -lkblas -L${HPCKIT_KML}/bisheng/lib/noarch/ -lkm  -L${HPCKIT_KML}/bisheng/lib/neon/ -lklapack_full -lnetcdff -lnetcdf -lpnetcdf -lhdf5_hl -lhdf5 -lm -lz -I${NETCDF_PATH}/include -I${NETCDF_FORTRAN_PATH}/include  -L${LIB_PNETCDF} -L${NETCDF_PATH}/lib/ -lstdc++ -lc -fno-openmp -I${INC_PNETCDF} -L${LIB_HDF5} </append>"
slib_line3="  </SLIBS>"
sed -i '232a\
'"$slib_line1"'\n'"$slib_line2"'\n'"$slib_line3"'
' config_compilers.xml

cd ${CESM_2_2_2_CODE_ROOT}/cime/scripts

chmod +x ${CESM_2_2_2_CODE_ROOT}/ -R
rm -rf ${CESM_2_2_2_CASE_DIR}
./create_newcase --case ${CESM_2_2_2_CASE_DIR} --compset B1850 --res f09_g17 --mach=centos7-linux --run-unsupported --pecount=128 -i ${CESM_2_2_2_CASE_INPUTDATA}
cp -rf ${CESM_2_2_2_ROOT}/scripts/user_nl_pop_f09g17_b1850 ${CESM_2_2_2_CASE_DIR}/user_nl_pop
cp -rf ${CESM_2_2_2_ROOT}/scripts/user_nl_cam_416_f09g17_b1850 ${CESM_2_2_2_CASE_DIR}/user_nl_cam

cd ${CESM_2_2_2_CASE_DIR}

./xmlquery CICE_DECOMPTYPE

#module ava
./xmlquery PIO_TYPENAME
./xmlchange PIO_TYPENAME=pnetcdf
./xmlquery PIO_TYPENAME

./xmlchange CLM_FORCE_COLDSTART=on

./xmlchange ATM_NCPL=16,LND_NCPL=16,ICE_NCPL=16,OCN_NCPL=4,WAV_NCPL=8,GLC_NCPL=1,ROF_NCPL=1

#修改Tools/Makefile
#-L${LIB_MPI}
sed -i "624s|.*|SLIBS +=  -O3 -ffast-math -fstack-arrays -fGNU-compatibility -fIntel-compatibility -mcmodel=small -finit-zero -ftrivial-auto-var-init=zero  -lmpi -lopen-pal -L${HPCKIT_COM_BS}/lib -I${PNETCDF_PATH}/include -L${LIB_HDF5}  -I${NETCDF_PATH}/include/ -L${LIB_PNETCDF} -L${NETCDF_PATH}/lib/ -I${NETCDF_FORTRAN_PATH}/include -lnetcdff -lnetcdf -lpnetcdf -fno-openmp -I${INC_PNETCDF} -L${LIB_HDF5} |" Tools/Makefile

#修改../../src/share/util/shr_sys_mod.F90
sed -i "70s|!defined CPRGNU|defined CPRGNU|" ${CESM_2_2_2_CODE_ROOT}/cime/src/share/util/shr_sys_mod.F90
sed -i "115s|!defined CPRGNU|defined CPRGNU|" ${CESM_2_2_2_CODE_ROOT}/cime/src/share/util/shr_sys_mod.F90

./xmlquery PIO_TYPENAME
./xmlchange PIO_TYPENAME=pnetcdf
./xmlquery PIO_TYPENAME

./xmlchange CLM_FORCE_COLDSTART=on

./xmlchange NTASKS=592
./xmlchange MAX_MPITASKS_PER_NODE=592
./xmlchange MAX_TASKS_PER_NODE=592

./xmlchange NTASKS_ATM=416,NTASKS_LND=288,NTASKS_ICE=96,NTASKS_CPL=416,NTASKS_OCN=176,NTASKS_WAV=32,NTASKS_ROF=32,NTASKS_GLC=16,NTASKS_ESP=16
./xmlchange ROOTPE_ATM=0,ROOTPE_LND=0,ROOTPE_ICE=288,ROOTPE_CPL=0,ROOTPE_OCN=416,ROOTPE_WAV=384,ROOTPE_ROF=384,ROOTPE_GLC=384,ROOTPE_ESP=400
./xmlchange NTHRDS_ATM=1,NTHRDS_LND=1,NTHRDS_ICE=1,NTHRDS_CPL=1,NTHRDS_OCN=1,NTHRDS_WAV=1,NTHRDS_ROF=1,NTHRDS_GLC=1,NTHRDS_ESP=1
./xmlchange PSTRID_ATM=1,PSTRID_LND=1,PSTRID_ICE=1,PSTRID_CPL=1,PSTRID_OCN=1,PSTRID_WAV=1,PSTRID_ROF=1,PSTRID_GLC=1,PSTRID_ESP=1

./xmlchange DOUT_S=TRUE
./xmlchange PIO_ROOT=0
./xmlchange PIO_NUMTASKS=592

#576
./xmlchange PIO_STRIDE=1
./xmlchange REST_OPTION=never
./xmlquery PIO_NUMTASKS,PIO_STRIDE,PIO_ROOT
./xmlquery STOP_N,STOP_OPTION,CONTINUE_RUN
./xmlchange STOP_N=14

./xmlchange ATM_NCPL=16,LND_NCPL=16,ICE_NCPL=16,OCN_NCPL=4,WAV_NCPL=8,GLC_NCPL=1,ROF_NCPL=1

./xmlquery ATM_NCPL,LND_NCPL,ICE_NCPL,OCN_NCPL,WAV_NCPL

#./xmlchange REST_OPTION=never
./xmlchange CLM_ACCELERATED_SPINUP="on"

./xmlchange POP_AUTO_DECOMP=FALSE
./xmlchange POP_DECOMPTYPE=spacecurve
./xmlchange POP_BLCKX=30
./xmlchange POP_BLCKY=24
./xmlchange POP_NX_BLOCKS=11
./xmlchange POP_NY_BLOCKS=16
./xmlchange POP_MXBLCKS=1

./case.setup --reset
#pwd
./case.build --clean-all

./case.build --skip-provenance-check

set +x
./check_case
./check_input_data  -i ${CESM_2_2_2_CASE_INPUTDATA} -check
#./check_input_data --download -i ${CESM_2_2_2_CASE_INPUTDATA}

export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

./preview_run
