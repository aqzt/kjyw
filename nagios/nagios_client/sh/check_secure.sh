#!/bin/bash
IP=`tail -n 99 /var/log/secure  | grep sshd | grep ssh2 | awk -F ' ' '{print $11}' | tail -n 1`

strA="192.168.1.12 192.168.1.21"
strB=`cat /tmp/ssh.log | awk -F ' ' '{print $11}' | tail -n 1 | awk -F'.' '{print $1 "." $2}'`
if [[ $strA =~ $strB ]]
then
    NUM=10
else
    NUM=20
fi

if [ $NUM -gt 15 ]
        then
        echo "Critical -secure $CHECK| Current=$NUM;Warning=15;Critical=15"
        exit 2
fi
if [ $NUM -lt 15 ]
        then
        echo "OK -secure $CHECK| Current=$NUM;Warning=15;Critical=15"
        exit 0
fi
if [ $NUM -eq 15 ]
        then
        echo "Warning -secure $CHECK | Current=$NUM;Warning=15;Critical=15"
        exit 1
fi
