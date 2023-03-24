CC = gcc
CCFLAGS = -fopenmp -O2
NVCFLAGS = 

all:  caclPI

caclPI: caclPI.cpp
	${CC} ${CCFLAGS} caclPI.cpp -o caclPI

gramSchmidt_gpu: gramSchmidt_gpu.c
	nvc -mp=gpu -Minfo=mp -lm gramSchmidt_gpu.c -o gramSchmidt_gpu.o

gramSchmidt_gpu_f90: gramSchmidt_gpu.F90
	nvfortran -mp=gpu -Minfo=mp -lm gramSchmidt_gpu.F90 -o gramSchmidt_gpu_f.o

clean:
	rm -rf caclPI gramSchmidt_gpu
