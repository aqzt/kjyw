#!/bin/bash
## 批量添加用户  批量删除用户 2016-10-14
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6和centos 7

cat userlist.log
username  password
test      123123
aaa       123123

########批量添加用户
for name in $(cat userlist.log | awk -F ' ' '{print $1}')
do
if [ -n $name ]
then
    useradd -m $name
    echo $(cat userlist.log  |grep $name | awk -F ' ' '{print $2}') | passwd --stdin $name
else
    echo "user is null"
fi
done

########批量删除用户
for name in $(cat userlist.log | awk -F ' ' '{print $1}')
do
if [ -n $name ]
then
    userdel $name
else
    echo "user is null"
fi
done
