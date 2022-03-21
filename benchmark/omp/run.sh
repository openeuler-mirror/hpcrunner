flags="**************"
armRun(){
    echo "${flags}benching omp perf, best 0.023ms${flags}"
    make
    ./caclPI
    make gramSchmidt_gpu
    ./gramSchmidt_gpu
}

x86Run(){
    armRun
}
# check Arch
if [ x$(arch) = xaarch64 ];then
    armRun
else
    x86Run
fi