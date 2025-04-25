from abc import ABC, abstractmethod
from pathlib import Path
from softwareTypes import SoftwareProfile, EnvironmentProfile
from collections import defaultdict

class PathBuilder(ABC):
    def __init__(self, base_config: 'DeploymentConfig'):
        self.config = base_config
    
    @abstractmethod
    def build_path(self, software: SoftwareProfile, env: EnvironmentProfile) -> Path:
        pass

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
        return self.config.compiler_base / f"{software.name}/{software.version}"

class LibPathBuilder(PathBuilder):
    def build_path(self, software: SoftwareProfile, env: EnvironmentProfile) -> Path:
        base_path = self.config.pro_lib_base if self.config.is_pro else self.config.normal_lib_base
        path_segments = [
            f"{env.compiler_name}{env.compiler_version}",
            *([f"mpi{env.mpi_version}"] if software.requires_mpi else []),
            f"{software.name}/{software.version}"
        ]
        return base_path.joinpath(*path_segments)

from collections import defaultdict

class PathFactory:
    _builder_registry = defaultdict(lambda: None)

    def __init__(self, config: 'DeploymentConfig'):
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

        if builder := self._builder_registry[software_type]:
            return builder
        raise ValueError(f"No path builder registered for {software_type}")

