import json
import os

class JSONService:
    def __init__(self, filename):
        self.filename = filename
        self.data = self.read_file()

    # 读取 JSON 文件
    def read_file(self):
        if not os.path.exists(self.filename):
            with open(self.filename, 'w') as f:
                f.write('{}')
        with open(self.filename, "r") as file:
            data = json.load(file)
        return data

    # 写入 JSON 文件
    def write_file(self):
        with open(self.filename, "w") as file:
            json.dump(self.data, file, indent=4)

    # 查询数据
    def query_data(self, key):
        if key in self.data:
            return self.data[key]
        else:
            return None

    # 添加数据
    def add_data(self, key, value):
        self.data[key] = value

    # 删除数据
    def delete_data(self, key):
        if key in self.data:
            del self.data[key]
        else:
            print("Key not found")

    # 修改数据
    def update_data(self, key, value):
        if key in self.data:
            self.data[key] = value
        else:
            print("Key not found")

    def json_transform(self, dict):
        return json.dumps(dict)