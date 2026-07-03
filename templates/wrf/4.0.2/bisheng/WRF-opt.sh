cat << \EOF > ./arch/configure.defaults
###########################################################
#ARCH   Linux   aarch64,clang HYPERMPI#serial smpar dmpar dm+sm
DESCRIPTION     =       CLANG ($SFC/$SCC)
DMPARALLEL      =        #1
OMPCPP          =       #-D_OPENMP
OMP             =       #-fopenmp
OMPCC           =       #-fopenmp
SFC             =       flang
SCC             =       clang
CCOMP           =       clang
DM_FC           =       mpif90 -f90=$(SFC)
DM_CC           =       mpicc -cc=$(SCC) -DMPI2_SUPPORT
FC              =       CONFIGURE_FC
CC              =       CONFIGURE_CC
LD              =       $(FC)
RWORDSIZE       =       CONFIGURE_RWORDSIZE
PROMOTION       =       #-fdefault-real-8
ARCH_LOCAL      =       -DNONSTANDARD_SYSTEM_SUBR  -DWRF_USE_CLM
CFLAGS_LOCAL    =       -w -O3 -c -Mcache_align -march=armv8.5-a+sve -fvectorize -funroll-loops -L${BISHENG_ROOT}/lib -I${BISHENG_ROOT}/include -I/usr/include/tirpc -Wno-implicit-function-declaration -Wno-implicit-int -mcpu=hip09
LDFLAGS_LOCAL   =       -ltirpc
FCOPTIM         =       -O3 -Mcache_align -march=armv8.5-a+sve  -fveclib=KPL_SVML_SVE -fvectorize -funroll-loops -ffast-math -fhonor-nans -mllvm -unroll-indirect-loads=true -fopenmp -fstack-arrays -L${BISHENG_ROOT}/lib  -Wl,-rpath,${BISHENG_ROOT}/lib -L${KML_ROOT}/lib/sve -lksvml -L${KML_ROOT}/lib/noarch -mllvm -prefetch-loop-depth=3 -mllvm -min-prefetch-stride=16 -mllvm -prefetch-distance=940 -lkm -lmathlib -lm -mcpu=hip09
FCREDUCEDOPT    =       $(FCOPTIM)
FCNOOPT         =       -O1 -Wno-implicit-function-declaration -Wno-implicit-int
FCDEBUG         =       -g -Wno-implicit-function-declaration -Wno-implicit-int # -fbacktrace -ggdb-fcheck=bounds,do,mem,pointer -ffpe-trap=invalid,zero,overflow
FORMAT_FIXED    =       -ffixed-form
FORMAT_FREE     =       -ffree-form -ffree-line-length-0
FCSUFFIX        =
BYTESWAPIO      =       -fconvert=big-endian
FCBASEOPTS_NO_G =       -w $(FORMAT_FREE) $(BYTESWAPIO)
FCBASEOPTS      =       -march=armv8.5-a+sve $(FCBASEOPTS_NO_G) $(OMP)
MODULE_SRCH_FLAG=      -I$(WRF_SRC_ROOT_DIR)/main
TRADFLAG        =      -traditional
CPP             =      /lib/cpp -P
AR              =      ar
ARFLAGS         =      ru
M4              =      m4 -G
RANLIB          =      ranlib
RLFLAGS         =
CC_TOOLS        =      $(SCC) -Wno-implicit-function-declaration -Wno-implicit-int
###########################################################
#ARCH  NULL
EOF
sed -i 's/derf/erf/g' ./phys/module_mp_SBM_polar_radar.F

