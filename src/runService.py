#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import os
import sys
from toolService import ToolService
from executeService import ExecuteService
from dataService import DataService

class RunService:
    def __init__(self):
        self.hpc_data = DataService()
        self.exe = ExecuteService()
        self.tool = ToolService()
        self.ROOT = os.getcwd()
        self.avail_ips_list = self.tool.gen_list(DataService.avail_ips)

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
        print(f"start run {DataService.app_name}")
        nodes = int(DataService.run_cmd['nodes'])
        self.gen_hostfile(nodes)
        run_cmd = self.hpc_data.get_run_cmd()
        self.exe.exec_raw(run_cmd)

    def batch_run(self):
        batch_file = 'batch_run.sh'
        batch_file_path = os.path.join(self.ROOT, batch_file)
        print(f"start batch run {DataService.app_name}")
        batch_content = f'''
{self.hpc_data.get_env()}
cd {DataService.case_dir}
{DataService.batch_cmd}
'''
        self.tool.write_file(batch_file_path, batch_content)
        run_cmd = f'''
chmod +x {batch_file}
./{batch_file}
'''
        self.exe.exec_raw(run_cmd)

    def job_run(self,num):
        job_file = 'job_run.sh'
        job_file_path = os.path.join(self.ROOT, job_file)
        print(f"start job run {DataService.app_name}")
        job_cmd = DataService.job_cmd if num == 1 else DataService.job2_cmd
        job_content = f'''
{self.hpc_data.get_env()}
cd {DataService.case_dir}
cat > run.sh << \EOF
{job_cmd}
EOF

chmod +x run.sh
if type djob >/dev/null 2>&1;then
    dsub -s run.sh
elif type sbatch >/dev/null 2>&1;then
    sbatch run.sh
else
    echo "dsub not exists."
fi
'''
        self.tool.write_file(job_file_path, job_content)
        run_cmd = f'''
chmod +x {job_file}
./{job_file}
'''
        self.exe.exec_raw(run_cmd)
