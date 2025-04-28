import os
from typing import Dict
from softwareTypes import SoftwareProfile, SoftwareType, EnvironmentProfile
from detectorService import GCCDetector, ClangDetector,NVCCDetector,ICCDetector
from detectorService import HMPIDetector, OpenMPIDetector, MPICHDetector
from versionParser import VersionParser

class EnvFactory:
    def __init__(self):
        self.ROOT = os.getcwd()
        self.gcc_detector = GCCDetector()
        self.clang_detector = ClangDetector()
        self.icc_detector = ICCDetector()
        self.nvcc_detector = NVCCDetector()

        self.hmpi_detector = HMPIDetector()
        self.openmpi_detector = OpenMPIDetector()
        self.mpich_detector = MPICHDetector()
        self._compilers = {
                "GCC":self.gcc_detector.detect, 
                "CLANG":self.clang_detector.detect,
                "NVC":self.nvcc_detector.detect,
                "ICC":self.icc_detector.detect,
                "BISHENG": self.clang_detector.detect
                }
    
    def create_profile(self, software: SoftwareProfile, compiler_mpi_info: str) -> EnvironmentProfile:
        """创建环境信息对象的统一入口"""
        compiler_mpi_info = self._check_compiler_mpi(self._compilers.keys(), compiler_mpi_info)
        stype = software.software_type
        if stype != SoftwareType.LIB and stype != SoftwareType.MPI and stype != SoftwareType.APP:
            return None
        compiler_info = self._get_compiler_info(compiler_mpi_info)
        profile = EnvironmentProfile(
            compiler_name=compiler_info['cname'],
            compiler_version=compiler_info['full_version'],
            compiler_major_version=compiler_info['cmversion']
        )
        if software.use_mpi:
            mpi_info = self._get_mpi_info()
            profile.mpi_name = mpi_info['name']
            profile.mpi_version = mpi_info['full_version']
            profile.mpi_major_version = mpi_info['mversion']
        return profile
    
    def _check_compiler_mpi(self, compiler_list, compiler_mpi_info):
        no_compiler = ["COM","ANY","MISC","APP"]
        is_valid = False
        compiler_mpi_info = compiler_mpi_info.upper()
        valid_list = []
        for compiler in compiler_list:
            valid_list.append(compiler)
            valid_list.append(f'{compiler}+MPI')
        valid_list += no_compiler
        for valid_para in valid_list:
            if compiler_mpi_info == valid_para:
                is_valid = True
                break
        if not is_valid:
            print(f"compiler or mpi info error, Only {valid_list.join('/').lower()} is supported")
            sys.exit()
        return compiler_mpi_info

    def _get_compiler_info(self, compiler_mpi_info):
        compiler_info = None
        for compiler, info_func in self._compilers.items():
            if compiler in compiler_mpi_info:
                compiler_info = info_func()
                break
        if compiler_info == None:
            print(f"The specified {compiler_mpi_info} Compiler not found!")
            sys.exit()
        cname = compiler_info['cname']
        cfullver = compiler_info['full_version']
        print(f"Use Compiler: {cname} {cfullver}")
        return compiler_info

    def _get_mpi_info(self):
        mpich_info = self.mpich_detector.detect()
        if mpich_info:return mpich_info
        hmpi_info = self.hmpi_detector.detect()
        if hmpi_info:return hmpi_info
        openmpi_info = self.openmpi_detector.detect()
        if openmpi_info:return openmpi_info
        print("MPI not found, please install MPI first.")
        sys.exit()
