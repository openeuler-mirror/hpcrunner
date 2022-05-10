#!/usr/bin/expect

set ip  [lindex $argv 0]
set password  [lindex $argv 1]
set src [lindex $argv 2]
set dst [lindex $argv 3]
spawn scp -rp root@$ip:$src $dst
expect "*password:" {send "$password\r"}
interact
