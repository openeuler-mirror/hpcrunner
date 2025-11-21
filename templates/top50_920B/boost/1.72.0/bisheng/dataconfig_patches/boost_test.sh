#!/bin/bash
export CC="clang  -O3 -fcommon -Wno-incompatible-function-pointer-types -Wno-enum-constexpr-conversion Wno-implicit-function-declaration -Wno-dynamic-exception-spec -Wno-error=register  -Wno-implicit-int -Wno-enum-constexpr-conversion  -Wno-missing-template-arg-list-after-template-kw -fdelayed-template-parsing "
export  CXX="clang++  -O3 -fcommon -Wno-incompatible-function-pointer-types -Wno-enum-constexpr-conversion -Wno-implicit-function-declaration -Wno-dynamic-exception-spec -Wno-error=register  -Wno-implicit-int -Wno-enum-constexpr-conversion  -Wno-missing-template-arg-list-after-template-kw -fdelayed-template-parsing "
export  FC="flang -O3 -fcommon -Wno-incompatible-function-pointer-types -Wno-enum-constexpr-conversion -Wno-implicit-function-declaration -Wno-dynamic-exception-spec -Wno-error=register  -Wno-implicit-int -Wno-enum-constexpr-conversion  -Wno-missing-template-arg-list-after-template-kw  "

set -x
cd boost_1_72_0
rm -rf bin.v2
cd status
../b2 toolset=clang cxxflags="-Wno-enum-constexpr-conversion" --limit-tests=system*
cd -
set +x
