import re
from typing import Optional, Pattern, Dict
from installTypes import VersionInfo

class VersionParser:
    DEFAULT_REGEX: Pattern = re.compile(r'(\d+)\.(\d+)\.(\d+)')

    @classmethod
    def parse(cls, info: str, pattern: Pattern = DEFAULT_REGEX) -> Optional[VersionInfo]:
        """语义化版本解析"""
        match = pattern.search(info)
        if not match:
            return None
        return (match.group(1), f"{match[1]}.{match[2]}.{match[3]}")

    @classmethod
    def gen_compiler_profile(cls, name: str, version: VersionInfo) -> Dict:
        return {
            'cname': name,
            'cmversion': version[0],
            'full_version': version[1]
        }

    @classmethod
    def gen_mpi_profile(cls, name: str, version: VersionInfo) -> Dict:
        return {
            'name': name,
            'mversion': version[0],
            'full_version': version[1]
        }

