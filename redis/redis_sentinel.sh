#!/bin/bash
## 2017-03-04
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6
## 部署redis  sentinel脚本
## 

Host=$2

case "$1" in

start)
### start
/opt/redis/bin/redis-server /opt/redis/redis.conf &
/opt/redis/bin/redis-server /opt/redis/sentinel.conf --sentinel &
### start
 ;;

 stop)
### stop
ps -ef | grep redis | grep sentinel | grep -v grep | grep -v sh | awk '{print $2}' | xargs kill
ps -ef | grep redis | grep server | grep -v grep | grep -v sh | awk '{print $2}' | xargs kill
echo ok
### stop
 ;;

 restart)
echo restart
 ;;
 
 master)
###master
cat >/opt/redis/redis.conf<<EOF
daemonize yes
pidfile /var/run/redis_7121.pid
port 7121
requirepass 123123
masterauth 123123
timeout 0
loglevel notice
databases 16
rdbcompression yes
dbfilename dump-7121.rdb
dir /data/redis/data
maxclients 50000
maxmemory 256mb
slave-serve-stale-data yes
appendonly no
appendfilename appendonly7121.aof
appendfsync everysec
activerehashing yes
slave-read-only yes
EOF
### master
 ;;

  slave)
###slave
cat >/opt/redis/redis.conf<<EOF
daemonize yes
pidfile /var/run/redis_7121.pid
port 7121
dbfilename dump-7121.rdb
appendonly yes
requirepass 123123
masterauth 123123
timeout 0
loglevel notice
databases 16
rdbcompression yes
dir /data/redis/data
maxclients 50000
maxmemory 256mb
slave-serve-stale-data yes
appendonly no
appendfilename appendonly7121.aof
appendfsync everysec
activerehashing yes
slave-read-only yes
slaveof $Host 7121
EOF
### slave
 ;;

  sentinel)
###sentinel
cat >/opt/redis/sentinel.conf<<EOF
port 26379
daemonize yes
protected-mode no
sentinel monitor mymaster $Host 7121 2
sentinel auth-pass mymaster 123123
sentinel down-after-milliseconds mymaster 3000
sentinel failover-timeout mymaster 3000
sentinel parallel-syncs mymaster 1
logfile "/var/log/sentinel.log"
EOF
### sentinel
 ;;

 uninstall)
echo uninstall
 ;;

 *)
 echo "Usage: $SCRIPTNAME {start|stop|restart|install|uninstall}" >&2
 exit 3
 ;;
esac
