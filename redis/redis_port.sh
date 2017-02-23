#!/bin/bash
##  2016-06-22
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6
##批量部署redis的脚本，输入开始端口和结束端口，自动创建文件夹，
##准备配置文件模板，批量替换配置文件端口，批量启动和停止redis

num1=$2
num2=$3
n=$2
case "$1" in

start)
### start
for ((n=$num1;n<=$num2;n++))
do
echo "port:$n ok"
/opt/redis/bin/redis-server /opt/redis/redis_$n/redis.conf
done
### start
 ;;

 stop)
### stop
for ((n=$2;n<=$3;n++))
do
echo "port:$n ok"
ps -ef | grep redis | grep $n | grep -v grep | grep -v sh | awk '{print $2}' | xargs kill
done
echo ok
### stop
 ;;

 restart)
echo restart
 ;;
 
 install)
### install
for ((n=$num1;n<=$num2;n++))
do
echo "port:$n ok"
mkdir -p /opt/redis/redis_$n
cp /opt/redis/redis.conf  /opt/redis/redis_$n/
sed -i "s/7121/$n/g"  /opt/redis/redis_$n/redis.conf
/opt/redis/bin/redis-server /opt/redis/redis_$n/redis.conf
done
### install
 ;;

 uninstall)
echo uninstall
 ;;

 *)
 echo "Usage: $SCRIPTNAME {start|stop|restart|install|uninstall}" >&2
 exit 3
 ;;
esac
