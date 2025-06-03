#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u http://www.codesynthesis.com/download/xsd/4.0/xsd-4.0.0+dep.tar.bz2
cd ${JARVIS_TMP}
rm -rf xsd-4.0.0+dep
tar -xvf ${JARVIS_DOWNLOAD}/xsd-4.0.0+dep.tar.bz2
cd xsd-4.0.0+dep

sed -i "11s|.*|#include <sstream>|" libxsd-frontend/xsd-frontend/semantic-graph/elements.cxx
sed -i "298s|.*|   std::wstringstream wss;\n   wss << path.string().c_str();\n   return os << wss.str();|" libxsd-frontend/xsd-frontend/semantic-graph/elements.cxx
sed -i '28s|throw (std::bad_alloc)|throw()|' libcutl/cutl/shared-ptr/base.cxx
sed -i '34s|throw (std::bad_alloc)|throw()|; 64s|throw (std::bad_alloc)|throw()|' libcutl/cutl/shared-ptr/base.hxx
sed -i '62s|throw (std::bad_alloc)|throw()|' libcutl/cutl/shared-ptr/base.ixx

rm -f /usr/lib64/libxerces-c.so
ln -s ${XERCES_PATH}/lib/libxerces-c.so /usr/lib64/libxerces-c.so
make -j CFLAGS="-I${XERCES_PATH}/include -L${XERCES_PATH}/lib -lxerces-c" \
	CXXFLAGS="-std=c++14 -I${XERCES_PATH}/include -L${XERCES_PATH}/lib -lxerces-c"
make install_prefix=$1 install
