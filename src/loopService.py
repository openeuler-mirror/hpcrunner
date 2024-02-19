#!/usr/bin/env python3
# -*- coding: utf-8 -*- 
# 本程序自动根据循环内变量生成模拟数据和可直接运行的代码
# 优点：
# 1.极速调优，可添加向量化和并行化支持  
# 2.自动性能评测，性能优劣一目了然  
# 3.快速查看不同编译选项下的汇编代码，辅助调优 
# 4.快速调试，直观了解程序逻辑  
# 5.快速校验性能是否影响精度问题
# 缺点：数据规模需要自己调节
# 使用步骤：
# 1.将循环粘贴到LOOP处
# 2.修改代码以编译、运行，添加正确性验证代码(只需添加改变值的数组的初始化)
# 3.修改数据规模让运行总耗时在1000ms以上
# 4.优化代码，使优化效果稳定在20%以上
# 5.回合循环，查看加速效果
import re
from toolService import ToolService
from dataService import DataService

MARK_FOR_KEYWORD = '!'
VAR_REG = '[_a-zA-Z]\w*'
ITER_NUM = 1000

class LoopService:
    def __init__(self):
        self.tool = ToolService()
        self.data = DataService()
    
    def remove_mk(self, content):
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

    def remove_line_break(self, content):
        return content.replace('&\n', '').replace('& \n', '').replace('&', '')

    def get_dim_str(self, dim_list, level = 1):
        if len(dim_list) > 0:
            dimensions = ','.join(['nnxx']*level)
            dim_str = ','.join(dim_list)
            return f'   integer, dimension ({dimensions}) ::{dim_str}\n'
        return ''

    def get_simulate_code(self):
        loop_code = DataService.loop_cmd
        print(loop_code)
        if loop_code.strip() == '':
            print("No Loop code detected! please add your code under [LOOP] section.")
            return
        filename = "simulated.F90"
        content = self.remove_mk(loop_code)
        content = self.remove_line_break(content)
        integer_list = []
        dim1_list = []
        dim2_list = []
        dim3_list = []
        dim4_list = []
        init_list = []
        fortran_keywords = ['THEN','SELECT','PROGRAM','PRINT','STOP','END','ENDDO','WRITE','INTEGER','REAL','COMPLEX','CHARACTER','LOGICAL','READ','FORMAT','IMPLICIT','PARAMETER','DATA','EQUIVALENCE','TYPE','PAUSE','CONTINUE','CYCLE','EXIT','IF','SELECT','DO','ALLOCATE','DEALLOCATE','WHERE','FORALL','SUBROUTINE','CALL','RETURN','FUNCTION','COMMON','BLOCKDATA','SAVE','INTERFACE','CONTAINS','MODULE','USE','PUBLIC','PRIVATE','ENTRY','OPEN','INQUIRE','CLOSE','NAMELIST','POINTER','NULLFY','REWIND','BACKSPACE','ENDFILE','_r8']
        # searching all variable
        all_words = re.findall(VAR_REG, content,re.M)
        variable_list = []
        for word in all_words:
            if word.upper() in fortran_keywords:
                continue
            if word in variable_list:
                continue
            variable_list.append(word)
        # start category
        for variable in variable_list:
            init_list.append(f"   {variable}=1")
            ismatch = re.search("\W"+variable+r' *(\([^\)]*\))', content, re.M)
            if not ismatch:
                integer_list.append(variable)
                continue
            # arrays
            paras = ismatch.groups(1)[0]
            if paras.count(',') == 0:
                dim1_list.append(variable)
            elif paras.count(',') == 1:
                dim2_list.append(variable)
            elif paras.count(',') == 2:
                dim3_list.append(variable)
            elif paras.count(',') == 3:
                dim4_list.append(variable)
        
        array_define = ""
        array_define += self.get_dim_str(dim1_list, 1)
        array_define += self.get_dim_str(dim2_list, 2)
        array_define += self.get_dim_str(dim3_list, 3)
        array_define += self.get_dim_str(dim4_list, 4)
        init_str = '\n'.join(init_list)
        amplifier = 100
        vector_template = f'''
program SimulateExample
    implicit none
    integer         :: t_start,t_stop,time1,time2, ii, flag
    
    integer {','.join(integer_list)}
    integer,parameter:: nnxx={ITER_NUM}
    {array_define}
    flag = 0
    {init_str}
    write(*,*) '********The optimize code START******'
    call system_clock(t_start)
    do ii=1, {amplifier}
        {loop_code}
    end do
    call system_clock(t_stop)
    time1 = t_stop-t_start
    write(*,*) '********The optimize loop time used(ms)******',time1
    write(*,*) '********The origin code START******'
    call system_clock(t_start)
    do ii=1, {amplifier}
        {loop_code}
    end do
    call system_clock(t_stop)
    time2 = t_stop-t_start
    write(*,*) '********The origin loop time used(ms)********',time2
    write(*,*) ' ACC:', (time2-time1)*100.0/time2,'%'
    write(*,*) 'Check if two result is consistent, Please add your code here:'
    loop_i: {loop_code.strip()} loop_i
    if(flag .eq. 0) then
        write(*,*) 'Correct result'
    else
        write(*,*) 'Wrong result'
    end if
end program SimulateExample
    '''
        self.tool.write_file(filename,vector_template)
        print("**********Successfully simulated************")
        print("compile and run: flang -O3 -fopenmp -g -ffast-math simulated.F90 && ./a.out")
        print("reassamblely: objdump -S ./a.out > assemble.txt")
