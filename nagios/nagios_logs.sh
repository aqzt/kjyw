#!/bin/bash
## nagios  2016-11-11
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6和centos 7
## 对nagios日志排序，找出告警最多的IP，用于优化ngios配置

cat nagios-$1-2016-00.log |grep mail  | awk -F '[;]' '{print $2}' > nagios_$1.log

sort nagios_$1.log | uniq -c | sort -n > nagios_$1_a.log

cat nagios_$1_a.log

echo ok