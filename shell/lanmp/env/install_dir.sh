#!/bin/bash

#ifcentos=$(cat /proc/version | grep centos)
ifubuntu=$(cat /proc/version | grep ubuntu)

userdel www
groupadd www
if [ "$ifubuntu" != "" ];then
useradd -g www -M -d /alidata/www -s /usr/sbin/nologin www &> /dev/null
else
useradd -g www -M -d /alidata/www -s /sbin/nologin www &> /dev/null
fi

#if [ "$ifcentos" != "" ];then
#useradd -g www -M -d /alidata/www -s /sbin/nologin www &> /dev/null
#elif [ "$ifubuntu" != "" ];then
#useradd -g www -M -d /alidata/www -s /usr/sbin/nologin www &> /dev/null
#fi

mkdir -p /alidata
mkdir -p /alidata/server
mkdir -p /alidata/www
mkdir -p /alidata/www/phpwind
mkdir -p /alidata/log
mkdir -p /alidata/log/php
mkdir -p /alidata/log/mysql
mkdir -p /alidata/log/nginx
mkdir -p /alidata/log/nginx/access
chown -R www:www /alidata/log

mkdir -p /alidata/server/${mysql_dir}
ln -s /alidata/server/${mysql_dir} /alidata/server/mysql

mkdir -p /alidata/server/${php_dir}
ln -s /alidata/server/${php_dir} /alidata/server/php


mkdir -p /alidata/server/${web_dir}
if echo $web |grep "nginx" > /dev/null;then
mkdir -p /alidata/log/nginx
mkdir -p /alidata/log/nginx/access
ln -s /alidata/server/${web_dir} /alidata/server/nginx
else
mkdir -p /alidata/log/httpd
mkdir -p /alidata/log/httpd/access
ln -s /alidata/server/${web_dir} /alidata/server/httpd
fi
