#!/bin/bash
##  2016-06-22
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6
##批量部署redis的脚本，输入开始端口和结束端口，自动创建文件夹，
##准备配置文件模板，批量替换配置文件端口，批量启动和停止redis

Install_C(){
echo "start num"
read num1
echo "end num"
read num2
echo -en "\n"
n=$num1
for ((n=$num1;n<=$num2;n++))
do
echo "port:$n ok"
mkdir -p /opt/redis/redis_$n
cp /opt/redis/redis.conf  /opt/redis/redis_$n/
sed -i "s/7121/$n/g"  /opt/redis/redis_$n/redis.conf
/opt/redis/bin/redis-server /opt/redis/redis_$n/redis.conf
done
}

Start_C(){
echo "start num"
read num1
echo "end num"
read num2
echo -en "\n"
n=$num1
for ((n=$num1;n<=$num2;n++))
do
echo "port:$n ok"
/opt/redis/bin/redis-server /opt/redis/redis_$n/redis.conf
done
}

Stop_C(){
echo "start num"
read num1
echo "end num"
read num2
echo -en "\n"
n=$num1
for ((n=$num1;n<=$num2;n++))
do
echo "port:$n ok"
ps -ef | grep 'redis' | grep $n | grep -v 'grep' | awk '{print $2}' | xargs kill
done


echo ok
}

case "$1" in
 start)
Start_C
 ;;
 stop)
Stop_C
 ;;
 restart)
Restart_C
 ;;
 install)
Install_C
 ;;
 uninstall)
Uninstall_A
 ;;
 *)
 echo "Usage: $SCRIPTNAME {start|stop|restart|install|uninstall}" >&2
 exit 3
 ;;
esac