# types.py
from enum import Enum
from typing import Tuple, Optional, Dict

class InstallMode(Enum):
    PRO = "0"
    NORMAL = "1"

class SoftwareCategory(Enum):
    COMPILER = 1
    MPI = 2
    UTIL = 3
    LIB = 4
    MISC = 5
    APP = 6

VersionInfo = Tuple[str, str]  # (major_version, full_version)

