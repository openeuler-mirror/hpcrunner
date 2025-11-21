from dataclasses import dataclass
from pathlib import Path
from softwareTypes import SoftwareType
from typing import Tuple, Optional, Dict, List

@dataclass
class ModuleConfig:
    is_pro:bool = True
    install_root: Path = None
    software_name: str = ""
    full_version: str = ""
    category: SoftwareType = None
    dependencies: List[str] = None
    attach_module_path: str = ""

