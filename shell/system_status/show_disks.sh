#!/bin/sh
os=`uname`

if [ "$os" = "linux" ] || [ "$os" = "Linux" ]
then
  df -k | awk '{ print $1 ";" $6 ";" $2 }'
elif [ "$os" = "SunOS" ]
then
  df -k |more | awk '{ print $1 ";" $6 ";" $2 }'
elif [ "$os" = "HP-UX" ]
then
  df -k | awk '{ print $1 ";" $6 }'
elif [ "$os" = "SCO_SV" ] || [ "$os" = "UnixWare" ]
then
  df -k | awk '{ print $1 ";" $6 }'
elif [ "$os" = "OSF1" ]
then
  df -k | awk '{ print $1 ";" $6 }'
elif [ "$os" = "AIX" ] || [ "$os" = "aix" ]
then
  df -k | awk '{ print $1 ";" $7 }'
else 
  df -k | awk '{ print $1 ";" $6 }'
fi
exit
