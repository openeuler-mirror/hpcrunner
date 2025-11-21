#!/usr/bin/bash

TYPE="${1}"
WORK_PATH="${2}"
CESM_PATH="${3}"

PACKAGE_DIR=${WORK_PATH}/../

cd ${WORK_PATH}
CESM_DIR=${CESM_PATH}/input/cesm-1.2.2
MYCASE_DIR=${WORK_PATH}/input/cesm-1.2.2/cime/scripts/mycase
CESM_OUTPUT=${WORK_PATH}/output


set -x
#test "$cputype_" = "sme"  && NP_NUM=256
# SME:256
# sve:128
MAX_TASKS_PER_NODE=128
MAX_MPITASKS_PER_NODE=128
EXE_ARGS="--allow-run-as-root --mca btl ^openib -np {{ total_tasks }}"
CPUFLAGS=""
#set -e

PNETCDF_PATH=${PNETCDF_CLANG_PATH}
echo "NETCDF_CLANG_PATH:${NETCDF_CLANG_PATH}"
echo "PNETCDF_PATH:${PNETCDF_PATH}"
echo "OPENBLAS_CLANG_PATH:${OPENBLAS_CLANG_PATH}"
echo "ZLIB_PATH:${ZLIB_PATH}"
echo "CURL_PATH:${CURL_PATH}"

function case_build
{
	
	cd ${WORK_PATH}
	TMP_NAME="cesm-1.2.2"
	mkdir -p $WORK_PATH/input
	cd $WORK_PATH/input
	CESM_OUT_HOME=$WORK_PATH/output

	#rm -rf $CESM_OUT_HOME/cesm
	rm -rf $CESM_OUT_HOME/cesm/archive
	rm -rf $CESM_OUT_HOME/cesm/scratch

	test -e $TMP_NAME && rm -rf $TMP_NAME
	cp -rf $CESM_PATH/bin/$TMP_NAME .

	cd  $TMP_NAME
	echo "#####Modify config_machines.xml start"
	cp cime/config/cesm/machines/config_machines.xml cime/config/cesm/machines/config_machines.xml-bak
	sed -i "152c <NODENAME_REGEX>$(hostname)</NODENAME_REGEX>" cime/config/cesm/machines/config_machines.xml
	sed -i '155c <COMPILERS>gnu</COMPILERS>' cime/config/cesm/machines/config_machines.xml
	sed -i '156c <MPILIBS>openmpi</MPILIBS>' cime/config/cesm/machines/config_machines.xml
	sed -i "159c <CIME_OUTPUT_ROOT>$CESM_OUT_HOME/cesm/scratch</CIME_OUTPUT_ROOT>" cime/config/cesm/machines/config_machines.xml
    	sed -i "160c <DIN_LOC_ROOT>$CESM_OUT_HOME/cesm/inputdata</DIN_LOC_ROOT>" cime/config/cesm/machines/config_machines.xml
    	sed -i "161c <DIN_LOC_ROOT_CLMFORC>$CESM_OUT_HOME/cesm/inputdata/lmwg</DIN_LOC_ROOT_CLMFORC>" cime/config/cesm/machines/config_machines.xml
    	sed -i "162c <DOUT_S_ROOT>$CESM_OUT_HOME/cesm/archive/\$CASE</DOUT_S_ROOT>" cime/config/cesm/machines/config_machines.xml
    	sed -i "163c <BASELINE_ROOT>$CESM_OUT_HOME/cesm/cesm_baselines</BASELINE_ROOT>" cime/config/cesm/machines/config_machines.xml
    	sed -i "164c <CCSM_CPRNC>$CESM_OUT_HOME/cesm/tools/cime/tools/cprnc/cprnc</CCSM_CPRNC>" cime/config/cesm/machines/config_machines.xml

	sed -i "169c <MAX_TASKS_PER_NODE>$MAX_TASKS_PER_NODE</MAX_TASKS_PER_NODE>" cime/config/cesm/machines/config_machines.xml
	sed -i "170c <MAX_MPITASKS_PER_NODE>$MAX_MPITASKS_PER_NODE</MAX_MPITASKS_PER_NODE>" cime/config/cesm/machines/config_machines.xml
	sed -i "173c <executable>mpirun</executable>" cime/config/cesm/machines/config_machines.xml
	sed -i "175c <arg name=\"ntasks\">$EXE_ARGS </arg>" cime/config/cesm/machines/config_machines.xml

	sed -i "198a\<env name=\"NETCDF_PATH\">${NETCDF_CLANG_PATH}</env>" cime/config/cesm/machines/config_machines.xml
	sed -i "199a\<env name=\"NETCDF_FORTRAN_PATH\">${NETCDF_CLANG_PATH}</env>" cime/config/cesm/machines/config_machines.xml
	sed -i "200a\<env name=\"PNETCDF_PATH\">${PNETCDF_PATH}</env>" cime/config/cesm/machines/config_machines.xml
	sed -i "201a\<env name=\"NETCDF_C_PATH\">${NETCDF_CLANG_PATH}</env>" cime/config/cesm/machines/config_machines.xml
	sed -i "202a\<env name=\"MPI_PATH\">${OPAL_PREFIX}</env>" cime/config/cesm/machines/config_machines.xml
	sed -i "187c <!-- modules>" cime/config/cesm/machines/config_machines.xml
	sed -i "195c </modules -->" cime/config/cesm/machines/config_machines.xml
	#sed -i "191c <command name=\"use\">$MODULE_PATH</command>" cime/config/cesm/machines/config_machines.xml
	#sed -i "192c <command name=\"load\">hpckit24.10.30/kit_bs/4.1.0</command>" cime/config/cesm/machines/config_machines.xml
	#sed -i "193c <command name=\"load\">kit_hmpi/2.4.2</command>" cime/config/cesm/machines/config_machines.xml
	#sed -i "194c <!-- add here -->" cime/config/cesm/machines/config_machines.xml
	echo "#####Modify config_machines.xml end"


	echo "#####Modify config_compilers.xml start"
	cp cime/config/cesm/machines/config_compilers.xml cime/config/cesm/machines/config_compilers.xml-bak
	sed -i "109c <base>  -O3 ${CPUFLAGS} </base>" cime/config/cesm/machines/config_compilers.xml
	sed -i "125c <base>  -fconvert=big-endian -O3 ${CPUFLAGS} -I${NETCDF_PATH}/include -I${HDF5_CLANG_PATH}/include -I${PNETCDF_PATH}/include -I${CURL_PATH}/include -I${OPENBLAS_CLANG_PATH}/include -I${ZLIB_PATH}/include </base>" cime/config/cesm/machines/config_compilers.xml
	sed -i "146c <append compile_threaded=\"true\"> -fopenmp -L${NETCDF_CLANG_PATH}/lib -L${PNETCDF_PATH}/lib -L${HDF5_CLANG_PATH}/lib -L${OPENBLAS_CLANG_PATH}/lib -L${CURL_PATH}/lib -L${ZLIB_PATH}/lib -L${OPAL_PREFIX}/lib -lopenblas -lnetcdff -lnetcdf -lpnetcdf -lhdf5_hl -lhdf5 -lm -lz -lcurl  -lmpi -lopen-pal</append>" cime/config/cesm/machines/config_compilers.xml
	sed -i "148c <MPICC> $(which mpicc)  </MPICC>" cime/config/cesm/machines/config_compilers.xml
	sed -i "149c <MPICXX> $(which mpicxx) </MPICXX>" cime/config/cesm/machines/config_compilers.xml
	sed -i "150c  <MPIFC> $(which mpif90) </MPIFC>" cime/config/cesm/machines/config_compilers.xml
	sed -i "151c <SCC> $(which clang) </SCC>" cime/config/cesm/machines/config_compilers.xml
	sed -i "152c <SCXX> $(which clang++) </SCXX>" cime/config/cesm/machines/config_compilers.xml
	sed -i "153c <SFC> $(which flang) </SFC>" cime/config/cesm/machines/config_compilers.xml
	sed -i "154a\<SLIBS>" cime/config/cesm/machines/config_compilers.xml
	sed -i "155a\<append> -L${NETCDF_CLANG_PATH}/lib -L${PNETCDF_PATH}/lib -L${HDF5_CLANG_PATH}/lib -L${OPENBLAS_CLANG_PATH}/lib -L${CURL_PATH}/lib -L${ZLIB_PATH}/lib -L${OPAL_PREFIX}/lib -lopenblas -lnetcdff -lnetcdf -lpnetcdf -lhdf5_hl -lhdf5 -lm -lz -lcurl  -lmpi -lopen-pal </append>" cime/config/cesm/machines/config_compilers.xml
	sed -i "156a\</SLIBS>" cime/config/cesm/machines/config_compilers.xml
	echo "#####Modify config_compilers.xml end"


	test -e $CESM_OUT_HOME/cesm ||	mkdir -p $CESM_OUT_HOME/cesm
	if [ ! -d $CESM_OUT_HOME/cesm/inputdata ]; then
		tar xzf $PACKAGE_DIR/cesm_1.2.2_inputdata.tar.gz -C $CESM_OUT_HOME/cesm
	fi

	echo "Create case ................"
	cd cime/scripts

	./create_newcase --case mycase --compset X --res f19_g16 --mach=centos7-linux

	echo "Check case ................"
	cd mycase
	
	echo "histaux_l2x1yrg = .true." > user_nl_cpl
	
	./check_case
	echo "Check Input data ................"
	./check_input_data --download
	echo "Case setup ................"
	./case.setup

	cp ../../src/share/util/shr_infnan_mod.F90.in ../../src/share/util/shr_infnan_mod.F90.in-bak
	sed -i '227c      is_nan = is_nan' ../../src/share/util/shr_infnan_mod.F90.in

	cp ../../src/share/util/shr_sys_mod.F90 ../../src/share/util/shr_sys_mod.F90-bak
	sed -i '70c #if (defined LINUX && defined CPRGNU)' ../../src/share/util/shr_sys_mod.F90
	sed -i '115c #if (defined AIX || (defined LINUX && defined CPRGNU && !defined CPRNAG) || defined CPRINTEL)' ../../src/share/util/shr_sys_mod.F90

	echo "Case Build................"
	./case.build --skip-provenance-check
	./check_case	
		
	#echo "Case Submit................"

	#./case.submit | tee -a tee_submit.xlog

}

set -x
function case_submit()
{
	cd ${MYCASE_DIR}
	echo ${MYCASE_DIR}
	echo "Case Submit................"
	./case.submit | tee  tee_submit.xlog
}

if [ "${TYPE}" == "CASE_BUILD" ]; then
	case_build
fi


if [ "${TYPE}" == "CASE_SUBMIT" ]; then
	case_submit
fi

set +x
exit 0

