#!/bin/bash
/sbin/iptables -F
/sbin/iptables -X

/sbin/iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
/sbin/iptables -A INPUT -s 127.0.0.1 -j ACCEPT
/sbin/iptables -A INPUT -s 114.114.114.114 -j ACCEPT
/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -A OUTPUT -j ACCEPT
/sbin/iptables -A INPUT -s 114.114.114.114 -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT

/sbin/iptables -A INPUT -j REJECT
/sbin/iptables -A FORWARD -j REJECT

iptables-save

##iptables-save >/etc/iptables.up.rules
##iptables-restore </etc/iptables.up.rules

echo ok