#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
import sys
import re
from enum import Enum
from glob import glob

from dataService import DataService
from toolService import ToolService
from executeService import ExecuteService

class SType(Enum):
    COMPILER = 1
    MPI = 2
    UTIL = 3
    LIB = 4

class InstallService:
    def __init__(self):
        self.hpc_data = DataService()
        self.exe = ExecuteService()
        self.tool = ToolService()
        self.ROOT = os.getcwd()
        self.PACKAGE = 'package'
        self.FULL_VERSION='fullver'
        self.PACKAGE_PATH = os.path.join(self.ROOT, self.PACKAGE)
        self.SOFTWARE_PATH = os.path.join(self.ROOT, 'software')
        self.COMPILER_PATH = os.path.join(self.SOFTWARE_PATH, 'compiler')
        self.LIBS_PATH = os.path.join(self.SOFTWARE_PATH, 'libs')
        self.MODULE_DEPS_PATH = os.path.join(self.SOFTWARE_PATH, 'moduledeps')
        self.MODULE_FILES = os.path.join(self.SOFTWARE_PATH, 'modulefiles')
        self.MPI_PATH = os.path.join(self.SOFTWARE_PATH, 'mpi')
        self.UTILS_PATH = os.path.join(self.SOFTWARE_PATH, 'utils')

    def get_version_info(self, info, reg = r'(\d+)\.(\d+)\.(\d+)'):
        matched_group = re.search(reg ,info)
        if not matched_group:
            return None
        mversion = matched_group.group(1)
        mid_ver = matched_group.group(2)
        last_ver = matched_group.group(3)
        return ( mversion, f'{mversion}.{mid_ver}.{last_ver}')

    def gen_compiler_dict(self, cname, version):
        return {"cname": cname, "cmversion": version[0], self.FULL_VERSION: version[1]}
    
    def gen_mpi_dict(self, name, version):
        return {"name": name, "mversion": version[0], self.FULL_VERSION: version[1]}

    # some command don't generate output, must redirect to a tmp file
    def get_cmd_output(self, cmd):
        tmp_path = os.path.join(self.ROOT, 'tmp')
        tmp_file = os.path.join(tmp_path, 'tmp.txt')
        self.tool.mkdirs(tmp_path)
        cmd += f' &> {tmp_file}'
        self.exe.exec_popen(cmd, False)
        info_list = self.tool.read_file(tmp_file).split('\n')
        return info_list

    def get_gcc_info(self):
        gcc_info_list = self.get_cmd_output('gcc -v')
        gcc_info = gcc_info_list[-1].strip()
        version = self.get_version_info(gcc_info)
        if not version:
            print("GCC not found, please install gcc first")
            sys.exit()
        name = 'gcc'
        if 'kunpeng' in gcc_info.lower():
            name =  'kgcc'
        return self.gen_compiler_dict(name, version)

    def get_clang_info(self):
        clang_info_list = self.get_cmd_output('clang -v')
        clang_info = clang_info_list[0].strip()
        version = self.get_version_info(clang_info)
        if not version:
            print("clang not found, please install clang first")
            sys.exit()
        name = 'clang'
        if 'bisheng' in clang_info.lower():
            name =  'bisheng'
        return self.gen_compiler_dict(name, version)

    def get_nvc_info(self):
        return self.gen_compiler_dict("nvc", ('11', "11.4"))

    def get_icc_info(self):
        return self.gen_compiler_dict("icc", ('2018', "2018.4"))
    
    def get_hmpi_version(self):
        ucx_path = self.get_cmd_output('which ucx_info')[0]
        ucx_path = os.path.dirname(ucx_path)
        ucx_path = os.path.dirname(ucx_path)
        libucg_path = os.path.join(ucx_path, "lib")
        libucg_so_flag = "libucg.so."
        version = None
        for file_name in os.listdir(libucg_path):
            if libucg_so_flag in file_name:
                version = self.get_version_info(file_name)
                if version:
                    break
        return version

    def get_hmpi_info(self):
        hmpi_info = self.get_cmd_output('ompi_info | grep "MCA coll: ucx"')[0]
        if hmpi_info == "":
            return None
        name = 'hmpi'
        version = self.get_hmpi_version()
        return self.gen_mpi_dict(name, version)
 
    def get_openmpi_info(self):
        mpi_info_list = self.get_cmd_output('mpirun -version')
        mpi_info = mpi_info_list[0].strip()
        name = 'openmpi'
        version = self.get_version_info(mpi_info)
        if not version:
            return None
        return self.gen_mpi_dict(name, version)

    def get_mpich_info(self):
        mpi_info_list = self.get_cmd_output('mpirun -version')
        mpi_info = "".join(mpi_info_list).strip()
        name = 'mpich'
        if name not in mpi_info:
            return None
        version = self.get_version_info(mpi_info)
        if not version:
            return None
        return self.gen_mpi_dict(name, version)

    def get_mpi_info(self):
        mpich_info = self.get_mpich_info()
        if mpich_info:
            return mpich_info
        hmpi_info = self.get_hmpi_info()
        if hmpi_info:
            return hmpi_info
        openmpi_info = self.get_openmpi_info()
        if openmpi_info:
            return openmpi_info
        print("MPI not found, please install MPI first.")
        sys.exit()

    def check_software_path(self, software_path):
        abs_software_path = os.path.join(self.PACKAGE_PATH, software_path)
        if not os.path.exists(abs_software_path):
            print(f"{software_path} not exist, Are you sure the software lies in package dir?")
            return False
        return abs_software_path

    def check_compiler_mpi(self, compiler_list, compiler_mpi_info):
        no_compiler = ["COM","ANY"]
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
            return False
        return compiler_mpi_info

    def get_used_compiler(self, compiler_mpi_info):
        return compiler_mpi_info.split('+')[0]

    def get_software_type(self,software_name, compiler_mpi_info):
        if self.is_mpi_software(software_name):
            return SType.MPI
        if compiler_mpi_info == "COM":
            return SType.COMPILER
        elif compiler_mpi_info == "ANY":
            return SType.UTIL
        else:
            return SType.LIB

    def get_suffix(self, software_info_list):
        if len(software_info_list) >= 3:
            return software_info_list[2]
        return ""

    def get_software_info(self, software_path, compiler_mpi_info):
        software_info_list = software_path.split('/')
        software_name = software_info_list[0]
        software_version = software_info_list[1]
        software_main_version = self.get_main_version(software_version)
        software_type = self.get_software_type(software_name, compiler_mpi_info)
        software_info = {
            "sname":software_name, 
            "sversion": software_version, 
            "mversion": software_main_version, 
            "type" : software_type,
            "suffix": self.get_suffix(software_info_list)
        }
        if software_type == SType.LIB or software_type == SType.MPI:
            software_info["is_use_mpi"] = self.is_contained_mpi(compiler_mpi_info)
            software_info["use_compiler"] = self.get_used_compiler(compiler_mpi_info)
        return software_info

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
        if not software_info['is_use_mpi']:
            return install_path
        mpi_info = self.get_mpi_info()
        if mpi_info[self.FULL_VERSION] == None:
            print("MPI not found!")
            return False
        mpi_str = mpi_info["name"]+mpi_info[self.FULL_VERSION]
        print("Use MPI: "+mpi_str)
        install_path = os.path.join(install_path, mpi_str)
        return install_path

    def get_install_path(self, software_info, env_info):
        suffix = software_info['suffix']
        sversion = software_info['sversion']
        stype = software_info['type']
        cname = env_info['cname']
        cfullver = env_info[self.FULL_VERSION]
        if suffix != "":
            software_info['sname'] += '-' + suffix
        sname = software_info['sname']
        if stype == SType.MPI:
            return os.path.join(self.MPI_PATH, f"{sname}{sversion}-{cname}{cfullver}", sversion)
        if stype == SType.COMPILER:
            install_path = os.path.join(self.COMPILER_PATH, f'{sname}/{sversion}')
        elif stype == SType.UTIL:
            install_path = os.path.join(self.UTILS_PATH, f'{sname}/{sversion}')
        else:
            # install library
            install_path = os.path.join(self.LIBS_PATH, cname+cfullver)
            # get mpi name and version
            install_path = self.add_mpi_path(software_info, install_path)
            install_path = os.path.join(install_path, f'{sname}/{sversion}')
        return install_path

    def is_contained_mpi(self, compiler_mpi_info):
        return "MPI" in compiler_mpi_info
    
    def get_files(self, abs_path):
        file_list = [d for d in glob(abs_path+'/**', recursive=True)]
        return file_list

    def get_module_file_content(self, install_path, sname, sversion):
        module_file_content = ''
        file_list = self.get_files(install_path)
        bins_dir_type = ["bin"]
        libs_dir_type = ["libs", "lib", "lib64"]
        incs_dir_type = ["include"]
        bins_dir = []
        libs_dir = []
        incs_dir = []
        bins_str = ''
        libs_str = ''
        incs_str = ''
        opal_prefix = ''
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
        if len(bins_dir) >= 1:
            bins_str = "prepend-path    PATH              "+':'.join(bins_dir)
        if len(libs_dir) >= 1:
            libs_str = "prepend-path    LD_LIBRARY_PATH            "+':'.join(libs_dir)
        if len(incs_dir) >= 1:
            incs_str = "prepend-path	INCLUDE	   " + ':'.join(incs_dir)
        if self.is_mpi_software(sname):
            opal_prefix = f"setenv OPAL_PREFIX {install_path}"
        module_file_content = f'''#%Module1.0#####################################################################
set     prefix  {install_path}
set     version			    {sversion}

setenv    {sname.upper().replace('-','_')}_PATH {install_path}
{opal_prefix}
{bins_str}
{libs_str}
{incs_str}
'''
        return module_file_content

    def get_installed_file_path(self, install_path):
        return os.path.join(install_path, "installed")

    def is_installed(self, install_path):
        installed_file_path = self.get_installed_file_path(install_path)
        if not os.path.exists(installed_file_path):
            return False
        if not self.tool.read_file(installed_file_path) == "1":
            return False
        return True

    def set_installed_status(self, install_path, flag="1"):
        installed_file_path = self.get_installed_file_path(install_path)
        self.tool.write_file(installed_file_path, flag)

    def gen_module_file(self, install_path, software_info, env_info):
        sname = software_info['sname']
        sversion = software_info['sversion']
        stype = software_info['type']
        cname = env_info['cname']
        cfullversion = env_info[self.FULL_VERSION]
        module_file_content = self.get_module_file_content(install_path, sname, sversion)
        if not self.is_installed(install_path):
            return
        # if install_path is empty, The module file should not generated.
        if len(os.listdir(install_path)) == 1:
            print('module file did not generated because no file generated under install path')
            return
        if stype == SType.MPI:
            compiler_str = cname + cfullversion
            software_str = sname + sversion
            module_path = os.path.join(self.MODULE_DEPS_PATH, compiler_str ,sname)
            attach_module_path = os.path.join(self.MODULE_DEPS_PATH, compiler_str+'-'+software_str)
            self.tool.mkdirs(attach_module_path)
            module_file_content += f"\nprepend-path    MODULEPATH     {attach_module_path}"
            print(f'attach module file {attach_module_path} successfully generated.')
        else:
            if stype == SType.COMPILER:
                software_str = sname + sversion
                module_path = os.path.join(self.MODULE_FILES, sname)
                attach_module_path = os.path.join(self.MODULE_DEPS_PATH, software_str)
                self.tool.mkdirs(attach_module_path)
                module_file_content += f"\nprepend-path    MODULEPATH     {attach_module_path}"
                print(f'attach module file {attach_module_path} successfully generated.')
            elif stype == SType.UTIL:
                module_path = os.path.join(self.MODULE_FILES, sname)
            else:
                compiler_str = cname + cfullversion
                if software_info['is_use_mpi']:
                    mpi_info = self.get_mpi_info()
                    mpi_str = mpi_info['name'] + mpi_info[self.FULL_VERSION]
                    module_path = os.path.join(self.MODULE_DEPS_PATH, f"{compiler_str}-{mpi_str}" ,sname)
                else:
                    module_path = os.path.join(self.MODULE_DEPS_PATH, compiler_str, sname)
        self.tool.mkdirs(module_path)
        module_file = os.path.join(module_path, sversion)
        self.tool.write_file(module_file, module_file_content)
        print(f"module file {module_file} successfully generated")

    def install_package(self, abs_software_path, install_path, other_args):
        install_script = 'install.sh'
        install_script_path = os.path.join(abs_software_path, install_script)
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
            self.set_installed_status(install_path, "1")
        else:
            print("install failed")
            sys.exit()

    def install(self, install_args):
        software_path = install_args[0]
        compiler_mpi_info = install_args[1]
        other_args = install_args[2:]
        self.tool.prt_content("INSTALL " + software_path)
        compilers = {"GCC":self.get_gcc_info, "CLANG":self.get_clang_info,
                     "NVC":self.get_nvc_info, "ICC":self.get_icc_info,
		             "BISHENG":self.get_clang_info}
        software_path = software_path.replace("package/", '', 1)
        # software_path should exists
        abs_software_path = self.check_software_path(software_path)
        if not abs_software_path: return
        compiler_mpi_info = self.check_compiler_mpi(compilers.keys(), compiler_mpi_info)
        if not compiler_mpi_info: return
        software_info = self.get_software_info(software_path, compiler_mpi_info)
        stype = software_info['type']
        # get compiler name and version
        env_info = self.get_compiler_info(compilers, compiler_mpi_info)
        if stype == SType.LIB or stype == SType.MPI:
            cmversion = env_info['cmversion']
            cfullver = env_info[self.FULL_VERSION]
            if cmversion == None:
                print(f"The specified {software_info['use_compiler']} Compiler not found!")
                return False
            else:
                print(f"Use Compiler: {env_info['cname']} {cfullver}")
        
        # get install path
        install_path = self.get_install_path(software_info, env_info)
        if not install_path: return
        # get install script
        self.install_package(abs_software_path, install_path, other_args)
        # gen module file
        self.gen_module_file( install_path, software_info, env_info)

    def install_depend(self):
        depend_file = 'depend_install.sh'
        print(f"start installing dependendcy of {DataService.app_name}")
        depend_content = f'''
source ./init.sh
{DataService.dependency}
'''
        self.tool.write_file(depend_file, depend_content)
        run_cmd = f'''
chmod +x {depend_file}
./{depend_file}
'''
        self.exe.exec_raw(run_cmd)
    
    def remove(self, software_info):
        self.tool.prt_content("UNINSTALL " + software_info)
        file_list = [d for d in glob(self.SOFTWARE_PATH+'/**', recursive=True)]
        remove_list = []
        for file in file_list:
            if software_info in file and os.path.isdir(file) and self.is_installed(file):
                remove_list.append(file)
        lens = len(remove_list)
        if lens == 0:
            print("software not installed")
            return
        choice = 1
        if lens > 1:
            for i in range(lens):
                print(f"{i+1}: {remove_list[i]}")
            self.tool.prt_content("")
            choice = input(f"find {lens} software, which one do you want to remove?\n")
            try:
                choice = int(choice)
                if choice > lens or choice < 1:
                    print("invalid choice!")
                    return
            except:
                sys.exit("please enter a valid number!")
        self.set_installed_status(remove_list[choice-1], "0")
        print("Successfully remove "+software_info)
        
    def list(self):
        self.tool.prt_content("Installed list".upper())
        file_list = [d for d in glob(self.SOFTWARE_PATH+'/**', recursive=True)]
        installed_list = []
        for file in file_list:
            if os.path.isdir(file) and self.is_installed(file):
                installed_list.append(file)
        for file in installed_list:
            file = file.replace(self.SOFTWARE_PATH, 'software')
            print(file)
    
    def find(self, content):
        self.tool.prt_content(f"Looking for package {content}")
        file_list = [d for d in glob(self.SOFTWARE_PATH+'/**', recursive=True)]
        flag = False
        for file in file_list:
            if os.path.isdir(file) and self.is_installed(file):
                if content in file:
                    flag = True
                    print(f"FOUND: {file}")
        if not flag:
            print("NOT FOUND")

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
        print("update successfully.")
        
