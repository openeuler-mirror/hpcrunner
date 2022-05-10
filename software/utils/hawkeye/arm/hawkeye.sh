#!/bin/sh

program=$1 #wrf.exe
srcdir=$2
filename=$3
num1=$4
num2=$5
x86_ip=$6
x86_password=$7
x86_workdir=$8
workdir=$9
workdir=${workdir:="md5"}
loop=${10}
loop=${loop:=1}

filepath=$(find $srcdir -name $filename)
mkdir -p tmp/x86/md5
./autofind.sh $program $filepath $num1 $num2 $x86_ip $x86_password $x86_workdir $workdir
./autocopy.sh $x86_ip $x86_password $x86_workdir/tmp/md5/* ./tmp/x86/md5 > /dev/null

while [ $loop -gt 0 ]
do
    ((loop--))
    for file in ./tmp/$workdir/*
    do
        if [[ $file == *".txt" ]]
        then
            continue
        fi
        echo "file:"$file
        x86_file="./tmp/x86/"${file#*tmp/}
        diff=$(diff $file $x86_file)
        if [[ "$diff" != "" ]]
        then
            funcname=$(sed -n "1p" $file/*.txt)
            filepath=$(grep -wrn "SUBROUTINE $funcname" --exclude="*.F" $srcdir | cut -f1-2 -d:)
            if [[ "$filepath" == "" ]]
            then
                continue
            fi

            filepath=(${filepath})
            filename=$(echo ${filepath[0]} | cut -f1 -d:)
            filename=${filename##*/}
            num1=$(echo ${filepath[0]} | cut -f2 -d:)
            num2=$(echo ${filepath[1]} | cut -f2 -d:)
            ./hawkeye.sh $program $srcdir $filename $num1 $num2 $x86_ip $x86_password $x86_workdir $workdir"/"$funcname $loop
       fi
    done
done

