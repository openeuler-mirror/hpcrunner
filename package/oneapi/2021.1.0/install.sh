#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://registrationcenter-download.intel.com/akdlm/irc_nas/17431/l_BaseKit_p_2021.1.0.2659_offline.sh
. ${DOWNLOAD_TOOL} -u https://registrationcenter-download.intel.com/akdlm/irc_nas/17427/l_HPCKit_p_2021.1.0.2684_offline.sh

cd $JARVIS_TMP

cp $JARVIS_DOWNLOAD/l_BaseKit_p_2021.1.0.2659_offline.sh ./
cp $JARVIS_DOWNLOAD/l_HPCKit_p_2021.1.0.2684_offline.sh ./

bash l_BaseKit_p_2021.1.0.2659_offline.sh -x
bash l_HPCKit_p_2021.1.0.2684_offline.sh -x

#rm -r /var/intel/installercache
cd l_BaseKit_p_2021.1.0.2659_offline
./install.sh --silent --eula accept --install-dir /opt/intel/oneapi

cd ..

cd l_HPCKit_p_2021.1.0.2684_offline
./install.sh --silent --eula accept --install-dir /opt/intel/oneapi

echo -e "\033[0;32m[Info]\033[0m:Please use 'source /opt/intel/oneapi/setvars.sh' to set up your development environment."
