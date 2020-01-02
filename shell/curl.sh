#!/bin/bash
## curl http2 2020-01-02
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

yum install -y bzip2 openssl openssl-devel libcurl

wget https://github.com/nghttp2/nghttp2/releases/download/v1.40.0/nghttp2-1.40.0.tar.bz2
tar xvf nghttp2-1.40.0.tar.bz2
cd nghttp2-1.40.0
./configure
make
make install
cd ..

echo "/usr/local/lib" >> /etc/ld.so.conf
ldconfig

wget https://curl.haxx.se/download/curl-7.67.0.tar.gz
tar zxvf curl-7.67.0.tar.gz
cd curl-7.67.0
./configure --with-nghttp2=/usr/local --with-ssl
make
make install
cd ..
echo ok

echo "/usr/local/bin/curl -kv --http2  -I  https://aqzt.com"
