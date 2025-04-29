import os
from typing import Dict
from softwareTypeDetection import SoftwareTypeDetection,MPIStrategy,AppStrategy,DefaultStrategy
from softwareTypes import SoftwareProfile, SoftwareType

class SoftwareFactory:
    PACKAGE = 'package'
    def __init__(self):
        self.ROOT = os.getcwd()
        self.PACKAGE_PATH = os.path.join(self.ROOT, self.PACKAGE)
        self._strategies: Dict[str, SoftwareTypeDetection] = {
            'mpi': MPIStrategy(),
            'app': AppStrategy(),
            'default': DefaultStrategy()
        }
    
    def create_profile(self, software_path: str, compiler_mpi_info: str, isapp=False) -> SoftwareProfile:
        """创建软件信息对象的统一入口"""
        compiler_mpi_info = compiler_mpi_info.upper()
        (software_name, version, suffix) = self._parse_name_and_version(software_path)
        software_type = self._determine_type(software_name, compiler_mpi_info, isapp)
        profile = SoftwareProfile(
            name=self._handle_suffix(software_name, suffix),
            full_version=version,
            major_version=self._parse_major_version(version),
            software_type=software_type,
            suffix=suffix,
            use_mpi='+MPI' in compiler_mpi_info,
            compiler_name=compiler_mpi_info.split('+')[0] if '+' in compiler_mpi_info else compiler_mpi_info,
            install_script_path=self._get_install_script_path(software_name, version, software_type, suffix),
        )
        return profile
    
    def _handle_suffix(self, name: str, suffix):
        if suffix != "":
            return f"{name}-{suffix}"
        return name
    
    def _determine_type(self, name: str, compiler_info: str, isapp=False) -> SoftwareType:
        for strategy in self._strategies.values():
            detected_type = strategy.detect(name, compiler_info, isapp)
            if detected_type:
                return detected_type
        return SoftwareType.LIB
    
    @staticmethod
    def _parse_major_version(version: str) -> str:
        return version.split('.')[0] if version else '0'
    
    def _parse_name_and_version(self, software_path: str) -> str:
        software_path = self._remove_prefix(software_path)
        software_info = software_path.split('/')
        suffix = ""
        if len(software_info) >= 3: suffix = software_info[2]
        return (software_info[0], software_info[1], suffix)
    
    @staticmethod
    def _remove_prefix(software_path):
        if software_path.startswith('package/') or software_path.startswith('./'):
            software_path = software_path.replace('./', '', 1)
            software_path = software_path.replace('package/', '', 1)
        return software_path
    
    def _get_install_script_path(self, software_name, version, software_type, suffix):
        if software_type == SoftwareType.APP:
            return False
        install_script_path = os.path.join(self.PACKAGE_PATH, software_name, version, suffix)
        if not os.path.exists(install_script_path):
            print(f"{software_path} not exist, are you sure the software lies in package dir?")
            sys.exit()
        return install_script_path

