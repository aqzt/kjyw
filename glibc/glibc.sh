#!/bin/bash
## glibc 2016-07-8
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6
##解决libc.so.6: version `GLIBC_2.14' not found问题


strings /lib64/libc.so.6 |grep GLIBC_


yum install -y  curl openssh-server openssh-clients postfix cronie git nmap unzip wget lsof xz gcc make vim  curl gcc-c++ libtool

cd /opt/
#wget http://ftp.gnu.org/gnu/glibc/glibc-2.14.tar.gz
wget http://ftp.gnu.org/gnu/glibc/glibc-2.24.tar.xz

tar zxvf glibc-2.14.tar.gz
cd glibc-2.14

mkdir build
cd build
/opt/glibc-2.14/configure --prefix=/opt/glibc-2.14
make
make install

mkdir -p  /opt/glibc-2.14/etc
touch /opt/glibc-2.14/etc/ld.so.conf
export LD_LIBRARY_PATH=/opt/glibc-2.14/lib:$LD_LIBRARY_PATH 
