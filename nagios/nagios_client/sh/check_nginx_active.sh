#!/bin/bash
NUM=`curl http://192.168.10.9:8081/status | grep Active | awk '{print $3}'`

if [ $NUM -lt $1 ]
        then
       echo "OK -connect counts is $NUM | Current=$NUM;Warning=$Warn;Critical=$Crit" 

        exit 0
fi
if [ $NUM -gt $1 -a $NUM -lt $2 ]
        then
        echo "Warning -connect counts is $NUM | Current=$NUM;Warning=$Warn;Critical=$Crit" 
        exit 1
fi
if [ $NUM -gt $2 ]
        then
        echo "Critical -connect counts is $NUM | Current=$NUM;Warning=$Warn;Critical=$Crit"
        exit 2
fi
