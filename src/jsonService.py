import json
import os
from pathlib import Path
from typing import Any, Dict, Optional

class JSONService:
    """提供JSON文件读写和数据处理的服务类"""
    
    def __init__(self, filepath: str) -> None:
        """
        初始化JSON服务
        
        :param filepath: JSON文件路径
        :raises FileNotFoundError: 当文件不存在时抛出
        :raises json.JSONDecodeError: 当JSON解析失败时抛出
        """
        self._filepath = Path(filepath).absolute()
        self._data: Dict[str, Any] = {}
        self._load_data()

    def _load_data(self) -> None:
        """加载JSON文件数据到内存"""
        try:
            if not self._filepath.exists():
                raise FileNotFoundError(f"JSON文件不存在: {self._filepath}")
            
            with self._filepath.open('r', encoding='utf-8') as f:
                self._data = json.load(f)
                
            if not isinstance(self._data, dict):
                raise ValueError("JSON文件内容必须为字典结构")
                
        except json.JSONDecodeError as e:
            raise json.JSONDecodeError(f"JSON解析失败: {self._filepath}", e.doc, e.pos) from e

    def save(self, indent: int = 4, ensure_ascii: bool = False) -> None:
        """
        将内存数据持久化到文件
        
        :param indent: 缩进空格数
        :param ensure_ascii: 是否转义非ASCII字符
        """
        with self._filepath.open('w', encoding='utf-8') as f:
            json.dump(self._data, f, indent=indent, ensure_ascii=ensure_ascii)

    @property
    def data(self) -> Dict[str, Any]:
        """获取完整数据字典的只读视图"""
        return self._data.copy()

    def get(self, key: str, default: Optional[Any] = None) -> Optional[Any]:
        """
        安全获取数据项
        
        :param key: 数据键名
        :param default: 键不存在时返回的默认值
        :return: 键对应的值或默认值
        """
        return self._data.get(key, default)

    def set(self, key: str, value: Any, auto_save: bool = False) -> None:
        """
        设置数据项
        
        :param key: 数据键名
        :param value: 要设置的值
        :param auto_save: 是否自动保存到文件
        :raises TypeError: 当键名不是字符串时抛出
        """
        if not isinstance(key, str):
            raise TypeError("键名必须是字符串类型")
        self._data[key] = value
        if auto_save:
            self.save()

    def delete(self, key: str, auto_save: bool = False) -> bool:
        """
        删除数据项
        
        :param key: 要删除的键名
        :param auto_save: 是否自动保存到文件
        :return: 是否成功删除
        """
        if key in self._data:
            del self._data[key]
            if auto_save:
                self.save()
            return True
        return False

    def update(self, mapping: Dict[str, Any], auto_save: bool = False) -> None:
        """
        批量更新数据
        
        :param mapping: 要合并的字典数据
        :param auto_save: 是否自动保存到文件
        """
        self._data.update(mapping)
        if auto_save:
            self.save()

    @classmethod
    def from_dict(cls, data: Dict[str, Any], filepath: str) -> 'JSONService':
        """
        从字典创建JSON服务实例
        
        :param data: 初始数据字典
        :param filepath: 目标文件路径
        :return: JSONService实例
        """
        instance = cls(filepath)
        instance._data = data.copy()
        instance.save()
        return instance

    def to_json_str(self, indent: Optional[int] = None) -> str:
        """
        将当前数据转换为JSON字符串
        
        :param indent: 缩进格式设置
        :return: 格式化后的JSON字符串
        """
        return json.dumps(self._data, indent=indent, ensure_ascii=False)

