#!/bin/sh
which iostat > /dev/null 2>&1
if [ $? -ne 0 ]
then
  echo "error_text=iostat command not found!"
  exit 0
fi

if [ $# -lt 1 ]
then
  echo "error_text=diskname argument not specified!"
  exit
fi

os=`uname`
diskname=$1
rb=0
wb=0
trans=0
wt=0
bt=0
if [ "$os" = "linux" ] || [ "$os" = "Linux" ]
then
  output=`iostat 1 3 |grep $diskname|tail -1`
  rb=`echo $output|awk '{printf $3}'`
  wb=`echo $output|awk '{printf $4}'`
  wt=`echo $output|awk '{printf $9}'`
  bt=`echo $output|awk '{printf $10}'`
elif [ "$os" = "SunOS" ]
then
  output=`iostat -xnp 2 2 |grep $diskname|tail -1`
  rb=`echo $output|awk '{printf $3}'`
  wb=`echo $output|awk '{printf $4}'`
  wt=`echo $output|awk '{printf $9}'`
  bt=`echo $output|awk '{printf $10}'`
elif [ "$os" = "AIX" ] 
then
  output=`iostat -d 1 3 | grep $diskname | tail -1`
  rb=`echo $output | awk '{ print $5 }'`
  wb=`echo $output | awk '{ print $6 }'`
  trans=`echo $output | awk '{ print $4 }'`
fi
echo "Read bytes=$rb"
echo "Write bytes=$wb"
echo "Number of transactions being serviced=$trans"
echo "Wait time=$wt"
echo "Busy time=$bt"

