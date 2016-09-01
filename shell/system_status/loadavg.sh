#!/bin/sh
os=`uname`
load=0

if [ "$os" = "linux" ] || [ "$os" = "Linux" ]
then
  uptime>loadtemp
  load=`sed -n 1p loadtemp|awk '{print substr($(NF-2),1,4)}'`

elif [ "$os" = "SunOS" ]
then
  uptime>loadtemp
  load=`sed -n 1p loadtemp|awk '{print substr($(NF-2),1,4)}'`

elif [ "$os" = "HP-UX" ] 
then
  uptime>loadtemp
  load=`sed -n 1p loadtemp|awk '{print substr($(NF-2),1,4)}'`

elif [ "$os" = "AIX" ] 
then
  uptime>loadtemp
  load=`sed -n 1p loadtemp|awk '{print substr($(NF-2),1,4)}'`

elif [ "$os" = "SCO_SV" ] || [ "$os" = "UnixWare" ]
then
  uptime>loadtemp
  load=`sed -n 1p loadtemp|awk '{print substr($(NF-2),1,4)}'`

fi
status_text=`cat loadtemp`
echo "Load Average=$load"
echo "status_text=Uptime:$status_text"

exit 0
