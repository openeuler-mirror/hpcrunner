from abc import ABC, abstractmethod
from pathlib import Path
from softwareTypes import SoftwareType, SoftwareProfile, EnvironmentProfile
from collections import defaultdict
from deploymentConfig import DeploymentConfig
from collections import defaultdict
import os

class PathBuilder(ABC):
    def __init__(self, base_config: DeploymentConfig):
        self.config = base_config
    
    @abstractmethod
    def build_path(self, software: SoftwareProfile, env: EnvironmentProfile) -> Path:
        pass

    def add_mpi_path(self, software_info, env_info, install_path):
        if not software_info.use_mpi:
            return install_path
        mpi_str = env_info.mpi_name + env_info.mpi_version
        print("Use MPI: "+mpi_str)
        if self.config.is_pro:
            install_path = os.path.join(install_path, mpi_str)
        else:
            install_path = f"{install_path}-{mpi_str}"
        return install_path

class MpiPathBuilder(PathBuilder):
    def build_path(self, software: SoftwareProfile, env: EnvironmentProfile) -> Path:
        folder_pattern = (
            self.config.pro_path_pattern if self.config.is_pro 
            else self.config.normal_path_pattern
        )
        return self._construct_mpi_path(folder_pattern, software, env)

    def _construct_mpi_path(self, pattern: str, software: SoftwareProfile, env: EnvironmentProfile) -> Path:
        path_vars = {
                'name': software.name,
                'version': software.full_version,
                'compiler': env.compiler_name,
                'compiler_ver': env.compiler_version
            }
        return self.config.mpi_base / pattern.format(**path_vars)

class CompilerPathBuilder(PathBuilder):
    def build_path(self, software: SoftwareProfile, _: EnvironmentProfile) -> Path:
        return self.config.compiler_base / f"{software.name}/{software.full_version}"

class UtilPathBuilder(PathBuilder):
    def build_path(self, software: SoftwareProfile, _: EnvironmentProfile) -> Path:
        util_path = self.config.util_base / f"{software.name}/{software.full_version}"
        return util_path.absolute()

class MiscPathBuilder(PathBuilder):
    def build_path(self, software: SoftwareProfile, _: EnvironmentProfile) -> Path:
        return self.config.misc_base / f"{software.name}/{software.full_version}"

class LibPathBuilder(PathBuilder):
    def build_path(self, software: SoftwareProfile, env: EnvironmentProfile) -> Path:
        base_path = self.config.lib_base
        if self.config.is_pro:
            lib_path = os.path.join(base_path, f"{env.compiler_name}{env.compiler_version}")
            lib_path = self.add_mpi_path(software, env, lib_path)
            lib_path = os.path.join(lib_path, f"{software.name}/{software.full_version}")
        else:
            lib_path = os.path.join(base_path, f"{software.name}/{software.full_version}-{env.compiler_name}{env.compiler_version}")
            lib_path = self.add_mpi_path(software, env, lib_path)
        return lib_path

class AppPathBuilder(PathBuilder):
    def build_path(self, software: SoftwareProfile, env: EnvironmentProfile) -> Path:
        base_path = self.config.app_base
        app_path = os.path.join(base_path, f"{software.name}/{software.full_version}-{env.compiler_name}{env.compiler_version}")
        app_path = self.add_mpi_path(software, env, app_path)
        return app_path

class PathFactory:
    _builder_registry = defaultdict(lambda: None)

    def __init__(self, config: DeploymentConfig):
        self.config = config
        self._initialize_builders()

    def _initialize_builders(self):
        self._builder_registry.update({
            SoftwareType.MPI: MpiPathBuilder(self.config),
            SoftwareType.COMPILER: CompilerPathBuilder(self.config),
            SoftwareType.LIB: LibPathBuilder(self.config),
            SoftwareType.APP: AppPathBuilder(self.config),
            SoftwareType.UTIL: UtilPathBuilder(self.config),
            SoftwareType.MISC: MiscPathBuilder(self.config)
        })

    def get_builder(self, software_type: SoftwareType) -> PathBuilder:
        builder = self._builder_registry[software_type]
        if builder:
            return builder
        raise ValueError(f"No path builder registered for {software_type}")

