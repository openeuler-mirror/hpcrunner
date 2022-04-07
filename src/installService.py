#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
from secrets import choice
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
        self.PACKAGE_PATH = os.path.join(self.ROOT, 'package')
        self.SOFTWARE_PATH = os.path.join(self.ROOT, 'software')
        self.COMPILER_PATH = os.path.join(self.SOFTWARE_PATH, 'compiler')
        self.LIBS_PATH = os.path.join(self.SOFTWARE_PATH, 'libs')
        self.MODULE_DEPS_PATH = os.path.join(self.SOFTWARE_PATH, 'moduledeps')
        self.MODULE_FILES = os.path.join(self.SOFTWARE_PATH, 'modulefiles')
        self.MPI_PATH = os.path.join(self.SOFTWARE_PATH, 'mpi')
        self.UTILS_PATH = os.path.join(self.SOFTWARE_PATH, 'utils')

    def get_version_info(self, info):
        return re.search( r'(\d+)\.(\d+)\.',info).group(1)

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
        name = 'gcc'
        if 'kunpeng' in gcc_info.lower():
            name =  'kgcc'
        return {"cname": name, "cmversion": version}

    def get_clang_info(self):
        clang_info_list = self.get_cmd_output('clang -v')
        clang_info = clang_info_list[0].strip()
        version = self.get_version_info(clang_info)
        name = 'clang'
        if 'bisheng' in clang_info.lower():
            name =  'bisheng'
        return {"cname": name, "cmversion": version}

    def get_nvc_info(self):
        return {"cname": "cuda", "cmversion": "11"}

    def get_icc_info(self):
        return {"cname": "icc", "cmversion": "11"}

    def get_mpi_info(self):
        mpi_info_list = self.get_cmd_output('mpirun -version')
        mpi_info = mpi_info_list[0].strip()
        name = 'openmpi'
        version = self.get_version_info(mpi_info)
        hmpi_info = self.get_cmd_output('ompi_info | grep "MCA coll: ucx"')[0]
        if hmpi_info != "":
            name = 'hmpi'
            version = re.search( r'Component v(\d+)\.(\d+)\.',hmpi_info).group(1)
        return {"name": name, "version": version}

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
        if len(software_info_list) == 3:
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
        compiler_info = {"cname":None, "cmversion": None}
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
        if mpi_info["version"] == None:
            print("MPI not found!")
            return False
        mpi_str = mpi_info["name"]+mpi_info["version"]
        print("Use MPI: "+mpi_str)
        install_path = os.path.join(install_path, mpi_str)
        return install_path

    def get_install_path(self, software_info, env_info):
        suffix = software_info['suffix']
        sversion = software_info['sversion']
        stype = software_info['type']
        cname = env_info['cname']
        if suffix != "":
            software_info['sname'] += '-' + suffix
        sname = software_info['sname']
        if stype == SType.MPI:
            return os.path.join(self.MPI_PATH, f"{sname}{self.get_main_version(sversion)}-{cname}{env_info['cmversion']}", sversion)
        if stype == SType.COMPILER:
            install_path = os.path.join(self.COMPILER_PATH, f'{sname}/{sversion}')
        elif stype == SType.UTIL:
            install_path = os.path.join(self.UTILS_PATH, f'{sname}/{sversion}')
        else:
            install_path = os.path.join(self.LIBS_PATH, cname+env_info['cmversion'])
            # get mpi name and version
            install_path = self.add_mpi_path(software_info, install_path)
            install_path = os.path.join(install_path, f'{sname}/{sversion}')
        return install_path

    def is_contained_mpi(self, compiler_mpi_info):
        return "MPI" in compiler_mpi_info
    
    def get_files(self, abs_path):
        file_list = [d for d in glob(abs_path+'/**', recursive=True)]
        return file_list

    def get_module_file_content(self, install_path, sversion):
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
        module_file_content = f'''#%Module1.0#####################################################################
set     prefix  {install_path}
set     version			    {sversion}

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
        cmversion = env_info['cmversion']
        software_str = sname + self.get_main_version(sversion)
        module_file_content = self.get_module_file_content(install_path, sversion)
        if not self.is_installed(install_path):
            return
        if stype == SType.MPI:
            compiler_str = cname + cmversion
            module_path = os.path.join(self.MODULE_DEPS_PATH, compiler_str ,software_str)
            attach_module_path = os.path.join(self.MODULE_DEPS_PATH, compiler_str+'-'+software_str)
            self.tool.mkdirs(attach_module_path)
            module_file_content += f"\nprepend-path    MODULEPATH     {attach_module_path}"
        else:
            if stype == SType.COMPILER:
                module_path = os.path.join(self.MODULE_FILES, software_str)
                attach_module_path = os.path.join(self.MODULE_DEPS_PATH, software_str)
                self.tool.mkdirs(attach_module_path)
                module_file_content += f"\nprepend-path    MODULEPATH     {attach_module_path}"
            elif stype == SType.UTIL:
                module_path = os.path.join(self.MODULE_FILES, sname)
            else:
                compiler_str = cname + cmversion
                if software_info['is_use_mpi']:
                    mpi_info = self.get_mpi_info()
                    mpi_str = mpi_info['name'] + self.get_main_version(mpi_info['version'])
                    module_path = os.path.join(self.MODULE_DEPS_PATH, f"{compiler_str}-{mpi_str}" ,sname)
                else:
                    module_path = os.path.join(self.MODULE_DEPS_PATH, compiler_str, sname)
        self.tool.mkdirs(module_path)
        module_file = os.path.join(module_path, sversion)
        self.tool.write_file(module_file, module_file_content)
        print(f"module file {module_file} successfully generated")

    def install_package(self, abs_software_path, install_path):
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
        install_cmd = f'''
source ./init.sh
cd {abs_software_path}
chmod +x {install_script}
./{install_script} {install_path}
'''
        result = self.exe.exec_raw(install_cmd)
        if result:
            print(f"install to {install_path} successful")
            self.set_installed_status(install_path, "1")
        else:
            print("install failed")
            sys.exit()

    def install(self, software_path, compiler_mpi_info):
        self.tool.prt_content("INSTALL " + software_path)
        compilers = {"GCC":self.get_gcc_info, "CLANG":self.get_clang_info,
                     "NVC":self.get_nvc_info, "ICC":self.get_icc_info,
		             "BISHENG":self.get_clang_info}
        
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
            if cmversion == None:
                print(f"The specified {software_info['use_compiler']} Compiler not found!")
                return False
            else:
                print(f"Use Compiler: {env_info['cname']} {cmversion}")
        
        # get install path
        install_path = self.get_install_path(software_info, env_info)
        if not install_path: return
        # get install script
        self.install_package(abs_software_path, install_path)
        # gen module file
        self.gen_module_file( install_path, software_info, env_info)

    def install_depend(self):
        depend_file = 'depend_install.sh'
        print(f"start installing dependendcy of {DataService.app_name}")
        depend_content = f'''
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
            choice = int(choice)
            if choice > lens or choice < 1:
                print("Wrong choice!")
                return
        self.set_installed_status(remove_list[choice-1], "0")
        print("Successfully remove "+software_info)
        
        
        
