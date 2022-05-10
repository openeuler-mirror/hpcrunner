#!/bin/sh

program=$1 #wrf.exe
filepath1=$2
filepath2=$2
num1=$3
num2=$4

x86_ip=$5
x86_password=$6
x86_workdir=$7
workdir=$8

filename1=${filepath1##*/}
filename2=${filepath2##*/}

rm -f ./tmp/1.txt ./tmp/2.txt ./tmp/3.txt ./tmp/4.txt ./tmp/5.txt

$(cat -n  $filepath1 | head -n ${num2} | tail -n +${num1} | grep -w CALL | grep -v ! | grep -v wrf_debug > ./tmp/1.txt)
$(cat -n  $filepath2 | head -n ${num2} | tail -n +${num1} | grep -w CALL | grep -v ! | grep -v wrf_debug > ./tmp/2.txt)

while true
do

    firstline=$(sed -n "1p" ./tmp/1.txt)
    if [ "$firstline" == "" ]
    then
        break
    fi

    functionname=${firstline#*CALL}
    functionname=${functionname/(*}
    $(grep -wi $functionname ./tmp/1.txt | cut -f1 -dC | sed -n "1p" > ./tmp/3.txt)
    $(grep -wi $functionname ./tmp/2.txt | cut -f1 -dC | sed -n "1p" > ./tmp/4.txt)
    
    $(paste ./tmp/3.txt ./tmp/4.txt >> ./tmp/5.txt)
    $(sed -i "/$functionname/d" ./tmp/1.txt)
    $(sed -i "/$functionname/d" ./tmp/2.txt)
done

linenum=1
while true
do
    breaknum=$(sed -n "${linenum}p" ./tmp/5.txt)
    if [ "$breaknum" == "" ]
    then
        break
    fi
    breaknums=(${breaknum})
    if [ "${breaknums[0]}" == "" ] || [ "${breaknums[1]}" == "" ]
    then
        ((linenum++))
        continue
    fi
    ((linenum++))

    end0=${breaknums[0]}
    while true
    do
        func=$(sed -n "${end0}p" $filepath1)
        spec="&"
        if [[ ${func} == *$spec* ]]
        then
           ((end0++))
        else
           break
        fi
    done
    
    end1=${breaknums[1]}
    while true
    do
        func=$(sed -n "${end1}p" $filepath2)
        spec="&"
        if [[ ${func} == *$spec* ]]
        then
           ((end1++))
        else
           break
        fi
    done
    echo $program $filename1:${breaknums[0]} $filename1:$end0 $filename2:${breaknums[1]} $filename2:$end1 $workdir
    ./autocompare.sh $program $filename1:${breaknums[0]} $filename1:$end0 $filename2:${breaknums[1]} $filename2:$end1 $x86_ip $x86_password $x86_workdir $workdir $filepath1
done

