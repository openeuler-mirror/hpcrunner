from pathBuilder import PathFactory
from deploymentConfig import DeploymentConfig
from softwareTypes import SoftwareType, SoftwareProfile, EnvironmentProfile
from installTypes import InstallMode

class DeploymentService:
    def __init__(self, config: DeploymentConfig):
        self.factory = PathFactory(config)
        self.config = config

    def resolve_install_path(
        self,
        software: SoftwareProfile,
        env: EnvironmentProfile
    ) -> Path:
        """生成规范化安装路径"""
        self._validate_input(software, env)
        
        builder = self.factory.get_builder(software.software_type)
        path = builder.build_path(software, env)
        return path.absolute()

    def _validate_input(self, software: SoftwareProfile, env: EnvironmentProfile):
        if software.software_type == SoftwareType.MPI and not env.mpi_version:
            raise ValueError("MPI software requires MPI version in environment profile")
        
        if software.requires_mpi and not env.mpi_version:
            raise ValueError("MPI-dependent software requires MPI version specification")

if __name__ == '__main__':
    dconfig = DeploymentConfig(InstallMode.NORMAL)
    dservice = DeploymentService()

