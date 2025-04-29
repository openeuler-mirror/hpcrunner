from dataclasses import dataclass
from enum import Enum
from typing import Tuple, Optional, Dict
from softwareTypes import SoftwareProfile, EnvironmentProfile

class InstallMode(Enum):
    PRO = "0"
    NORMAL = "1"

@dataclass
class InstallProfile:
    install_path: str = ""
    software_info: SoftwareProfile = None
    env_info: EnvironmentProfile = None

VersionInfo = Tuple[str, str]  # (major_version, full_version)

