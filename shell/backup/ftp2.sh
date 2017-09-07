#!/bin/bash
## ftp 批量上传 2017-01-12
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6和centos 7

## 从linux服务器批量下载文件备份

date >> /tmp/ftp.log
today=`date +%Y-%m-%d_%H_%M_%S`
cd /data/backup/
mv 192.168.1.122  192.168.1.122_$today 
wget ftp://192.168.1.122:21/* --ftp-user=test --ftp-password=test123123 -r
date >> /tmp/ftp.log