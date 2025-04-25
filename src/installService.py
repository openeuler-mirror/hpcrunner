#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
import sys
import re
import fnmatch
from enum import Enum
from glob import glob
from typing import Tuple, Optional, Dict

from dataService import DataService
from toolService import ToolService
from executeService import ExecuteService
from jsonService import JSONService
from installStrategy import PathStrategyFactory
from installTypes import InstallMode
from versionParser import VersionParser
from detectorService import GCCDetector, ClangDetector,NVCCDetector,ICCDetector
from detectorService import HMPIDetector, OpenMPIDetector, MPICHDetector
from softwareFactory import SoftwareFactory
from softwareTypes import SoftwareType

class Singleton(type):

    def __init__(self, name, bases, dictItem):
        super(Singleton,self).__init__(name,bases, dictItem)
        self._instance = None

    def __call__(self, *args, **kwargs):
        if self._instance is None:
            self._instance = super(Singleton,self).__call__(*args, **kwargs)
        return self._instance

class InstallService(object,metaclass=Singleton):
    PACKAGE = 'package'
    FULL_VERSION='full_version'
    def __init__(self):
        self.ds = DataService()
        self.exe = ExecuteService()
        self.tool = ToolService()
        self.software_factory = SoftwareFactory()
        self.ROOT = os.getcwd()

        self.gcc_detector = GCCDetector()
        self.clang_detector = ClangDetector()
        self.icc_detector = ICCDetector()
        self.nvcc_detector = NVCCDetector()

        self.hmpi_detector = HMPIDetector()
        self.openmpi_detector = OpenMPIDetector()
        self.mpich_detector = MPICHDetector()
        
        self._mode = self._detect_mode()
        self._init_paths()
        self.INSTALL_INFO_PATH = os.path.join(self.SOFTWARE_PATH, "install.json")
        self._is_first_install = self._set_first_install()
        self.IS_PRO = self._mode == InstallMode.PRO
        self.IS_NORMAL = self._mode == InstallMode.NORMAL
        self.PACKAGE_PATH = os.path.join(self.ROOT, self.PACKAGE)
        self.dependencies = False       
        self.LINK_FILE = os.path.join(self.MODULE_FILES,'linkpathtomodules.sh')
        self._create_install_json(self.INSTALL_INFO_PATH)
        self._validate_installation()
        self._prepare_infrastructure()

    def _create_install_json(self, filename):
        if self._is_first_install:
            self.tool.write_file(filename, "{}")
            self.json = JSONService(filename)
            self.json.set("MODE", self._mode.value, True)
            return
        # 处理老的目录结构
        self.json = JSONService(filename)
        stored_mode = self.json.get('MODE')
        if not stored_mode:
            self.json.set("MODE", InstallMode.PRO.value, True)

    def _set_first_install(self):
        if not os.path.exists(self.INSTALL_INFO_PATH):
            return True
        return False

    def _detect_mode(self) -> InstallMode:
        """安全模式检测"""
        env_mode = os.getenv('JARVIS_MODE')
        if env_mode not in (InstallMode.PRO.value, InstallMode.NORMAL.value):
            print(f"Invalid JARVIS_MODE: {env_mode}")
            sys.exit()
        modes = {"1": "normal", "0": "professional"}
        print(f"current MODE: {modes.get(env_mode)}")
        return InstallMode(env_mode)

    def _init_paths(self) -> Dict[str, str]:
        """路径初始化策略化"""
        strategy = PathStrategyFactory.create(self._mode)
        self._paths = strategy.get_paths()
        for attr, cur_path in self._paths.items():
            setattr(self, attr, cur_path)

    def _validate_installation(self) -> None:
        """安装一致性校验"""
        stored_mode = self.json.get('MODE')
        if stored_mode and stored_mode != self._mode.value:
            print(f"Mode conflict: Current {self._mode.value} vs Stored {stored_mode}")
            sys.exit()

    def _prepare_infrastructure(self) -> None:
        """基础设施准备（原子化操作）"""
        if self.IS_NORMAL and self._is_first_install:
            self.init_linkfile()
        if self._is_first_install:
            for dir_item in self._paths.values():
                os.makedirs(dir_item, mode=0o755, exist_ok=True)
    
    def init_linkfile(self):
        linkfile_content = '''
#!/bin/bash

# 源目录数组
SOURCEDIRS=("compiler/" "lib/" "misc/" "mpi/" "tool/" "app/")

# 目标目录
TARGETDIR="modules/"

# 确保目标目录存在
mkdir -p "$TARGETDIR"

# 函数用于递归遍历目录并创建软链接
link_files() {
    local SOURCEDIR="$1"
    local TARGETDIR="$2"
    # 遍历源目录中的所有文件和子目录
    for FILE in "$SOURCEDIR"*; do
        # 检查是否为目录
        if [ -d "$FILE" ] && [ "$FILE" != "$SOURCEDIR"." ] && [ "$FILE" != "$SOURCEDIR".." ]; then
            # 创建软链接
            SUBDIRNAME=$(basename "$FILE")
            rel_path=$(realpath "$FILE")
            ln -sfn "$rel_path" "$TARGETDIR/$SUBDIRNAME"
        fi
    done
}

# 遍历所有源目录
for SOURCEDIR in "${SOURCEDIRS[@]}"; do
    link_files "$SOURCEDIR" "$TARGETDIR"
done
'''
        self.tool.write_file(self.LINK_FILE, linkfile_content)

    def get_mpi_info(self):
        mpich_info = self.mpich_detector.detect()
        if mpich_info:return mpich_info
        hmpi_info = self.hmpi_detector.detect()
        if hmpi_info:return hmpi_info
        openmpi_info = self.openmpi_detector.detect()
        if openmpi_info:return openmpi_info
        print("MPI not found, please install MPI first.")
        sys.exit()

    def check_compiler_mpi(self, compiler_list, compiler_mpi_info):
        no_compiler = ["COM","ANY","MISC","APP"]
        is_valid = False
        compiler_mpi_info = compiler_mpi_info.upper()
        valid_list = []
        for compiler in compiler_list:
            valid_list.append(compiler)
            valid_list.append(f'{compiler}+MPI')
        valid_list += no_compiler
        for valid_para in valid_list:
            if compiler_mpi_info == valid_para:
                is_valid = True
                break
        if not is_valid:
            print(f"compiler or mpi info error, Only {valid_list.join('/').lower()} is supported")
            sys.exit()
        return compiler_mpi_info

    def get_used_compiler(self, compiler_mpi_info):
        return compiler_mpi_info.split('+')[0]

    def get_software_type(self,software_name, compiler_mpi_info):
        if self.is_mpi_software(software_name):
            return SoftwareType.MPI
        if compiler_mpi_info == "COM":
            return SoftwareType.COMPILER
        elif compiler_mpi_info == "ANY":
            return SoftwareType.UTIL
        elif compiler_mpi_info == "MISC":
            return SoftwareType.MISC
        elif compiler_mpi_info == "APP":
            return SoftwareType.APP
        else:
            return SoftwareType.LIB

    def get_compiler_info(self, compilers, compiler_mpi_info):
        compiler_info = {"cname":None, "cmversion": None, self.FULL_VERSION: None}
        for compiler, info_func in compilers.items():
            if compiler in compiler_mpi_info:
                compiler_info = info_func()
        return compiler_info

    def get_main_version(self, version):
        return version.split('.')[0]

    def is_mpi_software(self, software_name):
        mpis = ['hmpi', 'openmpi', 'hpcx', 'mpich']
        for mpi in mpis:
            if software_name.startswith(mpi):
                return True
        return False

    def add_mpi_path(self, software_info, install_path):
        if not software_info.use_mpi:
            return install_path
        mpi_info = self.get_mpi_info()
        if mpi_info[self.FULL_VERSION] == None:
            print("MPI not found!")
            return False
        mpi_str = mpi_info["name"]+mpi_info[self.FULL_VERSION]
        print("Use MPI: "+mpi_str)
        if self.IS_PRO:
            install_path = os.path.join(install_path, mpi_str)
        elif self.IS_NORMAL:
            install_path = f"{install_path}-{mpi_str}"
        return install_path

    def get_install_path(self, software_info, env_info):
        sversion = software_info.full_version
        stype = software_info.software_type
        cname = env_info['cname']
        cfullver = env_info[self.FULL_VERSION]
        sname = software_info.name
        if stype == SoftwareType.MPI:
            if self.IS_PRO:
                mpi_path = os.path.join(self.MPI_PATH, f"{sname}{sversion}-{cname}{cfullver}", sversion)
            if self.IS_NORMAL:
                mpi_path = os.path.join(self.MPI_PATH,sname, f"{sversion}-{cname}{cfullver}")
            print(f"mpi_path:{mpi_path}")
            return mpi_path
        if stype == SoftwareType.COMPILER:
            install_path = os.path.join(self.COMPILER_PATH, f'{sname}/{sversion}')
        elif stype == SoftwareType.UTIL:
            install_path = os.path.join(self.UTILS_PATH, f'{sname}/{sversion}')
        elif stype == SoftwareType.MISC:
            install_path = os.path.join(self.MISC_PATH, f'{sname}/{sversion}')
        elif stype == SoftwareType.APP:
            install_path = os.path.join(self.APP_PATH, f'{sname}/{sversion}-{cname}{cfullver}')
            install_path = self.add_mpi_path(software_info, install_path)
        else:
            if self.IS_PRO:
                # install library
                install_path = os.path.join(self.LIBS_PATH, cname+cfullver)
                # get mpi name and version
                install_path = self.add_mpi_path(software_info, install_path)
                install_path = os.path.join(install_path, f'{sname}/{sversion}')
            elif self.IS_NORMAL:
                install_path = os.path.join(self.LIBS_PATH, f'{sname}/{sversion}-{cname}{cfullver}')
                install_path = self.add_mpi_path(software_info, install_path)
        return install_path

    def is_contained_mpi(self, compiler_mpi_info):
        return "MPI" in compiler_mpi_info
    
    def get_files(self, abs_path):
        file_list = [d for d in glob(abs_path+'/**', recursive=True)]
        return file_list

    def add_special_library_path(self, install_path, sname, libs_dir):
        prefix = install_path.replace(install_path, "$prefix")
        if "kml" in sname:
            libs_dir.append(os.path.join(prefix, "lib/kblas/nolocking"))
            libs_dir.append(os.path.join(prefix, "lib/kblas/pthread"))
            libs_dir.append(os.path.join(prefix, "lib/kblas/omp"))
            libs_dir.append(os.path.join(prefix, "lib/kblas/locking"))
            libs_dir.append(os.path.join(prefix, "lib/kvml/single"))
            libs_dir.append(os.path.join(prefix, "lib/kvml/multi"))
            libs_dir.append(os.path.join(prefix, "lib/kspblas/single"))
            libs_dir.append(os.path.join(prefix, "lib/kspblas/multi"))
        return libs_dir

    def get_loaded_modules(self):
        import subprocess
        try:
            # 执行module list命令(需初始化module环境)
            cmd = "source /etc/profile.d/modules.sh; module list 2>&1"
            output = subprocess.check_output(cmd, shell=True, executable='/bin/bash')
            raw_list = output.decode().split()
            modules = []
            for item in raw_list:
                if '/' in item:
                    modules.append(item)
            return modules
        except subprocess.CalledProcessError as e:
            print(f"module list执行失败: {e}")
            return []

    def complement_dep(self):
        loaded_modules = self.get_loaded_modules()
        print(f"loaded: {loaded_modules}")
        deps = self.dependencies.split()
        depsmap = {}
        for dep in deps:
            depsmap[dep] = False
            for loaded_module in loaded_modules:
                if loaded_module.startswith(dep):
                    depsmap[dep] = loaded_module
                    print(f"{loaded_module} for dependency {dep} loaded.")
            if not depsmap[dep]:
                print(f"{dep} not loaded, please use module load first.")
                sys.exit(0)
        return " ".join(depsmap.values())

    def get_module_file_content(self, install_path, sname, sversion):
        module_file_content = ''
        if "hpckit" in sname.lower():
            module_file_content = f'''#%Module1.0#####################################################################
prepend-path MODULEPATH  {install_path}/HPCKit/latest/modulefiles
'''
            return module_file_content
        file_list = self.get_files(install_path)
        bins_dir_type = ["bin"]
        libs_dir_type = ["libs", "lib", "lib64"]
        incs_dir_type = ["include"]
        bins_dir = []
        libs_dir = []
        incs_dir = []
        compiler_values = ''
        bins_str = ''
        libs_str = ''
        incs_str = ''
        opal_prefix = ''
        pmix_install_prefix = ''
        for file in file_list:
            if not os.path.isdir(file):
                continue
            last_dir = file.split('/')[-1]
            if last_dir in bins_dir_type:
                bins_dir.append(file.replace(install_path, "$prefix"))
            elif last_dir in libs_dir_type:
                libs_dir.append(file.replace(install_path, "$prefix"))
            elif last_dir in incs_dir_type:
                incs_dir.append(file.replace(install_path, "$prefix"))
        self.add_special_library_path(install_path, sname, libs_dir)
        if len(bins_dir) >= 1:
            bins_str = "prepend-path    PATH              "+':'.join(bins_dir)
        if len(libs_dir) >= 1:
            libs_str = "prepend-path    LD_LIBRARY_PATH            "+':'.join(libs_dir)
        if len(incs_dir) >= 1:
            incs_str = "prepend-path	INCLUDE	   " + ':'.join(incs_dir)
        if "bisheng" in sname:
              compiler_values = "setenv CC clang \nsetenv CXX clang++ \nsetenv FC flang \nsetenv F77 flang \nsetenv F90 flang "
        elif "gcc" in sname:
              compiler_values = "setenv CC gcc \nsetenv CXX g++ \nsetenv FC gfortran \nsetenv F77 gfortran \nsetenv F90 gfortran "
        elif "hmpi" in sname or "openmpi" in sname:
              compiler_values = "setenv CC mpicc \nsetenv CXX mpicxx \nsetenv FC mpifort \nsetenv F77 mpifort \nsetenv F90 mpifort "
        if self.is_mpi_software(sname):
            opal_prefix = f"setenv OPAL_PREFIX {install_path}"
            pmix_install_prefix = f"setenv PMIX_INSTALL_PREFIX {install_path}"
        depend_content=''
        if self.dependencies:
            # complement dependencies
            depend_content='''
foreach dep {%s} {
    if { ![is-loaded $dep] } {
        module load $dep
    }
}
''' % self.dependencies
        module_file_content = f'''#%Module1.0#####################################################################
set     prefix  {install_path}
set     version	{sversion}
{depend_content}
setenv    {sname.upper().replace('-','_')}_PATH {install_path}
{compiler_values}
{opal_prefix}
{pmix_install_prefix}
{bins_str}
{libs_str}
{incs_str}
'''
        return module_file_content

    def is_installed(self, install_path):
        #为了兼容老版本，只要安装路径下存在installed也算做已安装
        installed_file_path = os.path.join(install_path, "installed")
        if self.tool.read_file(installed_file_path) == "1":
            return True
        return self.json.get(install_path)

    def gen_module_file(self, install_path, software_info, env_info):
        sname = software_info.name
        sversion = software_info.full_version
        stype = software_info.software_type
        cname = env_info['cname']
        cfullversion = env_info[self.FULL_VERSION]
        module_file_content = self.get_module_file_content(install_path, sname, sversion)
        if not self.is_installed(install_path):
            return ''
        # if install_path is empty, The module file should not generated.
        if len(os.listdir(install_path)) == 0:
            print('module file did not generated because no file generated under install path')
            return ''
        if stype == SoftwareType.MPI:
            compiler_str = cname + cfullversion
            software_str = sname + sversion
            if self.IS_PRO:
                module_path = os.path.join(self.MODULE_DEPS_PATH, compiler_str ,sname)
                attach_module_path = os.path.join(self.MODULE_DEPS_PATH, compiler_str+'-'+software_str)
                self.tool.mkdirs(attach_module_path)
                module_file_content += f"\nprepend-path    MODULEPATH     {attach_module_path}"
                print(f'attach module file {attach_module_path} successfully generated.')
            elif self.IS_NORMAL:
                module_path = os.path.join(self.MODULE_COMPILER_PATH, sname, f'{sversion}-{compiler_str}')
        else:
            if stype == SoftwareType.COMPILER:
                software_str = sname + sversion
                if self.IS_PRO:
                    module_path = os.path.join(self.MODULE_FILES, sname)
                    attach_module_path = os.path.join(self.MODULE_DEPS_PATH, software_str)
                    self.tool.mkdirs(attach_module_path)
                    module_file_content += f"\nprepend-path    MODULEPATH     {attach_module_path}"
                    print(f'attach module file {attach_module_path} successfully generated.')
                elif self.IS_NORMAL:
                    module_path = os.path.join(self.MODULE_COMPILER_PATH, sname, sversion)
            elif stype == SoftwareType.UTIL:
                if self.IS_PRO:
                    module_path = os.path.join(self.MODULE_FILES, sname)
                elif self.IS_NORMAL:
                    module_path = os.path.join(self.MODULE_UTIL_PATH, sname, sversion)
            elif stype == SoftwareType.MISC:
                if self.IS_PRO:
                    module_path = os.path.join(self.MODULE_FILES, sname)
                elif self.IS_NORMAL:
                    module_path = os.path.join(self.MODULE_MISC_PATH, sname, sversion)
            else:
                if self.IS_NORMAL:
                    if stype == SoftwareType.APP:
                        BASE_PATH = self.MODULE_APP_PATH
                    else:
                        BASE_PATH = self.MODULE_LIB_PATH
                elif self.IS_PRO:
                    if stype == SoftwareType.APP:
                        BASE_PATH = self.MODULE_APP_PATH
                    else:
                        BASE_PATH = self.MODULE_DEPS_PATH
                compiler_str = cname + cfullversion
                if software_info.use_mpi:
                    mpi_info = self.get_mpi_info()
                    mpi_str = mpi_info['name'] + mpi_info[self.FULL_VERSION]
                    if self.IS_PRO:
                        module_path = os.path.join(self.BASE_PATH, f"{compiler_str}-{mpi_str}" ,sname)
                    if self.IS_NORMAL:
                        module_path = os.path.join(BASE_PATH, sname, f"{sversion}-{compiler_str}-{mpi_str}")
                else:
                    if self.IS_PRO:
                        module_path = os.path.join(self.BASE_PATH, compiler_str, sname)
                    elif self.IS_NORMAL:
                        module_path = os.path.join(BASE_PATH, sname, f"{sversion}-{compiler_str}")
        if self.IS_PRO:
            self.tool.mkdirs(module_path)
            module_file = os.path.join(module_path, sversion)
        elif self.IS_NORMAL:
            self.tool.mkdirs(os.path.dirname(module_path))
            module_file = module_path
        self.tool.write_file(module_file, module_file_content)
        print(f"module file {module_file} successfully generated")
        row = self.json.get(install_path)
        row["module_path"] = module_file
        self.json.set(install_path, row, True)
        #更新linkfile
        if self.IS_NORMAL:self.update_modules()

    def update_modules(self):
        upd_cmd = f'''
cd {self.MODULE_FILES}
source {self.LINK_FILE}
'''
        result = self.exe.exec_raw(upd_cmd)
        if result:
            print(f"update modules successful")
        else:
            print("update failed")

    def extract_dependency_variable(self,file_path):
        """
        从 install.sh 文件中提取环境变量的值
        :param file_path: install.sh 文件路径
        :return: extract 的值（字符串），未找到时返回 None
        """
        ex_value = None
        # 正则匹配 export AA=value 或 AA=value 的行（忽略注释和空格）
        pattern = re.compile(r'^\s*(?:export\s+)?DEPENDENCIES\s*=\s*(.*?)(?:\s*#.*)?$', re.IGNORECASE)
        
        with open(file_path, 'r') as f:
            for line in f:
                line = line.strip()
                if line.startswith('#'):
                    continue  # 跳过注释行
                match = pattern.match(line)
                if match:
                    value = match.group(1)
                    # 去除两侧的引号（单引号、双引号）
                    if value.startswith(('"', "'")) and value.endswith(('"', "'")):
                        value = value[1:-1]
                    ex_value = value
        return ex_value 

    def install_package(self, abs_software_path, install_path, other_args):
        install_script = 'install.sh'
        install_script_path = os.path.join(abs_software_path, install_script)
        # Extracting dependency information
        self.dependencies = self.extract_dependency_variable(install_script_path)
        if self.dependencies:self.dependencies = self.complement_dep()
        print("start installing..."+ abs_software_path)
        if not os.path.exists(install_script_path):
            print("install script not exists, skipping...")
            return
        self.tool.mkdirs(install_path)
        if self.is_installed(install_path):
            print("already installed, skipping...")
            return
        #argparse无法解析前缀为-的参数，所以参数使用双单引号，这里要去除单引号
        other_args = [x.replace('\'','') for x in other_args]
        other_args_uni = ' '.join(other_args)
        #print(other_args)
        install_cmd = f'''
source ./init.sh
cd {abs_software_path}
chmod +x {install_script}
./{install_script} {install_path} {other_args_uni}
'''
        result = self.exe.exec_raw(install_cmd)
        if result:
            print(f"install to {install_path} successful")
        else:
            print("install failed")
            sys.exit()

    def add_install_info(self, software_info, install_path):
        software_dict = {}
        software_dict['name'] = software_info.name
        software_dict['version'] = software_info.full_version
        software_dict['module_path'] = ''
        self.json.set(install_path, software_dict, True)

    def remove_prefix(self, software_path):
        if software_path.startswith('package/') or software_path.startswith('./'):
            software_path = software_path.replace('./', '', 1)
            software_path = software_path.replace('package/', '', 1)
        return software_path
    
    def install(self, install_args, isapp = False):
        software_path = install_args[0]
        compiler_mpi_info = install_args[1]
        other_args = install_args[2:]
        self.tool.prt_content("INSTALL " + software_path)

        compilers = {"GCC":self.gcc_detector.detect, "CLANG":self.clang_detector.detect,
                     "NVC":self.nvcc_detector.detect, "ICC":self.icc_detector.detect,
		             "BISHENG": self.clang_detector.detect}
        compiler_mpi_info = self.check_compiler_mpi(compilers.keys(), compiler_mpi_info)
        software_info = self.software_factory.create_profile(software_path, compiler_mpi_info, isapp)
        stype = software_info.software_type
        # get compiler name and version
        env_info = self.get_compiler_info(compilers, compiler_mpi_info)
        if stype == SoftwareType.LIB or stype == SoftwareType.MPI or stype == SoftwareType.APP:
            cmversion = env_info['cmversion']
            cfullver = env_info[self.FULL_VERSION]
            if cmversion == None:
                print(f"The specified {software_info.compiler_name} Compiler not found!")
                return False
            else:
                print(f"Use Compiler: {env_info['cname']} {cfullver}")
        
        # get install path
        install_path = self.get_install_path(software_info, env_info)
        if not install_path: 
            return
        else:
            self.tool.mkdirs(install_path)
        if isapp: 
            return {
                "install_path": install_path,
                "software_info":software_info,
                "env_info":env_info
            }
        # get install script
        self.install_package(software_info.install_script_path, install_path, other_args)
        # add install info
        self.add_install_info(software_info, install_path)
        # gen module file
        self.gen_module_file( install_path, software_info, env_info)

    def install_depend(self):
        depend_file = self.ds.get_depend_file()
        print(f"start installing dependendcy of {self.ds.app_config.name}")
        depend_content = f'''{self.ds.get_dependency()}'''
        self.tool.write_file(depend_file, depend_content)
        run_cmd = f'''
chmod +x {depend_file}
sh {depend_file}
'''
        self.exe.exec_raw(run_cmd)
    
    def remove(self, software_info):
        self.tool.prt_content("UNINSTALL " + software_info)
        remove_list = []
        installed_dict = self.json.data
        installed_dict.pop('MODE', None)
        for path, software_row in installed_dict.items():
            if software_info in software_row['name']:
                remove_list.append((path, software_row))
        lens = len(remove_list)
        if lens == 0:
            print("software not installed")
            return
        choice = 1
        if lens > 1:
            for i in range(lens):
                print(f"{i+1}: {remove_list[i][1]}")
            self.tool.prt_content("")
            choice = input(f"find {lens} software, which one do you want to remove?\n")
            try:
                choice = int(choice)
                if choice > lens or choice < 1:
                    print("invalid choice!")
                    return
            except:
                sys.exit("please enter a valid number!")
        self.json.delete(remove_list[choice-1][0], True)
        print("Successfully remove "+software_info)
        
    def list(self):
        self.tool.prt_content("Installed list".upper())
        installed_list = self.json.data
        installed_list.pop('MODE', None)
        if len(installed_list) == 0:
            print("no software installed.")
            return
        # 获取所有列名,除了module_path
        headers = list(installed_list.values())[0].keys()
        print_headers = list(headers)[:-1]
        # 打印表头
        table_str = ""
        for header in print_headers:
            table_str += f"{header:<10}"
        # 添加path打印
        table_str += "     path"
        # 分割线
        table_str += "\n" + "-" * (10 * (len(print_headers)+1)) + "\n"
        # 打印每行数据
        for path, row in installed_list.items():
            for key in print_headers:
                table_str += f"{row[key]:<10} "
            table_str += f"{path:<10} \n"
        print(table_str)

    def find(self, content):
        self.tool.prt_content(f"Looking for package {content}")
        installed_list = list(self.json.data.values())
        for row in installed_list:
            if content in row['name']:
                print(row)

    # update path when hpcrunner is translocation
    def update(self):
        file1_list = [d for d in glob(self.MODULE_FILES+'/**', recursive=True)]
        file2_list=  [d for d in glob(self.MODULE_DEPS_PATH+'/**', recursive=True)]
        file_list = file1_list+file2_list
        module_list = []
        for file in file_list:
            if not os.path.isdir(file):
                module_list.append(file)
        for file in module_list:
            content = self.tool.read_file(file)
            search_old_path = re.search(r'prefix +(.*hpcrunner(-master)?)', content)
            if search_old_path:
                content = content.replace(search_old_path.group(1), self.ROOT)
                self.tool.write_file(file, content)
        #还要更新install list
        install_info = self.tool.read_file(self.INSTALL_INFO_PATH)
        search_old_path = re.search(r'(\/.*hpcrunner(-master)?)', install_info)
        if search_old_path:
            content = install_info.replace(search_old_path.group(1), self.ROOT)
            self.tool.write_file(self.INSTALL_INFO_PATH, content)
        print("update successfully.")
        
    def check_download_url(self):
        # 查找指定目录下所有名字叫做install.sh的文件，将文件路径保存到列表中
        matches = []
        for root, dirnames, filenames in os.walk(self.PACKAGE_PATH):
            for filename in fnmatch.filter(filenames, 'install.sh'):
                matches.append(os.path.join(root, filename))
        # 定义匹配下载链接的正则表达式
        url_regex = r'(https?://\S+\.[zip|rar|tar|gz|bz|git]{2,3})'
        for script in matches:
            script_content = self.tool.read_file(script)
            urls = re.findall(url_regex, script_content)
            print(f"checking script {script}")
            for url in urls:
                if self.tool.check_url_isvalid(url):
                    print(f"url {url} successfully checked")
                else:
                    print(f"url {url} check failed,please update")
        print("all of the urls has been checked.")
