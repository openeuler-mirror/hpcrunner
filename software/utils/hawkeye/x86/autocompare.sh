#!/bin/sh
#!/usr/bin/expect

GDB=${GDB:-/usr/bin/gdb}
program=$1 #wrf.exe
breakpoint=$2
breakpointend=$3
workdir=$4
filepath=$5

mkdir -p tmp
#get args
($GDB -quiet  ${program}   << EOF
l $breakpoint,$breakpointend
EOF
) > ./tmp/gdb.txt

# delete the content after the &
sed -i 's/!.*$//g' ./tmp/gdb.txt
gdbtxt=$(cat ./tmp/gdb.txt)
func=${gdbtxt#*(gdb)}
func=${func/(gdb)*}
funcname=${func#*CALL}
funcname=${funcname/(*}
funcname=$(echo $funcname | sed 's/ //g')
args_string=${func#*(}
args_string=${args_string%)*}
args_string=$(echo $args_string | sed 's/ [0-9]*//g')

zero=0
bracketnum=0
argswithspace=''
for i in `seq ${#args_string}`
do
    var=${args_string:$i-1:1}
    if [[ $bracketnum == $zero ]] && [[ $var = ',' ]]
    then
        argswithspace=$argswithspace' '
    elif [[ $var = ' ' ]] || [[ $var = '&' ]]
    then
        argswithspace=$argswithspace
    else
        argswithspace=$argswithspace$var
    fi

    if [[ $var == '(' ]]
    then
        ((bracketnum++))
    fi
    if [[ $var == ')' ]]
    then
        ((bracketnum--))
    fi
done

args=(${argswithspace})
argsnum=${#args[@]}

for(( i=0;i<${#args[@]};i++))
do
    # delete string constant args
    var=${args[i]}
    char1="\'"
    char2="\""
    if [[ ${var:0:1} == $char1 ]] || [[ ${var:0:1} == $char2 ]]
    then
        unset args[i]
    fi

    if [[ $var == "grid" ]] || [[ $var == "t0" ]] || [[ $var == "g" ]] || [[ $var == "p0" ]]
    then
        unset args[i]
    fi


    # use the value on the right of the equal.
    char3="="
    if [[ $var == *$char3* ]]
    then
        twoargs=(${var//=/ })
        args[i]=${twoargs[1]}
    fi
done

#for var in ${args[@]}
#do
#    echo $var
#done

if [ $argsnum == $zero ]
then 
   echo "error:can't get any args, please enter the correct funtion line number"
   exit
fi
echo "info:function name is "$funcname", args is "${args[*]}

#loop print args md5 value
mkdir -p ./tmp/$workdir"/"$funcname
mkdir -p ./tmp/args
echo "$filepath" >> printmd5.txt
echo "$funcname" >> printmd5.txt
./expect.sh ${args[*]} $program $breakpoint
cat printmd5.txt >> ./tmp/x86_result.txt
echo "#" >> ./tmp/x86_result.txt
mv printmd5.txt  ./tmp/$workdir"/"$funcname"/"$funcname".txt"
