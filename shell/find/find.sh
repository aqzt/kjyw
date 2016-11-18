#!/bin/bash
## gitlab_rpm 2016-05-16
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7
##运维就是踩坑，踩坑的最高境界就是：踩遍所有的坑，让别人无坑可踩！

##cd  /var/cache/yum找*.rpm移动到一个文件夹
find  . -name  "*.rpm" -exec cp {} /root/111 \;


##找到*.log日志全部删除
find . -name *.log | xargs rm
find . -name *.rpm | xargs rm
find /data/file1 -name .svn -print0 | xargs -0 rm -r -f
find /data/file1 -name .git -print0 | xargs -0 rm -r -f

#删除5天之前的日志
find /data/nginx/log/ -ctime +5 -exec rm -f {} \;
find /data/logs -ctime +5 -exec rm -f {} \;
find /data/logs -name "localhost_access_log*.txt" -type f -mtime +5 -print -exec rm -f {} \;
find /data/zookeeper/logs -name "log.*" -type f -mtime +5 -print -exec rm -f {} \;

##删除目录下所有的 .svn 隐藏子目录
find . -name .svn -print0 | xargs -0 rm -r -f
find /data/file1 -name .svn -print0 | xargs -0 rm -r -f
find /data/file1 -name .git -print0 | xargs -0 rm -r -f
find . -name .svn -print0 | xargs -0 rm -r -f
find . -name .git -print0 | xargs -0 rm -r -f


##找出 n 天前的文件
find /temp/ -type f -mtime +n -print

##注：/temp/ 指出寻找/temp/目录下的文件
##-type f 指出找系统普通文件，不包含目录文件
##-mtime +n 指出找 n*24 小时前的文件
##-print 将找出的文件打印出来

##如：找出 7 天前的文件
find /temp/ -type f -mtime +7 -print
##找出 3 天前的文件
find /temp/ -type f -mtime +3 -print

##找出并删除 7 天前的文件
find /temp/ -type f -mtime +7 -print -exec rm -f {} \;
find /temp/ "ut*.log" -type f -mtime +7 -print -exec rm -f {} \;

##注：-exec 指出要执行后面的系统命令
##rm -f 删除找出的文件
##{} 只有该符号能跟在命令后面
##\ 结束符

##也可以使用 xargs 代替 -exec
find /temp/ -type f -mtime +7 -print | xargs rm -f

##find命令用途举例：
##如：
##查找/var下最大的前10个文件：
find /var -type f -ls | sort -k 7 -r -n | head -10

##查找/var/log/下大于5GB的文件：
find /var/log/ -type f -size +5120M -exec ls -lh {} \;

##找出今天的所有文件并将它们拷贝到另一个目录：
find /home/me/files -ctime 0 -print -exec cp {} /mnt/backup/{} \;

##找出所有一周前的临时文件并删除：
find /temp/ -mtime +7-type f | xargs /bin/rm -f

##查找所有的mp3文件，并修改所有的大写字母为小写字母：
find /home/me/music/ -type f -name *.mp3 -exec rename ‘y/[A-Z]/[a-z]/’ ‘{}’ \;


