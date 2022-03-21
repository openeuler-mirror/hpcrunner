all: test

test: test.F90
	gfortran -O3 $^ -o $@.o

clean:
	rm -f test.o