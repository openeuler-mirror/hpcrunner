from pathlib import Path
from generationStrategy import IGenerationStrategy, BaseStrategy, GCCStrategy, ClangStrategy, MPIStrategy, HPCKitStrategy, KMLStrategy
from pathManager import PathOrganizer
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
        "kml-gcc": KMLStrategy(),
        "kml-bisheng": KMLStrategy()
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
        if config.software_name == "hpckit" or "anaconda" in config.software_name:
            return ""
        
        path_config = PathOrganizer.auto_discover(config.install_root)
        path_commands = []
        
        # 环境变量与路径配置的映射关系
        env_mapping = {
            'PATH': ('bins', lambda x: x),
            'LD_LIBRARY_PATH': ('libs', lambda x: x),
            'C_INCLUDE_PATH': ('includes', lambda x: x),
            'INCLUDE': ('includes', lambda x: x)
        }
        
        # 动态生成有效路径指令
        for env_var, (config_key, formatter) in env_mapping.items():
            paths = path_config.get(config_key, [])
            if not paths:
                continue
                
            formatted_paths = PathOrganizer.format_paths(formatter(paths))
            path_commands.append(f"prepend-path {env_var} {formatted_paths}")
        
        return "\n".join(path_commands) if path_commands else ""

    def _generate_dependencies(self, config: ModuleConfig) -> str:
        return DependencyResolver(config.dependencies).generate_load_commands()

