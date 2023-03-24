flags="**************"
armRun(){
    echo "${flags}benching p2p perf, best 18GB/s${flags}"
    make
    ./p2pTest
}

x86Run(){
    armRun
}
# check Arch
if [ x"$(arch)" = xaarch64 ];then
    armRun
else
    x86Run
fi
