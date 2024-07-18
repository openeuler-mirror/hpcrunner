#download from https://mirror.spack.io/_source-cache/archive/a4/a474e90b5882ce69c5e9f66f6359c53b8b73eb448c5f631fa96e8cd2c14df004.tar.gz
#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://mirror.spack.io/_source-cache/archive/a4/a474e90b5882ce69c5e9f66f6359c53b8b73eb448c5f631fa96e8cd2c14df004.tar.gz
mv ${JARVIS_DOWNLOAD}/a474e90b5882ce69c5e9f66f6359c53b8b73eb448c5f631fa96e8cd2c14df004.tar.gz ${JARVIS_DOWNLOAD}/med-4.0.0.tar.gz
cd ${JARVIS_TMP}
rm med-4.0.0 -rf
tar -xvf ${JARVIS_DOWNLOAD}/med-4.0.0.tar.gz
cd med-4.0.0

echo `h5dump --version`  >hdf5_ver.txt
hdf5_ver=`awk '{print $3}' hdf5_ver.txt`
ver1=$(echo $hdf5_ver | cut -d'.' -f1)
ver2=$(echo $hdf5_ver | cut -d'.' -f2)
ver3=$(echo $hdf5_ver | cut -d'.' -f3)
if [[ "$HDF5_DIR" &&  $ver1 -eq 1 && $ver2 -eq 10 && $ver3 -ge 2 ]]; then
    echo "The HDF5 environment variable is ready"
else
    echo "The HDF5_DIR environment variable does not exist or the version does not match, please make sure that it is configured correctly"
    echo "The HDF5 library version used by med-fichier4.y.z MUST NOT be > 1.10 and have to be at least HDF5-1.10.2"
    exit 99
fi
./configure --prefix=$1 --with-hdf5=${HDF5_DIR} --disable-python
make -j
make install
