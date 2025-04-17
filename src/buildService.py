#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
from dataService import DataService
from executeService import ExecuteService
from toolService import ToolService
from installService import InstallService
import subprocess
import os

class BuildService:
    def __init__(self):
        self.hpc_data = DataService()
        self.exe = ExecuteService()
        self.tool = ToolService()
        self.installService = InstallService()

    def clean(self):
        print(f"start clean {DataService.app_name}")
        clean_cmd=self.hpc_data.get_clean_cmd()
        clean_file = 'clean.sh'
        self.tool.write_file(clean_file, clean_cmd)
        run_cmd = f'''
chmod +x {clean_file}
./{clean_file}
'''
        self.exe.exec_raw(run_cmd)
    
    def inject_env(self):
        #获取APP安装路径
        commands = self.hpc_data.get_env()
        cmd_list = commands.split("\n")
        cmd_str = "&&".join(cmd_list)
        cmd_str = f'{cmd_str} && env -0'
        result = subprocess.run(
            cmd_str,
            shell=True,
            stdout=subprocess.PIPE,
            text=True
        )
        # 处理错误并注入变量
        if result.returncode != 0:
            print("执行失败:", result.stderr)
        else:
            for line in result.stdout.strip('\0').split('\0'):
                if '=' in line:
                    key, value = line.split('=', 1)
                    os.environ[key] = value

    def build(self):
        print(f"start build {DataService.app_name}")
        self.inject_env()
        #获取APP安装路径
        app_name = self.hpc_data.app_name
        app_version = self.hpc_data.app_version
        app_compiler = self.hpc_data.app_compiler
        result = self.installService.install([f"{app_name}/{app_version}", app_compiler], True)
        install_path = result["install_path"]
        software_info = result["software_info"]
        env_info = result["env_info"]
        build_cmd = self.hpc_data.get_build_cmd()
        build_file = 'build.sh'
        self.tool.write_file(build_file, build_cmd)
        run_cmd = f'''
chmod +x {build_file}
./{build_file} {install_path}
'''
        self.exe.exec_raw(run_cmd)
        # add install info
        self.installService.add_install_info(software_info, install_path)
        loaded_modules = self.installService.get_loaded_modules()
        self.installService.dependencies = " ".join(loaded_modules)
        # gen module file
        self.installService.gen_module_file( install_path, software_info, env_info)

