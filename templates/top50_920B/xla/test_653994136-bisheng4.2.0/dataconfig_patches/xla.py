import tensorflow as tf
import time

tf.config.optimizer.set_jit(True)

@tf.function(jit_compile=True)
def matmul(a, b):
    return tf.matmul(a,b)

a = tf.random.normal([50000, 10000])
b = tf.random.normal([10000, 50000])

# 预热
for i in range(1):
    result = matmul(a, b)

start_time = time.time()
# 执行矩阵乘法
result = matmul(a, b)

end_time = time.time()
exe_time = end_time - start_time
print("time:", exe_time)
print("Result:", result)

