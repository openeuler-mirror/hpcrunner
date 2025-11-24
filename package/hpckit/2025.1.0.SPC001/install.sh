#!/bin/bash
set -e
set -x
mkdir -p ${JARVIS_LOG_DIR}/hpckit/2025.1.0.SPC001
{
export hpckit_ver="25.1.0.SPC001"
../meta.sh  $1

cat > ${1}/module_tail.modulefile << EOF
set HPCKIT_BASEDIR "${1}/HPCKit/25.1.0.SPC001"
set HPCKIT_COM_BS "${1}/HPCKit/25.1.0.SPC001/compiler/bisheng"
set HPCKIT_COM_KGCC "${1}/HPCKit/25.1.0.SPC001/compiler/gcc"
set HPCKIT_HMPI "${1}/HPCKit/25.1.0.SPC001/hmpi"
set HPCKIT_KML "${1}/HPCKit/25.1.0.SPC001/kml"

setenv HPCKIT_BASEDIR   "${1}/HPCKit/25.1.0.SPC001"
setenv HPCKIT_COM_BS "${1}/HPCKit/25.1.0.SPC001/compiler/bisheng"
setenv HPCKIT_COM_KGCC "${1}/HPCKit/25.1.0.SPC001/compiler/gcc"
setenv HPCKIT_HMPI "${1}/HPCKit/25.1.0.SPC001/hmpi"
setenv HPCKIT_KML "${1}/HPCKit/25.1.0.SPC001/kml"

if { [module-info mode load] } {
puts stderr "HPCKIT_ENV: HPCKIT_BASEDIR=\${HPCKIT_BASEDIR}"
puts stderr "HPCKIT_ENV: HPCKIT_COM_BS=\${HPCKIT_COM_BS}"
puts stderr "HPCKIT_ENV: HPCKIT_COM_KGCC=\${HPCKIT_COM_KGCC}"
puts stderr "HPCKIT_ENV: HPCKIT_HMPI=\${HPCKIT_HMPI}"
puts stderr "HPCKIT_ENV: HPCKIT_KML=\${HPCKIT_KML}"
}
EOF

} 2>&1 | tee ${JARVIS_LOG_DIR}/hpckit/2025.1.0.SPC001/tee_install_$(date +%Y%m%d%H%M%S).xlog
res=${PIPESTATUS[0]}
echo "Install Result:${res}"
set +x
exit ${res}
