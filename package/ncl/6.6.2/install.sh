#!/bin/bash

# download from https://github.com/NCAR/ncl/archive/refs/tags/6.6.2.tar.gz
. $CHECK_ROOT && yum install zlib zlib-devel expat-devel freetype freetype-devel freetype-demos python-freetype ftgl ftgl-devel udunits2  udunits2-devel 
set -x
set -e
. ${DOWNLOAD_TOOL} -u https://github.com/NCAR/ncl/archive/refs/tags/6.6.2.tar.gz
cd ${JARVIS_TMP}
rm -rf ncl-6.6.2
tar -xvf ${JARVIS_DOWNLOAD}/6.6.2.tar.gz
cd ncl-6.6.2

#INCULE_PATCH#################################################################
#common/src/libncarg_c/yMakefile
sed -i '61c EXCSRCS = bcopyswap.c logic32.c' common/src/libncarg_c/yMakefile
sed -i '62c EXFSRCS = gbytes.f sbytes.f' common/src/libncarg_c/yMakefile
sed -i '62a EXOBJS  = bcopyswap.o sbytes.o gbytes.o logic32.o' common/src/libncarg_c/yMakefile
#config/LINUX
sed -i '32c #define LibSearchUser    -L/usr/X11R6/lib64 -L/usr/lib64' config/LINUX
sed -i '33c #define IncSearchUser    -I/usr/X11R6/include -I/usr/include' config/LINUX
sed -i '35c #define ArchRecLibSearch    -L/usr/X11R6/lib64 -L/usr/lib64' config/LINUX
sed -i '36c #define ArchRecIncSearch    -I/usr/X11R6/include -I/usr/include' config/LINUX
#ncarg2d/src/libncarg/conpack/CodeIftran
sed -i "9660c IF ((CEX1(1:1).EQ.' ') .AND. (LCX1 .EQ. 1)) LCX1=0" ncarg2d/src/libncarg/conpack/CodeIftran
sed -i "9662c IF ((CEX2(1:1).EQ.' ') .AND. (LCX2 .EQ. 1)) LCX2=0" ncarg2d/src/libncarg/conpack/CodeIftran
sed -i "9664c IF ((CEX3(1:1).EQ.' ') .AND. (LCX3 .EQ. 1)) LCX3=0" ncarg2d/src/libncarg/conpack/CodeIftran
sed -i "9669a DO (III=1,LBUF)\nCBUF(III:III)=' '\nEND DO" ncarg2d/src/libncarg/conpack/CodeIftran
sed -i "9795c CBUF(1:1)='0'" ncarg2d/src/libncarg/conpack/CodeIftran
#ni/src/ncl/yMakefile
sed -i '46c EXTRA_CCOPTIONS = -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -g -fsigned-char' ni/src/ncl/yMakefile
#common/src/bin/ncargpath/ncargpath.c
sed -i '30a #include <stdlib.h>' common/src/bin/ncargpath/ncargpath.c
#ncarg2d/src/libncarg/plotchar/bofred.c
sed -i "14a #include <sys/types.h>\n#include <sys/stat.h>\n#include <fcntl.h>\n#include <stdlib.h>" ncarg2d/src/libncarg/plotchar/bofred.c
#ncarg2d/src/libncarg/areasC/c_argeti.c
sed -i "14a #include <string.h>" ncarg2d/src/libncarg/areasC/c_argeti.c
#ncarg2d/src/libncarg/ncargC.h
sed -i "182a extern void NGCALLF(agback,AGBACK)(\n#ifdef  NeedFuncProto\nvoid\n#endif\n);\n" ncarg2d/src/libncarg/ncargC.h
#ncarview/src/lib/libncarg_ras/raster.c
sed -i "37a #include <stdlib.h>" ncarview/src/lib/libncarg_ras/raster.c
sed -i "508a int" ncarview/src/lib/libncarg_ras/raster.c
#ncarview/src/lib/libncarg_ras/misc.c
sed -i "60a void" ncarview/src/lib/libncarg_ras/misc.c
sed -i "76a void" ncarview/src/lib/libncarg_ras/misc.c
sed -i "103a int" ncarview/src/lib/libncarg_ras/misc.c
#####################################
#ncarview/src/lib/libncarg_ras/misc.h
cat << EOF > ncarview/src/lib/libncarg_ras/misc.h
int read_swap(FILE *fp, int nb, char *buf, int swapflag);
void _swapshort (register char *bp, register unsigned n);
void _swaplong (register char *bp, register unsigned n);
int ImageCount_(char *name, char *format);
EOF
#####################################
#ncarview/src/lib/libctrans/buffer.c
sed -i "66c void   flush()" ncarview/src/lib/libctrans/buffer.c
sed -i "76c void   buffer(str,count)" ncarview/src/lib/libctrans/buffer.c
####################################
#ncarview/src/lib/libctrans/buffer.h
cat << EOF > ncarview/src/lib/libctrans/buffer.h
#include "ctrandef.h"
int    GcapOpenBuffer(char *file);
void   flush(void);
void   buffer(SignedChar *str, int count);
EOF
###################################
#ncarview/src/lib/libctrans/default.c
sed -i "89c void   InitDefault()" ncarview/src/lib/libctrans/default.c
sed -i "163c void    SetInPic(value)" ncarview/src/lib/libctrans/default.c
sed -i "1280c void SetMinLineWidthDefault(line_width)" ncarview/src/lib/libctrans/default.c
sed -i "1305c void SetMaxLineWidthDefault(line_width)" ncarview/src/lib/libctrans/default.c
sed -i "1320c void SetAdditionalLineScale(line_scale)" ncarview/src/lib/libctrans/default.c
sed -i "1334c void SetRGBIntensityScale(rgb_scale)" ncarview/src/lib/libctrans/default.c
#ncarview/src/lib/libctrans/default.h
sed -i "443a void   InitDefault(void);\nvoid   _CtDefNoColorDefault(void);\nvoid    SetInPic(boolean  value);\nint MFVersion(CGMC *c);\nint MFDesc(CGMC *c);\nint VDCType(CGMC *c);\nint IntergerPrec(CGMC *c);\nint RealPrec(CGMC *c);\nint IndexPrec(CGMC *c);\nint ColrPrec(CGMC *c);\nint ColrIndexPrec(CGMC *c);\nint MaxColrIndex(CGMC *c);\nint ColrValueExt(CGMC *c);\nint MFElemList(CGMC *c);\nint MFDefaults(CGMC *c);\nint CharSetList(CGMC *c);\nint CharCoding(CGMC *c);\nint ScaleMode(CGMC *c);\nint ColrMode(CGMC *c);\nint LineWidthMode(CGMC *c);\nint MarkerSizeMode(CGMC *c);\nint EdgeWidthMode(CGMC *c);\nint VDCExt(CGMC *c);\nint BackColr(CGMC *c);\nint VDCIntergerPrec(CGMC *c);\nint VDCRealPrec(CGMC *c);\nint AuxColr(CGMC *c);\nint Transparency(CGMC *c);\nint ClipRect(CGMC *c);\nint Clip(CGMC *c);\nint LineIndex(CGMC *c);\nint LineType(CGMC *c);\nint LineWidth(CGMC *c);\nint LineColr(CGMC *c);\nint MarkerIndex(CGMC *c);\nint MarkerType(CGMC *c);\nint MarkerSize(CGMC *c);\nint MarkerColr(CGMC *c);\nint TextIndex(CGMC *c);\nint TextFontIndex(CGMC *c);\nint TextPrec(CGMC *c);\nint CharExpan(CGMC *c);\nint CharSpace(CGMC *c);\nint TextColr(CGMC *c);\nint CharHeight(CGMC *c);\nint CharOri(CGMC *c);\nint TextPath(CGMC *c);\nint TextAlign(CGMC *c);\nint CharSetIndex(CGMC *c);\nint AltCharSetIndex(CGMC *c);\nint FillIndex(CGMC *c);\nint IntStyle(CGMC *c);\nint FillColr(CGMC *c);\nint HatchIndex(CGMC *c);\nint PatIndex(CGMC *c);\nint EdgeIndex(CGMC *c);\nint EdgeType(CGMC *c);\nint EdgeWidth(CGMC *c);\nint EdgeColr(CGMC *c);\nint EdgeVis(CGMC *c);\nint FillRefPt(CGMC *c);\nint PatTable(CGMC *c);\nint PatSize(CGMC *c);\nint ColrTable(CGMC *c);\nint ASF(CGMC *c);\nvoid SetMinLineWidthDefault(float line_width);\nvoid SetMaxLineWidthDefault(float line_width);\nvoid SetAdditionalLineScale(float line_scale);\nvoid SetRGBIntensityScale(float rgb_scale); " ncarview/src/lib/libctrans/default.h
#ncarview/src/lib/libctrans/gcaprast.c
sed -i "33a #include       <string.h>" ncarview/src/lib/libctrans/gcaprast.c
sed -i '44a #include       "buffer.h"' ncarview/src/lib/libctrans/gcaprast.c
sed -i '45a #include       "format.h"' ncarview/src/lib/libctrans/gcaprast.c
#ncarview/src/lib/libctrans/in.h
sed -i '18a  #include "cgmc.h"' ncarview/src/lib/libctrans/in.h
sed -i "63a int Instr_Dec(CGMC *cgmc);" ncarview/src/lib/libctrans/in.h
#ncarview/src/lib/libctrans/misc.c
sed -i "26c int CoordStringToInt(s, llx, lly, urx, ury)" ncarview/src/lib/libctrans/misc.c
#ncarview/src/lib/libctrans/misc.h
##################################
cat << EOF > ncarview/src/lib/libctrans/misc.h
int CoordStringToInt(char *s, int *llx, int *lly, int *urx, int *ury);
EOF
##################################
#ncarview/src/lib/libctrans/rast.c
sed -i '19a #include "in.h"' ncarview/src/lib/libctrans/rast.c
sed -i '34a #include "misc.h"' ncarview/src/lib/libctrans/rast.c 
sed -i "96c static int build_ras_arg(ras_argc, ras_argv, rast_opts)" ncarview/src/lib/libctrans/rast.c
sed -i "158c static void clear_grid(grid)" ncarview/src/lib/libctrans/rast.c
sed -i "176c static void init_color_tab()" ncarview/src/lib/libctrans/rast.c
sed -i "190c void get_resolution(dev_extent, opts, name)" ncarview/src/lib/libctrans/rast.c
#ncarview/src/lib/libncarg_ras/sunraster.c
sed -i "48a #include <unistd.h>" ncarview/src/lib/libncarg_ras/sunraster.c
sed -i '58a #include "misc.h"' ncarview/src/lib/libncarg_ras/sunraster.c
sed -i "227c nb = write(ras->fd, dep, sizeof(SunInfo));" ncarview/src/lib/libncarg_ras/sunraster.c
sed -i "232c nb = write(ras->fd, ras->red, ras->ncolor);" ncarview/src/lib/libncarg_ras/sunraster.c
sed -i "235c nb = write(ras->fd, ras->green, ras->ncolor);" ncarview/src/lib/libncarg_ras/sunraster.c
sed -i "238c nb = write(ras->fd, ras->blue, ras->ncolor);" ncarview/src/lib/libncarg_ras/sunraster.c
#END_INCLUDE_PATCH############################################################

#LNETCDFF#####################################################################
#ni/src/scripts/nhlf77.csh
sed -i '67c set extra_libs = "$extra_libs SED_NCDFLIBS -lnetcdff"' ni/src/scripts/nhlf77.csh
#END_LNETCDFF#################################################################


#Other######################
#common/src/fontcap/yMakefile
sed -i '46c .fc: $(FONTC)' common/src/fontcap/yMakefile

#ni/src/scripts/yMakefile
sed -i '9a InstallTarget($(SCRIPTS1),$(INSTALL_BIN),$(BINPATH))' ni/src/scripts/yMakefile
sed -i '10a InstallTarget($(SCRIPTS2),$(INSTALL_BIN),$(BINPATH))' ni/src/scripts/yMakefile
sed -i '11a CleanFilesTarget($(SCRIPTS1))' ni/src/scripts/yMakefile
sed -i '12a InstallManPages($(MAN1),$(FORMAT_EXT),$(MAN1PATH),$(MAN1_SECTION))' ni/src/scripts/yMakefile
sed -i '13a FormatManPages($(MAN1),.m,.p)' ni/src/scripts/yMakefile
sed -i '79,83d'	ni/src/scripts/yMakefile

#config/Rules
sed -i '82c install-local:: ]\' config/Rules

#config/ymake
sed -i '187a set share_dir = `ncargpath share`' config/ymake
sed -i '188a if ($status != 0) then' config/ymake
sed -i '189a echo "$0 : Unable to find NCARG_SHARE dir" > /dev/tty' config/ymake
sed -i "190a exit 1\nendif" config/ymake
sed -i '192a set defines = ($defines -D_InstShare\=$share_dir)' config/ymake

#config/Template
sed -i "165a #ifndef        ShareRoot\n#ifndef        _IgnoreYmakeRoot\n#define        ShareRoot       YmakeRoot/share\n#else\n#define        ShareRoot       _InstShare\n#endif /* _IgnoreYmakeRoot */\n#endif /* ShareRoot */\n" config/Template
sed -i "224a #ifndef        SharePath\n#ifdef _UseRootPath\n#define        SharePath       RootPath/share\n#else\n#define        SharePath       ShareRoot\n#endif\n#endif\n" config/Template
sed -i "623a SHAREPATH              = SharePath" config/Template

#config/Project
sed -i '384c LIBNCARGROOT           = $(SHAREPATH)/$(NCARGDIR)' config/Project
sed -i '384a LIBNCARGARCH           = $(LIBPATH)/$(NCARGDIR)' config/Project
sed -i '393c ROBJROOT               = $(LIBNCARGARCH)/$(ROBJDIR)' config/Project
sed -i '402c LIBNCARGPATH           = $(SHAREPATH)/$(NCARGDIR)' config/Project

sed -i '410c ROBJPATH               = $(LIBNCARGARCH)/$(ROBJDIR)' config/Project
sed -i '472c "lib",NULL,NULL,"$(LIBROOT)",NULL,                      \\' config/Project
sed -i '473a "share",NULL,"root",NULL,NULL,                  \\' config/Project
sed -i '476c "ncarg",NULL,"share",NULL,NULL,                 \\' config/Project

#config/ymake		line+6
sed -i '374c case    ppc*:' config/ymake
sed -i '381c case    aarch64:' config/ymake
sed -i '384c set sysincs = LINUX' config/ymake
sed -i '385c set vendor  = ARM' config/ymake
sed -i '374a case    s390*:' config/ymake
sed -i '375a case    sparc*:' config/ymake

#ncarg2d/src/libncarg_gks/bwi/argb2ci.f
sed -i "19c parameter (ARGBMASK = INT(Z'40000000'))" ncarg2d/src/libncarg_gks/bwi/argb2ci.f
sed -i "20c  parameter (RMASK     = INT(Z'00FF0000'))" ncarg2d/src/libncarg_gks/bwi/argb2ci.f
sed -i "21c parameter (GMASK     = INT(Z'0000FF00'))" ncarg2d/src/libncarg_gks/bwi/argb2ci.f
sed -i "22c parameter (BMASK     = INT(Z'000000FF'))" ncarg2d/src/libncarg_gks/bwi/argb2ci.f
sed -i "34c r = (iand(index, RMASK) / INT(Z'0000FFFF')) / 255." ncarg2d/src/libncarg_gks/bwi/argb2ci.f
sed -i "35c g = (iand(index, GMASK) / INT(Z'000000FF')) / 255." ncarg2d/src/libncarg_gks/bwi/argb2ci.f

#ni/src/lib/nfp/ripW.c
sed -i "536c fputs(errmsg, stderr);" ni/src/lib/nfp/ripW.c
sed -i "1083c fputs(errmsg, stderr);" ni/src/lib/nfp/ripW.c

#ni/src/lib/nfp/wrfW.c
sed -i "1517c fputs(errmsg, stderr);" ni/src/lib/nfp/wrfW.c
sed -i "9224c fputs(errmsg, stderr);" ni/src/lib/nfp/wrfW.c
sed -i "9870c fputs(errmsg, stderr);" ni/src/lib/nfp/wrfW.c
sed -i "10532c fputs(errmsg, stderr);" ni/src/lib/nfp/wrfW.c
sed -i "11235c fputs(errmsg, stderr);" ni/src/lib/nfp/wrfW.c
sed -i "13623c fputs(errmsg, stderr);" ni/src/lib/nfp/wrfW.c

#ni/src/lib/nfp/wrf_vinterpW.c
sed -i "822c fputs(errmsg, stderr);" ni/src/lib/nfp/wrf_vinterpW.c

#ni/src/ncl/yMakefile--vim ncl-gdal.patch
sed -i '201c # EXTRA_LIBS      =    $(NCDFLIBS) $(HDFEOS5LIB) $(NETCDF4LIB) $(HDFEOSLIB) $(HDFLIB) $(HDF5LIB) $(GRIB2LIB) $(GDALLIB) $(GRIDSPECLIB) $(UDUNITSLIB) $(V5DLIB) $(PNGLIB) $(CAIROLIB) $(SPHERELIB) $(FFTPACK5LIB) -fast -xlic_lib=sunperf		-lnsl -lintl -lsocket -ldl -lw -lfui' ni/src/ncl/yMakefile
sed -i '202c EXTRA_LIBS      =      $(NCDFLIBS) $(HDFEOS5LIB) $(NETCDF4LIB) $(HDFEOSLIB) $(HDFLIB) $(HDF5LIB) $(GRIB2LIB) $(GDALLIB) $(GRIDSPECLIB) $(OpenCLLIB) $(UDUNITSLIB) $(V5DLIB) $(PNGLIB) $(CAIROLIB) $(EEMDLIB) $(EXTERNALLIBS) -lnsl -lintl -lsocket -ldl -lw' ni/src/ncl/yMakefile
sed -i '204c EXTRA_LIBS      =      $(NCDFLIBS) $(HDFEOS5LIB) $(NETCDF4LIB) $(HDFEOSLIB) $(HDFLIB) $(HDF5LIB) $(GRIB2LIB) $(GDALLIB) $(GRIDSPECLIB) $(OpenCLLIB) $(UDUNITSLIB) $(V5DLIB) $(PNGLIB) $(CAIROLIB) $(EEMDLIB) $(EXTERNALLIBS) -lxlf90 -lxlopt' ni/src/ncl/yMakefile
sed -i '206c EXTRA_LIBS      =      $(NCDFLIBS) $(HDFEOS5LIB) $(NETCDF4LIB) $(HDFEOSLIB) $(HDFLIB) $(HDF5LIB) $(GRIB2LIB) $(GDALLIB) $(GRIDSPECLIB) $(OpenCLLIB) $(UDUNITSLIB) $(V5DLIB) $(PNGLIB) $(CAIROLIB) $(EEMDLIB) $(EXTERNALLIBS)' ni/src/ncl/yMakefile
sed -i '208c EXTRA_LIBS      =      $(NCDFLIBS) $(HDFEOS5LIB) $(NETCDF4LIB) $(HDFEOSLIB) $(HDFLIB) $(HDF5LIB) $(GRIB2LIB) $(GDALLIB) $(GRIDSPECLIB) $(OpenCLLIB) $(UDUNITSLIB) $(V5DLIB) $(PNGLIB) $(CAIROLIB) $(EEMDLIB) $(EXTERNALLIBS)' ni/src/ncl/yMakefile

#ncarview/src/bin/ictrans/yMakefile
sed -i "31a #else\nMORE_LIBS      = -lm" ncarview/src/bin/ictrans/yMakefile

##################################END########################################

./Configure -v


make Everything
make all install
