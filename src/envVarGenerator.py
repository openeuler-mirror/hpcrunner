class EnvVarGenerator:
    COMPILER_MAP = {
        "gcc": {"CC": "gcc", "CXX": "g++"},
        "bisheng": {"CC": "clang", "FC": "flang"}
    }

    @classmethod
    def get_compiler_vars(cls, compiler_name: str) -> str:
        vars = cls.COMPILER_MAP.get(compiler_name, {})
        return "\n".join(f"setenv {k} {v}" for k, v in vars.items())

    @staticmethod
    def generate_mpi_vars() -> str:
        return """setenv MPICC mpicc
setenv MPICXX mpicxx
setenv MPIF90 mpifort"""

