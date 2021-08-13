#!/bin/bash
## Iptables 2016-09-28
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6
## iptables 流量限制，可以通过调整--limit-burst 10值来控制流入 流出
## --limit 1/s 表示每秒一次; 1/m 则为每分钟一次
## --limit-burst 表示允许触发 limit 限制的最大次数 (预设 5)
## --limit 2000/s --limit-burst 5   传送速度5.1MB/s
## --limit 2400/s --limit-burst 4   传送速度6.1MB/s
## --limit 2000/s --limit-burst 10     传送速度18.4MB/s
## --limit 2500/sec --limit-burst 200  传送速度51.7MB/s
## --limit 3000/sec --limit-burst 360  传送速度66.7MB/s

/sbin/iptables -F

/sbin/iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
/sbin/iptables -A INPUT -s 127.0.0.1 -j ACCEPT
/sbin/iptables -A INPUT -s 192.168.1.111 -j ACCEPT
/sbin/iptables -A INPUT -s 192.168.1.112 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 80  -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m tcp --dport 22 -m limit --limit 2000/s --limit-burst 10 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m tcp --dport 22 -j DROP
/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED  -m limit --limit 2000/s --limit-burst 10 -j ACCEPT
/sbin/iptables -A FORWARD -p tcp -m tcp --dport 22 -m limit --limit 2000/s --limit-burst 10 -j ACCEPT
/sbin/iptables -A FORWARD -p tcp -m tcp --dport 22 -j DROP
/sbin/iptables -A OUTPUT -p tcp -m tcp --dport 22 -m limit --limit 2000/s --limit-burst 10 -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp -m tcp --dport 22 -j DROP

/sbin/iptables -A INPUT -j REJECT
/sbin/iptables -A FORWARD -j REJECT
/sbin/iptables -A OUTPUT -j ACCEPT

/sbin/service iptables save
echo ok