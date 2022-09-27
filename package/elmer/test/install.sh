set -x
set -e
. ${DOWNLOAD_TOOL} -u https://sources.debian.org/data/non-free/e/elmer-doc/2014.02.06-1~bpo70+1/ElmerTutorialsFiles_nonGUI.tar.gz
cd ${JARVIS_TMP}
rm -rf tutorials_files
tar -xvf ${JARVIS_DOWNLOAD}/ElmerTutorialsFiles_nonGUI.tar.gz