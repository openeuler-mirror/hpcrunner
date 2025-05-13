import os
from dataService import DataService
from toolService import ToolService
from typing import List, Dict, Tuple

class CommandBuilder:
    """命令构造组件 (与DataService解耦)"""
    def __init__(self):
        self.ds = DataService()
        self.tool_service = ToolService()
        self.ROOT = os.getcwd()

    def env_generate(self) -> str:
        """环境文件生成命令 (模板方法)"""
        env_file = self.ds.get_env_file()
        self.tool_service.write_file(env_file, self.ds.env_content)
        print(f"ENV FILE {env_file} GENERATED.")
        return f'chmod +x {env_file}'

    def env_activation(self) -> str:
        """环境激活命令 (模板方法)"""
        env_file = self.ds.get_env_file()
        return f'source {env_file}'

    def clean(self) -> str:
        """构建清理命令链"""
        return self._chain_commands([
            self.env_activation,
            f'cd {self.ds.app_config.build_dir}',
            self.ds.clean_cmd
        ])

    def build(self) -> str:
        """构建编译命令链"""
        return self._chain_commands([
            f'cd {self.ds.app_config.build_dir}',
            self.ds.build_cmd
        ])

    def run(self) -> str:
        """生成运行命令核心逻辑"""
        nodes = int(self.ds.run_cmd.get('nodes', 1))
        base_cmd = self.ds.run_cmd.get('run', '')

        # 动态添加hostfile参数
        hostfile = f'--hostfile {self.ds.root_path}/hostfile' if nodes > 1 else ''
        cmd = base_cmd.replace('mpirun', f'mpirun {hostfile}') if 'mpi' in base_cmd else base_cmd

        # 拼接二进制路径和参数
        binary_path = os.path.join(
            self.ds.app_config.binary_dir,
            self.ds.binary_file
        )
        return f'{cmd} {binary_path} {self.ds.get_binary_para()}'

    def full_run(self) -> str:
        """完整运行环境命令链"""
        return self._chain_commands([
            self.env_activation(),
            f'cd {self.ds.app_config.case_dir}',
            self.run()
        ])
    
    def batch_run(self):
        batch_file_path = self.ds.get_batch_run_file()
        print(f"start batch run {self.ds.get_app_name()}")
        batch_content = self._chain_commands([
            self.env_activation(),
            f'cd {self.ds.app_config.case_dir}',
            self.ds.get_batch_cmd()
        ])
        self.tool_service.write_file(batch_file_path, batch_content)
        return self._chain_commands([
            f"chmod +x {batch_file_path}",
            f"sh {batch_file_path}"
        ])

    def job_run(self, num):
        job_file_path = self.ds.get_job_run_file()
        print(f"start job run {self.ds.get_app_name()}")
        job_cmd = self.ds.get_job_cmd() if num == 1 else self.ds.get_job2_cmd()
        job_content = f'''
{self.env_activation()}
mkdir -p {self.ds.app_config.case_dir}
cd {self.ds.app_config.case_dir}
cat > job_run.sh << \EOF
{job_cmd}
EOF

chmod +x job_run.sh
if type djob >/dev/null 2>&1;then
    dsub -s job_run.sh
elif type sbatch >/dev/null 2>&1;then
    sbatch job_run.sh
else
    echo "dsub not exists."
fi
'''
        self.tool_service.write_file(job_file_path, job_content)
        return self._chain_commands([
            f"chmod +x {job_file_path}",
            f"sh {job_file_path}"
        ])

    @staticmethod
    def _chain_commands(commands: List[str]) -> str:
        """命令链拼接工具 (自动过滤空行)"""
        return '\n'.join([cmd for cmd in commands if cmd.strip()])

