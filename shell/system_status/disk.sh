#!/bin/sh
if [ $# -lt 1 ]
then
  echo "error_text=diskname argument not specified!"
  exit
fi

os=`uname`
diskname=$1
diskutil="5"
awk_cmd="awk"
disk_size=""
used=""
disk_size_mb="-1"
used_mb="-1"

#get pure disk name
which nawk > /dev/null 2>&1
if [ $? -eq 0 ]
then
    awk_cmd="nawk"
fi
tempfile=`echo $diskname|$awk_cmd '{gsub("/",""); print $0}'`
tempfile="disk_$tempfile.temp"

if [ "$os" = "linux" ] || [ "$os" = "Linux" ]
then
  df $diskname >$tempfile
  if [ $? -ne 0 ]
  then
    echo "error_text=$diskname not found"
    rm $tempfile
    exit 0
  fi
  temp=`cat $tempfile |tail -1`
  diskutil=`echo $temp|awk '{printf("%s",$5)}'|awk '{gsub("%",""); print $0}'`
  disk_size=`cat $tempfile |tail -1 | awk '{print $2}'`
  disk_size_mb=`expr $disk_size / 1024`
  disk_size=`echo | awk '{ printf("%.2f",(c1/1024.0)) }' c1=$disk_size_mb`
  disk_size="${disk_size}GB"

  used=`cat $tempfile |tail -1 | awk '{print $3}'`
  used_mb=`expr $used / 1024`
  used=`echo | awk '{ printf("%.2f",(c1/1024.0)) }' c1=$used_mb`
  used="${used}GB"


elif [ "$os" = "SunOS" ]
then
  df -k $diskname > $tempfile
  if [ $? -ne 0 ]
  then
    echo "error_text=$diskname not found"
    exit 0
  fi
  diskutil=`cat $tempfile |tail -1 | awk '{print $5}' | cut -f1 -d %`
  disk_size=`cat $tempfile |tail -1 | awk '{print $2}'`
  disk_size_mb=`expr $disk_size / 1024`
  disk_size=`echo | awk '{ printf("%.2f",(c1/1024.0)) }' c1=$disk_size_mb`
  disk_size="${disk_size}GB"


  used=`cat $tempfile |tail -1 | awk '{print $3}'`
  used_mb=`expr $used / 1024`
  used=`echo | awk '{ printf("%.2f",(c1/1024.0)) }' c1=$used_mb`
  used="${used}GB"



elif [ "$os" = "HP-UX" ]
then
  #df -k $diskname > /dev/null
  df -k $diskname > $tempfile
  if [ $? -ne 0 ]
  then
    echo "error_text=$diskname not found"
    exit 0
  fi
  #temp=`df -k $diskname |tail -1`
  temp=`cat $tempfile |tail -1`
  diskutil=`echo $temp|awk '{printf("%s",$1)}'|awk '{gsub("%"," "); print $0}'`
  diskutil=`echo $diskutil|awk '{gsub(" ",""); print $0}'`
  echo "Disk Utilization=${diskutil}"
  echo "Total Size=-1"
  echo "Used Size=-1"
  echo "Avail Size=-1"
  echo "status_text=Disk Utilization: {0}%;;;${diskutil}"
  exit

elif [ "$os" = "SCO_SV" ] || [ "$os" = "UnixWare" ]
then
  #df -k $diskname > /dev/null
  df -k $diskname > $tempfile
  if [ $? -ne 0 ]
  then
    echo "error_text=$diskname not found"
    exit 0
  fi
  #temp=`df -k $diskname |tail -1`
  temp=`cat $tempfile |tail -1`
  diskutil=`echo $temp|awk '{printf("%s",$4)}'|awk '{gsub("%"," "); print $0}'`
  diskutil=`echo $diskutil|awk '{gsub(" ",""); print $0}'`
  echo "Disk Utilization=${diskutil}"
  echo "Total Size=-1"
  echo "Used Size=-1"
  echo "Avail Size=-1"
  echo "status_text=Disk Utilization: {0}%;;;${diskutil}"
  exit

elif [ "$os" = "OSF1" ]
then
  df $diskname > $tempfile
  if [ $? -ne 0 ]
  then
    echo "error_text=$diskname not found"
    exit 0
  fi
  temp=`cat $tempfile |tail -1`
  diskutil=`echo $temp|awk '{printf("%s",$5)}'|awk '{gsub("%"," "); print $0}'`
  diskutil=`echo $diskutil|awk '{gsub(" ",""); print $0}'`
  echo "Disk Utilization=${diskutil}"
  echo "Total Size=-1"
  echo "Used Size=-1"
  echo "Avail Size=-1"
  echo "status_text=Disk Utilization: {0}%;;;${diskutil}"
  exit

elif [ "$os" = "AIX" ] || [ "$os" = "aix" ]
then
  #df -k $diskname > /dev/null
  df -k $diskname > $tempfile
  if [ $? -ne 0 ]
  then
    echo "error_text=$diskname not found"
    exit 0
  fi
  #temp=`df -k $diskname |tail -1`
  temp=`cat $tempfile |tail -1`
  diskutil=`echo $temp|awk '{printf("%s",$4)}'|awk '{gsub("%"," "); print $0}'`
  echo "Disk Utilization=${diskutil}"
  echo "Total Size=-1"
  echo "Used Size=-1"
  echo "Avail Size=-1"
  echo "status_text=Disk Utilization: {0}%;;;${diskutil}"
  exit

else 
  echo "error_text=Unsupported platform: $os"
  exit
fi

rm $tempfile
avail_mb=`expr $disk_size_mb - $used_mb`
avail=`echo | awk '{ printf("%.2f",(c1/1024.0)) }' c1=$avail_mb`
avail="${avail}GB"
echo "Disk Utilization=${diskutil}"
echo "Total Size=$disk_size_mb"
echo "Used Size=$used_mb"
echo "Avail Size=$avail_mb"
