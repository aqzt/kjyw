#!/bin/bash
## ansible_nagios_em2  2017-01-13
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6

ps -ef | grep 'nagios' | grep 'nrpe' | grep -v 'grep' | awk '{print $2}' | xargs kill
num1=`cat /usr/local/nagios/etc/nrpe.cfg |grep -v "#" |grep em2 | grep public123 | awk -F ' ' '{print $11}' | awk -F ',' '{print $2}'`
num2=`cat /usr/local/nagios/etc/nrpe.cfg |grep -v "#" |grep em2 | grep public123 | awk -F ' ' '{print $11}'`
num5=`cat /usr/local/nagios/etc/nrpe.cfg |grep -v "#" |grep em2 | grep public123 | awk -F ' ' '{print $13}' | awk -F ',' '{print $2}'`
num6=`cat /usr/local/nagios/etc/nrpe.cfg |grep -v "#" |grep em2 | grep public123 | awk -F ' ' '{print $13}'`
var1=`expr $num1 + 10000`
var2=`expr $num5 + 10000`
echo "w=$num1  c=$num5"
echo "w=$var1  c=$var2"
sed -i "s/-w $num2/-w $var1,$var1/g" /usr/local/nagios/etc/nrpe.cfg
sed -i "s/-c $num6/-c $var2,$var2/g" /usr/local/nagios/etc/nrpe.cfg
/usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d