#!/bin/sh
os=`uname`
run_queue=0
blocked=0
swapped=0
vmexec=`which vmstat | awk '{print $1}'`
if [ "$vmexec" = "no" ]
then
  echo "error_text=vmstat command not found!"
  exit 0
fi

if [ "$os" = "linux" ] || [ "$os" = "Linux" ]
then
  temp=`vmstat |tail -1`
  run_queue=`echo $temp |awk '{printf("%s\n",$1)}'`
  blocked=`echo $temp |awk '{printf("%s\n",$2)}'`
  swapped=`echo $temp |awk '{printf("%s\n",$3)}'`

elif [ "$os" = "AIX" ] || [ "$os" = "aix" ]
then
  temp=`vmstat 1 5 |tail -1`
  run_queue=`echo $temp |awk '{printf("%s\n",$1)}'`
  blocked=`echo $temp |awk '{printf("%s\n",$2)}'`
  swapped=0

elif [ "$os" = "HP-UX" ]
then
  temp=`vmstat 1 5 |tail -1`
  run_queue=`echo $temp |awk '{printf("%s\n",$1)}'`
  blocked=`echo $temp |awk '{printf("%s\n",$2)}'`
  swapped=`echo $temp |awk '{printf("%s\n",$3)}'`

elif [ "$os" = "SCO_SV" ] || [ "$os" = "UnixWare" ]
then
  temp=`vmstat 1 5 |tail -1`
  run_queue=`echo $temp |awk '{printf("%s\n",$1)}'`
  blocked=`echo $temp |awk '{printf("%s\n",$2)}'`
  swapped=`echo $temp |awk '{printf("%s\n",$3)}'`

else
  temp=`vmstat 1 5 |tail -1`
  run_queue=`echo $temp |awk '{printf("%s\n",$1)}'`
  blocked=`echo $temp |awk '{printf("%s\n",$2)}'`
  swapped=`echo $temp |awk '{printf("%s\n",$3)}'`
fi

echo "Run queue length=$run_queue"
echo "Blocked processes=$blocked"
echo "Runnable but swapped processes=$swapped"
if [ "$os" = "AIX" ] || [ "$os" = "aix" ]
then
  echo "status_text=Processes run:{0}, blocked:{1};;;${run_queue};;;${blocked}"
else
  echo "status_text=Processes run:{0}, blocked:{1}, swapped:{2};;;${run_queue};;;${blocked};;;${swapped}"
fi

exit


