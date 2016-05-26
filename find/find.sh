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