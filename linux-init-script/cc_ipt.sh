#!/bin/bash
# Author:  ppabc <ppabc AT qq.com>
# Blog:  http://ppabc.cn
#
# Version: 0.1 1-October-2014 ppabc AT qq.com
# Notes: init script  for CentOS/RadHat 5+ Debian 6+ and Ubuntu 12+ 
#
# This script's project home is:
#       https://github.com/ppabc/linux-init-script
#       


num=200
cd /data/nginxlogs/
tail nginxlogs.access.log  -n 9999  |awk '{print $1}'|sort |uniq -c|sort -nr|head -n 200 > /data/nginxlogs/iptables.log
tail nginxlogs.access.log  -n 9999  |awk '{print $1}'|sort |uniq -c|sort -nr|head -n 200

cd /data/nginxlogs/
for i in `cat iptables.log|awk  '{print $2}'`
do
#k=`awk -F" " '{print $1}' $i`
#echo $k
/sbin/iptables -I INPUT -p tcp -s $i --dport 80 -j DROP
echo $i
done