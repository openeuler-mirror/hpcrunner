from pathlib import Path
from installTypes import InstallMode

class DeploymentConfig:
    def __init__(self, mode, paths):
        self.is_pro = mode == InstallMode.PRO
        # 基础路径配置
        self.mpi_base = Path(paths['MPI_PATH'])
        self.compiler_base = Path(paths['COMPILER_PATH'])
        self.lib_base = Path(paths['LIBS_PATH'])
        self.util_base = Path(paths['UTILS_PATH'])
        self.app_base = Path(paths['APP_PATH'])
        self.misc_base = Path(paths['MISC_PATH']) 
        # 路径模式配置
        self.pro_path_pattern = "{name}{version}-{compiler}{compiler_ver}/{version}"
        self.normal_path_pattern = "{name}/{version}-{compiler}{compiler_ver}"
        
    @property
    def pro_mpi_path_pattern(self) -> Path:
        return self.pro_path_pattern
    
    @property
    def normal_mpi_path_pattern(self) -> Path:
        return self.normal_path_pattern

