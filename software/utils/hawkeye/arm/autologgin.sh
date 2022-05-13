#!/usr/bin/expect

set ip  [lindex $argv 0]
set password  [lindex $argv 1]
set commands [lindex $argv 2]
spawn ssh root@$ip
expect {
    "*yes/no" {send "yes\r"; exp_continue}
    "*password:" {send "$password\r"}
}
expect "*#" {send "$commands"}
interact
