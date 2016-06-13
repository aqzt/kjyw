#!/bin/bash
## HTTPS 测试工具
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##Ubuntu 12.04 LTS Ubuntu 14.04 LTS

apt-get install g++ make binutils autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libev-dev libevent-dev libjansson-dev libjemalloc-dev cython python3-dev python-setuptools git

git clone https://github.com/tatsuhiro-t/nghttp2.git

cd ./nghttp2

autoreconf -i
automake
autoconf
./configure

make
make install

##ubuntu  GCC  error: expected nested-name-specifier before ‘ResultType’
##gcc 系统默认版本低导致错误，需升级GCC 4.8
add-apt-repository ppa:ubuntu-toolchain-r/test
apt-get update
apt-get install gcc-4.8
apt-get install g++-4.8
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 20
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 20
update-alternatives --config gcc
update-alternatives --config g++

gcc --version
g++ --version

echo "/usr/local/lib" >> /etc/ld.so.conf
ldconfig -v

nghttp -nvu http://baidu.com
h2load https://baidu.com -n 100 -c 10
h2load https://baidu.com -c 1000 -n 1000000 -m1

