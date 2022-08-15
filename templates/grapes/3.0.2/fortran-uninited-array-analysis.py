# -*- coding: utf-8 -*- 
# 本程序用于自动将Fortran代码中未初始化的变量进行自动初始化
#在气象领域未初始化变量有可能导致计算精度下降

from glob import glob
import re
SRC_PATH = './trams_v3.02/phys/key'
SUBROUTINE_FOR_KEYWORD = 'subroutine'
END_SUBROUTINE_FOR_KEYWORD = 'end subroutine'
INTENT_FOR_KEYWORD = 'intent'
DEFINE_FOR_KEYWORD = '::'
MARK_FOR_KEYWORD = '!'
DIMENSION_FOR_KEYWORD = 'dimension'
POINTER_FOR_KEYWORD = 'pointer'
REAL_FOR_KEYWORD = 'real'
INTEGER_FOR_KEYWORD = 'integer'
DATA_FOR_KEYWORD = 'data'
LOGICAL_FOR_KEYWORD = 'logical'
COMMA = ','
FILE_POSTFIX = ['.F']

def read_file(filename):
    content = ''
    with open(filename) as f:
        content = f.read().strip()
    return content

def write_file(filename, content=""):
    with open(filename,'w') as f:
        f.write(content)

def get_input_para(line):
    input_para = set()
    if line.lower().startswith(SUBROUTINE_FOR_KEYWORD):
        variable_list = re.split(r',|\(|\)', line)
        for exits_variable in variable_list:
            input_para.add(exits_variable.strip())
    return input_para

def get_undefined_variables(line):
    var_list = []
    line_lower = line.lower()
    if DIMENSION_FOR_KEYWORD not in line_lower or POINTER_FOR_KEYWORD in line_lower:
        return var_list
    if INTENT_FOR_KEYWORD not in line_lower and DEFINE_FOR_KEYWORD in line:
        variables = line.split(DEFINE_FOR_KEYWORD)[1].strip()
        var_list = variables.split(COMMA)
    return var_list

def check_is_defined(var , content):
    matched = []
    try:
        pattern = re.compile('.*'+var+r'( *= *\d)')
        matched = re.findall(pattern, content)
    except:
        return False
    #说明定义过
    if len(matched) >= 1:
        return True
    return False

def check_is_valid(var):
    pattern = re.compile('^[_a-zA-Z]\w*$')
    ismatch = re.match(pattern, var)
    if not ismatch:
        return False
    return True

def check_is_input_para(var, input_paras):
    return var in input_paras

def get_var_inited(var, line):
    line_lower = line.lower()
    init_line = ''
    if REAL_FOR_KEYWORD in line_lower:
        init_line= f'{var} = 0.0\n'
    elif INTEGER_FOR_KEYWORD in line_lower:
        init_line= f'{var} = 0\n'
    return init_line

def is_define_line(line):
    line_lower = line
    return line_lower.startswith(DATA_FOR_KEYWORD) or line.startswith(LOGICAL_FOR_KEYWORD)

def get_inited_content(content, last_line, init_lines):
    return content.replace(last_line, last_line + init_lines) 

def init_undefined_variables(content):
    lines = content.splitlines()
    init_lines = '\n'
    last_line = ''
    is_change = 0
    input_paras = set()
    for line in lines:
        line = line.strip()
        input_paras = input_paras | get_input_para(line)
        var_list = get_undefined_variables(line)
        if len(var_list)>0:last_line = line
        for var in var_list:
            var = var.strip()
            if check_is_defined(var, content):
                continue
            if not check_is_valid(var):
                continue
            if check_is_input_para(var, input_paras):
                continue
            init_line = get_var_inited(var, line)
            if init_line: is_change = 1
            init_lines += init_line
        if is_define_line(line):
            last_line = line
    init_lines += '\n'
    if not is_change:
        return content
    return get_inited_content(content, last_line, init_lines)

def remove_mk(content):
    #注释的处理
    content_line = content.split('\n')
    nomk_content = ''
    for line in content_line:
        exclamation_index = line.find(MARK_FOR_KEYWORD)
        if exclamation_index >= 0:
           line = line[0:exclamation_index]
        if line:
            nomk_content += line + '\n'
    return nomk_content

def remove_line_break(content):
    return content.replace('&\n', '').replace('& \n', '').replace('&', '')

def split_routine(content):
    return re.split(f'{END_SUBROUTINE_FOR_KEYWORD}|{END_SUBROUTINE_FOR_KEYWORD.lower()}', content)

def handle_routines(routines, filename):
    inited_file_content = []
    for routine in routines:
        content = init_undefined_variables(routine)
        inited_file_content.append(content)
    write_file(filename, END_SUBROUTINE_FOR_KEYWORD.lower().join(inited_file_content))

def init_file(filename):
    content = read_file(filename)
    content = remove_mk(content)
    content = remove_line_break(content)
    routines = split_routine(content)
    handle_routines(routines, filename)
    
def init_all_files():
    file_list = [d for d in glob(SRC_PATH+'/**', recursive=True)]
    for file in file_list:
        if file.endswith('.F'):
            init_file(file)
            print(file+" Successfully INITED")

if __name__ == "__main__":
    init_all_files()