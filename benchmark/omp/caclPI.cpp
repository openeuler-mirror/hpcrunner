
#include <stdio.h>
#include <omp.h>

#define NUM_THREADS 32
static long num_steps = 100000000;

int main ()
{       
    int i;  
    double x, pi, sum = 0.0, step, start_time,end_time;
	step = 1.0/(double) num_steps;
    omp_set_num_threads(NUM_THREADS);
	start_time=omp_get_wtime();
    #pragma omp parallel for reduction(+ : sum) private(x)
	for (i=1;i<= num_steps; i++){
        x = (i-0.5)*step;
        sum = sum + 4.0/(1.0+x*x);
    }
    pi = step * sum;
    end_time=omp_get_wtime();
    printf("Pi = %16.15f\n Running time:%.3f ms \n", pi, end_time - start_time);
    return 1;
}
