#!/bin/bash
## cacti 2016-09-06
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6
##cacti搭建

#安装LAMP环境
yum install -y gcc make vim unzip wget install httpd mysql mysql-devel mysql-server php php-devel php-mysql php-comman php-pdo php-gd lm_sensor net-snmp php-snmp net-snmp-utils

yum install -y gcc perl-devel libxml2-devel libpng-devel pkg-config glib pixman pango pango-devel freetype freetype-devel fontconfig cairo cairo-devel libart_lgpl libart_lgpl-devel

### chkconfig mysqld on
### chkconfig httpd on
### chkconfig snmpd on
### service mysqld start
### service httpd start
### service snmpd start
### mysqladmin -u root password '123456'
### mysql -uroot -p
if false ; then
###注释start###
Enter password: 
Welcome to the MySQL monitor. Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.1.69 Source distribution
Copyright (c) 2000, 2013, Oracle and/or its affiliates. All rights reserved.
Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
mysql> create database cacti;
Query OK, 1 row affected (0.00 sec)
mysql> grant all on cacti.* to cactiuser@localhost identified by '654321';
Query OK, 0 rows affected (0.01 sec)
mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)
###注释end###
fi

tar zxvf rrdtool-1.4.5.tar.gz
cd rrdtool-1.4.5
./configure --prefix=/usr/local/rrdtool

make && make install

ln -s /usr/local/rrdtool/bin/* /usr/local/bin/


cd ..

tar zxvf net-snmp-5.3.4.tar.gz
cd net-snmp-5.3.4
./configure --prefix=/usr/local/net-snmp

make && make install

cp EXAMPLE.conf /usr/local/net-snmp/share/snmp/
ln -s /usr/local/net-snmp/bin/* /usr/local/bin/
/usr/local/net-snmp/sbin/snmpd -c /usr/local/net-snmp/share/snmp/snmpd.conf
echo "/usr/local/net-snmp/sbin/snmpd -c /usr/local/net-snmp/share/snmp/snmpd.conf" >>/etc/rc.local
cd ..

tar zxvf cacti-0.8.7g.tar.gz
cd cacti-0.8.7g
mysql -ucacti -pcactiWWW123 cacti < cacti.sql
cd include
sed -i "/cactiuser/ {29s/cactiuser/cacti/g}" config.php
sed -i "/cactiuser/ {30s/cactiuser/cactiWWW123/g}" config.php
cd ..
cd ..
mv cacti-0.8.7g /data/www/wwwroot/cacti
ln -s /usr/local/php-5.2.17/bin/php  /usr/bin/php
/usr/bin/php /data/www/wwwroot/cacti/poller.php
echo "*/5 * * * * env LANG=C /usr/bin/php /data/www/wwwroot/cacti/poller.php" >>/etc/crontab

