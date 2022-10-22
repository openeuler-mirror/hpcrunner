program main
      real :: a
      a = '26.47527'
      call calc(a)
end program main

subroutine calc(a)
      real :: res
      res=cos(3.14159*a/180.)
      write(*,100) res
      100 FORMAT('', b32.32)
end subroutine calc

# The result is not the same if change ARM -O0 to -O3, flang will use constant transfer, skip the KML math library, uses system libmath library.
# X86: ifort -O3 -fp-model precise -no-ftz -lm cos.F90 && ./a.out
# ARM: flang -O0 -mllvm -disable-sincos-opt -ffp-model=precise -ffp-contract=off -L/usr/local/kml/lib/ -lkm_l9 cos.F90 && ./a.out
