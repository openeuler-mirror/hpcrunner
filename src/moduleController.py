from pathlib import Path
from generationStrategy import IGenerationStrategy, BaseStrategy, GCCStrategy, ClangStrategy, MPIStrategy, HPCKitStrategy, KMLStrategy
from pathManager import PathOrganizer
from envVarGenerator import EnvVarGenerator
from softwareTypes import SoftwareType
from moduleConfig import ModuleConfig
from dependencyManager import DependencyResolver

class ModulefileEngine:
    STRATEGY_MAP = {
        "gcc": GCCStrategy(),
        "kgcc": GCCStrategy(),
        "clang": ClangStrategy(),
        "bisheng": ClangStrategy(),
        "openmpi": MPIStrategy(),
        "hmpi": MPIStrategy(),
        "hpckit": HPCKitStrategy(),
        "kml": KMLStrategy()
    }

    def __init__(self, strategy: IGenerationStrategy = None):
        self.strategy = strategy or BaseStrategy()
        
    def generate(self, config: ModuleConfig) -> str:
        self.strategy = self.STRATEGY_MAP.get(config.software_name, BaseStrategy())
        sections = [
            self.strategy.generate_header(config),
            self.strategy.generate_body(config),
            self._generate_dependencies(config),
            self._generate_paths(config),
            self.strategy.generate_footer(config)
        ]
        return "\n".join(filter(None, sections))

    def _generate_paths(self, config: ModuleConfig) -> str:
        if config.software_name == "hpckit":
            return ""
        path_config = PathOrganizer.auto_discover(config.install_root)
        return f"""
prepend-path PATH {PathOrganizer.format_paths(path_config['bins'])}
prepend-path LD_LIBRARY_PATH {PathOrganizer.format_paths(path_config['libs'])}
prepend-path C_INCLUDE_PATH {PathOrganizer.format_paths(path_config['includes'])}
"""

    def _generate_dependencies(self, config: ModuleConfig) -> str:
        return DependencyResolver(config.dependencies).generate_load_commands()

