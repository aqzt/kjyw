#!/bin/bash

wget https://codeload.github.com/openssl/openssl/tar.gz/OpenSSL_1_1_1h

yum install -y gcc make  perl

tar zxvf OpenSSL_1_1_1h.tar.gz

cd openssl-OpenSSL_1_1_1h
./config --prefix=/usr/local/openssl
make
make install


mv /usr/bin/openssl /usr/bin/openssl.old
mv /usr/lib64/openssl /usr/lib64/openssl.old
mv /usr/lib64/libssl.so /usr/lib64/libssl.so.old
ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/openssl/include/openssl /usr/include/openssl
ln -s /usr/local/openssl/lib/libssl.so /usr/lib64/libssl.so
echo "/usr/local/openssl/lib" >> /etc/ld.so.conf
ldconfig -v
openssl version
