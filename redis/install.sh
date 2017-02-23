#!/bin/bash
##  2016-06-22
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6

yum install -y nmap unzip wget lsof xz net-tools gcc make gcc-c++

wget http://download.redis.io/releases/redis-2.8.24.tar.gz
tar zxvf redis-2.8.24.tar.gz
cd redis-2.8.24
make

mkdir  -p /opt/redis/bin/
cp src/redis-benchmark /opt/redis/bin/
cp src/redis-check-aof /opt/redis/bin/
cp src/redis-check-dump /opt/redis/bin/
cp src/redis-cli /opt/redis/bin/
cp src/redis-sentinel /opt/redis/bin/
cp src/redis-server /opt/redis/bin/

cd ..
#cp conf/redis.conf /opt/redis/redis.conf
cat >/opt/redis/redis.conf<<EOF
daemonize yes
port 7121
timeout 60
loglevel warning
databases 16
EOF

echo vm.overcommit_memory=1 >> /etc/sysctl.conf
sysctl -p

/opt/redis/bin/redis-server /opt/redis/redis.conf

echo "ok"

#sysctl vm.overcommit_memory=1 
##或执行
#echo vm.overcommit_memory=1 >>/proc/sys/vm/overcommit_memory

##释放内存
#sync && echo 3 > /proc/sys/vm/drop_caches

##测试连接
#/opt/redis/bin/redis-cli -h 127.0.0.1 -p 7121 
#/opt/redis/bin/redis-cli -h 127.0.0.1 -p 7121 -a Msxxsdsdsfaqqqqqq
