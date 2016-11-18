#!/bin/bash
## storm 2016-06-23
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6
##storm  单节点安装部署

yum install -y  curl openssh-server openssh-clients postfix cronie git nmap unzip wget lsof xz gcc make vim  curl gcc-c++ libtool

##注意修改主机名
cat >>/etc/hosts<<EOF
192.168.142.137   master.storm.com
EOF

hostname   master.storm.com
sed -i  '/HOSTNAME/d' /etc/sysconfig/network
echo  "HOSTNAME=master.storm.com" >>/etc/sysconfig/network

cat >>/etc/profile<<EOF
export JAVA_HOME=/opt/tomcat/jdk1.8.0_77/
export CLASSPATH=/opt/tomcat/jdk1.8.0_77/lib/*.jar:/opt/tomcat/jdk1.8.0_77/jre/lib/*.jar
export PATH=\$PATH:/opt/tomcat/jdk1.8.0_77/bin
EOF

cd /opt/
tar zxvf tomcat.tar

source  /etc/profile

##编译安装ZMQ：
#wget http://download.zeromq.org/zeromq-3.2.5.tar.gz
tar zxvf  zeromq-3.2.5.tar.gz
cd zeromq-3.2.5
./configure
make
make install
cd ..

编译安装JZMQ：
##git clone https://github.com/nathanmarz/jzmq.git
tar zxvf  jzmq.tar
cd jzmq
./autogen.sh
./configure
make
make install
cd ..


mkdir -p /data/zookeeper/

tar zxvf zk.tar
cat >/opt/zk/conf/zoo.cfg<<EOF
maxClientCnxns=500
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/data/zookeeper/
dataLogDir=/data/zookeeper/logs
clientPort=2181
server.1=master.storm.com:2888:3888
EOF

cd /opt/zk/bin/
/opt/zk/bin/zkServer.sh start

cd /opt
tar zxvf apache-storm-0.10.1.tar.gz
mkdir  -p /data/storm

cat >/opt/apache-storm-0.10.1/conf/storm.yaml<<EOF
storm.zookeeper.servers:
     - "master.storm.com"
storm.zookeeper.port: 2181

nimbus.host: "master.storm.com"

supervisor.slots.ports:
    - 6700
    - 6701
    - 6702
    - 6703

storm.local.dir: "/data/storm"
EOF


##启动Storm各个后台进程的方式：

##Nimbus: 在Storm主控节点上运行
cd /opt/apache-storm-0.10.1
bin/storm nimbus >/dev/null 2>&1 &

sleep 10
##Supervisor: 在Storm各个工作节点上运行
cd /opt/apache-storm-0.10.1
bin/storm supervisor >/dev/null 2>&1 &

sleep 10
##UI: 在Storm主控节点上运行
cd /opt/apache-storm-0.10.1
bin/storm ui >/dev/null 2>&1 &
##启动后可以通过http://{nimbus host}:8080观察集群的worker资源使用情况、Topologies的运行状态等信息。


##如果是集群，多节点，其他节点Supervisor: 在Storm各个工作节点上运行
##cd /opt/apache-storm-0.10.1
##bin/storm supervisor >/dev/null 2>&1 &

##停止Storm Topology：
##storm kill {toponame}
##其中，{toponame}为Topology提交到Storm集群时指定的Topology任务名称。


