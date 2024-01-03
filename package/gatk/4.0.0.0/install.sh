#download from $JARVIS_PROXY/broadinstitute/gatk/releases/download/4.0.0.0/gatk-4.0.0.0.zip
#module  load      
#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u $JARVIS_PROXY/broadinstitute/gatk/releases/download/4.0.0.0/gatk-4.0.0.0.zip

cd ${JARVIS_TMP}

unzip ${JARVIS_DOWNLOAD}/gatk-4.0.0.0.zip  -d $1
mv $1/gatk-4.0.0.0 $1/bin
