# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
"""Configure pytest"""
import pytest
import numpy as np
import tvm
from tvm import te
from tvm.contrib import cblas
from tvm.contrib import mkl
from tvm.contrib import dnnl
import tvm.testing
import tvm.topi.testing
import sys
import time

def verify_dense():
    import warnings
    import numpy as np

    import tvm
    from tvm import testing
    import timeit
    import numpy
    import os
    import sys
    from tvm import relay

    warnings.filterwarnings('ignore')
	#target = tvm.target.create({"kind":"llvm","mtriple":"aarch64-linux-gnu","mattr":"+neon"})
    target = tvm.target.Target("llvm -mtriple=aarch64-linux-gnu -mattr=+neon -libs=cblas")

	# 1. 创建输入张量
    batch_size = 1
    in_features = 1024
    out_features = 512
    a = relay.var("a", shape=(batch_size, in_features), dtype="float32")
    b = relay.var("b", shape=(out_features, in_features), dtype="float32")

	# 2. 构建 dense 计算
    dense_out = relay.nn.dense(a, b)

	# 3. 创建 Relay 模块
    mod = tvm.IRModule.from_expr(dense_out)

	# 4. 设置目标设备
    target = "llvm -mtriple=aarch64-linux-gnu -mattr=+neon -libs=cblas"  # 也可以是 "cuda", "opencl" 等

    opt_level=3
	# 5. 构建计算图
    with tvm.transform.PassContext(opt_level=3):
        lib = relay.build(mod, target=target)

	# 6. 创建运行时并执行
    dev = tvm.device(str(target), 0)
    a_np = np.random.uniform(size=(batch_size, in_features)).astype("float32")
    b_np = np.random.uniform(size=(out_features, in_features)).astype("float32")

    model_path = "/home/test/dense_%s.so" % (opt_level)
    lib.export_library(model_path)
    lib = tvm.runtime.load_module(model_path)

    #module = tvm.contrib.graph_executor.GraphModule(lib["default"](dev))
    module = tvm.contrib.graph_executor.create(lib["get_graph_json"](), lib, dev)
    module.set_input("a", a_np)
    module.set_input("b", b_np)
    module.run()
    output = module.get_output(0)
    print(output.shape)  # 应该输出 (1, 512)
    time.sleep(300)

def verify_matmul_add(
    matrix_m, matrix_l, matrix_n, lib, transa=False, transb=False, dtype="float32"
):
    """Tests matmul+add op"""
    bias = te.var("bias", dtype=dtype)
    ashape = (matrix_l, matrix_n) if transa else (matrix_n, matrix_l)
    bshape = (matrix_m, matrix_l) if transb else (matrix_l, matrix_m)
    input1_data = te.placeholder(ashape, name="input1_data", dtype=dtype)
    input2_data = te.placeholder(bshape, name="input2_data", dtype=dtype)
    matmul_result = lib.matmul(input1_data, input2_data, transa, transb)
    final_result = te.compute(
        matmul_result.shape, lambda i, j: matmul_result[i, j] + bias, name="final_result"
    )
    s = te.create_schedule(final_result.op)
    target_des="llvm -mtriple=aarch64-linux-gnu -mattr=+neon,+sve -libs=cblas"
    def get_numpy(a, b, matrix_bias, transa, transb):
        if transa:
            a = a.transpose()
        if transb:
            b = b.transpose()
        return np.dot(a, b) + matrix_bias

    def compiling(f, name="test_matmul_add", ext=".so"):
        path = name + ext
        f.export_library(path)
        mod = tvm.runtime.load_module(path)
        f = mod[name]
        return f
    # -libs=cbla
    def verify(target=target_des):
        if not tvm.testing.device_enabled(target):
            print("skip because %s is not enabled..." % target)
            return
        if not tvm.get_global_func(lib.__name__ + ".matmul", True):
            print("skip because extern function is not available")
            return
        dev = tvm.cpu(0)
        name = "test_matmul_add"
        f = tvm.build(s, [input1_data, input2_data, final_result, bias], target, name=name)
        if target == "c":
            f = compiling(f, name)
        print("==========================")
        #print(f.get_source("ll"))
        #sys.exit(0)
        matrix_input1 = tvm.nd.array(np.random.uniform(size=ashape).astype(input1_data.dtype), dev)
        matrix_input2 = tvm.nd.array(np.random.uniform(size=bshape).astype(input2_data.dtype), dev)
        matrix_result = tvm.nd.array(np.zeros((matrix_n, matrix_m), dtype=final_result.dtype), dev)
        matrix_bias = 10.0
        f(matrix_input1, matrix_input2, matrix_result, matrix_bias)
        tvm.testing.assert_allclose(
            matrix_result.numpy(),
            get_numpy(matrix_input1.numpy(), matrix_input2.numpy(), matrix_bias, transa, transb),
            rtol=1e-5,
        )

    def evaluate_operation(s, target, name, optimization, log,isprint):
        dev = tvm.device(target.kind.name, 0)
        func = tvm.build(s, [input1_data, input2_data, final_result, bias], target, name=name)
        assert func
        if isprint:
            print(f'================={optimization}==================')
            print(tvm.lower(s, [input1_data, input2_data, final_result, bias], simple_mode=True))

        matrix_input1 = tvm.nd.array(np.random.uniform(size=ashape).astype(input1_data.dtype), dev)
        matrix_input2 = tvm.nd.array(np.random.uniform(size=bshape).astype(input2_data.dtype), dev)
        matrix_result = tvm.nd.array(np.zeros((matrix_n, matrix_m), dtype=final_result.dtype), dev)
        matrix_bias = 10.0
        func(matrix_input1, matrix_input2, matrix_result, matrix_bias)
        tvm.testing.assert_allclose(
            matrix_result.numpy(),
            get_numpy(matrix_input1.numpy(), matrix_input2.numpy(), matrix_bias, transa, transb),
            rtol=1e-5,
        )


        evaluator = func.time_evaluator(func.entry_name, dev, number=8)
        mean_time = evaluator(matrix_input1, matrix_input2, matrix_result, matrix_bias).mean
        print("%s: %f" % (optimization, mean_time))
        log.append((optimization, mean_time))


    #verify(target_des)
    #log = [("numpy", np_running_time / np_repeat)]
    log = []
    target = tvm.target.Target(target_des)
    if True:
        evaluate_operation(s,target,"test_matmul_add","cblas",log,False)

    sys.exit(0)
    verify("c")
    sys.exit(0)


def test_matmul_add():
    """Tests of matmul+add op"""
    verify_matmul_add(8192 * 2, 8192 *2, 8192 *2, cblas)
    sys.exit(0)
    verify_matmul_add(235, 128, 1024, cblas, True, False)
    verify_matmul_add(235, 128, 1024, cblas, False, True)
    verify_matmul_add(235, 128, 1024, cblas, True, True)
    verify_matmul_add(235, 128, 1024, mkl)
    verify_matmul_add(235, 128, 1024, mkl, True, False)
    verify_matmul_add(235, 128, 1024, mkl, False, True)
    verify_matmul_add(235, 128, 1024, mkl, True, True)
    verify_matmul_add(235, 128, 1024, dnnl)
    verify_matmul_add(235, 128, 1024, dnnl, True, False)
    verify_matmul_add(235, 128, 1024, dnnl, False, True)
    verify_matmul_add(235, 128, 1024, dnnl, True, True)
    verify_matmul_add(1, 16, 4, cblas)
    verify_matmul_add(1, 16, 3, cblas, True, False)
    verify_matmul_add(1, 16, 3, cblas, False, False)
    verify_matmul_add(1, 16, 3, cblas, True, True)
    verify_matmul_add(1, 16, 4, mkl)
    verify_matmul_add(1, 16, 3, mkl, True, False)
    verify_matmul_add(1, 16, 3, mkl, False, False)
    verify_matmul_add(1, 16, 3, mkl, True, True)
    verify_matmul_add(1, 16, 4, dnnl)
    verify_matmul_add(1, 16, 3, dnnl, True, False)
    verify_matmul_add(1, 16, 3, dnnl, False, False)
    verify_matmul_add(1, 16, 3, dnnl, True, True)


def verify_quantized_matmul_add(matrix_m, matrix_l, matrix_n, transa=False, transb=False):
    """Tests quantized matmul+add op"""
    if not tvm.get_global_func("tvm.contrib.mkl.matmul_u8s8s32", True):
        pytest.skip("Quantized dense is supported only for MKL. TVM GPU CI uses openblas")
    data_dtype = "uint8"
    kernel_dtype = "int8"
    out_dtype = "int32"
    bias = te.var("bias", dtype=out_dtype)
    ashape = (matrix_l, matrix_n) if transa else (matrix_n, matrix_l)
    bshape = (matrix_m, matrix_l) if transb else (matrix_l, matrix_m)
    input1_data = te.placeholder(ashape, name="input1_data", dtype=data_dtype)
    input2_data = te.placeholder(bshape, name="input2_data", dtype=kernel_dtype)
    matmul_result = mkl.matmul_u8s8s32(input1_data, input2_data, transa, transb, dtype=out_dtype)
    final_result = te.compute(
        matmul_result.shape, lambda i, j: matmul_result[i, j] + bias, name="final_result"
    )
    s = te.create_schedule(final_result.op)

    def get_numpy(a, b, matrix_bias, transa, transb):
        if transa:
            a = a.transpose()
        if transb:
            b = b.transpose()
        return np.dot(a, b) + matrix_bias

    def verify(target="llvm"):
        if not tvm.testing.device_enabled(target):
            print("skip because %s is not enabled..." % target)
            return
        if not tvm.get_global_func("tvm.contrib.mkl.matmul_u8s8s32", True):
            print("skip because extern function is not available")
            return
        dev = tvm.cpu(0)
        f = tvm.build(s, [input1_data, input2_data, final_result, bias], target)
        matrix_input1 = tvm.nd.array(
            np.random.randint(low=0, high=50, size=ashape).astype(input1_data.dtype), dev
        )
        matrix_input2 = tvm.nd.array(
            np.random.randint(low=0, high=50, size=bshape).astype(input2_data.dtype), dev
        )
        matrix_result = tvm.nd.array(np.zeros((matrix_n, matrix_m), dtype=final_result.dtype), dev)
        matrix_bias = 10
        f(matrix_input1, matrix_input2, matrix_result, matrix_bias)
        tvm.testing.assert_allclose(
            matrix_result.numpy(),
            get_numpy(
                matrix_input1.numpy().astype("int32"),
                matrix_input2.numpy().astype("int32"),
                matrix_bias,
                transa,
                transb,
            ),
            rtol=1e-5,
        )

    verify()


def test_quantized_matmul_add():
    """Tests of quantized matmul+add op"""
    verify_quantized_matmul_add(235, 128, 1024)
    verify_quantized_matmul_add(235, 128, 1024, True, False)
    verify_quantized_matmul_add(235, 128, 1024, False, True)
    verify_quantized_matmul_add(235, 128, 1024, True, True)
    verify_quantized_matmul_add(1, 16, 4)
    verify_quantized_matmul_add(1, 16, 3, True, False)
    verify_quantized_matmul_add(1, 16, 3, False, True)
    verify_quantized_matmul_add(1, 16, 3, True, True)


def verify_batch_matmul(
    batch_a,
    batch_b,
    matrix_m,
    matrix_l,
    matrix_n,
    lib,
    transa=False,
    transb=False,
    dtype="float32",
):
    """Tests matmul op where matrices are in batch"""
    batch = max(batch_a, batch_b)
    ashape = (batch_a, matrix_l, matrix_n) if transa else (batch_a, matrix_n, matrix_l)
    bshape = (batch_b, matrix_m, matrix_l) if transb else (batch_b, matrix_l, matrix_m)
    input1_data = te.placeholder(ashape, name="input1_data", dtype=dtype)
    input2_data = te.placeholder(bshape, name="input2_data", dtype=dtype)
    matmul_result = lib.batch_matmul(input1_data, input2_data, transa, transb)
    final_result = te.compute(
        matmul_result.shape, lambda k, i, j: matmul_result[k, i, j], name="final_result"
    )
    s = te.create_schedule(final_result.op)

    def get_numpy(a, b, transa, transb):
        if transa:
            a = a.transpose(0, 2, 1)
        if not transb:
            b = b.transpose(0, 2, 1)
        return tvm.topi.testing.batch_matmul(a, b)

    def compiling(f, name="test_batch_matmul", ext=".so"):
        path = name + ext
        f.export_library(path)
        mod = tvm.runtime.load_module(path)
        f = mod[name]
        return f

    def verify(target="llvm"):
        if not tvm.testing.device_enabled(target):
            print("skip because %s is not enabled..." % target)
            return
        if not tvm.get_global_func(lib.__name__ + ".matmul", True):
            print("skip because extern function is not available")
            return
        dev = tvm.cpu(0)
        name = "test_batch_matmul"
        f = tvm.build(s, [input1_data, input2_data, final_result], target, name=name)
        if target == "c":
            f = compiling(f, name)
        matrix_input1 = tvm.nd.array(np.random.uniform(size=ashape).astype(input1_data.dtype), dev)
        matrix_input2 = tvm.nd.array(np.random.uniform(size=bshape).astype(input2_data.dtype), dev)
        matrix_result = tvm.nd.array(
            np.zeros((batch, matrix_n, matrix_m), dtype=final_result.dtype), dev
        )
        f(matrix_input1, matrix_input2, matrix_result)
        tvm.testing.assert_allclose(
            matrix_result.numpy(),
            get_numpy(matrix_input1.numpy(), matrix_input2.numpy(), transa, transb),
            rtol=1e-5,
        )

    verify("llvm")
    verify("c")


def test_batch_matmul():
    """Tests of matmul op where matrices are in batch"""
    verify_batch_matmul(16, 16, 235, 128, 1024, cblas)
    verify_batch_matmul(16, 16, 235, 128, 1024, cblas, True, False)
    verify_batch_matmul(16, 16, 235, 128, 1024, cblas, False, True)
    verify_batch_matmul(16, 16, 235, 128, 1024, cblas, True, True)
    verify_batch_matmul(16, 16, 235, 128, 1024, mkl)
    verify_batch_matmul(16, 16, 235, 128, 1024, mkl, True, False)
    verify_batch_matmul(16, 16, 235, 128, 1024, mkl, False, True)
    verify_batch_matmul(16, 16, 235, 128, 1024, mkl, True, True)
    verify_batch_matmul(16, 1, 235, 128, 1024, cblas)
    verify_batch_matmul(1, 16, 235, 128, 1024, cblas)
    verify_batch_matmul(16, 1, 235, 128, 1024, cblas)
    verify_batch_matmul(1, 16, 235, 128, 1024, cblas)
    verify_batch_matmul(16, 1, 235, 128, 1024, mkl)
    verify_batch_matmul(1, 16, 235, 128, 1024, mkl)
    verify_batch_matmul(16, 1, 235, 128, 1024, mkl)
    verify_batch_matmul(1, 16, 235, 128, 1024, mkl)
    verify_batch_matmul(1, 1, 1, 16, 3, cblas)
    verify_batch_matmul(1, 1, 1, 16, 3, cblas, True, False)
    verify_batch_matmul(1, 1, 1, 16, 3, cblas, False, False)
    verify_batch_matmul(1, 1, 1, 16, 3, cblas, True, True)
    verify_batch_matmul(1, 1, 1, 16, 3, cblas)
    verify_batch_matmul(1, 1, 1, 16, 3, mkl)
    verify_batch_matmul(1, 1, 1, 16, 3, mkl, True, False)
    verify_batch_matmul(1, 1, 1, 16, 3, mkl, False, False)
    verify_batch_matmul(1, 1, 1, 16, 3, mkl, True, True)
    verify_batch_matmul(1, 1, 1, 16, 3, mkl)


if __name__ == "__main__":
    #verify_dense()
    
    #sys.exit(1)
    
    test_matmul_add()
    sys.exit(1)
    test_quantized_matmul_add()
    test_batch_matmul()
