#!/bin/bash
## Iptables 2016-07-21
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 7


#查看
#iptables -t raw -L -n

/sbin/iptables -F

##清除raw
/sbin/iptables -t raw -F

/sbin/iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
/sbin/iptables -A INPUT -s 127.0.0.1 -j ACCEPT

##设置Iptables禁止对连接数较大的服务进行跟踪
/sbin/iptables -A INPUT -m state --state UNTRACKED,ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -t raw -A PREROUTING -p tcp --dport 80 -j NOTRACK
/sbin/iptables -t raw -A OUTPUT -p tcp --sport 80 -j NOTRACK

/sbin/iptables -A OUTPUT -j ACCEPT
/sbin/iptables -A INPUT   -s 192.168.10.12 -p tcp --dport 22  -j ACCEPT
/sbin/iptables -A INPUT   -s 192.168.10.15 -p tcp --dport 22  -j ACCEPT
/sbin/iptables -A INPUT   -s 192.168.10.0/255.255.255.0 -p icmp -j ACCEPT
/sbin/iptables -A INPUT  -p tcp --dport 443  -j ACCEPT
/sbin/iptables -A INPUT  -p tcp --dport 80  -j ACCEPT

/sbin/iptables -A INPUT -j REJECT
/sbin/iptables -A FORWARD -j REJECT

/sbin/service iptables save
echo ok