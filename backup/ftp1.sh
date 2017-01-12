#!/bin/bash
## ftp 批量上传 2017-01-12
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6和centos 7

## 从linux服务器批量上传/home/test文件夹里面文件到FTP(192.168.1.122)里面wwwroot目录

updir=/home/test
todir=wwwroot
ip=192.168.1.122
user=test
password=test123123
sss=`find $updir -type d -printf $todir/'%P\n'| awk '{if ($0 == "")next;print "mkdir " $0}'`
aaa=`find $updir -type f -printf 'put %p %P \n'`
ftp -nv $ip <<EOF 
user $user $password
type binary 
prompt 
$sss 
cd $todir 
$aaa 
quit 
EOF