#!/bin/bash
rm -f out.log error.log result.log
touch out.log error.log result.log

cat > ex01.f << EOF
C NCLFORTSTART
      subroutine cquad (a, b, c, nq, x, quad)
      real x(nq), quad(nq)
C NCLEND
C
C  Calculate quadratic polynomial values.
C
      do 10 i=1,nq
        quad(i) = a*x(i)**2 + b*x(i) + c
   10 continue

      return
      end

C NCLFORTSTART
      function arcln (numpnt, pointx, pointy)
      dimension pointx(numpnt),pointy(numpnt)
C NCLEND

C
C  Calculate arc lengths.
C
      if (numpnt .lt. 2) then
        print *, 'arcln: number of points must be at least 2'
        stop
      endif
      arcln = 0.
      do 10 i=2,numpnt
        pdist = sqrt((pointx(i)-pointx(i-1))**2 +
     +                        (pointy(i)-pointy(i-1))**2)
        arcln = arcln + pdist
   10 continue

      return
      end
EOF

WRAPIT ex01.f
cd nug
count=0
sum=$(ls *.ncl|wc -l)

for file in *.ncl;do
       if [ -e "$file" ];then
            echo "============test $file==============" >> out.log
            ncl $file >> out.log 2>> error.log
            ret=$?
            echo "Return value: $ret"
            if [ "$ret" -ne 0 ]; then
                echo "ERROR: TEST $file FAILED! STOP TEST." 2>&1 | tee -a error.log
                exit 2
            else
                let count++
                echo "$count/$sum TEST $file PASSED." 2>&1 |tee -a result.log
            fi
       fi
done

echo -e "\033[1;32m$((count*100/sum))% TESTS PASSED\033[0m, $((sum-count)) TESTS FAILED OUT OF $sum" 2>&1 |tee -a result.log
