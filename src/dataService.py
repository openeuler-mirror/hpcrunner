#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
import platform

from toolService import ToolService

class Singleton(type):

    def __init__(self, name, bases, dictItem):
        super(Singleton,self).__init__(name,bases, dictItem)
        self._instance = None

    def __call__(self, *args, **kwargs):
        if self._instance is None:
            self._instance = super(Singleton,self).__call__(*args, **kwargs)
        return self._instance

class DataService(object,metaclass=Singleton):
    # Hardware Info
    avail_ips=''
    # Dependent Software environment Info
    dependency = ''
    module_content=''
    env_file = 'env.sh'

    # Application Info
    app_name = ''
    build_dir = ''
    binary_dir =  ''
    binary_file = ''
    case_dir = ''

    # cmd info
    build_cmd = ''
    clean_cmd = ''
    run_cmd = {}
    batch_cmd = ''
    loop_cmd = ''
    job_cmd = ''
    job2_cmd = ''
    #Other Info
    env_config_file = 'JARVIS_CONFIG'
    config_file = 'data.config'
    meta_file = '.meta'
    root_path = os.getcwd()
    download_info = ''
    #perf info
    kperf_para = ''
    perf_para = ''
    nsys_para = ''
    ncu_para = ''
    hpccollect_para = ''
    hpcreport_para = ''
    def get_abspath(self, relpath):
        return os.path.join(DataService.root_path, relpath)

    def __init__(self):
        self.isARM = platform.machine() == 'aarch64'
        self.tool = ToolService()
        self.data_process()
    # 优先读取环境变量的JARVIS_CONFIG配置,方便多人同时操控
    # 然后读取.meta文件中的值
    # 最后读取data.config中的值
    def get_config_file_name(self):
        CONFIG_ENV = os.getenv(DataService.env_config_file)
        if CONFIG_ENV is not None:
            print("LOAD Config file from ENV:", CONFIG_ENV)
            return CONFIG_ENV
        if not os.path.exists(DataService.meta_file):
            return DataService.config_file
        return self.tool.read_file(DataService.meta_file)

    def get_data_config(self):
        file_name = self.get_config_file_name()
        file_path = self.get_abspath(file_name)
        if not os.path.exists(file_path):
            print("config file not found, switch to default data.config.")
            file_path = self.get_abspath(DataService.config_file)
        with open(file_path, encoding='utf-8') as file_obj:
            contents = file_obj.read()
            return contents.strip()

    def is_empty(self, content):
        return len(content) == 0 or content.isspace() or content == '\n'

    def read_rows(self, rows, start_row, needs_strip=True):
        data = ''
        row = rows[start_row]
        if needs_strip:
            row = row.strip()
        while not row.startswith('['):
            if not self.is_empty(row):
                data += row + '\n'
            start_row += 1
            if start_row == len(rows):
                break
            row = rows[start_row]
            if needs_strip:
                row = row.strip()
        return start_row, data

    def read_rows_kv(self, rows, start_row):
        data = {}
        row = rows[start_row].strip()
        while not row.startswith('['):
            if '=' in row:
                key, value = row.split('=', 1)
                data[key.strip()] = value.strip()
            start_row += 1
            if start_row == len(rows):
                break
            row = rows[start_row].strip()
        return start_row, data

    def set_app_info(self, data):
        DataService.app_name = data['app_name']
        DataService.build_dir = data['build_dir']
        DataService.binary_dir = data['binary_dir']
        DataService.case_dir = data['case_dir']
    
    def set_perf_info(self, data):
        DataService.kperf_para = data['kperf'] if 'kperf' in data else ''
        DataService.perf_para = data['perf'] if 'perf' in data else ''
        DataService.nsys_para = data['nsys'] if 'nsys' in data else ''
        DataService.ncu_para = data['ncu'] if 'ncu' in data else ''
        DataService.hpccollect_para = data['hpccollect'] if 'hpccollect' in data else ''
        DataService.hpcreport_para = data['hpcreport'] if 'hpcreport' in data else ''

    def split_two_part(self, data):
        split_list = data.split(' ', 1)
        first = split_list[0]
        second = ''
        if len(split_list) > 1:
            second = split_list[1]
        return (first, second)

    def data_integration(self, config_data):
        DataService.avail_ips = config_data.get('[SERVER]','')
        DataService.download_info = config_data.get('[DOWNLOAD]','')
        DataService.dependency = config_data.get('[DEPENDENCY]','')
        DataService.module_content = config_data.get('[ENV]','')
        DataService.build_cmd = config_data.get('[BUILD]','')
        DataService.clean_cmd = config_data.get('[CLEAN]','')
        DataService.run_cmd = config_data.get('[RUN]','')
        DataService.batch_cmd = config_data.get('[BATCH]','')
        DataService.loop_cmd = config_data.get('[LOOP]','')
        DataService.job_cmd = config_data.get('[JOB]','')
        DataService.job2_cmd = config_data.get('[JOB2]','')
        data = config_data.get('[APP]','')
        perf_data = config_data.get('[PERF]','')
        self.set_app_info(data)
        self.set_perf_info(perf_data)
        DataService.binary_file, DataService.binary_para = self.split_two_part(DataService.run_cmd['binary'])

    def data_process(self):
        contents = self.get_data_config()
        rows = contents.split('\n')
        rowIndex = 0
        handlers = {
            '[SERVER]': lambda  rows, rowIndex: self.read_rows(rows, rowIndex+1),
            '[DOWNLOAD]': lambda rows, rowIndex: self.read_rows(rows, rowIndex+1),
            '[DEPENDENCY]': lambda rows, rowIndex: self.read_rows(rows, rowIndex+1),
            '[ENV]': lambda rows, rowIndex: self.read_rows(rows, rowIndex+1),
            '[APP]': lambda rows, rowIndex: self.read_rows_kv(rows, rowIndex+1),
            '[BUILD]': lambda rows, rowIndex: self.read_rows(rows, rowIndex+1, False),
            '[CLEAN]': lambda rows, rowIndex: self.read_rows(rows, rowIndex+1),
            '[RUN]': lambda rows, rowIndex: self.read_rows_kv(rows, rowIndex+1),
            '[BATCH]': lambda rows, rowIndex: self.read_rows(rows, rowIndex+1),
            '[LOOP]': lambda rows, rowIndex: self.read_rows(rows, rowIndex+1, False), 
            '[JOB]': lambda rows, rowIndex: self.read_rows(rows, rowIndex+1, False),
            '[JOB2]': lambda rows, rowIndex: self.read_rows(rows, rowIndex+1, False), 
            '[PERF]': lambda rows, rowIndex: self.read_rows_kv(rows, rowIndex+1)
        }
        config_data = {}
        while rowIndex < len(rows):
            row = rows[rowIndex].strip()
            if row in handlers.keys():
                rowIndex, config_data[row] = handlers[row](rows, rowIndex)
            else:
                rowIndex += 1
        self.data_integration(config_data)

    def get_clean_cmd(self):
        return f'''
{self.get_env()}
cd {DataService.build_dir}
{DataService.clean_cmd}
'''
    def get_env(self):
        return f'''source ./init.sh
./jarvis -e
source ./{DataService.env_file}'''

    def get_build_cmd(self):
        return f'''
{self.get_env()}
cd {DataService.build_dir}
{DataService.build_cmd}
'''

    def get_run(self):
        nodes = int(DataService.run_cmd['nodes'])
        run_cmd = DataService.run_cmd['run']
        hostfile = ''
        if nodes > 1:
            hostfile = f'--hostfile {DataService.root_path}/hostfile'
        if 'mpi' in run_cmd:
            run_cmd = run_cmd.replace('mpirun', f'mpirun {hostfile}')
        binary = os.path.join(DataService.binary_dir, DataService.binary_file)
        return f'''{run_cmd} {binary} {DataService.binary_para}'''

    def get_run_cmd(self):
        return  f'''
{self.get_env()}
cd {DataService.case_dir}
{self.get_run()}
'''
