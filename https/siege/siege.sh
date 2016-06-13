#!/bin/bash
## HTTPS并发测试工具
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6

wget http://download.joedog.org/siege/siege-latest.tar.gz
tar -xzvf siege-latest.tar.gz
cd siege-4.0.2
./configure --prefix=/opt/siege --with-ssl=/home/test/openssl-1.0.2h
make && make install

#siege -c 20 -r 2 -f url
#-c 20 并发20个用户
#-r 2 重复循环2次
#-f url 任务列表：URL列表
#-i  随机 URL ,默认是从列表的上面到下面来打压力
#-b 进行压力测试,不进行延时
#-t  持续时间,即测试持续时间,在NUM时间后结束,单位默认为分
#siege -c 200 -r 150 -f /root/4k.list  -i -b
#200个用户，重复150次，利用4k.list 文件中的url，-i是随机，-b 不延时

运行测试，模拟1000用户打压5分钟：
/opt/siege/bin/siege -c 1000 -t 5m https://www.baidu.com

