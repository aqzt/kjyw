@echo off
rem ================================================== 
rem author   赵亚南 
rem date     2013/03/27
rem apply to win2k3 http://www.2cto.com/Article/201303/198927.html
rem ================================================== 
 
sc config "PolicyAgent" start= auto 
sc start PolicyAgent 
 
Netsh ipsec static del rule all ipsec_base_config 
Netsh ipsec static del policy all
Netsh ipsec static del filteraction all
Netsh ipsec static del filterlist all
 
Netsh ipsec static add policy name=ipsec_base_config activatedefaultrule = no
 
Netsh ipsec static add filteraction name=block action=block 
Netsh ipsec static add filteraction name=permit action=permit 
 
Netsh ipsec static add filterlist name=permitlist 
Netsh ipsec static add filterlist name=alllist 
 
Netsh ipsec static add filter filterlist=permitlist srcaddr=any dstaddr=me protocol=tcp mirrored=yes dstport=80 对外服务端口 
Netsh ipsec static add filter filterlist=permitlist srcaddr=1.2.3.4 dstaddr=me protocol=tcp mirrored=yes dstport=3306 数据库 
Netsh ipsec static add filter filterlist=permitlist srcaddr=2.3.4.5 srcmask=32 dstaddr=me dstmask=32 protocol=any mirrored=yes dstport=0 VPN-IP 
Netsh ipsec static add filter filterlist=permitlist srcaddr=2.3.4.6 dstaddr=me protocol=any mirrored=yes dstport=0 VPN-IP 
rem Netsh ipsec static add filter filterlist=permitlist srcaddr=192.168.1.0 srcmask=255.255.255.0 dstaddr=me protocol=any mirrored=yes dstport=0 内网信任网络 
Netsh ipsec static add filter filterlist=permitlist srcaddr=210.72.145.44 srcmask=255.255.255.255 srcport=123 dstaddr=me dstport=123 protocol=UDP mirrored=yes 复旦大学NTP时间同步服务器 
Netsh ipsec static add filter filterlist=permitlist srcaddr=any dstaddr=me protocol=ICMP mirrored=yes PING响应，注释这条可以禁ping，连本机也ping不出去 
Netsh ipsec static add filter filterlist=permitlist srcaddr=60.195.252.107 dstaddr=me protocol=udp mirrored=yes dstport=161 监控宝snmp 
Netsh ipsec static add filter filterlist=permitlist srcaddr=60.195.252.110 dstaddr=me protocol=udp mirrored=yes dstport=161 监控宝snmp 
Netsh ipsec static add filter filterlist=permitlist srcaddr=60.195.252.106 dstaddr=me protocol=tcp mirrored=yes dstport=3306 监控宝mysql 
Netsh ipsec static add filter filterlist=permitlist srcaddr=me dstaddr=202.96.128.86 protocol=udp mirrored=yes dstport=53 访问外网DNS，要换成你当地的DNS 
Netsh ipsec static add filter filterlist=permitlist srcaddr=me dstaddr=any protocol=tcp mirrored=yes dstport=80 访问外网WEB 
Netsh ipsec static add filter filterlist=permitlist srcaddr=me dstaddr=any protocol=tcp mirrored=yes dstport=8080 访问外网WEB 
Netsh ipsec static add filter filterlist=permitlist srcaddr=me dstaddr=any protocol=tcp mirrored=yes dstport=443 访问外网WEB 
Netsh ipsec static add filter filterlist=permitlist srcaddr=me dstaddr=any protocol=tcp mirrored=yes dstport=21 访问外网FTP 
Netsh ipsec static add filter filterlist=alllist srcaddr=any dstaddr=me protocol=any mirrored=yes dstport=0 最后默认阻止其它所有 
 
Netsh ipsec static add rule name=1 policy=ipsec_base_config filterlist=permitlist filteraction=permit 
Netsh ipsec static add rule name=2 policy=ipsec_base_config filterlist=alllist filteraction=block 
 
netsh ipsec static set policy name=ipsec_base_config assign=y 