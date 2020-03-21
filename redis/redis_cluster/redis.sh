#!/bin/bash
##Author: aq2.cn
##Date: 2020-02-19 17:50:11
##LastEditors: aq2.cn
##LastEditTime: 2020-02-19 17:50:11
##Description: aqzt.com redis集群搭建
########################

num1="30011"
num2="30016"
IP="192.168.56.101"
Ruby="ruby-2.4.5"
Redis="redis-4.0.12"

if  [[ -n "$2" ]];then
    num1="$2"
fi
if  [[ -n "$3" ]];then
    num2="$3"
fi
if  [[ -n "$4" ]];then
    IP="$4"
fi
if [[ "${num2}" -le "${num1}" ]] ;then
    echo "Port parameter error"
    exit
fi
if  [[ ! -f "$Ruby.tar.gz" ]];then
    yum install -y wget
    wget https://cache.ruby-lang.org/pub/ruby/2.4/"$Ruby.tar.gz"
fi
if  [[ ! -f "$Redis.tar.gz" ]];then
    yum install -y wget
    wget http://download.redis.io/releases/"$Redis.tar.gz"
fi

Install_Ruby_AQZT(){
yum install -y nmap unzip wget lsof xz net-tools gcc make gcc-c++ zlib-devel openssl-devel

##安装ruby
##wget https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.5.tar.gz
tar -zxvf "$Ruby.tar.gz"
cd "$Ruby"
./configure
make && make install

cd ext/zlib
ruby ./extconf.rb
/usr/bin/cp ../../../zlib/Makefile Makefile
make
make install
cd ../../
cd ext/openssl
ruby ./extconf.rb
/usr/bin/cp ../../../openssl/Makefile Makefile
make
make install
cd ../../
gem sources -a https://gems.ruby-china.com/
gem install redis
cd ..
echo "ok"
}

##安装redis
Install_Redis_AQZT(){
## wget http://download.redis.io/releases/redis-3.2.12.tar.gz
## wget http://download.redis.io/releases/redis-4.0.12.tar.gz
## wget http://download.redis.io/releases/redis-5.0.8.tar.gz
tar zxvf "$Redis.tar.gz"
cd "$Redis"
make

mkdir  -p /opt/redis/bin/
/usr/bin/cp src/redis-benchmark /opt/redis/bin/
/usr/bin/cp src/redis-check-aof /opt/redis/bin/
/usr/bin/cp src/redis-check-rdb /opt/redis/bin/
/usr/bin/cp src/redis-trib.rb /opt/redis/bin/
/usr/bin/cp src/redis-cli /opt/redis/bin/
/usr/bin/cp src/redis-sentinel /opt/redis/bin/
/usr/bin/cp src/redis-server /opt/redis/bin/

cat >/opt/redis/redis.conf<<EOF
daemonize yes
port 9852
masterauth test20200316
requirepass test20200316
maxclients 10000
maxmemory 256mb
bind 127.0.0.1
pidfile /var/run/redis_9852.pid 
logfile /data/redis/data_9852/redis_9852.log 
dir /data/redis/data_9852/
cluster-enabled yes
cluster-config-file nodes_9852.conf
cluster-node-timeout 15000
appendonly yes
appendfilename "appendonly_9852.aof"
appendfsync always
EOF

sed -i 's/:password => nil,/:password => \"test20200316\",/g' /usr/local/lib/ruby/gems/2.4.0/gems/redis-4.1.*/lib/redis/client.rb
echo "ok"
}


Init_AQZT(){
echo -en "\n"
n=$num1
for ((n="$num1";n<="$num2";n++))
do
echo "port:$n ok"
mkdir -p /opt/redis/redis_$n/
mkdir -p /data/redis/data_$n/
/usr/bin/cp /opt/redis/redis.conf  /opt/redis/redis_$n/redis.conf
sed -i "s/127.0.0.1/$IP/g" /opt/redis/redis_$n/redis.conf
sed -i "s/9852/$n/g"  /opt/redis/redis_$n/redis.conf

NUMREDIS=$(tail -n 32 /etc/rc.local|grep -c "redis_$n")
if [[ "${NUMREDIS}" -ge "1" ]] ;then
   sed -i "/redis_$n/d" /etc/rc.local
   echo "/opt/redis/bin/redis-server /opt/redis/redis_$n/redis.conf &" >> /etc/rc.local
else
   echo "/opt/redis/bin/redis-server /opt/redis/redis_$n/redis.conf &" >> /etc/rc.local
fi
done
}

Start_AQZT(){
echo -en "\n"
n=$num1
for ((n="$num1";n<="$num2";n++))
do
echo "port:$n ok"
/opt/redis/bin/redis-server /opt/redis/redis_$n/redis.conf
done
}

Stop_AQZT(){
echo -en "\n"
n=$num1
NUMREDIS=$(ps -ef | grep 'redis-server'  | grep -v 'grep'| grep -c 'opt')
if [[ "${NUMREDIS}" -ge "1" ]] ;then
   for ((n="$num1";n<="$num2";n++))
   do
   echo "port:$n ok"
   ps -ef | grep 'redis-server'  | grep -v 'grep'| grep 'opt' | grep $n | awk '{print $2}' | xargs kill
   done
     if [[ "${NUMREDIS}" -ge "1" ]] ;then
     ps -ef | grep 'redis-server'  | grep -v 'grep'| grep 'opt' | awk '{print $2}' | xargs kill
     fi
else
   echo "No redis process"
fi
echo ok
}

Uninstall_AQZT(){
echo -en "\n"
NUMREDIS=$(ps -ef | grep 'opt'  | grep -v 'grep'| grep -c 'redis-server')
if [[ "${NUMREDIS}" -ge "1" ]] ;then
   ps -ef | grep 'redis-server' | grep 'opt'  | grep -v 'grep' | awk '{print $2}' | xargs kill
   rm -rf /opt/redis/redis_*
   rm -rf /data/redis/data_*
else
   rm -rf /opt/redis/redis_*
   rm -rf /data/redis/data_*
fi
echo ok
}


case "$1" in
 start)
Start_AQZT
 ;;
 stop)
Stop_AQZT
 ;;
 restart)
Restart_AQZT
 ;;
 init)
Init_AQZT
 ;;
 redis)
Install_Redis_AQZT
 ;;
 install)
Install_Ruby_AQZT
Install_Redis_AQZT
 ;;
 uninstall)
Uninstall_AQZT
 ;;
 *)
 echo "Usage: $SCRIPTNAME {start|stop|restart|init|redis|install|uninstall}" >&2
 exit 3
 ;;
esac
