from enum import Enum, auto
from dataclasses import dataclass

class SoftwareType(Enum):
    COMPILER = auto()
    MPI = auto()
    UTIL = auto()
    MISC = auto()
    LIB = auto()
    APP = auto()

@dataclass(frozen=True)
class SoftwareProfile:
    name: str
    full_version: str
    software_type: SoftwareType
    major_version: str
    suffix: str = ""
    use_mpi: bool = False
    compiler_name: str = None
    install_script_path: str = None

@dataclass
class EnvironmentProfile:
    compiler_name: str
    compiler_version: str
    compiler_major_version: str
