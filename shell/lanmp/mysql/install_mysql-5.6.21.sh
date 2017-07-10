#!/bin/bash

ifubuntu=$(cat /proc/version | grep ubuntu)
if14=$(cat /etc/issue | grep 14)

if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi
if [ $machine == "x86_64" ];then
  rm -rf mysql-5.6.21-linux-glibc2.5-x86_64
  if [ ! -f mysql-5.6.21-linux-glibc2.5-x86_64.tar.gz ];then
	 wget http://zy-res.oss-cn-hangzhou.aliyuncs.com/mysql/mysql-5.6.21-linux-glibc2.5-x86_64.tar.gz
  fi
  tar -xzvf mysql-5.6.21-linux-glibc2.5-x86_64.tar.gz
  mv mysql-5.6.21-linux-glibc2.5-x86_64/* /alidata/server/mysql
else
  rm -rf mysql-5.6.21-linux-glibc2.5-i686
  if [ ! -f mysql-5.6.21-linux-glibc2.5-i686.tar.gz ];then
  wget http://zy-res.oss-cn-hangzhou.aliyuncs.com/mysql/mysql-5.6.21-linux-glibc2.5-i686.tar.gz
  fi
  tar -xzvf mysql-5.6.21-linux-glibc2.5-i686.tar.gz
  mv mysql-5.6.21-linux-glibc2.5-i686/* /alidata/server/mysql
fi

if [ "$ifubuntu" != "" ] && [ "$if14" != "" ];then
	mv /etc/mysql/my.cnf /etc/mysql/my.cnf.bak
fi

groupadd mysql
useradd -g mysql -s /sbin/nologin mysql
/alidata/server/mysql/scripts/mysql_install_db --datadir=/alidata/server/mysql/data/ --basedir=/alidata/server/mysql --user=mysql
chown -R mysql:mysql /alidata/server/mysql/
chown -R mysql:mysql /alidata/server/mysql/data/
chown -R mysql:mysql /alidata/log/mysql
\cp -f /alidata/server/mysql/support-files/mysql.server /etc/init.d/mysqld
sed -i 's#^basedir=$#basedir=/alidata/server/mysql#' /etc/init.d/mysqld
sed -i 's#^datadir=$#datadir=/alidata/server/mysql/data#' /etc/init.d/mysqld
cat > /etc/my.cnf <<END
[client]
port            = 3306
socket          = /tmp/mysql.sock
[mysqld]
port            = 3306
socket          = /tmp/mysql.sock
skip-external-locking
log-error=/alidata/log/mysql/error.log
key_buffer_size = 16M
max_allowed_packet = 1M
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M

log-bin=mysql-bin
binlog_format=mixed
server-id       = 1

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
END

chmod 755 /etc/init.d/mysqld
/etc/init.d/mysqld start
