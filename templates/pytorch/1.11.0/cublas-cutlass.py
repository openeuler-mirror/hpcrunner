import torch

# 指定使用GPU
device = torch.device("cuda")

# 创建两个随机矩阵
A = torch.randn(1000, 1000, device=device)
B = torch.randn(1000, 1000, device=device)

# 进行矩阵乘法运算
C = torch.matmul(A, B)

# 将结果转移到CPU上
C = C.cpu()

# 打印结果
print(C)

#添加export CUBLASLT_LOG_LEVEL=5 可判别是否调用了cutlass
#输出：使能cutlass 算法是21号，切分Block Size为128x128x32
[cublasLt][3794797][Trace][cublasLtSSSMatmul] A=0X400380DD0A00 Adesc=[type=R_32F rows=1000 cols=1000 ld=1000] B=0X400380A00000 Bdesc=[type=R_32F rows=1000 cols=1000 ld=1000] C=0X4003811A1400 Cdesc=[type=R_32F rows=1000 cols=1000 ld=1000] D=0X4003811A1400 Ddesc=[type=R_32F rows=1000 cols=1000 ld=1000] computeDesc=[computeType=COMPUTE_32F_FAST_TF32 scaleType=R_32F smCountTarget=108] algo=[algoId=21 tile=MATMUL_TILE_128x128 stages=MATMUL_STAGES_32x5] workSpace=0X0 workSpaceSizeInBytes=0 beta=0 outOfPlace=0 stream=0X0
#输出：未使能cutlass 算法是0号或者21号，切分Block Size为64x64x32
[cublasLt][3837588][Trace][cublasLtSSSMatmul] A=0X400484FD0A00 Adesc=[type=R_32F rows=1000 cols=1000 ld=1000] B=0X400484C00000 Bdesc=[type=R_32F rows=1000 cols=1000 ld=1000] C=0X4004853A1400 Cdesc=[type=R_32F rows=1000 cols=1000 ld=1000] D=0X4004853A1400 Ddesc=[type=R_32F rows=1000 cols=1000 ld=1000] computeDesc=[computeType=COMPUTE_32F_FAST_TF32 scaleType=R_32F] algo=[algoId=21 tile=MATMUL_TILE_64x64 stages=MATMUL_STAGES_32x6] workSpace=0X0 workSpaceSizeInBytes=0 beta=0 outOfPlace=0 stream=0X0
tensor([[-35.9243, -17.1637,  43.2401,  ...,  -5.8674,  27.3440,   5.0968],
        [ 67.7127,   0.9203,  -7.6000,  ...,  37.2051, -80.3450,  23.1073],
        [ -6.7195,   4.0443,  24.7202,  ..., -36.4448,  19.3249, -31.6387],
        ...,
        [-13.0232, -41.7477, -19.7421,  ...,  40.6747,  -0.6182, -56.0985],
        [-33.5083,  12.9116,  17.2967,  ...,  45.3489,  49.2308, -16.7261],
        [ 25.1251, -43.3838, -30.2829,  ...,  10.3012,  19.7520, -32.6221]])