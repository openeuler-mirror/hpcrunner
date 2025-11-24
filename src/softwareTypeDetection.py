from abc import ABC, abstractmethod
from softwareTypes import SoftwareProfile, SoftwareType

class SoftwareTypeDetection(ABC):
    @abstractmethod
    def detect(self, software_name: str, compiler_info: str, isapp = False) -> SoftwareType:
        pass

class MPIStrategy(SoftwareTypeDetection):
    MPI_KEYWORDS = {'hmpi', 'openmpi', 'hpcx', 'mpich'}

    def detect(self, name: str, _: str, isapp = False) -> SoftwareType:
        return SoftwareType.MPI if any(name.startswith(kw) for kw in self.MPI_KEYWORDS) else None

class AppStrategy(SoftwareTypeDetection):
    def detect(self, _: str, compiler_info: str, isapp = False) -> SoftwareType:
        return SoftwareType.APP if isapp else None

class DefaultStrategy(SoftwareTypeDetection):
    TYPE_MAPPING = {
        "COM": SoftwareType.COMPILER,
        "ANY": SoftwareType.UTIL,
        "MISC": SoftwareType.MISC
    }

    def detect(self, _: str, compiler_info: str, isapp = False) -> SoftwareType:
        return self.TYPE_MAPPING.get(compiler_info, SoftwareType.LIB)

