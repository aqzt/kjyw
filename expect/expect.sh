#!/bin/bash  
##yum install expect -y
for i in `awk '{print $1}' passwd.txt`  
do  
j=`awk -v I="$i" '{if(I==$1)print $2}' passwd.txt`  
k=`awk -v I="$i" '{if(I==$1)print $3}' passwd.txt`  

expect login.exp $i $j $k
#~/.ssh/known_hosts存在重复KEY处理
#echo $i  
#check1=`cat ~/.ssh/known_hosts|grep  "$i ssh"`
#echo $check1
#if [ "$check1" == "" ];then
#expect login.exp $i $j $k
#else
#sed -i  "/$i ssh/d" ~/.ssh/known_hosts
#expect login.exp $i $j $k
#fi
done
