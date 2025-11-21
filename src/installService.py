#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
import sys
import re
import fnmatch
from enum import Enum
from glob import glob
from typing import Tuple, Optional, Dict
from pathlib import Path

from dataService import DataService
from toolService import ToolService
from executeService import ExecuteService
from jsonService import JSONService
from installStrategy import PathStrategyFactory
from installTypes import InstallMode, InstallProfile
from versionParser import VersionParser
from softwareFactory import SoftwareFactory
from envFactory import EnvFactory
from softwareTypes import SoftwareType
from pathBuilder import PathFactory
from deploymentConfig import DeploymentConfig
from moduleConfig import ModuleConfig
from moduleController import ModulefileEngine
import json
import subprocess

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
    INSTALL_JSON = "install.json"
    LINK_FILE_NAME = 'linkpathtomodules.sh'
    DEPEND_JSON = 'dependencies.json'
	
    def __init__(self):
        self.ds = DataService()
        self.exe = ExecuteService()
        self.tool = ToolService()
        self.env_factory = EnvFactory()
        self.software_factory = SoftwareFactory()
        self.ROOT = os.getcwd()

        self._mode = self._detect_mode()
        self._init_paths()
        self.deployment_config = DeploymentConfig(self._mode, self._paths)
        self.path_factory = PathFactory(self.deployment_config)
        self.INSTALL_INFO_PATH = os.path.join(self.SOFTWARE_PATH, self.INSTALL_JSON)
        self._is_first_install = self._set_first_install()
        self.IS_PRO = self._mode == InstallMode.PRO
        self.IS_NORMAL = self._mode == InstallMode.NORMAL
        self.PACKAGE_PATH = os.path.join(self.ROOT, self.PACKAGE)
        self.dependencies = False       
        self.LINK_FILE = os.path.join(self.MODULE_FILES, self.LINK_FILE_NAME)
        self._create_install_json(self.INSTALL_INFO_PATH)
        self._validate_installation()
        self._prepare_infrastructure()
        self.DEPEND_INFO_PATH = os.path.join(self.PACKAGE_PATH, self.DEPEND_JSON)

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

    def is_installed(self, install_path):
        #为了兼容老版本，只要安装路径下存在installed也算做已安装
        installed_file_path = os.path.join(install_path, "installed")
        if self.tool.read_file(installed_file_path) == "1":
            return True
        return self.json.get(install_path)

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
            sys.exit(1)

    def add_install_project_info(self, install_path, software_dict):
        install_registry = os.path.join(install_path, 'install_registry.json')
        if os.path.exists(install_registry):
            try:
                with open(install_registry, "r") as f:
                    data = json.load(f)
                    if 'projectURL' in data:
                        software_dict['projectURL']= data['projectURL']

                    if 'projectDate' in data:
                        software_dict['projectDate']= data['projectDate']
                    
                    if 'packaging' in data:
                        software_dict['packaging']= data['packaging']

                    if 'package' in data:
                        software_dict['package']= data['package']

                    if 'hashType' in data:
                        software_dict['hashType']= data['hashType']

                    if 'hashValue' in data:
                        software_dict['hashValue']= data['hashValue']

                    if 'dependencies' in data:
                        dependencies = []
                        for item in data["dependencies"]:
                            dependency = {}
                            if 'artifactId' in item:
                                dependency["artifactId"] = item["artifactId"]

                            if 'number' in item:
                                dependency["number"] = item["number"]

                            if 'version' in item:
                                dependency["version"] = item["version"]

                            # ref: compile, provided, runtime, test, system
                            # system: os libraries
                            # runtime: compiler libraries
                            # compile: user self compile libraries
                            # provided: local copy libraries
                            if 'scope' in item:
                                dependency["scope"] = item["scope"]

                            if 'url' in item:
                                dependency["url"] = item["url"]

                            # packaging: none, tgz
                            if 'packaging' in item:
                                dependency["packaging"] = item["packaging"]

                            if 'package' in item:
                                dependency["package"] = item["package"]

                            if 'hash_type' in item:
                                dependency["hash_type"] = item["hash_type"]

                            if 'hash_value' in item:
                                dependency["hash_value"] = item["hash_value"]

                            if dependency is not None:
                                dependencies.append(dependency)

                        software_dict['dependencies']= dependencies

            except json.JSONDecodeError as e:
                print(f"parse file  {e} failed")
            except FileNotFoundError:
                print(f"open file {install_registry} failed")
            finally:
                print(f"final done")

    def add_install_info(self, software_info, install_path):
        software_dict = {}
        software_dict['name'] = software_info.name
        software_dict['version'] = software_info.full_version
        software_dict['module_path'] = ''
        
        self.add_install_project_info(install_path, software_dict)
        self.json.set(install_path, software_dict, True)
    
    def _write_modulefile(self, install_path, module_path, content):
        base_path = os.path.dirname(module_path)
        self.tool.mkdirs(base_path)
        module_tail = os.path.join(install_path, 'module_tail.modulefile')
        if os.path.exists(module_tail):
            print(f"Found module_tail:{module_tail}")
            try:
                with open(module_tail, "r", encoding="utf-8") as f:
                    content_tail = f.read()
                    content="\n".join([content, content_tail]) 
            except FileNotFoundError:
                print(f"open file {module_tail} failed")
            finally:
                print(f"final done")
  
        self.tool.write_file(module_path, content)
        print(f"module file {module_path} successfully generated")
        row = self.json.get(install_path)
        row["module_path"] = module_path
        self.json.set(install_path, row, True)
        #更新linkfile
        if self.IS_NORMAL:self.update_modules()
    
    def _get_attach_module_path(self, software_info, env_info):
        if self.IS_NORMAL:
            return ""
        stype = software_info.software_type
        attach_module_path = ""
        if stype == SoftwareType.MPI:
            attach_module_path = os.path.join(self.MODULE_DEPS_PATH, f"{env_info.compiler_name}{env_info.compiler_version}-{software_info.name}{software_info.full_version}")
            self.tool.mkdirs(attach_module_path)
        elif stype == SoftwareType.COMPILER:
            attach_module_path = os.path.join(self.MODULE_DEPS_PATH, f"{software_info.name}{software_info.full_version}")
            self.tool.mkdirs(attach_module_path)
        return attach_module_path

    def is_dir_empty(self, directory):
        return not os.listdir(directory)

    def gen_module_file(self, install_path, software_info, env_info, tag="", depend_tag="", search_dir={}):
        if self.is_dir_empty(install_path):
            print(f"install path {install_path} is empty, module file not generated")
            return
        stype = software_info.software_type
        # 构建配置对象
        deps = self.dependencies.split() if self.dependencies else []
        attach_mod_path = self._get_attach_module_path(software_info, env_info)
        config = ModuleConfig(
            is_pro = self.IS_PRO,
            install_root=Path(install_path),
            software_name=software_info.name,
            full_version=software_info.full_version,
            category=stype,
            dependencies=deps,
            attach_module_path=attach_mod_path 
        )

        # 生成模块文件
        engine = ModulefileEngine()
        module_file_content = engine.generate(config,search_dir)
        module_path = self.path_factory.get_module_builder(stype).build_path(software_info, env_info)
        module_path = str(module_path)
        if tag:
            module_path="{}-{}".format(module_path,tag)
        if depend_tag:
            module_path="{}{}".format(module_path,depend_tag)			
        self._write_modulefile(install_path, module_path, module_file_content)
		
    def get_depend_info(self, software_name, depend_json={}):
        depend_info=""
        for dep,tag in depend_json[software_name]['dependencies'].items():
            cmd = "module list |xargs -n1 |grep -iw {}".format(dep)
            result = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, text=True)
            if result.returncode != 0:
                if tag == 'required':
                    print(f"[ERROR] {dep} is {tag}, execute {cmd} failed: {result.stderr}")
                    sys.exit(1)
                elif tag == 'optional':
                    print(f"{dep} is {tag}")
                    continue
                else:
                    print(f"[ERROR] {tag} is a invalid value")
                    sys.exit(1)
            modules = result.stdout.strip('\n')

            modulefile = ""
            match_num = 0
            pattern = rf'\b{dep}(?:-\S+)?/\b'
            for line in modules.splitlines():
                matches = re.findall(pattern, line)
                if matches:
                    modulefile = line
                    match_num += 1
                if match_num > 1:
                    print(f"[ERROR] loaded {dep} many times")
                    sys.exit(1)

            if not modulefile:
                print(f"[ERROR] loaded {dep} failed")
                sys.exit(1)
            cmd = "cat `module show {} |awk 'NR==2' |cut -d: -f1` |grep 'set version' |cut -d' ' -f3".format(modulefile)
            result = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, text=True)
            if result.returncode != 0:
                print(f"[ERROR] execute {cmd} failed: {result.stderr}")
                sys.exit(1)
            dep_version = result.stdout.strip('\n')
            depend_info = depend_info + "-{}{}".format(dep,dep_version)
        return depend_info

    def install(self, install_args, isapp = False):
        software_path = install_args[0]
        compiler_mpi_info = install_args[1]
        other_args = []
        suffix_item=""
        depend_item=""
		
        for item in install_args[2:]:
            if item.find("\\--suffix=") == 0:
                print("Got suffix:{}".format(item[len("\\--suffix="):]))
                suffix_item=item[len("\\--suffix="):]
            else:
                other_args.append(item)

        self.tool.prt_content("INSTALL " + software_path)

        software_info = self.software_factory.create_profile(software_path, compiler_mpi_info, isapp)
        env_info = self.env_factory.create_profile(software_info, compiler_mpi_info)
        stype = software_info.software_type
        # get install path
        install_path = self.path_factory.get_builder(stype).build_path(software_info, env_info)
        install_path = str(install_path)

        if install_path and suffix_item:
            install_path="{}-{}".format(install_path,suffix_item)

        software_name=self.software_factory._parse_name_and_version(software_path)[0]
        if os.path.exists(self.DEPEND_INFO_PATH):
            with open(self.DEPEND_INFO_PATH, "r", encoding="utf-8") as file:
                data = json.load(file)
        if software_name in data:
            depend_item = self.get_depend_info(software_name, data)
        if depend_item:   
            install_path="{}{}".format(install_path,depend_item)			
        print(f'Request:{install_path}')
        
        if not install_path: 
            return
        self.tool.mkdirs(install_path)
        install_profile = InstallProfile(
                install_path = install_path,
                software_info = software_info,
                env_info = env_info
                )
        if isapp: return install_profile
        # get install script
        self.install_package(software_info.install_script_path, install_path, other_args)
        # add install info
        self.add_install_info(software_info, install_path)
        self.gen_module_file(install_path, software_info, env_info, tag=suffix_item, depend_tag=depend_item)
    
    ### install_depend -> bool
    def install_depend(self):
        depend_file = self.ds.get_depend_file()
        print(f"start installing dependendcy of {self.ds.app_config.name}")
        depend_content = f'''{self.ds.get_dependency()}'''
        self.tool.write_file(depend_file, depend_content)
        run_cmd = f'''
chmod +x {depend_file}
sh {depend_file}
'''
        res=self.exe.exec_raw(run_cmd)
        return res
    
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
