#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
from abc import ABC, abstractmethod
from versionParser import VersionParser
from executeService import ExecuteService
from typing import Dict

class DetectorService(ABC):
    def __init__(self):
        self.exe = ExecuteService()
    
    @abstractmethod
    def detect(self) -> Dict:
        pass

class GCCDetector(DetectorService):
    def detect(self) -> Dict:
        gcc_info_list = self.exe.exec_get_output("gcc -v")
        gcc_info = gcc_info_list[-1].strip()
        version = VersionParser.parse(gcc_info)
        if not version:
            print("GCC not found, please install gcc first")
            sys.exit()
        name = 'gcc'
        if 'kunpeng' in gcc_info.lower():
            name =  'kgcc'
        profile = VersionParser.gen_compiler_profile(name, version)
        return profile

class ClangDetector(DetectorService):
    def detect(self) -> Dict:
        clang_info_list = self.exe.exec_get_output('clang -v')
        clang_info = clang_info_list[0].strip()
        version = VersionParser.parse(clang_info)
        if not version:
            print("clang not found, please install clang first")
            sys.exit()
        name = 'clang'
        if 'bisheng' in clang_info.lower():
            name =  'bisheng'
        profile = VersionParser.gen_compiler_profile(name, version)
        return profile

class NVCCDetector(DetectorService):
    def detect(self) -> Dict:
        nv_info_list = self.exe.exec_get_output("nvcc -v")
        nv_info = nv_info_list[-1].strip()
        version = VersionParser.parse(nv_info)
        if not version:
            print("nvcc not found, please install cuda first")
            sys.exit()
        name =  'nvcc'
        profile = VersionParser.gen_compiler_profile(name, version)
        return profile

class ICCDetector(DetectorService):
    def detect(self) -> Dict:
        icc_info_list = self.exe.exec_get_output("icc --version")
        icc_info = icc_info_list[-1].strip()
        version = VersionParser.parse(icc_info)
        if not version:
            print("ICC not found, please install icc first")
            sys.exit()
        name = 'icc'
        profile = VersionParser.gen_compiler_profile(name, version)
        return profile

class HMPIDetector(DetectorService):
    def get_hmpi_version(self, hmpi_v3_info):
        if hmpi_v3_info != "":
            ucg_path = self.exe.exec_get_output('which ucg_info')[0]
        else:
            ucg_path = self.exe.exec_get_output('which ucx_info')[0]
        ver_dict = {('2','2.0.0'): ('1','1.3.0')}
        ucg_path = os.path.dirname(ucg_path)
        ucg_path = os.path.dirname(ucg_path)
        libucg_path = os.path.join(ucg_path, "lib")
        libucg_so_flag = "libucg.so."
        version = None
        for file_name in os.listdir(libucg_path):
            if libucg_so_flag in file_name:
                version = VersionParser.parse(file_name)
                if version in ver_dict:
                    return ver_dict[version]
                elif version:
                    break
        return version

    def detect(self) -> Dict:
        hmpi_v2_info = (self.exe.exec_get_output('(ucx_info -c | grep -i BUILT)')[0]).upper()
        hmpi_v3_info = (self.exe.exec_get_output('(ucg_info -c | grep -i PLANC)')[0]).upper()
        if "BUILT" not in hmpi_v2_info and "PLANC" not in hmpi_v3_info:
            return None
        name = 'hmpi'
        version = self.get_hmpi_version(hmpi_v3_info)
        profile = VersionParser.gen_mpi_profile(name, version)
        return profile

class OpenMPIDetector(DetectorService):
    def detect(self) -> Dict:
        mpi_info_list = self.exe.exec_get_output('mpirun -version')
        mpi_info = mpi_info_list[0].strip()
        name = 'openmpi'
        version = VersionParser.parse(mpi_info)
        if not version:
            return None
        profile = VersionParser.gen_mpi_profile(name, version)
        return profile

class MPICHDetector(DetectorService):
    def detect(self) -> Dict:
        mpi_info_list = self.exe.exec_get_output('mpirun -version')
        mpi_info = "".join(mpi_info_list).strip()
        name = 'mpich'
        if name not in mpi_info:
            return None
        version = VersionParser.parse(mpi_info)
        if not version:
            return None
        profile = VersionParser.gen_mpi_profile(name, version)
        return profile

