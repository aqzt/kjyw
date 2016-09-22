#!/bin/bash
## pigz rsync 2016-09-22
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6
## 

tomcat_log=/usr/local/tomcat/logs/home.log.`date -d last-day +%Y-%m-%d`
tomcat_file=home.log.`date -d last-day +%Y-%m-%d`
today=`date -d last-day +"%Y"`/`date -d last-day +"%m"`/`date -d last-day +"%d"`/
echo "Start....."
echo "`date +'%Y-%m-%d %H:%M:%S'`" 
echo "-----------------------"
/usr/local/bin/pigz -9 $tomcat_log
mv "$tomcat_log".gz "$tomcat_log".web_log.gz
echo "create dir....."
echo "`date +'%Y-%m-%d %H:%M:%S'`" 
echo "-----------------------"
ssh 192.168.56.101 "mkdir -p /data/log/$today"
/usr/bin/rsync -av --bwlimit=6400 "$tomcat_log".web_log.gz 192.168.56.101:/data/log/$today
#/usr/bin/rsync -av --bwlimit=6400 "$tomcat_log".gz 192.168.56.101:/data/$today/"$tomcat_file".web.gz
echo "finish....."
echo "`date +'%Y-%m-%d %H:%M:%S'`" 
echo "-----------------------"