#!/bin/sh
os=`uname`
mem=0
if [ "$os" = "linux" ] || [ "$os" = "Linux" ]
then
  which sar > /dev/null 2>&1
  if [ $? -ne 0 ]
  then
    which free > /dev/null 2>&1
    if [ $? -ne 0 ]
    then
      echo "error_text='sar'and 'free' commands not found!"
      exit
    else
      total=`free | grep Mem: | awk '{ print $2 }'`
      used=`free | grep Mem: | awk '{ print $3 }'`
      mem=`echo|awk '{print ((c1*100)/c2) }' c1=$used c2=$total`
    fi
  else 
    sar -r 1 3 > sar_memory_out 2>&1
    cat sar_memory_out | grep Average > memory_temp
    used=`sed -n 1p memory_temp | awk '{ print $3 }'`
    free=`sed -n 1p memory_temp | awk '{ print $2 }'`
    mem=`sed -n 1p memory_temp |awk '{ print $4 }'`

    total=`echo|awk '{print (c1+c2)}' c1=$used c2=$free`
  fi

elif [ "$os" = "SunOS" ]
then
vmexec=`which vmstat | awk '{print $1}'`
if [ "$vmexec" = "no" ]
then
    echo "error_text=vmstat command not found!"
    exit 0
  fi
  total=`prtconf | grep "Mem" | awk '{print $3}'`
  t=`echo $total | awk '{print $1}'`
  total_kb=`echo|awk '{print (c1*1024) }' c1=$t`

  vmstat_output=`/bin/vmstat 1 2 | tail -1`
  free=`echo $vmstat_output | awk '{print $5;}'`

  used_kb=`echo|awk '{print (c1-c2) }' c1=$total_kb c2=$free`
  used_pg=`echo|awk '{print (c1-c2*4) }' c1=$total_kb c2=$free`

  if [ $used_kb -gt $t ] && [ $used_pg -gt 0 ] 
  then
    used=$used_pg 
  else
    used=$used_kb
  fi
  mem=`echo|awk '{print ((c1*100)/c2) }' c1=$used c2=$total_kb`

  # change unit into KB
  total=$total_kb

elif [ "$os" = "AIX" ]
then
  svmon_out=`svmon -G | grep -i memory`
  total=`echo $svmon_out | awk '{ print ($2 * 4)}'`
  used=`echo $svmon_out | awk '{ print ($3 * 4)}'`
  mem=`echo|awk '{printf("%0.2f",((c1*100)/c2)) }' c1=$used c2=$total`

elif [ "$os" = "HP-UX" ]
then
vmexec=`which vmstat | awk '{print $1}'`
if [ "$vmexec" = "no" ]
then
    echo "error_text=vmstat command not found!"
    exit 0
  fi
  DMESG=`/sbin/dmesg | /usr/bin/grep 'Physical.*lockable.*available'`
  total=`echo ${DMESG} | /usr/bin/awk '{print $2}'`

  VMSTAT=`$vmexec 1 2 | /usr/bin/tail -1`

  free=`echo $VMSTAT | /usr/bin/awk '{print $5;}'`
  free=`/usr/bin/expr $free \* 4`

  used=`expr $total \- $free`
  mem=`expr $used \* 100 / $total`

else
vmexec=`which vmstat | awk '{print $1}'`
if [ "$vmexec" = "no" ]
then
    echo "error_text=vmstat command not found!"
    exit 0
  fi
  total=`prtconf | grep "Mem" | awk '{print $3}'`
  vmstat_output=`/bin/vmstat 1 2 | tail -1`
  free=`echo $vmstat_output | awk '{print $5;}'`
  total=`echo|awk '{print (c1*1024) }' c1=$total`
  used=`echo|awk '{print (c1-c2) }' c1=$total c2=$free`
  mem=`echo|awk '{print ((c1*100)/c2) }' c1=$used c2=$total`
fi
total=`echo | awk '{printf ("%.0f", c1/1024) }' c1=$total `
used=`echo | awk '{printf ("%.0f", c1/1024) }' c1=$used`
mem=`echo | awk '{printf ("%.0f", c1) }' c1=$mem`
echo "Used Memory=${used}"
echo "Free Memory=${free}"
echo "Total Memory=${total}"
echo "Memory Utilization=$mem"

exit 0
