from pathlib import Path

class PathOrganizer:
    install_path = None
    @staticmethod
    def auto_discover(install_path: Path):
        PathOrganizer.install_path = install_path
        return {
            "bins": sorted([p for p in install_path.glob("**/bin") if p.is_dir()]),
            "libs": sorted([p for p in install_path.glob("**/lib*") if p.is_dir()]),
            "includes": sorted([p for p in install_path.glob("**/include*") if p.is_dir()])
        }

    @staticmethod
    def format_paths(paths) -> str:
        if PathOrganizer.install_path is None:
            raise ValueError("install_path is not set. Please call auto_discover first.")
        return ":".join(f"$prefix/{p.relative_to(PathOrganizer.install_path)}" for p in paths)

