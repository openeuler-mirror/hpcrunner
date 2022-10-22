program main
      real :: a, b, c, d, e, f
      a = b'11000001110101010000111101101010'
      b = b'00000000000000000000000000000000'
      c = b'01000000010000000000000000000001'
      d = b'11000001101100100001111010101010'
      e = b'01000001001000000000000000000000'
      f = b'01000000010000000000000000000001'
      call calc(a, b, c, d, e, f)
end program main

subroutine calc(a, b, c, d, e, f)
      real :: res
      res = ((a - b) * c) ** 2 + &
            ((d - e) * f) ** 2
      write(*,100) res
      100 FORMAT('', b32.32)
end subroutine calc

! The result is not the same if remove -ffp-contract=off
! X86: ifort -O3 -fp-model precise -no-ftz fp-contract.F90 && ./a.out
! ARM: flang -O3 -mllvm -disable-sincos-opt -ffp-model=precise -ffp-contract=off fp-contract.F90 && ./a.out
