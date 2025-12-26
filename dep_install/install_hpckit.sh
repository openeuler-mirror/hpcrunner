#!/bin/bash
#安装编译器并加载对应的环境变量
function load_hpckit() {
    export BISHENG_VERSION=`ls $file_path|grep compiler|awk -F "compiler" '{print $2}'`
    export HMPI_VERSION=`ls $file_path|grep hmpi|awk -F "hmpi" '{print $2}'`
    module use ${JARVIS_ROOT}/software/utils/hpckit/${HPCKIT_VERSION}/HPCKit/${HPCKIT_VERSION}/modulefiles
    module load bisheng/compiler${BISHENG_VERSION}/bishengmodule
    module load bisheng/hmpi${HMPI_VERSION}/release
    module load bisheng/kml${HMPI_VERSION}/kml > /dev/null 2>&1
    module load bisheng/kml${HPCKIT_VERSION}/kblas/multi
    
    export HPCKIT_PATH=${JARVIS_UTILS}/hpckit/${HMPI_VERSION}
    export KML_LIB_PATH=${HPCKIT_PATH}/HPCKit/${HMPI_VERSION}/kml/bisheng/lib
    export KML_PATH=${HPCKIT_PATH}/HPCKit/${HMPI_VERSION}/kml
    export BLAS_LIBS="-L${JARVIS_ROOT}/software/utils/hpckit/${HPCKIT_VERSION}/HPCKit/${HPCKIT_VERSION}/kml/bisheng/lib/${kp}/kblas/multi -lkblas"
    export LAPACK_LIBS="-L${JARVIS_ROOT}/software/utils/hpckit/${HPCKIT_VERSION}/HPCKit/${HPCKIT_VERSION}/kml/bisheng/lib/${kp} -lklapack_full"
    echo -e "已自动加载毕昇编译器、Hyper-MPI和鲲鹏数学库："
    module li
}

function check_hpckit() {
    #判断hpckit是否安装，更新配套版本
    file_path="${JARVIS_ROOT}/software/utils/hpckit/${HPCKIT_VERSION}/HPCKit/${HPCKIT_VERSION}/modulefiles/bisheng"
    if [ -e "$file_path" ]; then
        echo -e "你正在使用 $HPCKIT_VERSION 版本的 HPCKit"
        load_hpckit
    else
        echo -e "INFO: 检测到未安装 $HPCKIT_VERSION 版本的 HPCKit，正在重新安装："
        #./jarvis -use templates/basic_env/data.hpckit.config
		#./jarvis -dp
        set +x
        ./jarvis -install hpckit/${HPCKIT_VERSION} any  > /dev/null
		load_hpckit
    fi
}


#检查编译器
function check_com() {
    if [ -e ".meta" ]; then
        ifclang=`cat .meta | awk -F '/' 'END{print $NF}'|grep clang`
        ifbisheng=`cat .meta | awk -F '/' '{print $(NF-1)}'|grep bisheng`
        ifgcc=`cat .meta | awk -F '/' 'END{print $NF}'|grep gcc`
        if [ -n "$ifclang" ]; then
            return 1
        elif [ -n "$ifbisheng" ]; then
            return 1
        elif [ -n "$ifgcc" ]; then
            return 2
        else
            return 0
        fi
    fi
}


check_com
if [ $? -eq 1 ]; then
    echo "using bisheng complier"
    check_hpckit
elif [ $? -eq 2 ]; then
    echo "using gcc complier"
else
    echo ""
fi

