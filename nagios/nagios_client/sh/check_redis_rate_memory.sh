#!/bin/bash
##检查redis使用内存是否占满
NORMAL_MSG="redis_memory is OK!"
WARONG_MSG="redis_memory is WARONG!!"
CRITICAL_MSG="redis_memory is CRITICAL!!!"
ERROR_MSG="max_redis_memory is 0"
PORT=$1
WARONG_NUM=$2
CRITICAL_NUM=$3
Redisclient=`find /opt/redis*|grep redis-cli$|head -1`

max_redis_memory=`echo 'config get maxmemory' |$Redisclient -h 127.0.0.1 -p $PORT | grep -v 'maxmemory'`
used_redis_memory=`$Redisclient -h 127.0.0.1 -p $PORT info | grep 'used_memory' | egrep -v 'used_memory_' | awk -F ":" '{print $2}'`
if [[ $max_redis_memory -ne 0 ]];then
    percent_redis_memory=`awk 'BEGIN{printf "%d\n",'$used_redis_memory'/'$max_redis_memory'*100}'`

    if [ $percent_redis_memory -ge $CRITICAL_NUM ];then
        echo "CRITICAL!!! ${CRITICAL_MSG} value is ${percent_redis_memory}"
        exit 2
    elif [[ $percent_redis_memory -ge $WARONG_NUM ]];then
        echo "WARONG!!! ${WARONG_MSG} value is ${percent_redis_memory}" 
        exit 1
    else
        echo "NORMAL ${NORMAL_MSG} value is ${percent_redis_memory}"
        exit 0
    fi
else
    echo "ERROR!!! ${ERROR_MSG}"
    exit 2
fi

#nrpe配置文件添加
#command[check_redis_7710_rate_memory]=/usr/local/nagios/libexec/check_redis_rate_memory.sh 7710 90 95
#command[check_redis_7711_rate_memory]=/usr/local/nagios/libexec/check_redis_rate_memory.sh 7711 90 95
#command[check_redis_7712_rate_memory]=/usr/local/nagios/libexec/check_redis_rate_memory.sh 7712 90 95
#command[check_redis_7713_rate_memory]=/usr/local/nagios/libexec/check_redis_rate_memory.sh 7713 90 95
#command[check_redis_7714_rate_memory]=/usr/local/nagios/libexec/check_redis_rate_memory.sh 7714 90 95
#command[check_redis_7715_rate_memory]=/usr/local/nagios/libexec/check_redis_rate_memory.sh 7715 90 95
#command[check_redis_7716_rate_memory]=/usr/local/nagios/libexec/check_redis_rate_memory.sh 7716 90 95
#command[check_redis_7717_rate_memory]=/usr/local/nagios/libexec/check_redis_rate_memory.sh 7717 90 95