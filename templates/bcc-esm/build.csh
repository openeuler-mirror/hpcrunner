#! /bin/csh -f

setenv NETCDF ${NETCDF_DIR}
setenv MPI_ROOT ${MPI_DIR}


limit datasize  unlimited
setenv XLSMPOPTS stack=860000000
setenv OMP_STACKSIZE 3G

setenv Atmosphere_Model     CAM3
setenv System_Time_Type     day                  # month/day
setenv Integration_Time     2
setenv Runoff_clm_ann       .true.
setenv carbon               .true.

##-------------wangln For Multi CPL-------------------------------------
echo -------------------------------------------------------------------------
set PATH=/bin 
set PATH=($PATH /usr/bin )
set PATH=($PATH /usr/sbin ) 
set PATH=($PATH /usr/lpp/ssp/bin )
set PATH=($PATH /usr/lpp/ssp/kerberos/bin)
set PATH=($PATH /usr/lpp/LoadL/full/bin /usr/local/lib/grads /usr/sbin/acct)
set PATH=($PATH /usr/java130/bin /u/weimin/soft /usr/local/bin)
set PATH=($PATH /usr/dt/bin /usr/lpp/X11/lib /usr/bin/X11)
set PATH=($PATH /usr/dt/bin /usr/X11R6/lib /usr/bin/X11)
echo -------------------------------------------------------------------------
echo -------------------------------------------------------------------------
echo  b1. Set case sensitive environment variables available to model setup scripts 
echo -------------------------------------------------------------------------
setenv CASE        historical                       # case name
setenv GRID        T382_gxp25
setenv RUNTYPE     startup                          # startup, continue, branch, hybrid
setenv SETBLD      auto                             # auto, true, false
setenv BASEDATE    2001-01-01     

setenv INIFILEDATE 2001-01-01
setenv OCNINIFILEDATE 20010101.000000

setenv CASESTR    "Datm CLM3 MOM SIS 0 Start"       # short descriptive text string
setenv CSMROOT     $MODEL_PATH                       # root directory of source
#############################################################################
# allocate exe directory
#############################################################################
setenv EXEROOT     $WORK_PATH/output

#############################################################################
setenv ARCROOT     $WORK_PATH/RESULT/ARC            # archive root directory 
setenv REFCASE     $WORK_PATH/RESTART               # Runtype=branch data case
setenv REFDATE     0001-01-06                       # Runtype=branch start date

echo -------------------------------------------------------------------------
echo  b2. Select multi-processing and resolution specs 
echo      The task and thread settings depend on the grid being used
echo      Use NTASK=1 and NTHRD=1 for data models
echo -------------------------------------------------------------------------

set MODELS  = (  atm   lnd   ice   ocn   cpl )  # generic model names.
set SETUPS  = ( bccam3.0  bccavim3.0 sis  mom   cpl5.3 )  # setup script name
set NTASKS=(   992  104  64   200  4  )
set NTHRDS=(   4    4   4     1     4  )
echo -------------------------------------------------------------------------
echo  c. The following environment variables can be set by the user but
echo     by default are derived from the environment variables above 
echo -------------------------------------------------------------------------

setenv MSSNAME `echo $LOGNAME | tr '[a-z]' '[A-Z]'`  # LOGNAME in caps

setenv MSSDIR   mss:$WORK_PATH/RESULT          # MSS directory path name
setenv MSSRPD   0                                # MSS file retention period
setenv MSSPWD   $LOGNAME                         # MSS file write password

setenv SCRIPTS  $WORK_PATH           # run scripts are here
setenv TOOLS    $MODEL_PATH/tools           # some tools are here
setenv LOGDIR   $EXEROOT/RESULT      # save stdout here
setenv CSMCODE  $MODEL_PATH/models       # base dir for src code
setenv CSMUTL   $CSMCODE/utils            # Util directory
setenv CSMSHR   $CSMCODE/csm_share        # shared code dir
setenv CSMBLD   $CSMCODE/bld              # makefiles are here
setenv LID      "`date +%y%m%d-%H%M%S`"          # time-stamp/file-ID string

setenv OBJROOT  $WORK_PATH/OBJ                         # build code here
setenv LIBROOT  $MODEL_PATH/lib                     # Location of supplemental libraries
setenv INCROOT  $LIBROOT/include                 # Location of supplemental includes/modfiles

setenv LFSINP  $CSMDATA                       # LOCAL INPUTDATA FSROOT
setenv LMSINP  $WORK_PATH/INIDATA                # LOCAL INPUTDATA MSROOT
setenv LMSOUT  $EXEROOT/RESULT            # LOCAL OUTPUT MSROOT
setenv MACINP  dataproc.ucar.edu              # REMOTE INPUT MACHINE
setenv RFSINP  /fs/cgd/ccsm/inputdata          # REMOTE INPUTDATA FSROOT
setenv RMSINP  /CCSM/inputdata                # REMOTE INPUTDATA MSROOT
setenv MACOUT  dataproc.ucar.edu              # REMOTE OUTPUT MACHINE
setenv RFSOUT  /fc44/$LOGNAME/archive/$CASE   # REMOTE OUTPUT FSROOT

#--- logic to set BLDTYPE based on SETBLD above
setenv BLDTYPE $SETBLD
if ($SETBLD =~ auto*) then
  setenv BLDTYPE true
  if ($RUNTYPE == 'continue') setenv BLDTYPE false
endif
if ($BLDTYPE != 'true' && $BLDTYPE != 'false') then
  echo "error in BLDTYPE: $BLDTYPE"
  exit 1
endif

echo -------------------------------------------------------------------------
echo  d.  Determine os/machine/site 
echo -------------------------------------------------------------------------

setenv OS `uname -s`          # operating system
setenv ARCH AARCH64
setenv MACH ifc  
setenv MACHKEY `hostname`
setenv SITE NCC

echo -------------------------------------------------------------------------
echo  e.  Create ccsm_joe
echo -------------------------------------------------------------------------

setenv CSMJOE $SCRIPTS/ccsm_joe
rm -f $CSMJOE
$TOOLS/ccsm_checkenvs > $CSMJOE

echo -------------------------------------------------------------------------
echo  f. Prepare $GRID component models for execution 
echo      - create execution directories for atm,cpl,lnd,ice,ocn              
echo      - invoke component model setup scripts found in $SCRIPTS 
echo -------------------------------------------------------------------------

setenv ATM_GRID `echo $GRID | sed s/_.\*//`; setenv LND_GRID   $ATM_GRID 
setenv OCN_GRID `echo $GRID | sed s/.\*_//`; setenv ICE_GRID   $OCN_GRID

#--- create working directories
foreach DIR ( $EXEROOT $LIBROOT $INCROOT $OBJROOT $LOGDIR)
  if !(-d $DIR) mkdir -p $DIR
end
#--- run machine dependent commands (i.e. modules on SGI).
echo $TOOLS/modules.$OS.$MACH 
###if (-f $TOOLS/modules.$OS.$MACH) source $TOOLS/modules.$OS.$MACH  || exit 1 ###if (-f $TOOLS/modules.$OS.$MACH) module load emacs null GNU.tools MASS netcdf 
#--- create env variables for use in components
foreach n (1 2 3 4 5)
  set model = $MODELS[$n]
  setenv ${model}_dir $EXEROOT/$model; setenv ${model}_setup $SETUPS[$n]  
  setenv ${model}_in  $model.stdin   ; setenv ${model}_out $model.log.$LID
  echo ${model}_in
end
#--- get restart files
#$TOOLS/ccsm_getrestart
echo -------------------------------------------------------------------------
echo  g. Build Earth System Modeling Framework   http://www.esmf.ucar.edu 
echo -------------------------------------------------------------------------

setenv EXEDIR $EXEROOT/esmf     ; if !(-d $EXEDIR) mkdir -p $EXEDIR
cd $EXEDIR
echo `date` $EXEDIR/esmf.log.$LID | tee esmf.log.$LID
if ( $argv[1] == 1 ) then
  $SCRIPTS/esmf.setup.csh >>& esmf.log.$LID || exit 1
endif

echo -------------------------------------------------------------------------
echo  h. Execute component setup.csh scripts, build models
echo -------------------------------------------------------------------------

foreach n (1 2 3 4 5)
#--- activate stdin/stdout redirect work-around ---
#--- setup env variables for components and grids ---
  setenv MODEL  $MODELS[$n]         ; setenv SETUP  $SETUPS[$n]
  setenv NTHRD  $NTHRDS[$n]         ; setenv NTASK  $NTASKS[$n]
  setenv OBJDIR $OBJROOT/$MODEL/$SETUP ; if !(-d $OBJDIR) mkdir -p $OBJDIR
  setenv EXEDIR $EXEROOT/$MODEL     ; if !(-d $EXEDIR) mkdir -p $EXEDIR
  setenv THREAD FALSE               ; if ($NTHRD > 1) setenv THREAD TRUE

  set ntask = $NTASKS[$n]
 
  cd   $EXEDIR
#xjx  rm -f $MODEL.log.*
  echo `date` $EXEDIR/$MODEL.log.$LID | tee $MODEL.log.$LID
  echo $SCRIPTS/$SETUP.setup.csh
if ( $argv[1] == 1 ) then
  $SCRIPTS/$SETUP.setup.csh             >>& $MODEL.log.$LID
endif
  if ($status != 0) then
    echo  ERROR: $MODEL.setup.csh failed, see $MODEL.log.$LID 
    echo  ERROR: cat $cwd/$MODEL.log.$LID 
    exit  99
  endif

#--- create model directories and processor counts for each platform
#--- ($EXEROOT/all for SGI, poe_sw.cmdfile for AIX, prun.cmdfile for OSF1)

if ($n == 1) then
rm -rf  $EXEROOT/csm.conf
set P1 = 0
set P2 = 0
endif
set P2 = `expr $P1 + $NTASK - 1`
echo "$P1-$P2   $EXEROOT/$MODEL/$MODEL" >> $EXEROOT/csm.conf
set P1 = `expr $P2 + 1`

end

if ( $argv[1] == 2 ) then
  cd $EXEROOT
  rm -rf atm/historical.cam2* atm/atm.log.* cpl/cpl.log.* esmf/esmf.log.* ice/ice.log.* lnd/lnd.log.* 
  rm -rf ocn/ocn.log.* esm_* esm_err_*
  echo -------------------------------------------------------------------------
  echo  j. Run the model, execute models simultaneously allocating CPUs
  echo -------------------------------------------------------------------------
  echo "`date` -- CSM EXECUTION BEGINS HERE"
  setenv I_MPI_COMPATIBILITY 4
  setenv KMP_AFFINITY        compact
  echo "`date` -- CSM JOB SUBMIT HAS FINISHED"
  chmod +x run.sh
  dsub -s run.sh
  env | egrep '(MP_|LOADL|XLS|FPE|DSM|OMP|MPC)' # document above env vars
endif
exit 0
