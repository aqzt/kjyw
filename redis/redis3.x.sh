#!/bin/bash
#
###
# Filename: install_redis.sh
# Author: roguo.wei - roguo.wei@gmail.com
# Description: 
# Last Modified: 2016-12-09 15:39
# Version: 1.0
###

REDIS_VERSION="3.2.3"
REDIS_USER=""
REDIS_AUTH="123456"

REDIS_INSTALL_DIR=""
REDIS_PORT="6379"
REDIS_CONF="/etc/redis/6379.conf"
REDIS_LOG="/var/log/redis_6379.log"
REDIS_DATA="/var/lib/redis/6379"
REDIS_EXEC="/usr/local/bin/redis-server"


# install needed packages
for P in gcc gcc-c++ tcl
do
 rpm -qa $P &> /dev/null
 if [ $? -ne 0 ];then
 echo -n "install $P..."
 yum install -y $P &> /dev/null
 echo "ok"
 else
 echo "$P already installed."
 fi
done

# check tar file
if [ ! -e redis-${REDIS_VERSION}.tar.gz ];then
 echo "downloading redis..."
 wget -c http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz
fi

tar xf redis-${REDIS_VERSION}.tar.gz
pushd redis-${REDIS_VERSION}
echo -n "install redis..."
make install &> /dev/null
if [ $? -eq 0 ];then
 make test &> /dev/null
 [ $? -eq 0 ] && echo "ok" || echo "failed"
else
 echo "instal redis-${REDIS_VERSION} failed."
 exit 1
fi

# init redis server
echo "${REDIS_PORT}
${REDIS_CONF}
${REDIS_LOG}
${REDIS_DATA}
${REDIS_EXEC}

" | utils/install_server.sh

popd


# config redis server
sed -i 's@bind 127.0.0.1@bind 0.0.0.0@' /etc/redis/6379.conf
sed -i "s@^# requirepass foobared@requirepass ${REDIS_AUTH}@" /etc/redis/6379.conf

# start redis service
/etc/init.d/redis_6379 restart