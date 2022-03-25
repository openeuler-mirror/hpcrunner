#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import platform
import sys
import os
import re
from glob import glob

from data import Data
from tool import Tool
from execute import Execute
from machine import Machine
from bench import Benchmark

from enum import Enum
 
class SType(Enum):
    COMPILER = 1
    MPI = 2
    UTIL = 3
    LIB = 4

class Install:
    def __init__(self):
        self.hpc_data = Data()
        self.exe = Execute()
        self.tool = Tool()
        self.ROOT = os.getcwd()
        self.PACKAGE_PATH = os.path.join(self.ROOT, 'package')
        self.COMPILER_PATH = os.path.join(self.ROOT, 'software/compiler')
        self.LIBS_PATH = os.path.join(self.ROOT, 'software/libs')
        self.MODULE_DEPS_PATH = os.path.join(self.ROOT, 'software/moduledeps')
        self.MODULE_FILES = os.path.join(self.ROOT, 'software/modulefiles')
        self.MPI_PATH = os.path.join(self.ROOT, 'software/mpi')
        self.UTILS_PATH = os.path.join(self.ROOT, 'software/utils')

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
        mpis = ['hmpi', 'openmpi', 'hpcx']
        return software_name in mpis

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

    def set_installed_status(self, install_path):
        installed_file_path = self.get_installed_file_path(install_path)
        self.tool.write_file(installed_file_path, "1")

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
            self.set_installed_status(install_path)
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
        print(f"start installing dependendcy of {Data.app_name}")
        depend_content = f'''
{Data.dependency}
'''
        self.tool.write_file(depend_file, depend_content)
        run_cmd = f'''
chmod +x {depend_file}
./{depend_file}
'''
        self.exe.exec_raw(run_cmd)

class Env:
    def __init__(self):
        self.hpc_data = Data()
        self.tool = Tool()
        self.ROOT = os.getcwd()
        self.exe = Execute()

    def env(self):
        print(f"set environment {Data.app_name}")
        env_file = os.path.join(self.ROOT, Data.env_file)
        self.tool.write_file(env_file, Data.module_content)
        print(f"ENV FILE {Data.env_file} GENERATED.")
        self.exe.exec_raw(f'chmod +x {Data.env_file}')

class Build:
    def __init__(self):
        self.hpc_data = Data()
        self.exe = Execute()
        
    def clean(self):
        print(f"start clean {Data.app_name}")
        clean_cmd=self.hpc_data.get_clean_cmd()
        self.exe.exec_raw(clean_cmd)

    def build(self):
        print(f"start build {Data.app_name}")
        build_cmd = self.hpc_data.get_build_cmd()
        self.exe.exec_raw(build_cmd)

class Run:
    def __init__(self):
        self.hpc_data = Data()
        self.exe = Execute()
        self.tool = Tool()
        self.ROOT = os.getcwd()
        self.avail_ips_list = self.tool.gen_list(Data.avail_ips)

    def gen_hostfile(self, nodes):
        length = len(self.avail_ips_list)
        if nodes > length:
            print(f"You don't have {nodes} nodes, only {length} nodes available!")
            sys.exit()
        if nodes <= 1:
            return
        gen_nodes = '\n'.join(self.avail_ips_list[:nodes])
        print(f"HOSTFILE\n{gen_nodes}\nGENERATED.")
        self.tool.write_file('hostfile', gen_nodes)

    # single run
    def run(self):
        print(f"start run {Data.app_name}")
        nodes = int(Data.run_cmd['nodes'])
        self.gen_hostfile(nodes)
        run_cmd = self.hpc_data.get_run_cmd()
        self.exe.exec_raw(run_cmd)

    def batch_run(self):
        batch_file = 'batch_run.sh'
        batch_file_path = os.path.join(self.ROOT, batch_file)
        print(f"start batch run {Data.app_name}")
        batch_content = f'''
cd {Data.case_dir}
{Data.batch_cmd}
'''
        self.tool.write_file(batch_file_path, batch_content)
        run_cmd = f'''
chmod +x {batch_file}
./{batch_file}
'''
        self.exe.exec_raw(run_cmd)

class Perf:
    def __init__(self):
        self.hpc_data = Data()
        self.exe = Execute()
        self.tool = Tool()
        self.isARM = platform.machine() == 'aarch64'

    def get_pid(self):
        #get pid
        pid_cmd = f'pidof {Data.binary_file}'
        result = self.exe.exec_popen(pid_cmd)
        if len(result) == 0:
            print("failed to get pid.")
            sys.exit()
        else:
            pid_list = result[0].split(' ')
        mid = int(len(pid_list)/2)
        return pid_list[mid].strip()

    def perf(self):
        print(f"start perf {Data.app_name}")
        #get pid
        pid = self.get_pid()
        #start perf && analysis
        perf_cmd = f'''
perf record {Data.perf_para} -a -g -p {pid}
perf report  -i ./perf.data -F period,sample,overhead,symbol,dso,comm -s overhead --percent-limit 0.1% --stdio
'''
        self.exe.exec_raw(perf_cmd)

    def get_arch(self):
        arch = 'arm'
        if not self.isARM:
            arch = 'X86'
        return arch

    def get_cur_time(self):
        return re.sub(' |:', '-', self.tool.get_time_stamp())

    def gpu_perf(self):
        print(f"start gpu perf")
        run_cmd = self.hpc_data.get_run()
        gperf_cmd = f'''
cd {Data.case_dir}
nsys profile -y 5s -d 100s {Data.nsys_para} -o nsys-{self.get_arch()}-{self.get_cur_time()} {run_cmd}
    '''
        self.exe.exec_raw(gperf_cmd)

    def ncu_perf(self, kernel):
        print(f"start ncu perf")
        run_cmd = self.hpc_data.get_run()
        ncu_cmd = f'''
    cd {Data.case_dir}
    ncu --export ncu-{self.get_arch()}-{self.get_cur_time()} {Data.ncu_para} --import-source=yes --set full --kernel-name {kernel} --launch-skip 1735 --launch-count 1 {run_cmd}
    '''
        self.exe.exec_raw(ncu_cmd)

class Download:
    def __init__(self):
        self.hpc_data = Data()
        self.exe = Execute()
        self.tool = Tool()
        self.ROOT = os.getcwd()
        self.download_list = self.tool.gen_list(Data.download_info)
        self.download_path = os.path.join(self.ROOT, 'downloads')
        self.package_path = os.path.join(self.ROOT, 'package')

    def check_network(self):
        print(f"start network checking")
        network_test_cmd='''
wget --spider -T 5 -q -t 2 www.baidu.com | echo $?
curl -s -o /dev/null www.baidu.com | echo $?
    '''
        self.exe.exec_raw(network_test_cmd)

    def change_yum_repo(self):
        print(f"start yum repo change")
        repo_cmd = '''
cp ./templates/yum/*.repo /etc/yum.repos.d/
yum clean all
yum makecache
'''
        self.exe.exec_raw(repo_cmd)

    def gen_wget_url(self, out_dir='./downloads', url='', filename=''):
        head = "wget --no-check-certificate"
        file_path = os.path.join(out_dir, filename)
        download_url = f'{head} {url} -O {file_path}'
        return download_url

    def download(self):
        print(f"start download")
        filename_url_map = {}
        self.tool.mkdirs(self.download_path)
        download_flag = False
        # create directory
        for url_info in self.download_list:
            url_list = url_info.split(' ')
            if len(url_list) < 2:
                continue
            software_info = url_list[0].strip()
            url_link = url_list[1].strip()
            filename = os.path.basename(url_link)
            if len(url_list) == 3:
                filename = url_list[2].strip()
            filename_url_map[filename] = url_link
            # create software directory
            software_path = os.path.join(self.package_path, software_info)
            self.tool.mkdirs(software_path)
            # create install script
            install_script = os.path.join(software_path, "install.sh")
            self.tool.mkfile(install_script)
        print(filename_url_map)
        # start download
        for filename, url in filename_url_map.items():
            download_flag = True
            file_path = os.path.join(self.download_path, filename)
            if os.path.exists(file_path):
                self.tool.prt_content(f"FILE {filename} already DOWNLOADED")
                continue
            download_url = self.gen_wget_url(self.download_path, url, filename)
            self.tool.prt_content("DOWNLOAD " + filename)
            output = os.popen(download_url)
            data = output.read()
            output.close()

        if not download_flag:
            print("The download list is empty!")
class Test:
    def __init__(self):
        self.exe = Execute()
        self.ROOT = os.getcwd()
        self.test_dir = os.path.join(self.ROOT, 'test')

    def test(self):
        run_cmd = f'''
cd {self.test_dir}
./test-qe.sh
cd {self.test_dir}
./test-util.sh
'''
        self.exe.exec_raw(run_cmd)

class Config:
    def __init__(self):
        self.exe = Execute()
        self.tool = Tool()
        self.ROOT = os.getcwd()

    def switch_config(self, config_file):
        print(f"Switch config file to {config_file}")
        meta_path = os.path.join(self.ROOT, Data.meta_file)
        self.tool.write_file(meta_path, config_file.strip())
        print("Successfully switched.")

class Analysis:
    def __init__(self):
        self.jmachine = Machine()
        self.jtest = Test()
        self.jdownload = Download()
        self.jbenchmark = Benchmark()
        self.jperf = Perf()
        self.jrun = Run()
        self.jbuild = Build()
        self.jenv = Env()
        self.jinstall = Install()
        self.jconfig = Config()

    def get_machine_info(self):
        self.jmachine.output_machine_info()

    def bench(self, bench_case):
        self.jbenchmark.output_bench_info(bench_case)

    def switch_config(self, config_file):
        self.jconfig.switch_config(config_file)

    def test(self):
        self.jtest.test()

    def download(self):
        self.jdownload.download()

    def check_network(self):
        self.jdownload.check_network()

    def gpu_perf(self):
        self.jperf.gpu_perf()
    
    def ncu_perf(self, kernel):
        self.jperf.ncu_perf(kernel)

    def perf(self):
        self.jperf.perf()

    def kperf(self):
        self.jperf.kperf()
    
    def run(self):
        self.jrun.run()
    
    def batch_run(self):
        self.jrun.batch_run()

    def clean(self):
        self.jbuild.clean()
    
    def build(self):
        self.jbuild.build()

    def env(self):
        self.jenv.env()
    
    def install(self,software_path, compiler_mpi_info):
        self.jinstall.install(software_path, compiler_mpi_info)
    
    def install_deps(self):
        self.jinstall.install_depend()
