#!/bin/sh
## docker快速安装zabbix:3.4.15
## 有问题可以反馈 https://aq2.cn/c/zabbix


docker run --name  mysql -t \
      -v /data/mysql:/var/lib/mysql  \
      -e MYSQL_ROOT_PASSWORD=test123123  \
      -v /etc/localtime:/etc/localtime:ro \
      --net=host \
      -d opcache/zabbix:3.4.15-mariadb
 
docker run --name zabbix-server-mysql -t \
      -e DB_SERVER_HOST="127.0.0.1" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix" \
      -e MYSQL_ROOT_PASSWORD="test123123" \
      -v /etc/localtime:/etc/localtime:ro \
      --net=host \
      -d opcache/zabbix:3.4.15-server
 
 
docker run --name zabbix-agent -t \
      -e ZBX_SERVER_HOST="127.0.0.1" \
      -e ZABBIX_SERVER_ACTIVE="127.0.0.1" \
      -e PHP_TZ="Asia/Shanghai" \
      --net=host \
      -d opcache/zabbix:3.4.15-agent
 
echo ok