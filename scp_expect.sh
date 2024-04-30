#!/usr/bin/expect

set timeout 20
set cmd [lindex $argv 0]
set password [lindex $argv 1]

eval spawn $cmd
expect {
    "*yes/no" { send "yes\r"; exp_continue }
    "*password:" { send "$password\r" }
}
expect eof
