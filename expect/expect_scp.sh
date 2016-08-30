#!/usr/bin/expect    -f
set ip [lindex $argv 0]
set timeout 1200
spawn    /usr/bin/scp -r 192.168.10.10:/data/www/  /data/
expect {
    "(yes/no)?" {send "yes\r"}
    "*password:" {send "www.aqzt.com\r"}
      }
expect "password:"
send "123456\r"
