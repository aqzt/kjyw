#!/bin/bash
date=`date -d "0 day" +%Y%m%d`
rpm -e openssh-server
rpm -e openssh-clients
rpm -e openssh-askpass
rpm -e openssh
mv /etc/ssh /etc/ssh.bak

tar zxvf zlib-1.2.8.tar.gz  
cd zlib-1.2.8 
./configure --prefix=/usr/local/zlib && make && make install

cd ..
####install openssl########  
tar zxvf openssl-1.0.2c.tar.gz
cd openssl-1.0.2c
./config --prefix=/usr/local/openssl && make && make install
cd ..
####install openssh########  
tar -zxvf openssh-6.9p1.tar.gz
cd openssh-6.9p1
./configure --prefix=/usr/local/openssh --sysconfdir=/etc/ssh --with-ssl-dir=/usr/local/openssl --with-zlib=/usr/local/zlib --with-md5-passwords --without-hardening && make && make install
cd ..

mv /etc/init.d/sshd /etc/init.d/sshd.4.OFF.$date
cp  sshd  /etc/init.d/sshd
chmod +x /etc/init.d/sshd 

mv /etc/init.d/sshd /etc/init.d/sshd.4.OFF.$date
cp ./contrib/redhat/sshd.init /etc/init.d/sshd
chmod +x /etc/init.d/sshd
chkconfig --add sshd
chkconfig sshd on
/etc/init.d/sshd restart
openssl version -a
ssh -V
exit
