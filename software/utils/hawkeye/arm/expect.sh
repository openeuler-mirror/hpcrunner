#!/usr/bin/expect

log_file ./tmp/expectlog.txt
set timeout -1
set argsnum [lindex $argc]
set args [lrange $argv 0 $argc-3]
set progname [lindex $argv $argc-2]
set breakpoint [lindex $argv $argc-1]

spawn gdb $progname
expect "(gdb)" {send "set height unlimited\n"}
expect "(gdb)" {send "set max-value-size unlimited\n"}
expect "(gdb)" {send "define printmd5\n"}
expect ">" {send "set \$i=\$argc \n"}
expect ">" {send "while \$i\n"}
expect ">" {send "set \$index=\$argc-\$i\n"}
expect ">" {send "eval \"call print_md5_float_all_c_(\$arg%d, sizeof(\$arg%d)/4, '\$arg%d', sizeof('\$arg%d'))\", \$index, \$index, \$index, \$index\n"}
expect ">" {send "set \$i=\$i-1\n"}
expect ">" {send "end\n"}
expect ">" {send "end\n"}


expect "(gdb)" {send "define writeargs\n"}
expect ">" {send "set \$i=\$argc \n"}
expect ">" {send "while \$i\n"}
expect ">" {send "set \$index=\$argc-\$i\n"}
expect ">" {send "eval \"call writegrid_(\$arg%d, sizeof(\$arg%d)/4, './tmp/args/\$arg%d', sizeof('./tmp/args/\$arg%d'))\", \$index, \$index, \$index, \$index\n"}
expect ">" {send "set \$i=\$i-1\n"}
expect ">" {send "end\n"}
expect ">" {send "end\n"}

expect "(gdb)" {send "define readargs\n"}
expect ">" {send "set \$i=\$argc \n"}
expect ">" {send "while \$i\n"}
expect ">" {send "set \$index=\$argc-\$i\n"}
expect ">" {send "eval \"call readgrid_(\$arg%d, sizeof(\$arg%d)/4, './tmp/args/\$arg%d', sizeof('./tmp/args/\$arg%d'))\", \$index, \$index, \$index, \$index\n"}
expect ">" {send "set \$i=\$i-1\n"}
expect ">" {send "end\n"}
expect ">" {send "end\n"}

expect "(gdb)" {send "b $breakpoint \n"}
expect "(gdb)" {send "r \n"}
expect "(gdb)" {send "shell echo before invoke function\n"}
#expect "(gdb)" {send "writeargs $args\n"}
expect "(gdb)" {send "readargs $args\n"}
expect "(gdb)" {send "printmd5 $args\n"}
expect "(gdb)" {send "n \n"}
expect "(gdb)" {send "shell echo after invoke function\n"}
expect "(gdb)" {send "printmd5 $args\n"}
expect "(gdb)" {send "q\n"}
