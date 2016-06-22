#!/bin/bash
##  2016-06-22
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6

yum install -y nmap unzip wget lsof xz net-tools gcc make gcc-c++

tar zxvf redis-2.8.24.tar.gz
cd redis-2.8.24
make
make install

mkdir  -p /opt/redis/bin/
cp src/redis-benchmark /opt/redis/bin/
cp src/redis-check-aof /opt/redis/bin/
cp src/redis-check-dump /opt/redis/bin/
cp src/redis-cli /opt/redis/bin/
cp src/redis-sentinel /opt/redis/bin/
cp src/redis-server /opt/redis/bin/

cd ..


echo vm.overcommit_memory=1 >> /etc/sysctl.conf
sysctl -p
#sysctl vm.overcommit_memory=1 
##或执行
#echo vm.overcommit_memory=1 >>/proc/sys/vm/overcommit_memory