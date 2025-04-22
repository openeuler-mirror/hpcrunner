#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from dataService import DataService
from executeService import ExecuteService
from toolService import ToolService
from commandBuilder import CommandBuilder
from installService import InstallService
import subprocess
import os

class BuildService:
    DEFAULT_APP_NAME = "unknown"
    DEFAULT_APP_VERSION = "1.0.0"
    DEFAULT_COMPILER = "gcc"
    BUILD_FILE_NAME = 'build.sh'
    CLEAN_FILE_NAME = 'clean.sh'

    def __init__(self):
        self.ds = DataService()
        self.exe = ExecuteService()
        self.tool = ToolService()
        self.command = CommandBuilder()
        self.installService = InstallService()

    def get_build_file(self):
        if self.ds.app_config.build_dir:
            build_root_path = self.ds.app_config.build_dir
        else:
            build_root_path = self.ds.root_path
        return os.path.join(build_root_path, self.BUILD_FILE_NAME)

    def get_clean_file(self):
        if self.ds.app_config.build_dir:
            clean_root_path = self.ds.app_config.build_dir
        else:
            clean_root_path = self.ds.root_path
        return os.path.join(clean_root_path, self.CLEAN_FILE_NAME)


    def clean(self):
        clean_cmd = self.ds.get_clean_cmd()
        self._execute_script(self.get_clean_file(), clean_cmd, "clean")

    def inject_env(self):
        env_cmd = self.command.env_activation()
        self.exe.exec_inject(env_cmd)

    def build(self):
        self.inject_env()
        app_name = self.ds.get_app_name() or self.DEFAULT_APP_NAME
        app_version = self.ds.get_app_version() or self.DEFAULT_APP_VERSION
        app_compiler = self.ds.get_app_compiler() or self.DEFAULT_COMPILER

        result = self.installService.install([f"{app_name}/{app_version}", app_compiler], True)
        self._handle_install_result(result)

    def _handle_install_result(self, result):
        install_path = result["install_path"]
        software_info = result["software_info"]
        env_info = result["env_info"]
        build_cmd = self.command.build()
        self._execute_script(self.get_build_file(), build_cmd, "build", install_path)
        self.installService.add_install_info(software_info, install_path)
        self._update_dependencies()
        self.installService.gen_module_file(install_path, software_info, env_info)

    def _update_dependencies(self):
        loaded_modules = self.installService.get_loaded_modules()
        self.installService.dependencies = " ".join(loaded_modules)

    def _execute_script(self, file_name, command, action, *args):
        print(f"start {action} {self.ds.get_app_name()}")
        self.tool.write_file(file_name, command)
        run_cmd = f"chmod +x {file_name}\nsh {file_name} " + " ".join(args)
        self.exe.exec_raw(run_cmd)

# Example usage:
if __name__ == "__main__":
    build_service = BuildService()
    build_service.clean()
    build_service.build()

