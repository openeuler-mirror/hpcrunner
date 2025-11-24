all:
	mpic++ -g -o kscalapack_pdgetrf_cpp_kml -I ${HPCKIT_DIR}/kml/bisheng/include -I ${HPCKIT_DIR}/hmpi/bisheng/hmpi/include/ -L ${HPCKIT_DIR}/hmpi/bisheng/hmpi/lib -lmpi -L${HPCKIT_DIR}/kml/bisheng/lib/noarch/ -lkm -L ${HPCKIT_DIR}/kml/bisheng/lib/sve/ -lkscalapack_full -lklapack_full -L ${HPCKIT_DIR}/kml/bisheng/lib/sve/kblas/multi -lkblas kscalapack_pdgetrf.cpp -fopenmp
	mpic++ -o kscalapack_pdgetrf_cpp_open kscalapack_pdgetrf.cpp -L${SCALAPACK_PATH}/lib -lscalapack  -fopenmp
clean:
	rm -rf kscalapack_pdgetrf_cpp_kml kscalapack_pdgetrf_cpp_open *.o

