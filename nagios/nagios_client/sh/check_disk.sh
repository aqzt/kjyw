#!/bin/bash
percent=`df -k | grep -v Filesystem| awk '{print int($5)}' | sort -nr | head -1`

for NUM in $percent
do

if [ $NUM -gt $1 ]
        then
        echo "Critical -Disk usage $NUM | Current=$NUM;Warning=$2;Critical=$3"
        exit 2
fi
if [ $NUM -lt $1 ]
        then
        echo "OK -Disk usage $NUM | Current=$NUM;Warning=$2;Critical=$3"
        exit 0
fi
if [ $NUM -eq $1 ]
        then
        echo "Warning -Disk usage $NUM | Current=$NUM;Warning=$2;Critical=$3"
        exit 1
fi

done
