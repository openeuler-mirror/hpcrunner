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

        #基础module路径配置
        if not self.is_pro:
            self.mpi_module_base = Path(paths['MODULE_MPI_PATH'])
            self.compiler_module_base = Path(paths['MODULE_COMPILER_PATH'])
            self.lib_module_base = Path(paths['MODULE_LIB_PATH'])
            self.util_module_base = Path(paths['MODULE_UTIL_PATH'])
            self.app_module_base = Path(paths['MODULE_APP_PATH'])
            self.misc_module_base = Path(paths['MODULE_MISC_PATH'])
        else:
            self.mpi_module_base = Path(paths['MODULE_DEPS_PATH'])
            self.compiler_module_base = Path(paths['MODULE_FILES'])
            self.lib_module_base = Path(paths['MODULE_DEPS_PATH'])
            self.util_module_base = Path(paths['MODULE_FILES'])
            self.app_module_base = Path(paths['MODULE_APP_PATH'])
            self.misc_module_base = Path(paths['MODULE_FILES'])
        # 路径模式配置
        self.pro_path_pattern = "{name}{version}-{compiler}{compiler_ver}/{version}"
        self.normal_path_pattern = "{name}/{version}-{compiler}{compiler_ver}"
        
        self.pro_module_path_pattern = "{compiler}{compiler_ver}/{name}/{version}"
