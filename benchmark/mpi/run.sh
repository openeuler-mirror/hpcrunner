mpicc reduce_avg.c -o avg
mpirun -n 2 --allow-run-as-root ./avg 2