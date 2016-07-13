#!/bin/bash
## for 2016-07-11
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

##linux  shell 按行循环读入文件
printf "*************************************\n"  
echo " cat file whiel read line"  
cat test.txt |while read line  
do  
  echo $line;  
done  
  
printf "*************************************\n"  
echo "while read line <file"  
while read line  
do  
  echo $line;  
done <test.txt  
  
printf "*************************************\n"  
echo "for line in cat test.txt"  
SAVEIFS=$IFS  
IFS=$(echo -en "\n")  
for line in $(cat test.txt)  
do  
  echo  $line;  
done  
IFS=$SAVEIFS 