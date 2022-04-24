CUR_PATH=$(pwd)
chmod -R +x ./benchmark
chmod -R +x ./package
chmod -R +x ./test
chmod +x *.sh
chmod +x jarvis
mkdir -p tmp
export JARVIS_ROOT=${CUR_PATH}
export JARVIS_COMPILER=${CUR_PATH}/software/compiler
export JARVIS_MPI=${CUR_PATH}/software/mpi
export JARVIS_LIBS=${CUR_PATH}/software/libs
export JARVIS_UTILS=${CUR_PATH}/software/utils
export JARVIS_DOWNLOAD=${CUR_PATH}/downloads
export JARVIS_TMP=${CUR_PATH}/tmp
export DOWNLOAD_TOOL=${CUR_PATH}/package/common/download.sh
