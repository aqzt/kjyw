#!/bin/bash
## 流量分析 日志分析 2017-03-24
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6

yum install -y epel-release
yum install -y vnstat

#查看eth2网卡流量
vnstat -l -i eth2

##抓包命令
tcpdump -i eth2 -s 0 -c 10000 -w 1.cap
tcpdump -i eth2 -s 0 -c 10000 -w 0808.cap
tcpdump -i em2  port 19000
tcpdump -i eth0 -nn port 21
tcpdump -vv -nn -i em2  tcp  port 19000 and host 192.168.1.12
tcpdump -vv -nn -i em2  tcp port 19000
tcpdump -vv -nn -i em2  tcp  port 19000 -p
tcpdump -i em2 -s 0 -c 100000 -w 0809.cap

##查端口请求
ss -an | grep 19000|grep -i es | awk '{ print $6 }' | awk -F: '{ print $1}' | sort | uniq -c | sort -nr | head -n 30

##安装库文件，需要 libpcap 及 libcurses 。
yum install -y flex byacc libpcap ncurses ncurses-devel libpcap-devel

##下载并安装，目前最新版是0.17。
cd /usr/local/
wget http://www.ex-parrot.com/~pdw/iftop/download/iftop-0.17.tar.gz
tar zvfx iftop-0.17.tar.gz
cd iftop-0.17
./configure --prefix=/usr/local/iftop
make && make install
cp /usr/local/iftop/sbin/iftop /bin

./iftop -i eth2 -n -P -N