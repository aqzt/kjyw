#!/bin/sh
os=`uname`
tempfile1=swap.tmp
tempfile2=swap.tmp.1
tempfile3=swap.tmp.3
rm -rf $tempfile1
rm -rf $tempfile2

temp1=0
temp2=0
total=0
free=0
used=0
util=0

if [ "$os" = "linux" ] || [ "$os" = "Linux" ]
then
 swapon -s | grep /dev > $tempfile1

 cat $tempfile1 | awk '{ print $3 }' > $tempfile2
 for var in `cat $tempfile2`
 do
   total=`expr $total + $var`
 done

 cat $tempfile1 | awk '{ print $4 }' > $tempfile2
 for var in `cat $tempfile2`
 do
   used=`expr $used + $var`
 done

 free=`expr $total - $used`
 util=`expr $used \* 100 / $total`
 total=`expr $total / 1024`
 used=`expr $used / 1024`
 free=`expr $free / 1024`

elif [ "$os" = "SunOS" ]
then
 swap -l | grep /dev > $tempfile1

 cat $tempfile1 | awk '{ print $4 }' > $tempfile2
 for var in `cat $tempfile2`
 do
   total=`expr $total + $var`
 done

 cat $tempfile1 | awk '{ print $5 }' > $tempfile2
 for var in `cat $tempfile2`
 do
   free=`expr $free + $var`
 done

 total=`expr $total / 2`
 free=`expr $free / 2`
 used=`expr $total - $free`
 util=`expr $used \* 100 / $total`
 total=`expr $total / 1024`
 used=`expr $used / 1024`
 free=`expr $free / 1024`

elif [ "$os" = "AIX" ] || [ "$os" = "aix" ]
then
temp1=`lsps -s | tail -1 | awk '{print $1}'`
total=`echo $temp1 | awk '{gsub("MB"," "); print $0}'`

temp2=`lsps -s | tail -1 | awk '{print $2}'` 
util=`echo $temp2 | awk '{gsub("%"," "); print $0}'`

used=`lsps -s | tail -1 | awk '{print ($1 * $2 / 100)}'`



elif [ "$os" = "HP-UX" ]
then
 swapinfo | grep /dev > $tempfile1
 cat $tempfile1 | awk '{ print $2 }' > $tempfile2
 for var in `cat $tempfile2`
 do
   total=`expr $total + $var`
 done

 cat $tempfile1 | awk '{ print $3 }' > $tempfile2
 for var in `cat $tempfile2`
 do
   used=`expr $used + $var`
 done

 free=`expr $total - $used`
 util=`expr $used \* 100 / $total`
 total=`expr $total / 1024`
 used=`expr $used / 1024`
 free=`expr $free / 1024`

elif [ "$os" = "SCO_SV" ] || [ "$os" = "UnixWare" ]
then
 swap -l | grep /dev > $tempfile1

 cat $tempfile1 | awk '{ print $4 }' > $tempfile2
 for var in `cat $tempfile2`
 do
   total=`expr $total + $var`
 done

 cat $tempfile1 | awk '{ print $5 }' > $tempfile2
 for var in `cat $tempfile2`
 do
   free=`expr $free + $var`
 done

 total=`expr $total / 2`
 free=`expr $free / 2`
 used=`expr $total - $free`
 util=`expr $used \* 100 / $total`
 total=`expr $total / 1024`
 used=`expr $used / 1024`
 free=`expr $free / 1024`
else
 echo "tobe done"
fi

echo "Total Swap=$total "
echo "Used Swap=$used"
echo "Swapspace Utilization=$util"

exit
