#!/bin/bash
## for 2016-07-11
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

##循环判断两文件，差集内容
for File in `cat aaa.txt`; do
f=`cat 222.log  |grep "$File"`
if [ ! -n "$f" ]; then  echo "$File" ; fi
##if [ "$f" == "" ]; then  echo "$File" ; fi
done

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


#生成192.168.10.1到192.168.10.254  IP列表
for((i=1;i<=254;i++));do echo 192.168.10.$i;done

for((i=1;i<=10;i++));do echo $(expr $i \* 4);done

#在shell中常用的是 for i in $(seq 10);do echo $i;done
for i in `ls`;do echo $i;done
for i in ${arr[@]};do echo $i;done
for i in $* ;do echo $i;done

##循环打印某文件内容
for File in /proc/sys/net/ipv4/conf/*/accept_redirects; do
echo $File
done

#直接指定循环内容
for i in f1 f2 f3 ;do
echo $i
done

##C 语法for 循环
for (( i=0; i<10; i++)); do
echo $i
done

##批量修改文件后缀，conf改cfg
for i in *.conf;do mv $i $(sed "s/conf/cfg/" <<<$i);done


##for循环每秒执行脚本
#!/bin/bash
while true; do 
   sudo sh /data/shell/check_slave.sh
    sleep 1
done


