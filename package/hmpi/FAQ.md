Q：hucx/src/ucs/arch/aarch64/cpu.h：259:20：error: redefinition of 'ucs_arch_clear_cache'

A:报错原因为该函数在其他地方已经被声明过了，无需重复声明, 应将src/ucs/arch/aarch64/cpu.h 中位于259–271行的函数注释或者删除掉

Q: builtin.c: 969:21: error: comparison of array 'builtin_op->steps' not equal to a null pointer is always true

A: builtin_op->steps不可能为空，该判断多余，直接删除即可