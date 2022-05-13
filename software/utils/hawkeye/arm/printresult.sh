#!/bin/sh

srcdir=$1
cd tmp
for file in `find md5 -name "*.txt"`
do
        if [[ $file != *".txt" ]]
        then
            continue
        fi
        filediff=$(diff $file "./x86/"$file)
        if [[ $filediff != "" ]]
        then 
            funcname=$(sed -n "1p" $file)
            filepath=$(grep -wrn "SUBROUTINE $funcname" --exclude="*.F" $srcdir | cut -f1-2 -d:)
            if [[ "$filepath" == "" ]]
            then
                continue
            fi
            test="/"
            filetmp=''
            for i in `seq ${#file}`
            do
                var=${file:$i-1:1}
                if [[ $var == $test ]]
                then
                    filetmp=$filetmp' '
                else
                    filetmp=$filetmp$var
                fi
            done
            args=(${filetmp})
            argsnum=${#filetmp[@]}
            call=''
            for(( i=1;i<${#args[@]}-1;i++))
            do
                if [[ $call == '' ]]
                then
                    call=${args[i]}
                else
                    call=$call" --> "${args[i]}
                fi
            done

            filepath=(${filepath})
            echo "存在精度差异的函数："$funcname "("${filepath[0]}")"
            echo "函数调用关系："$call
            echo ""
            call=''
        fi
done
