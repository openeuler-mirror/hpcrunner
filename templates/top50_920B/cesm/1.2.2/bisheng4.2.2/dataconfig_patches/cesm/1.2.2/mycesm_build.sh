#!/usr/bin/bash
WORK_PATH="$(dirname $(realpath ${BASH_SOURCE[0]}))"

[  -z ${ZLIB_PATH} ] && echo "Invalid ZLIB_PATH" && exit 1
echo "ZLIB_PATH:${ZLIB_PATH}"
[ -z ${SZIP_PATH} ] && echo "Invalid SZIP_PATH" && exit 1
echo "SZIP_PATH: ${SZIP_PATH}"
HDF5_PATH=${HDF5_CLANG_PATH}
[ -z ${HDF5_PATH} ] && echo "Invalid HDF5_PATH" && exit 1
echo "HDF5_PATH: ${HDF5_PATH}"

PNETCDF_PATH=${PNETCDF_CLANG_PATH}
[ -z ${PNETCDF_PATH} ] && echo "Invalid PNETCDF_PATH" && exit 1
echo "PNETCDF_PATH: ${PNETCDF_PATH}"

NETCDF_PATH=${NETCDF_CLANG_PATH}
[ -z ${NETCDF_PATH} ] && echo "Invalid NETCDF_PATH" && exit 1
echo "NETCDF_PATH: ${NETCDF_PATH}"

OPENBLAS_PATH=${OPENBLAS_CLANG_PATH}
[  -z ${OPENBLAS_PATH} ] && echo "Invalid OPENBLAS_PATH" && exit 1
echo "OPENBLAS_PATH: ${OPENBLAS_PATH}"

[ -z ${CURL_PATH} ] && echo "Invalid CURL_PATH" && exit 1
echo "SZIP_PATH: ${CURL_PATH}"

# run test
function build_test()
{
	set -x
	TMP_NAME="cesm1_2_2"
	cd $WORK_PATH

	CESM_CASE_INPUTDATA=${WORK_PATH}/cesm_inputdata
	CESM_OUT_HOME=${WORK_PATH}/output
	rm -rf ${CESM_OUT_HOME}
	mkdir -p ${CESM_OUT_HOME}

	cd source/$TMP_NAME 
	echo "#####Modify config_machines.xml start"
	cp scripts/ccsm_utils/Machines/mkbatch.userdefined scripts/ccsm_utils/Machines/mkbatch.centos7-linux
	cp scripts/ccsm_utils/Machines/env_mach_specific.userdefined scripts/ccsm_utils/Machines/env_mach_specific.centos7-linux
	if [ ! -f "scripts/ccsm_utils/Machines/config_machines.xml-bak" ]; then
		cp scripts/ccsm_utils/Machines/config_machines.xml scripts/ccsm_utils/Machines/config_machines.xml-bak
	else
		echo y | cp scripts/ccsm_utils/Machines/config_machines.xml-bak scripts/ccsm_utils/Machines/config_machines.xml
	fi
	sed -i "143i\ <machine MACH=\"centos7-linux\">" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "144i\ <DESC>" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "145i\ Example port to centos7 linux system with gcc, netcdf, pnetcdf and mpich" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "146i\ using modules from http://www.admin-magazine.com/HPC/Articles/Environment-Modules" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "147i\ </DESC>" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "148i\ <OS>LINUX</OS>" scripts/ccsm_utils/Machines/config_machines.xml

	sed -i "149i\ <COMPILERS>gnu</COMPILERS>" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "150i\ <MPILIBS>openmpi</MPILIBS>" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "151i\ <RUNDIR>$CESM_OUT_HOME/run</RUNDIR>" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "152i\ <EXEROOT>$CESM_OUT_HOME/bld</EXEROOT>" scripts/ccsm_utils/Machines/config_machines.xml

	sed -i "153i\ <DIN_LOC_ROOT>$CESM_OUT_HOME/cesm/inputdata</DIN_LOC_ROOT>" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "154i\ <DIN_LOC_ROOT_CLMFORC>$CESM_OUT_HOME/cesm/inputdata/lmwg</DIN_LOC_ROOT_CLMFORC>" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "155i\ <DOUT_S>FALSE</DOUT_S>" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "156i\ <DOUT_S_ROOT>$CESM_OUT_HOME/cesm/archive</DOUT_S_ROOT>" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "157i\ <DOUT_L_MSROOT>$CESM_OUT_HOME</DOUT_L_MSROOT>" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "158i\ <CCSM_BASELINE>UNSET</CCSM_BASELINE>" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "159i\ <BASELINE_ROOT>$CESM_OUT_HOME/cesm/cesm_baselines</BASELINE_ROOT>" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "160i\ <CCSM_CPRNC>$CESM_OUT_HOME/cesm/tools/cime/tools/cprnc/cprnc</CCSM_CPRNC>" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "161i\ <GMAKE_J>128</GMAKE_J>" scripts/ccsm_utils/Machines/config_machines.xml

	sed -i "162i\ <SUPPORTED_BY>me@my.address</SUPPORTED_BY>" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "163i\ <MAX_TASKS_PER_NODE>128</MAX_TASKS_PER_NODE>" scripts/ccsm_utils/Machines/config_machines.xml
	sed -i "164i\ </machine>" scripts/ccsm_utils/Machines/config_machines.xml
	echo "#####Modify config_machines.xml end"


	echo "#####Modify config_compilers.xml start"
	if [ ! -f "scripts/ccsm_utils/Machines/config_compilers.xml-bak" ]; then
		cp scripts/ccsm_utils/Machines/config_compilers.xml scripts/ccsm_utils/Machines/config_compilers.xml-bak
	else
		echo y | cp scripts/ccsm_utils/Machines/config_compilers.xml-bak scripts/ccsm_utils/Machines/config_compilers.xml
	fi
	sed -i "364c <compiler COMPILER=\"gnu\" MACH=\"centos7-linux\">" scripts/ccsm_utils/Machines/config_compilers.xml
	sed -i "366c <ADD_CPPDEFS> -DFORTRANUNDERSCORE -DNO_R16 -DCPRGNU</ADD_CPPDEFS>" scripts/ccsm_utils/Machines/config_compilers.xml
	sed -i "367i\<ADD_SLIBS>-L$NETCDF_PATH/lib -L$HDF5_PATH/lib -L$PNETCDF_PATH/lib -L$OPENBLAS_PATH/lib -L$CURL_PATH/lib -L$ZLIB_PATH/lib -fopenmp -lopenblas -lnetcdff -lnetcdf -lpnetcdf -lhdf5_hl -lhdf5 -lm -lz -lcurl </ADD_SLIBS>" scripts/ccsm_utils/Machines/config_compilers.xml
	sed -i "370c <ADD_LDFLAGS compile_threaded=\"true\"> -fopenmp -L$NETCDF_PATH/lib -L$HDF5_PATH/lib -L$PNETCDF_PATH/lib -L$OPENBLAS_PATH/lib -L$CURL_PATH/lib -L$ZLIB_PATH/lib -lopenblas -lnetcdff -lnetcdf -lpnetcdf -lhdf5_hl -lhdf5 -lm -lz -lcurl </ADD_LDFLAGS>" scripts/ccsm_utils/Machines/config_compilers.xml
	sed -i "374c <ADD_FFLAGS DEBUG=\"TRUE\"> -Wall -Og </ADD_FFLAGS>" scripts/ccsm_utils/Machines/config_compilers.xml
	sed -i '375i\<ADD_CFLAGS> -O3 -finit-zero -mcpu=hip09 </ADD_CFLAGS>' scripts/ccsm_utils/Machines/config_compilers.xml
	sed -i "378c <FFLAGS> -O3 -march=native -ffast-math -funroll-loops -fstack-arrays -finit-zero -fconvert=big-endian -ffree-line-length-none -ffixed-line-length-none -mcpu=hip09 -I$NETCDF_PATH/include -I$HDF5_PATH/include -I$PNETCDF_PATH/include -I$CURL_PATH/include -I$OPENBLAS_PATH/include -I$ZLIB_PATH/include -fopenmp </FFLAGS>" scripts/ccsm_utils/Machines/config_compilers.xml
	sed -i "381c   <SFC> flang </SFC>" scripts/ccsm_utils/Machines/config_compilers.xml
	sed -i "382c   <SCC> clang </SCC>" scripts/ccsm_utils/Machines/config_compilers.xml
	sed -i "383c   <SCXX> clang++ </SCXX>" scripts/ccsm_utils/Machines/config_compilers.xml
	sed -i "384c   <MPIFC> mpifort </MPIFC>" scripts/ccsm_utils/Machines/config_compilers.xml
	echo "#####Modify config_compilers.xml end"

	test -e $CESM_OUT_HOME/cesm || mkdir -p $CESM_OUT_HOME/cesm
	rm -rf $CESM_OUT_HOME/cesm/inputdata
	cp  ${CESM_CASE_INPUTDATA}/inputdata $CESM_OUT_HOME/cesm/ -ar
	echo "Create case ................"
	cd scripts
	test -e mycase && rm -rf mycase/
        chmod -R 777 $WORK_PATH/source/
	./create_newcase --case mycase --compset B1850 --res f09_g16 --mach=centos7-linux
	sed -i '/set fout = ${caseroot}\/timing\/ccsm_timing.$CASE.${lid}/a\echo "LOGOUTPUT:${fout}"' mycase/Tools/getTiming.csh
	echo "Check case ................"
	cd mycase
	./check_case
	# ./check_input_data -inputdata $CESM_OUT_HOME/cesm/inputdata -check -export
	./check_input_data -inputdata $CESM_OUT_HOME/cesm/inputdata -check
	./xmlchange NTASKS_ATM=128,NTASKS_LND=128,NTASKS_ROF=128,NTASKS_ICE=128,NTASKS_OCN=128,NTASKS_GLC=128,NTASKS_WAV=128,NTASKS_CPL=128,ROOTPE_ICE=0,ROOTPE_ATM=0,ROOTPE_LND=0,ROOTPE_ROF=0,ROOTPE_OCN=0,ROOTPE_GLC=0,ROOTPE_WAV=0,ROOTPE_CPL=0
	echo "Case setup ................"
	./cesm_setup
	
	PATCH_FILE="${WORK_PATH}/patch/run.patch"
	PROJECT_ROOT="${WORK_PATH}/source"

	cd "$PROJECT_ROOT" || exit 1

        cd $WORK_PATH/source/cesm1_2_2/scripts/mycase 
        chmod -R 777 $WORK_PATH/source/
	./xmlchange REST_OPTION=never

	echo "Case Build................"
	./mycase.build
	set +x
}	

#Main Function
function main()
{
        build_test $*
}

main $*

exit 0


