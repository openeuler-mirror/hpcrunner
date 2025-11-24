#yum  install libcurl-devel  --disablerepo="*" --enablerepo="JARVIS_SYS_CDROM" --config=$(pwd)/templates/top50/system/openEuler_22.03SP4/etc/yum.repos.d/openEuler.repo
opt=""
# for hdf5
# zlib-devel: /usr/include/zlib.h
CUR=$(pwd)
mode=$1
mode=$(echo "$mode" | tr '[:upper:]' '[:lower:]')

echo "mode:$mode"
packages=(
autoconf automake autoconf
tcsh ksh time
# for compress
zlib zlib-devel bzip2 bzip2-devel xz-devel xz xz-lzma-compat
curl libcurl libcurl-devel
ncurses ncurses-base ncurses-libs ncurses-devel

### BAD: patchelf
gtest
guile-devel
ImageMagick
openssl openssl-devel

libffi-devel
libffi
libjpeg-turbo-devel

libmpcdec 
libmpcdec-devel

libdrm-devel

# for png
libpng-devel libpng libpng-tools
# for system xll
libX11 libX11-devel libXpm libXpm-devel libXft libXft-devel libXext libXext-devel
libX11 libX11-devel libXaw libXaw-devel libXt-devel xorg-x11-xauth xorg-x11-server-utils xorg-x11-server-Xnest libXtst

# for perl
perl perl-Algorithm-Diff perl-Archive-Tar perl-B-Debug perl-Bit-Vector
perl-CPAN-Meta perl-CPAN-Meta-Requirements perl-CPAN-Meta-YAML perl-Carp perl-Carp-Clan perl-Class-Inspector
perl-Compress-Raw-Bzip2 perl-Compress-Raw-Zlib perl-Config-Perl-V
perl-DBD-MySQL perl-DBD-SQLite perl-DBI
perl-Data-Dump perl-Data-Dumper perl-Date-Calc perl-Date-Manip
perl-Devel-PPPort perl-Digest perl-Digest-HMAC perl-Digest-MD5 perl-Digest-SHA
perl-Encode perl-Encode-Locale perl-Env perl-Error perl-Exporter perl-ExtUtils-Command
perl-ExtUtils-Install perl-ExtUtils-MakeMaker perl-ExtUtils-Manifest perl-ExtUtils-ParseXS
perl-File-Fetch perl-File-Listing perl-File-Path
perl-File-ShareDir perl-File-Slurp perl-File-Temp perl-Filter perl-Filter-Simple
perl-Getopt-Long  perl-Git perl-HTML-Parser perl-HTML-Tagset
perl-HTTP-Cookies perl-HTTP-Date perl-HTTP-Message perl-HTTP-Negotiate perl-HTTP-Tiny
perl-IO-Compress perl-IO-HTML perl-IO-Socket-IP perl-IO-Socket-SSL
perl-IPC-Cmd perl-IPC-SysV perl-IPC-System-Simple perl-JSON perl-JSON-PP
perl-LWP-MediaTypes perl-Locale-Codes perl-Locale-Maketext
perl-MIME-Base64 perl-Math-BigInt perl-Math-BigInt-FastCalc perl-Math-BigRat
perl-Module-CoreList perl-Module-Load perl-Module-Load-Conditional perl-Module-Metadata perl-Mozilla-CA
perl-NTLM perl-Net-HTTP perl-Net-SSLeay perl-PCP-LogImport perl-PCP-LogSummary perl-PCP-MMV perl-PCP-PMDA
perl-Params-Check perl-PathTools perl-Perl-OSType perl-PerlIO-via-QuotedPrint 
perl-Pod-Checker perl-Pod-Escapes perl-Pod-Parser perl-Pod-Perldoc perl-Pod-Simple perl-Pod-Usage
perl-Scalar-List-Utils perl-Socket perl-Storable perl-Switch perl-Sys-Syslog
perl-Term-ANSIColor perl-Term-Cap perl-TermReadKey perl-Test-Harness perl-Test-Simple
perl-Text-Balanced perl-Text-Diff perl-Text-ParseWords perl-Text-Tabs+Wrap 
perl-Text-Unidecode perl-Thread-Queue perl-Time-HiRes perl-Time-Local perl-TimeDate perl-Try-Tiny
perl-URI perl-Unicode-Collate perl-Unicode-EastAsianWidth perl-Unicode-Normalize perl-WWW-RobotRules
perl-XML-LibXML perl-XML-NamespaceSupport perl-XML-Parser perl-XML-SAX perl-XML-SAX-Base perl-YAML-LibYAML 
perl-autodie perl-bignum perl-constant perl-devel
perl-experimental perl-generators perl-libintl-perl perl-libnet perl-libs perl-libwww-perl perl-parent 
perl-perlfaq perl-podlators perl-threads perl-threads-shared
### for other

memkind memkind-devel
bison
byacc
libtool
cairo cairo-devel cairo-gobject cairo-gobject-devel cairo-tools cairomm cairomm-devel
expat expat-devel lua-expat
environment-modules
freetype freetype-devel
flex flex-devel
gcc gcc-gfortran gcc-c++ libgfortran libgomp
gettext gettext-devel
libxml2 libxml2-devel
latex2html 
libtirpc-devel libtirpc
libcap-devel libcap
m4
pkgconf pkgconf-devel
tk tk-devel tcl tcl-devel
bc
fontconfig fontconfig-devel
gdbm gdbm-devel
pixman pixman-devel
sqlite sqlite-devel
readline readline-devel
avahi-compat-libdns_sd-devel
cfitsio cfitsio-devel
fltk fltk-devel
ftgl ftgl-devel
fftw fftw-devel
freeglut freeglut-devel
gsl-devel glibc glibc-devel 
glew glew-devel 
graphviz-devel
libtiff libtiff-devel

# for python
python3 python3-devel python3-numpy  python3-setuptools python3-pip python3-virtualenv python3-bind python3-decorator python3-ply python3-slip

cmake
libtirpc-devel
libcap-devel
m4
perl
patch
perf
bc
bzip2-devel
fontconfig-devel
gdbm-devel
libX11
libX11-devel 
pixman-devel
cfitsio-devel
ftgl-devel
guile-devel
gsl-devel
glew
glew-devel 
graphviz-devel
git
libmpc-devel
libmpcdec 
libmpcdec-devel 
libdrm-devel
libxcb  
libxcb-devel
libXpm
libXpm-devel
libXft
libXext
libXcursor
libXi
libXtst
libXrandr
libXt-devel
libXaw-devel
libXext-devel
libXi-devel
libtirpc-devel
libxslt
libxslt-devel
libXmu-devel
libXmu
libSM-devel
libXrender-devel 
libXinerama-devel
mpfr-devel
mesa-libEGL
mesa-libEGL-devel
mesa-libGL-devel
mesa-libglapi
mesa-vulkan-drivers 
mesa-vdpau-drivers
mesa-libgbm
mesa-libgbm-devel
mesa-libxatracker-devel
mesa-libxatracker 
mesa-libOSMesa-devel 
mesa-libOSMesa  
# mesa-libGLU-devel instead of mesa-libGLU 
mesa-libGLU-devel 
mesa-libGL 
mesa-libGL-devel 
gmp-devel 
libmpc 
perl-ExtUtils-MakeMaker
pcre-devel
pcre2-devel
uuid-devel
swig
xorg-x11-xauth xorg-x11-server-utils xorg-x11-server-Xnest
xerces-c xerces-c-devel
ant
alsa-lib
#boost-python
# lapack instead of blas
lapack lapack-devel
#boost
gnuplot
fribidi-devel
harfbuzz-devel
hdf5-devel
libXcomposite
libXdamage
java-1.8.0-openjdk-devel
libICE-devel
libgit2-devel
openblas-devel
### openmpi-devel
tbb
tbb-devel
systemd-devel
valgrind valgrind-devel
xerces-c-devel
util-linux
libXScrnSaver
nmon


rpm-build
abattis-cantarell-fonts
coreutils
cronie
cryptsetup
dejavu-fonts
dnf dnf-plugins-core
dosfstools
hostname
ipmitool
iproute
iprutils
iputils
kbd
lshw
lsscsi
net-snmp
procps-ng
rng-tools
rpm
rsync
sg3_utils
sysfsutils
util-linux
wget
expect
net-tools
nfs-utils
traceroute
lsof
dos2unix
libnl3
pciutils
sysstat
acl
rpm-build
attr
numactl numactl-devel
lldpad
libxalarm
sysSentry
cpu_sentry
zip
bc
libatomic
libstdc++
# BAD: openmpi for  libmca*
isl
binutils
# BAD: openmpi, mpich for libmpi*
# OpenIPMI instead of OpenIPMI*
OpenIPMI
# no require,nfs-utils instead of exportfs*
# vim vim-common vim-minimal
gperftools gperftools-devel gperftools-libs
openmotif-devel openmotif
libglvnd-devel libglvnd
# signuarity
libseccomp-devel squashfs-tools cryptsetup
)

packages_sorted_unique=($(printf "%s\n" "${packages[@]}" | sort  -u))

function install_rpm()
{
	local rpm=$1
	echo "=============$1============="
	yum  install ${rpm}  -y \
		--disablerepo="*" --enablerepo="JARVIS_SYS_CDROM" \
		--config=$(pwd)/templates/top50/system/openEuler_22.03SP4/etc/yum.repos.d/openEuler.repo
	res=$?
	return $res
}

rm -f rpms_request.txt
for ((i=0; i<${#packages_sorted_unique[@]}; i++));
do
	rpm_name=${packages_sorted_unique[i]}
	printf "%-64s\n" "${rpm_name}"  >> rpms_request.txt
done

case $mode in
	install)
	logfile=install_rpms_log.txt
		rm -f $logfile
		for ((i=0; i<${#packages_sorted_unique[@]}; i++)); 
		do
			rpm_name=${packages_sorted_unique[i]}
			ret=$(rpm -qa "$rpm_name")
			if [[ "$ret" != "$rpm_name"* ]]; then
				if install_rpm "${rpm_name}" ; then
					printf "%-64s,OK\n" "${rpm_name}"  | tee -a $logfile
				else
					printf "%-64s,FAILED\n" "${rpm_name}"  | tee -a $logfile
				fi

			else
				printf "%-64s,EXIST\n" "${rpm_name}"  | tee -a $logfile

			fi
												                
		done
		echo "Output file:$logfile"
		;;
	verify)
		rm -f verify_rpms_data.txt
		for ((i=0; i<${#packages_sorted_unique[@]}; i++)); 
		do
			    rpm_name=${packages_sorted_unique[i]}
			    ret=$(rpm -qa "$rpm_name")
			    if [[ "$ret" != "$rpm_name"* ]]; then
					printf "%-64s,FALSE\n" "${rpm_name}"  | tee -a verify_rpms_data.txt
			    else
				    	printf "%-64s,TRUE\n" "${rpm_name}"  | tee -a verify_rpms_data.txt

			    fi
												                
		done
		echo "Output file:verify_rpms.txt"

		;;
	*)

		echo -e "Usage: \r\n\t$0 install, for install all packages\r\n\t$0 verify, for verify rpm from system.output verify_rpms.txt"		exit 1
esac
echo "bye !!!"
exit 0
