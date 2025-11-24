from pathlib import Path
from typing import List
from collections import OrderedDict

class PathOrganizer:
    install_path = None

    @staticmethod
    def remove_redundant_paths(paths: List[Path]):
        path_objects = { p for p in paths}  # 去重 + 标准化
        unique_paths = set()
        for path in sorted(path_objects, key=lambda p: len(p.parts)):
            if not any(p in path.parents for p in unique_paths):
                unique_paths.add(path)
        return [p for p in unique_paths]

# search_dir: {"include":[], "exclude":[]},
# exclude: 内部合并规则，大吃小，吃不了保留
# "exclude":["/mnt//soft/app/tvm/././bs/tvm","/a/b/d","/a/b/f","/a/b"]
# 有2个独立作用域：/mnt/soft/app/tvm/bs/tvm,/a/b 

# include: 内部合并规则，循序如下
# 1.与install_path 关联路径，则install_path吃大（范围大)或吃重复，重复时则保序，否则放在首位
# 2. 余下则大(范围大)吃小，吃不了，则保留。
# 3. exclude 与include 关联，exclude 相对include 只保留范围小，或者范围独立的
# 例如
# install_path=Path("/mnt//soft/app/tvm/bs/"),"include":["/mnt//soft/app","/root/path_test","/a/b/c","/a/b/c","/a/b/c/d","/a/b/d"]
# /mnt//soft/app/tvm/bs吃掉 include中的/mnt//soft/app,非关联执行大吃小，因此保留：/root/path_test,/a/b/c,/a/b/d

    @staticmethod
    def check_excludes(src: Path, exclude_dirs=[]):
        if not exclude_dirs:
            return False
        for parent in exclude_dirs:
            parent_parts = parent.parts
            child_parts = src.parts
            #print(f'exclude {child_parts}, parent_parts:{parent_parts}')
            if parent_parts == child_parts[:len(parent_parts)] :
                return True
        return False

    @staticmethod
    def auto_discover_inc_exc(install_path: Path,search_dir={}):
        include_dirs=[]
        exclude_dirs=[]
        old_include_dirs=OrderedDict()
        j = -1
        if "include" in search_dir:
            for item in search_dir["include"]:
                # 标准化
                resolve=Path(item).resolve()
                if resolve not in install_path.parents:
                    include_dirs.append(resolve)

            # 删除与install_path重复的元素，只保留第一个
            j = -1
            for i in range(len(include_dirs) - 1, -1, -1):
                if include_dirs[i] == install_path:
                    if j != -1:
                        del include_dirs[j]
                    j = i
        # include_dirs 未包含install_path，则插入第一个位置
        if j == -1:
            include_dirs.insert(0, install_path.resolve())

        # include_dirs的保序列表，后续用于保序
        old_include_dirs=OrderedDict([(x,1) for x in include_dirs])

        # 去重
        include_dirs=PathOrganizer.remove_redundant_paths(include_dirs)

        old_exclude_dirs=OrderedDict()
        if "exclude" in search_dir :
            exclude_dirs=[Path(x).resolve() for x in search_dir["exclude"]]
            old_exclude_dirs=OrderedDict([(x,1) for x in exclude_dirs])
            # 去重+标准化
            exclude_dirs=PathOrganizer.remove_redundant_paths(exclude_dirs)


        #print(f'old_include_dirs:{old_include_dirs}')
        #print(f'include_dirs:{include_dirs}')
        #print(f'exclude_dirs:{exclude_dirs}')

        #print("++++++++++++++++++")

        new_exclude_dirs=[]
        for x in exclude_dirs:
            findOjb=False

            # include 已经包含目录名称，则跳过
            if x in include_dirs:
                continue;

            # include parents 包含目录名称，则跳过
            for y in include_dirs:
                if x in y.parents:
                    findOjb=True
                    break;

            if not findOjb:
                new_exclude_dirs.append(x)

        exclude_dirs=new_exclude_dirs

        #print(f'inc_exc_dirs:{include_dirs}')
        #print(f'exclude_dirs:{exclude_dirs}')

        #print("--------------------")
        # old_include_dirs 是保序记录，include_dirs 是去重记录，综合是保序去重
        # old_exclude_dirs 是保序记录，exclude_dirs 是去重记录，综合是保序去重
        include_dirs=[ x for x in old_include_dirs if x in include_dirs ]
        exclude_dirs=[ x for x in old_exclude_dirs if x in exclude_dirs ]

        #print(f'last old_include_dirs:{old_include_dirs}')
        #print(f'last old_exclude_dirs:{old_exclude_dirs}')
        #print(f'last inc_exc_dirs:{include_dirs}')
        #print(f'last exclude_dirs:{exclude_dirs}')

        dir_bins=[]
        for x in include_dirs:
            dir_bins_inner=[]
            for obj in x.glob("**/bin"):
                if obj.is_dir() and not PathOrganizer.check_excludes(obj,exclude_dirs):
                    dir_bins_inner.append(obj)
            if dir_bins_inner:
                sorted(dir_bins_inner)
                dir_bins.extend(dir_bins_inner)
        
        dir_libs=[]
        for x in include_dirs:
            dir_libs_inner=[]
            for obj in x.glob("**/lib*"):
                if obj.is_dir() and not PathOrganizer.check_excludes(obj,exclude_dirs):
                    dir_libs_inner.append(obj)
            if dir_libs_inner:
                sorted(dir_libs_inner)
                dir_libs.extend(dir_libs_inner)

        dir_includes=[]
        for x in include_dirs:
            dir_includes_inner=[]
            for obj in x.glob("**/include*"):
                if obj.is_dir() and not PathOrganizer.check_excludes(obj,exclude_dirs):
                    dir_includes_inner.append(obj)

            if dir_includes_inner:
                sorted(dir_includes_inner)
                dir_includes.extend(dir_includes_inner)

        print(f'dir_bins:============================\n{dir_bins}')
        print(f'dir_libs:============================\n{dir_libs}')
        print(f'dir_includes:============================\n{dir_includes}')

        return {
                "bins":dir_bins,
                "libs":dir_libs,
                "includes":dir_includes
            }

    @staticmethod
    def auto_discover(install_path: Path,search_dir={}):
        PathOrganizer.install_path = install_path
        if search_dir is  None:
            return {
                "bins": sorted([p for p in install_path.glob("**/bin") if p.is_dir()]),
                "libs": sorted([p for p in install_path.glob("**/lib*") if p.is_dir()]),
                "includes": sorted([p for p in install_path.glob("**/include*") if p.is_dir()])
            }
        else:
            return PathOrganizer.auto_discover_inc_exc(install_path, search_dir)
			

    @staticmethod
    def format_paths(paths) -> str:
        if PathOrganizer.install_path is None:
            raise ValueError("install_path is not set. Please call auto_discover first.")
        return ":".join(f"$prefix/{p.relative_to(PathOrganizer.install_path)}" for p in paths)

