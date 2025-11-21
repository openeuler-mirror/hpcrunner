class DependencyResolver:
    def __init__(self, required_deps):
        self.required = required_deps
        
    def generate_load_commands(self) -> str:
        if not self.required:
            return ""
        required_deps = " ".join(self.required)
        depend_content='''
foreach dep {%s} {
    if { ![is-loaded $dep] } {
        module load $dep
    }
}
''' % required_deps
        return depend_content
