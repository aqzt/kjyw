#!/bin/bash
##备份数据库脚本
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu


yum install make cmake pcre-devel openssl-devel glib2-devel zlib-devel gcc gcc-c++ mysql-devel -y
yum -y install mariadb-server mariadb mariadb-devel

###ln -s /usr/local/mysql/lib/libmysqlclient.so /usr/lib64/
ln -s /usr/lib64/mysql/libmysqlclient.so /usr/lib64/
wget --no-check-certificate https://github.com/maxbube/mydumper/archive/v0.9.5.tar.gz
tar zxf v0.9.5.tar.gz
cd mydumper-0.9.5
cmake .
make && make install
ln -sv /usr/local/bin/mydumper /usr/bin/mydumper
ln -sv /usr/local/bin/myloader /usr/bin/myloader

###centos6 install rpm
###https://github.com/maxbube/mydumper/releases/download/v0.9.5/mydumper-0.9.5-2.el6.x86_64.rpm
###centos7 install rpm
###https://github.com/maxbube/mydumper/releases/download/v0.9.5/mydumper-0.9.5-2.el7.x86_64.rpm
###Ubuntu / Debian
###wget https://github.com/maxbube/mydumper/releases/download/v0.9.5/mydumper_0.9.5-2.xenial_amd64.deb
###dpkg -i mydumper_0.9.5-1.xenial_amd64.deb
