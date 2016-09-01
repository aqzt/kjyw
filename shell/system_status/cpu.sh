#!/bin/sh
os=`uname`
total=0
idle=0
system=0
user=0
nice=0
mem=0
vmexec=`which vmstat | awk '{print $1}'`
if [ "$vmexec" = "no" ]
then
echo "error_text=Please check vmstat execute path"
exit
else
if [ "$os" = "linux" ] || [ "$os" = "Linux" ]
then
  which sar > /dev/null 2>&1
  if [ $? -ne 0 ]
  then
    ver=`vmstat -V | awk '{printf $3}'`
    if [ "$ver" = "2.0.11" ] || [ "$ver" = "2.0.7" ] || [ "$ver" = "2.0.6" ]
    then
      nice=0
      temp=`vmstat 1 3 |tail -1`
      user=`echo $temp |awk '{printf("%s\n",$14)}'`
      system=`echo $temp |awk '{printf("%s\n",$15)}'`
      idle=`echo $temp |awk '{printf("%s\n",$16)}'`
      total=`echo|awk '{print (c1+c2)}' c1=$system c2=$user`
   
    elif [ "$ver" = "2.0.13" ]
    then
      nice=0
      temp=`vmstat 1 3 |tail -1`
      user=`echo $temp |awk '{printf("%s\n",$13)}'`
      system=`echo $temp |awk '{printf("%s\n",$14)}'`
      idle=`echo $temp |awk '{printf("%s\n",$15)}'`
      total=`echo|awk '{print (c1+c2)}' c1=$system c2=$user`
    else
      nice=0
      temp=`vmstat 1 3 |tail -1`
      user=`echo $temp |awk '{printf("%s\n",$13)}'`
      system=`echo $temp |awk '{printf("%s\n",$14)}'`
      idle=`echo $temp |awk '{printf("%s\n",$15)}'`
      total=`echo|awk '{print (c1+c2)}' c1=$system c2=$user`


    fi
  else
    #save load data to temporary file
    sar -u 1 3 > sar_cpu_output 2>&1
    grep -i "Usage" sar_cpu_output > /dev/null
    if [ $? -eq 0 ]
    then
      sar -U 1 3 > sar_cpu_output 2>&1
    fi
    cat sar_cpu_output | grep Average > cputemp

    #calculate the load data
    user=`sed -n 1p cputemp|awk '{ print $3 }'`
    nice=`sed -n 1p cputemp|awk '{ print $4 }'`
    system=`sed -n 1p cputemp|awk '{ print $5 }'`
    idle=`sed -n 1p cputemp|awk '{ print $6 }'`
    total=`echo|awk '{print (c1+c2)}' c1=$system c2=$user`
  fi

elif [ "$os" = "SunOS" ]
then
  nice=0
  temp=`vmstat 1 3 |tail -1`
  user=`echo $temp |awk '{printf("%s\n",$20)}'`
  system=`echo $temp |awk '{printf("%s\n",$21)}'`
  idle=`echo $temp |awk '{printf("%s\n",$22)}'`
  total=`echo|awk '{print (c1+c2)}' c1=$system c2=$user`

elif [ "$os" = "HP-UX" ]
then
  nice=0
  temp=`vmstat 1 3 |tail -1`
  user=`echo $temp |awk '{printf("%s\n",$16)}'`
  system=`echo $temp |awk '{printf("%s\n",$17)}'`
  idle=`echo $temp |awk '{printf("%s\n",$18)}'`
  total=`echo|awk '{print (c1+c2)}' c1=$system c2=$user`

elif [ "$os" = "SCO_SV" ] || [ "$os" = "UnixWare" ]
then
  nice=0
  temp=`vmstat 1 3 |tail -1`
  user=`echo $temp |awk '{printf("%s\n",$18)}'`
  system=`echo $temp |awk '{printf("%s\n",$19)}'`
  idle=`echo $temp |awk '{printf("%s\n",$20)}'`
  total=`echo|awk '{print (c1+c2)}' c1=$system c2=$user`

elif [ "$os" = "AIX" ] || [ "$os" = "aix" ]
then
  temp=`vmstat 1 3 |tail -1`
  user=`echo $temp |awk '{printf("%s\n",$14)}'`
  system=`echo $temp |awk '{printf("%s\n",$15)}'`
  idle=`echo $temp |awk '{printf("%s\n",$16)}'`
  total=`echo|awk '{print (c1+c2)}' c1=$system c2=$user`

else
  echo "error_text=Unsupported platform: $os"
  exit
fi

echo "Total CPU Utilization=$total"
echo "CPU Utilization (user)=$user"
echo "CPU Utilization (system)=$system"
echo "CPU Utilization (nice)=$nice"
echo "CPU Utilization (idle)=$idle"

fi
exit 0