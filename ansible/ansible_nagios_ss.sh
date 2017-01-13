#!/bin/bash
## ansible_nagios_ss  2017-01-13
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6

ps -ef | grep 'nagios' | grep 'nrpe' | grep -v 'grep' | awk '{print $2}' | xargs kill
num1=`cat /usr/local/nagios/etc/nrpe.cfg |grep -v "#" |grep check_ss | grep nagios | awk -F ' ' '{print $2}'`
num2=`cat /usr/local/nagios/etc/nrpe.cfg |grep -v "#" |grep check_ss | grep nagios | awk -F ' ' '{print $2}'`
num5=`cat /usr/local/nagios/etc/nrpe.cfg |grep -v "#" |grep check_ss | grep nagios | awk -F ' ' '{print $3}'`
num6=`cat /usr/local/nagios/etc/nrpe.cfg |grep -v "#" |grep check_ss | grep nagios | awk -F ' ' '{print $3}'`
var1=`expr $num1 + 2000`
var2=`expr $num5 + 2000`
echo "w=$num1  c=$num5"
echo "w=$var1  c=$var2"
sed -i "s/check_ss.sh $num1 $num5/check_ss.sh $var1 $var2/g" /usr/local/nagios/etc/nrpe.cfg
/usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d