# types.py
from enum import Enum
from typing import Tuple, Optional, Dict

class InstallMode(Enum):
    PRO = "0"
    NORMAL = "1"

VersionInfo = Tuple[str, str]  # (major_version, full_version)

