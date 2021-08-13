#!/bin/bash
date=`date -d "0 day" +%Y%m%d`
apt-get install libpam-dev
##apt-get install libpam0g-dev
##yum install pam-devel
tar zxvf zlib-1.2.8.tar.gz  
cd zlib-1.2.8 
./configure --prefix=/usr/local/zlib -share
make && make install
echo "/usr/local/zlib/lib" >>/etc/ld.so.conf
ldconfig -v
cd ..
####install openssl########  
tar zxvf openssl-1.0.1h.tar.gz
cd openssl-1.0.1h
./config shared zlib-dynamic --prefix=/usr/local/openssl --with-zlib-lib=/usr/local/zlib/lib --with-zlib-include=/usr/local/zlib/include
make && make install
echo "/usr/local/openssl/lib" >>/etc/ld.so.conf
ldconfig -v
cd ..
####install openssh########  
tar -zxvf openssh-6.6p1.tar.gz
cd openssh-6.6p1
mv /usr/bin/openssl /usr/bin/openssl.OFF.$date
mv /usr/include/openssl /usr/include/openssl.OFF.$date
ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/openssl/include/openssl /usr/include/openssl
#mv /lib64/libcrypto.so.4  /lib64/libcrypto.so.4.OFF
#mv /lib64/libssl.so.4   /lib64/libssl.so.4.OFF
ln -s /usr/local/openssl/lib/libcrypto.so.1.0.0 /lib64/libcrypto.so.4
ln -s /usr/local/openssl/lib/libssl.so.1.0.0 /lib64/libssl.so.4
mv /usr/lib64/libcrypto.so  /usr/lib64/libcrypto.so.OFF.$date
mv /usr/lib64/libssl.so   /usr/lib64/libssl.so.OFF.$date
ln -s /usr/local/openssl/lib/libcrypto.so  /usr/lib64/libcrypto.so
ln -s /usr/local/openssl/lib/libssl.so  /usr/lib64/libssl.so
./configure --prefix=/usr --sysconfdir=/etc/ssh --with-pam --with-ssl-dir=/usr/local/openssl --with-md5-passwords --mandir=/usr/share/man --with-zlib=/usr/local/zlib --without-openssl-header-check  
make && make install
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.4.OFF.$date
sed -i '/GSSAPIAuthentication/d' /etc/ssh/sshd_config
sed -i '/GSSAPICleanupCredentials/d' /etc/ssh/sshd_config
mv /etc/init.d/sshd /etc/init.d/sshd.4.OFF.$date
cp ./contrib/redhat/sshd.init /etc/init.d/sshd
chmod +x /etc/init.d/sshd
chkconfig sshd on
/etc/init.d/sshd restart
openssl version -a
ssh -V
exit
