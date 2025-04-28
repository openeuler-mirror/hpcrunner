from abc import ABC, abstractmethod
from moduleConfig import ModuleConfig

class IGenerationStrategy(ABC):
    @abstractmethod
    def generate_header(self, config: ModuleConfig) -> str:
        pass
    
    @abstractmethod
    def generate_body(self, config: ModuleConfig) -> str:
        pass
    
    @abstractmethod
    def generate_footer(self, config: ModuleConfig) -> str:
        pass

class BaseStrategy(IGenerationStrategy):
    def generate_header(self, config: ModuleConfig) -> str:
        return f"""#%Module1.0
set prefix {config.install_root}
set version {config.full_version}
"""

    def generate_body(self, config: ModuleConfig) -> str:
        sname = config.software_name.upper().replace('-', '_')
        return f"""
setenv {sname}_PATH $prefix
"""

    def generate_footer(self, config: ModuleConfig) -> str:
        return ""

class CompilerStrategy(BaseStrategy):
    def generate_body(self, config: ModuleConfig) -> str:
        return f"""
prepend-path MANPATH $prefix/share/man
"""
    
    def generate_footer(self, config: ModuleConfig) -> str:
        if config.is_pro:
            return f"""
prepend-path MODULEPATH {config.attach_module_path}
"""


class GCCStrategy(CompilerStrategy):
    def generate_body(self, config: ModuleConfig) -> str:
        base = super().generate_body(config)
        return base + """
setenv CC gcc
setenv CXX g++
setenv FC gfortran
"""

class ClangStrategy(CompilerStrategy):
    def generate_body(self, config: ModuleConfig) -> str:
        base = super().generate_body(config)
        return base + """
setenv CC clang
setenv CXX clang++
setenv FC flang
"""

class MPIStrategy(BaseStrategy):
    def generate_body(self, config: ModuleConfig) -> str:
        return f"""
setenv MPI_HOME $prefix

setenv OMPI_CC $env(CC)
setenv OMPI_CXX $env(CXX)
setenv OPAL_PREFIX {config.install_root}
setenv PMIX_INSTALL_PREFIX {config.install_root}
setenv MPICC mpicc
setenv MPICXX mpicxx
setenv MPIF90 mpifort
"""

    def generate_footer(self, config: ModuleConfig) -> str:
        if config.is_pro:
            return f"""
prepend-path MODULEPATH {config.attach_module_path}
"""


class HPCKitStrategy(BaseStrategy):
    def generate_footer(self, config: ModuleConfig) -> str:
        return f"""
prepend-path MODULEPATH  {config.install_root}/HPCKit/latest/modulefiles
"""

class KMLStrategy(BaseStrategy):
    def generate_body(self, config: ModuleConfig) -> str:
        base = super().generate_body(config)
        libs_dir = [
            "$prefix/lib/kblas/nolocking",
            "$prefix/lib/kblas/pthread",
            "$prefix/lib/kblas/omp",
            "$prefix/lib/kblas/locking",
            "$prefix/lib/kvml/single",
            "$prefix/lib/kvml/multi",
            "$prefix/lib/kspblas/single",
            "$prefix/lib/kspblas/multi"
        ]
        return base + f"""
prepend-path LD_LIBRARY_PATH {':'.join(libs_dir)}
"""

