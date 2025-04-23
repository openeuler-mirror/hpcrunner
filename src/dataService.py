#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
import platform

from toolService import ToolService
from typing import List, Dict, Tuple

class Singleton(type):
    """单例元类 (线程不安全基础版)"""
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super().__call__(*args, **kwargs)
        return cls._instances[cls]

class AppConfig:
    """应用配置数据类 (Immutable)"""
    __slots__ = ['name', 'version', 'compiler', 'build_dir', 'binary_dir', 'case_dir']

    def __init__(self,
                 name: str = "",
                 version: str = "",
                 compiler: str = "",
                 build_dir: str = "",
                 binary_dir: str = "",
                 case_dir: str = ""):
        self.name = name
        self.version = version
        self.compiler = compiler
        self.build_dir = os.path.expandvars(build_dir)
        self.binary_dir = os.path.expandvars(binary_dir)
        self.case_dir = os.path.expandvars(case_dir)

class PerfConfig:
    """性能工具参数配置"""
    def __init__(self):
        self.kperf: str = ""
        self.perf: str = ""
        self.nsys: str = ""
        self.ncu: str = ""
        self.hpccollect: str = ""
        self.hpcreport: str = ""

class DataService(metaclass=Singleton):
    
    """配置中心服务 (单例模式)"""
    
    # 常量定义
    ENV_CONFIG_VAR = 'JARVIS_CONFIG'
    DEFAULT_CONFIG_FILE = 'data.config'
    META_FILE = '.meta'
    ENV_FILE = 'env.sh'
    BATCH_FILE = 'batch_run.sh'
    DEPEND_FILE = 'depend_install.sh'
    JOB_FILE = 'job_generate.sh'
    CONFIG_SECTIONS = [
        '[SERVER]', '[DOWNLOAD]', '[DEPENDENCY]', '[ENV]', 
        '[APP]', '[BUILD]', '[CLEAN]', '[RUN]', 
        '[BATCH]', '[LOOP]', '[JOB]', '[JOB2]', '[PERF]'
    ]
    KEY_CONFIG_SECTIONS = [
            "DOWNLOAD","DEPENDENCY","ENV","APP","BUILD","RUN"
    ]

    def __init__(self):
        # 基础设施信息
        self.available_ips: str = ""
        self.dependency: str = ""
        self.env_content: str = ""
        # 应用配置
        self.app_config = AppConfig()
        self.build_dir: str = ""
        self.binary_dir: str = ""
        self.case_dir: str = ""
        # 命令配置
        self.build_cmd: str = ""
        self.clean_cmd: str = ""
        self.run_cmd: Dict[str, str] = {}
        self.batch_cmd: str = ""
        self.loop_cmd: str = ""
        self.job_cmd: str = ""
        self.job2_cmd: str = ""
        # 性能工具
        self.perf_config = PerfConfig()

        # 系统状态
        self.is_arm: bool = platform.machine() == 'aarch64'
        self.root_path: str = os.getcwd()
        self.tool_service: ToolService = ToolService()
        # 初始化流程
        self._load_configurations()
    
    # 优先读取环境变量的JARVIS_CONFIG配置,方便多人同时操控
    # 然后读取.meta文件中的值
    # 最后读取data.config中的值
    def _get_config_path(self) -> str:
        """确定配置文件优先级"""
        env_config = os.getenv(self.ENV_CONFIG_VAR)
        if env_config:
            print(f"LOAD Config from ENV: {env_config}")
            return self._resolve_path(env_config)
            
        if os.path.exists(self.META_FILE):
            meta_config = self.tool_service.read_file(self.META_FILE)
            return self._resolve_path(meta_config)
            
        return self._resolve_path(self.DEFAULT_CONFIG_FILE)

    def _resolve_path(self, rel_path: str) -> str:
        """处理路径解析"""
        abs_path = os.path.join(self.root_path, rel_path)
        if not os.path.exists(abs_path):
            print(f"Config file {abs_path} not found, fallback to default.")
            abs_path = os.path.join(self.root_path, self.DEFAULT_CONFIG_FILE)
        return abs_path

    def _load_configurations(self):
        """配置加载总入口"""
        config_path = self._get_config_path()
        with open(config_path, 'r', encoding='utf-8') as f:
            raw_data = self._parse_config_file(f.readlines())
        self._map_config_data(raw_data)

    def _parse_config_file(self, lines: List[str]) -> Dict[str, str]:
        """解析配置文件结构"""
        config = {}
        current_section = None
        buffer = []
        
        for line in lines:
            line = line.strip()
            if line in self.CONFIG_SECTIONS:
                if current_section:
                    config[current_section] = '\n'.join(buffer).strip()
                current_section = line
                buffer = []
            elif current_section:
                buffer.append(line)
                
        if current_section and buffer:
            config[current_section] = '\n'.join(buffer).strip()
            
        return config

    def _map_config_data(self, config_data: Dict[str, str]):
        """映射配置数据到对象属性"""
        # 基础信息
        self.available_ips = config_data.get('[SERVER]', '')
        self.dependency = config_data.get('[DEPENDENCY]', '')
        self.env_content = config_data.get('[ENV]', '')
        self.download_info = config_data.get('[DOWNLOAD]', '')
        
        # 命令配置
        self._parse_command_sections(config_data) 
        
        # 应用配置
        app_data = self._parse_app_section(config_data.get('[APP]', ''))
        
        # 性能配置
        perf_data = self._parse_perf_section(config_data.get('[PERF]', ''))
        # 处理二进制命令
        self._process_binary_command()

    def _parse_command_sections(self, config_data: Dict[str, str]):
        """解析所有命令类型段落"""
        self.build_cmd = self._parse_section_content(config_data.get('[BUILD]', ''))
        self.clean_cmd = self._parse_section_content(config_data.get('[CLEAN]', ''))
        self.run_cmd = self._parse_kv_section(config_data.get('[RUN]', ''))
        self.batch_cmd = self._parse_section_content(config_data.get('[BATCH]', ''))
        self.loop_cmd = self._parse_section_content(config_data.get('[LOOP]', ''))
        self.job_cmd = self._parse_section_content(config_data.get('[JOB]', ''))
        self.job2_cmd = self._parse_section_content(config_data.get('[JOB2]', ''))

    def _parse_app_section(self, app_content: str):
        """解析应用配置段落"""
        app_data = self._parse_kv_section(app_content)
        self.app_config = AppConfig(
            name=app_data.get('app_name', ''),
            version=app_data.get('app_version', ''),
            compiler=app_data.get('compiler', ''),
            build_dir=app_data.get('build_dir', ''),
            binary_dir=app_data.get('binary_dir', ''),
            case_dir=app_data.get('case_dir', '')
        )

    def _parse_perf_section(self, perf_content: str):
        """解析性能配置段落"""
        perf_data = self._parse_kv_section(perf_content)
        self.perf_config.kperf = perf_data.get('kperf', '')
        self.perf_config.perf = perf_data.get('perf', '')
        self.perf_config.nsys = perf_data.get('nsys', '')
        self.perf_config.ncu = perf_data.get('ncu', '')

    def _process_binary_command(self):
        """处理二进制命令分解"""
        if 'binary' in self.run_cmd:
            parts = self.run_cmd['binary'].split(' ', 1)
            self.binary_file = parts[0]
            self.binary_para = parts[1] if len(parts) > 1 else ''

    @staticmethod
    def _parse_kv_section(content: str) -> Dict[str, str]:
        """解析键值对格式的配置段落"""
        kv_dict = {}
        for line in content.split('\n'):
            if '=' in line:
                kv = line.split('=', 1)
                kv_dict[kv[0].strip()] = kv[1].strip()
        return kv_dict

    @staticmethod
    def _parse_section_content(content: str) -> str:
        """解析多行文本段落"""
        return '\n'.join(line.strip() for line in content.split('\n') if line.strip())

    @staticmethod
    def _is_empty(content: str) -> bool:
        """判断字符串是否为空内容"""
        return not content.strip()

    def get_app_name(self):
        return self.app_config.name

    def get_app_version(self):
        return self.app_config.version

    def get_app_compiler(self):
        return self.app_config.compiler
    
    def get_download_info(self):
        return self.download_info

    def get_available_ips(self):
        return self.available_ips

    def get_run_cmd(self, key):
        return self.run_cmd.get(key)

    def get_batch_cmd(self):
        return self.batch_cmd

    def get_job_cmd(self):
        return self.job_cmd

    def get_job2_cmd(self):
        return self.job2_cmd

    def get_clean_cmd(self):
        return self.clean_cmd
    
    def get_env_file(self):
        if self.app_config.build_dir:
            env_root_path = self.app_config.build_dir
        else:
            env_root_path = self.root_path
        return os.path.join(env_root_path, self.ENV_FILE)

    def get_depend_file(self):
        if self.app_config.build_dir:
            depend_root_path = self.app_config.build_dir
        else:
            depend_root_path = self.root_path
        return os.path.join(depend_root_path, self.DEPEND_FILE)

    def get_batch_run_file(self):
        if self.app_config.case_dir:
            batch_root_path = self.app_config.case_dir
        else:
            batch_root_path = self.root_path
        return os.path.join(batch_root_path, self.BATCH_FILE)

    def get_job_run_file(self):
        if self.app_config.case_dir:
            job_root_path = self.app_config.case_dir
        else:
            job_root_path = self.root_path
        return os.path.join(job_root_path, self.JOB_FILE)
    
    def get_dependency(self):
        return self.dependency

    def get_binary_file(self):
        return self.binary_file
