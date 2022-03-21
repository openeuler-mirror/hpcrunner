ARCH=sm_80
NVCC_FLAGS = -arch=$(ARCH)  -O3
CUDA_DIR = /usr/local/cuda/
# CUDA compiler
NVCC = $(CUDA_DIR)/bin/nvcc
all: cuda

cuda: cuda.cu
	$(NVCC) $(NVCC_FLAGS) $^ -o $@.o

clean:
	rm -f cuda.o