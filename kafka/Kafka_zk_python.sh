#!/bin/bash
## python安装ZooKeeper模块 2017-03-14
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6
## python安装ZooKeeper模块，连接ZooKeeper，显示kafka节点 

yum install -y  wget gcc gcc-c++ libffi-devel python-devel openssl-devel
##yum -y install  libxml2 libxml2-dev libxslt* zlib gcc openssl

wget http://mirrors.hust.edu.cn/apache/zookeeper/stable/zookeeper-3.4.9.tar.gz
wget https://pypi.python.org/packages/14/38/a761465ab0a154405c11f7e5d6e81edf6e84584e114e152fddd340f7d6d3/zkpython-0.4.2.tar.gz

tar zxvf zookeeper-3.4.9.tar.gz
cd zookeeper-3.4.9/src/c
./configure && make && make install

cd ../../../
export LD_LIBRARY_PATH=/usr/lib:/usr/local/lib:/lib
tar xzvf zkpython-0.4.2.tar.gz
cd zkpython-0.4.2
python setup.py install

#注：这种安装方式可能遇到以下错误：
#找不到zookeeper.h头文件  可以调整setup.py 中include_dirs 路径的指向】
#import zookeeper时 报 库文件缺失 可以 
#export LD_LIBRARY_PATH=/usr/lib:/usr/local/lib:/lib:(指定缺失库文件位置) 】

#另一种安装zkpython方式
#pip install zkpython
#如果安装过程中报没有权限，则使用sudo pip install zkpython即可解决。

#测试python的zookeeper模块
#python
#import  zookeeper
#如果报错，请在.bashrc文件中加入
#export LD_LIBRARY_PATH=/usr/local/lib/

#测试python的zookeeper模块
#python
#import zookeeper as zoo   
# 初始化连接到集群  
# zk = zoo.init("127.0.0.1:2181")  
# 获取所有节点  
# zoo.get_children(zk, "/", None)  

##Python安装PIL出现command 'gcc' failed with exit status 1错误
##这个错误一般有两个原因导致：
## 1.  gcc python-devel 没装，或只上了一个，解决：yum install -y  wget gcc gcc-c++ libffi-devel python-devel
## 2.  zookeeper-3.4.9/src/c里面没有编译，进到这个目录执行：./configure && make && make install






