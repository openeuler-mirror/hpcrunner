CC = mpic++
CCFLAGS = -O2 -fopenmp
OPENBLAS_PATH = ${JARVIS_LIBS}/gcc9/openblas/0.3.18
OPENBLAS_INC = -I ${OPENBLAS_PATH}/include
OPENBLAS_LDFLAGS =  -L ${OPENBLAS_PATH}/lib -lopenblas

KML_PATH = /usr/local/kml
KML_INC = -I ${KML_PATH}/include
KML_LDFLAGS =  -L ${KML_PATH}/lib/kblas/omp -lkblas
all:  gemm

gemm: gemm.cpp
	${CC} ${CCFLAGS} ${OPENBLAS_INC} gemm.cpp -o gemm ${OPENBLAS_LDFLAGS}

gemm-kml: gemm.cpp
	${CC} -DUSE_KML ${CCFLAGS} ${KML_INC} gemm.cpp -o gemm-kml ${KML_LDFLAGS}

clean:
	rm -rf gemm*
