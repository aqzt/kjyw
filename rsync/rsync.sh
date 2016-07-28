#!/bin/bash
## rsync限速  2016-07-14
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6
##使用cp备份日志，比较占用IO，可以使用rsync  --bwlimit=10000限速

time=$(date '+%Y-%m-%d-%H-test1_access.log')
time1=$(date '+%Y-%m-%d-%H-test2_access.log')
#cp /data/nginx/log/test1_access.log /data/nginx/log/$time
#cp /data/nginx/log/test2_access.log /data/nginx/log/$time1
/usr/bin/rsync -av --bwlimit=10000 /data/nginx/log/test1_access.log /data/nginx/log/$time
/usr/bin/rsync -av --bwlimit=10000  /data/nginx/log/test2_access.log /data/nginx/log/$time1
cat /dev/null > /data/nginx/log/test1_access.log
cat /dev/null > /data/nginx/log/test2_access.log
find /data/nginx/log/ -ctime +5 -exec rm -f {} \;
