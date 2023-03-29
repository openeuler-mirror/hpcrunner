#!/bin/bash
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://codeload.github.com/cjcoats/ioapi-3.2/tar.gz/2020111 -f ioapi-3.2-2020111.tar.gz
cd ${JARVIS_TMP}
tar -xvf ${JARVIS_DOWNLOAD}/ioapi-3.2-2020111.tar.gz
mv ioapi-3.2-2020111 ioapi-3.2
cd ioapi-3.2
cp ioapi/Makeinclude.Linux2_ia64gfort ioapi/Makeinclude.Linux4_aarch64
sed -i "14c\CC   = mpicc" ioapi/Makeinclude.Linux4_aarch64
sed -i "15c\CXX  = mpicxx" ioapi/Makeinclude.Linux4_aarch64
sed -i "16c\FC   = mpifort" ioapi/Makeinclude.Linux4_aarch64
sed -i "30c\#FSFLAGS   = -save" ioapi/Makeinclude.Linux4_aarch64
cp ioapi/Makefile.nocpl ioapi/Makefile
export HOME=${JARVIS_TMP}
cp m3tools/Makefile.nocpl m3tools/Makefile
sed -i "65c\LIBS = -L\${OBJDIR} -lioapi -L${JARVIS_ROOT}/software/libs/kgcc9.3.1/hmpi1.1.1/netcdf/4.7.0/lib/ -lnetcdff -lnetcdf -L${JARVIS_ROOT}/software/libs/kgcc9.3.1/hmpi1.1.1/hdf5/1.10.1/lib -lhdf5_hl -lhdf5 -lz \$(OMPLIBS) \$(ARCHLIB) \$(ARCHLIBS)" m3tools/Makefile
sed -i "146c\LIBS = -L\${OBJDIR} -lioapi -L${JARVIS_ROOT}/software/libs/kgcc9.3.1/hmpi1.1.1/netcdf/4.7.0/lib/ -lnetcdff -lnetcdf -L${JARVIS_ROOT}/software/libs/kgcc9.3.1/hmpi1.1.1/hdf5/1.10.1/lib -lhdf5_hl -lhdf5 -lz \$(OMPLIBS) \$(ARCHLIB) \$(ARCHLIBS)" m3tools/Makefile

cp Makefile.template Makefile
sed -i "138c\BIN        = Linux4_aarch64" Makefile
sed -i "139c\BASEDIR    = \${PWD}" Makefile
sed -i "140c\INSTALL    = \${HOME}" Makefile
sed -i "141c\LIBINST    = \$(INSTALL)/\$(BIN)" Makefile
sed -i "142c\BININST    = \$(INSTALL)/\$(BIN)" Makefile
sed -i "143c\CPLMODE    = nocpl" Makefile
sed -i '144c\IOAPIDEFS  = "-DIOAPI_NCF4"' Makefile
sed -i "193c\NCFLIBS    = -L${JARVIS_ROOT}/software/libs/kgcc9.3.1/hmpi1.1.1/netcdf/4.7.0/lib/ -lnetcdff -lnetcdf -L${JARVIS_ROOT}/software/libs/kgcc9.3.1/hmpi1.1.1/hdf5/1.10.1/lib -lhdf5_hl -lhdf5 -lz" Makefile
make BIN=Linux4_aarch64
sed -i "174c\        COMMON  / BSTATE3 /                                              " ioapi/STATE3.EXT
sed -i "175c\     &          P_ALP3, P_BET3, P_GAM3,                                  " ioapi/STATE3.EXT
sed -i "176c\     &          XCENT3, YCENT3, XORIG3, YORIG3, XCELL3, YCELL3,          " ioapi/STATE3.EXT
sed -i "177c\     &          VGTYP3, VGTOP3, VGLVS3,                                  " ioapi/STATE3.EXT
sed -i "178c\     &          FINIT3, COUNT3, CURDATE, CURTIME, LOGDEV,                " ioapi/STATE3.EXT
sed -i "179c\     &          CDFID3, FTYPE3, SDATE3, STIME3, TSTEP3, MXREC3,          " ioapi/STATE3.EXT
sed -i "180c\     &          NVARS3, NLAYS3, NROWS3, NCOLS3, NTHIK3,                  " ioapi/STATE3.EXT
sed -i "181c\     &          TINDX3, NINDX3, SINDX3, LINDX3, WCNDX3, WRNDX3,          " ioapi/STATE3.EXT
sed -i "182c\     &          XINDX3, YINDX3, ZINDX3, DXNDX3, DYNDX3, VINDX3,          " ioapi/STATE3.EXT
sed -i "183c\     &          GDTYP3, VOLAT3, RONLY3,                                  " ioapi/STATE3.EXT
sed -i "184c\     &          BSIZE3, LDATE3, LTIME3, NDATE3, NTIME3, ILAST3,          " ioapi/STATE3.EXT
sed -i "185c\     &          VTYPE3,                                                  " ioapi/STATE3.EXT
sed -i "186c\     &          ILCNT3, NLIST3, IFRST3, ILIST3, BEGRC3, ENDRC3,          " ioapi/STATE3.EXT
sed -i "191c\        COMMON  / CSTATE3 /                                              " ioapi/STATE3.EXT
cp -a Linux4_aarch64 $1/bin

