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

##剪切参考，IO速度限制的cp和mv(限速1024 KB/s)
##cp: rsync --bwlimit=1024 {src} {dest}
##mv: rsync --bwlimit=1024 --remove-source-files {src} {dest}


##使用ssh方式rsync，不用服务端，简单方便，SSH需要认证，就不用每次输入密码
#ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa -q -b 2048 -C "root@test"
#cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
#chmod 600 ~/.ssh/authorized_keys

rsync -av --exclude=.gitlab-ci.yml --exclude=log --exclude=logs --delete /root/test 192.168.1.119:/root/test1

##rsync 参数的具体可以参考：
##http://bbs.aqzt.com/thread-138-1-1.html