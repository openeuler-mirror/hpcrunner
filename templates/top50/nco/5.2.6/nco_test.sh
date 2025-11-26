rm *.nc -f
rm -f out.log error.log result.log
touch out.log error.log result.log

ncgen -k netCDF-4 -b -o in.nc in.cdl
ncgen -k netCDF-4 -b -o in_1.nc in_1.cdl
ncgen -k netCDF-4 -b -o in_2.nc in_2.cdl
ln -sf in.nc 85.nc
ln -sf in.nc 86.nc
ln -sf in.nc 87.nc
ln -sf in.nc 88.nc
ln -sf in.nc 89.nc

count=0

echo "============TEST ncks============" >> out.log
ncks -O -M -v one in.nc 1.nc  >> out.log 2>> error.log
ret=$?
if [ "$ret" -ne 0 ]; then
        echo "ERROR: TEST ncks FAILED! STOP TEST." 2>&1 | tee -a error.log
        exit 2
else
        echo "1/14 TEST ncks PASSED." 2>&1 |tee -a result.log
        let count++
fi

echo "============TEST ncrename============" >> out.log
ncrename -O -v one,var 1.nc >> out.log 2>> error.log
ret=$?
if [ "$ret" -ne 0 ]; then
        echo "ERROR: TEST ncrename FAILED! STOP TEST." 2>&1 | tee -a error.log
        exit 2
else
        echo "2/14 TEST ncrename PASSED." 2>&1 |tee -a result.log
        let count++
fi

echo "============TEST ncap2============" >> out.log
ncap2 -O -s 'var=2' 1.nc 2.nc >> out.log 2>> error.log
ret=$?
if [ "$ret" -ne 0 ]; then
        echo "ERROR: TEST ncap2 FAILED! STOP TEST." 2>&1 | tee -a error.log
        exit 2
else
        echo "3/14 TEST ncap2 PASSED." 2>&1 |tee -a result.log
        let count++
fi

echo "============TEST nces============" >> out.log
nces -O 1.nc 2.nc 2.nc out_nces.nc >> out.log 2>> error.log
ret=$?
if [ "$ret" -ne 0 ]; then
        echo "ERROR: TEST nces FAILED! STOP TEST." 2>&1 | tee -a error.log
        exit 2
else
        echo "4/14 TEST nces PASSED." 2>&1 |tee -a result.log
        let count++
fi

echo "============TEST ncatted============" >> out.log
ncatted -t -o out_ncatted.nc -a _FillValue,,o,d,-9.99999979021476795361e+33 in.nc >> out.log 2>> error.log
ret=$?
if [ "$ret" -ne 0 ]; then
        echo "ERROR: TEST ncatted FAILED! STOP TEST." 2>&1 | tee -a error.log
        exit 2
else
        echo "5/14 TEST ncatted PASSED." 2>&1 |tee -a result.log
        let count++
fi

echo "============TEST ncbo============" >> out.log
ncbo --op_typ='-' in_1.nc in_2.nc out_ncbo.nc >> out.log 2>> error.log
ret=$?
if [ "$ret" -ne 0 ]; then
        echo "ERROR: TEST ncbo FAILED! STOP TEST." 2>&1 | tee -a error.log
        exit 2
else
        echo "6/14 TEST ncbo PASSED." 2>&1 |tee -a result.log
        let count++
fi

echo "============TEST ncecat============" >> out.log
ncecat --gag 85.nc 86.nc 87.nc 8587_ncecat.nc >> out.log 2>> error.log
ret=$?
if [ "$ret" -ne 0 ]; then
        echo "ERROR: TEST ncecat FAILED! STOP TEST." 2>&1 | tee -a error.log
        exit 2
else
        echo "7/14 TEST ncecat PASSED." 2>&1 |tee -a result.log
        let count++
fi

echo "============TEST ncflint============" >> out.log
ncflint -w 1,1 85.nc 86.nc 85p86_ncflint.nc >> out.log 2>> error.log
ret=$?
if [ "$ret" -ne 0 ]; then
        echo "ERROR: TEST ncflint FAILED! STOP TEST." 2>&1 | tee -a error.log
        exit 2
else
        echo "8/14 TEST ncflint PASSED." 2>&1 |tee -a result.log
        let count++
fi

echo "============TEST ncpdq============" >> out.log
ncpdq in.nc out_ncpdq.nc >> out.log 2>> error.log
ret=$?
if [ "$ret" -ne 0 ]; then
        echo "ERROR: TEST ncpdq FAILED! STOP TEST." 2>&1 | tee -a error.log
        exit 2
else
        echo "9/14 TEST ncpdq PASSED." 2>&1 |tee -a result.log
        let count++
fi

echo "============TEST ncra============" >> out.log
ncra 85.nc 86.nc 87.nc 88.nc 89.nc 8589_ncra.nc >> out.log 2>> error.log
ret=$?
if [ "$ret" -ne 0 ]; then
        echo "ERROR: TEST ncra FAILED! STOP TEST." 2>&1 | tee -a error.log
        exit 2
else
        echo "10/14 TEST ncra PASSED." 2>&1 |tee -a result.log
        let count++
fi

echo "============TEST ncrcat============" >> out.log
ncrcat 85.nc 86.nc 87.nc 88.nc 89.nc 8589_ncrcat.nc >> out.log 2>> error.log
ret=$?
if [ "$ret" -ne 0 ]; then
        echo "ERROR: TEST ncrcat FAILED! STOP TEST." 2>&1 | tee -a error.log
        exit 2
else
        echo "11/14 TEST ncrcat PASSED." 2>&1 |tee -a result.log
        let count++
fi

echo "============TEST ncwa============" >> out.log
ncwa in.nc out_ncwa.nc >> out.log 2>> error.log
ret=$?
if [ "$ret" -ne 0 ]; then
        echo "ERROR: TEST ncwa FAILED! STOP TEST." 2>&1 | tee -a error.log
        exit 2
else
        echo "12/14 TEST ncwa PASSED." 2>&1 |tee -a result.log
        let count++
fi

echo "============TEST ncclimo============" >> out.log
ncclimo --version >> out.log 2>> error.log
ret=$?
if [ "$ret" -ne 0 ]; then
        echo "ERROR: TEST ncclimo FAILED! STOP TEST." 2>&1 | tee -a error.log
        exit 2
else
        echo "13/14 TEST ncclimo PASSED." 2>&1 |tee -a result.log
        let count++
fi

echo "============TEST ncremap============" >> out.log
ncremap --version >> out.log 2>> error.log
ret=$?
if [ "$ret" -ne 0 ]; then
        echo "ERROR: TEST ncremap FAILED! STOP TEST." 2>&1 | tee -a error.log
        exit 2
else
        echo "14/14 TEST ncremap PASSED." 2>&1 |tee -a result.log
        let count++
fi

echo -e "\033[1;32m$((count * 100 / 14))% TESTS PASSED\033[0m, $((14-count)) TESTS FAILED OUT OF 14" 2>&1 |tee -a result.log
