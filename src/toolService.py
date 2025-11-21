#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import time
import os

class ToolService:
    def prt_content(self, content):
        """
        在内容上下添加分隔线并打印。
        """
        flags = '*' * 30
        print(f"{flags}\n{content}\n{flags}")

    def gen_list(self, data):
        """
        将字符串按行分割成列表。
        """
        return data.strip().split('\n')

    def get_time_stamp(self):
        """
        获取当前时间的时间戳。
        """
        return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())

    def read_file(self, filename):
        """
        读取文件内容。
        """
        content = ''
        try:
            with open(filename, encoding='utf-8') as f:
                content = f.read().strip()
        except FileNotFoundError:
            pass
        return content

    def write_file(self, filename, content=""):
        """
        将内容写入文件。
        """
        # 获取目标目录路径
        dir_path = os.path.dirname(filename)
        # 若目录不存在，则递归创建（包括所有父目录）
        if dir_path:  # 避免根目录（如 file_path 是 "file.txt"）
            os.makedirs(dir_path, exist_ok=True)
        try:
            with open(filename, 'w', encoding='utf-8') as f:
                f.write(content)
        except Exception as e:
            print(f"str(e)")

    def del_file(self, filepath):
        """
        删除文件。
        """
        if os.path.exists(filepath):
            os.remove(filepath)

    def mkdirs(self, path):
        """
        递归创建目录。
        """
        if not os.path.exists(path):
            os.makedirs(path)

    def mkfile(self, path, content=''):
        """
        创建文件并写入内容。
        """
        if not os.path.exists(path):
            self.write_file(path, content)

    def check_url_isvalid(self, url):
        """
        检查URL是否有效。
        """
        import requests
        try:
            response = requests.get(url, stream=True)
            return response.status_code == 200
        except requests.exceptions.RequestException as e:
            return False
