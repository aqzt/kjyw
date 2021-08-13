#!/bin/sh
## harbor API获取镜像地址，对比两个仓库差异
## 有问题可以反馈 https://aq2.cn/ 
##  


> hub.aaa.all.2020xxxx.log
> hub.bbb.all.2020xxxx.log
for Project in `cat ccc.txt`; do
bash pp1.sh  $Project  >> hub.aaa.all.2020xxxx.log
done

sleep 10

for Project in `cat ccc.txt`; do
bash tt1.sh  $Project >> hub.bbb.all.2020xxxx.log
done

> aa.aaa.xxxxa.log
> aa.aaa.xxxxb.log
for Project in `cat hub.aaa.all.2020xxxx.log`; do
echo "$Project" > a2.log
aaa=$(cat a2.log | awk -F ':' '{print $2}')
     if [[ "${#aaa}" -ge "39" ]];then
     echo "$Project"  >> aa.aaa.xxxxa.log
     else
     echo "$Project"  >> aa.aaa.xxxxb.log
     fi 
done

> bb.bbb.xxxxa.log
> bb.bbb.xxxxb.log

for Project in `cat hub.bbb.all.2020xxxx.log`; do
echo "$Project" > a3.log
aaa=$(cat a3.log | awk -F ':' '{print $2}')
     if [[ "${#aaa}" -ge "39" ]];then
     echo "$Project"  >> bb.bbb.xxxxa.log
     else
     echo "$Project"  >> bb.bbb.xxxxb.log
     fi 
done

diff  aa.aaa.xxxxb.log  bb.bbb.xxxxb.log |grep hub 
