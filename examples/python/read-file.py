#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
import chardet
 
file_name = 'turbulence.F90'
with open(file_name , 'rb') as f:
    data = f.read()
    try:
        content = data.decode('utf-8')
    except Exception as e :
        code_type = chardet.detect(data)['encoding']
        content = data.decode(code_type)
    print(content)
    print("The encoding is "+code_type)