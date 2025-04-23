import os
from pathlib import Path
from typing import Dict, Type
from installTypes import InstallMode
class PathStrategy:
    paths = {
            'SOFTWARE_PATH': 'JARVIS_SOFT_ROOT',
            'COMPILER_PATH': 'JARVIS_COMPILER',
            'LIBS_PATH': 'JARVIS_LIBS',
            'MODULE_FILES': 'JARVIS_MODULES',
            'MPI_PATH': 'JARVIS_MPI',
            'UTILS_PATH': 'JARVIS_UTILS',
            'MISC_PATH': 'JARVIS_MISC',
            'APP_PATH': 'JARVIS_APP',
            'MODULE_APP_PATH': 'JARVIS_MODULES_APP'
        }
    def get_paths(self) -> Dict[str, str]:
        raise NotImplementedError

class ProPathStrategy(PathStrategy):
    def get_paths(self) -> Dict[str, str]:
        merged_paths = self.paths.copy()
        merged_paths.update({
            "MODULE_DEPS_PATH":"JARVIS_MODULEDEPS"
            })
        return {k: os.getenv(v) for k, v in merged_paths.items()}

class NormalPathStrategy(PathStrategy):
    def get_paths(self) -> Dict[str, str]:
        merged_paths = self.paths.copy()
        merged_paths.update({
            "MODULE_LIB_PATH":"JARVIS_MODULES_LIB",
            'MODULE_COMPILER_PATH': 'JARVIS_MODULES_COMPILER',
            'MODULE_MISC_PATH': 'JARVIS_MODULES_MISC',
            'MODULE_MPI_PATH': 'JARVIS_MODULES_MPI',
            'MODULE_MOD_PATH': 'JARVIS_MODULES_MODS',
            'JOBSCRIPT_PATH': 'JARVIS_JOBSCRIPT'
            })
        return {k: os.getenv(v) for k, v in merged_paths.items()}

class PathStrategyFactory:
    @classmethod
    def create(cls, mode: InstallMode) -> Type[PathStrategy]:
        strategies = {
            InstallMode.PRO: ProPathStrategy,
            InstallMode.NORMAL: NormalPathStrategy
        }
        return strategies[mode]()

if __name__ == "__main__":
    service = PathStrategyFactory()
    mode = service.create(InstallMode.PRO)
    print(mode.get_paths())
    mode = service.create(InstallMode.NORMAL)
    print(mode.get_paths())

