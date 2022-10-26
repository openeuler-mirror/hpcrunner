program main
    real :: a, b, c
    a = b'11000000000100110101110110001110'
    b = b'01000111000110111101111101111010'
    c = b'01000100011000010000000000000000'

    call calc_exp(a, b, c)
end program main

subroutine calc_exp(a, b, c)
    real :: res
    real :: t1, t2, t3
    res = exp(a * b / c)
    t1 = a * b
    t2 = t1 / c
    t3 = a * b / c
    print*,'res = exp(a * b / c) = '
    write(*,100) res

    100 FORMAT('', b32.32)
end subroutine calc_exp

! The result is not the same if remove -ffp-contract=off
! X86: ifort -O3 -fp-model precise -no-ftz exp.F90 && ./a.out
! export LD_LIBRARY_PATH=/workspace/public/software/libs/kml/1.6.0/lib:$LD_LIBRARY_PATH
!echo "/workspace/public/software/libs/kml/1.6.0/lib" >> /etc/ld.so.conf
! ldconfig
! export LD_PRELOAD=/workspace/public/software/libs/kml/1.6.0/lib/libkm.so
! ARM: flang -O3 -mllvm -disable-sincos-opt -ffp-model=precise -ffp-contract=off exp.F90 && ./a.out
