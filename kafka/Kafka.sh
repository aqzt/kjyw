#!/bin/bash
## kafka  2016-06-07
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6
##kafka  单独ZooKeeper 搭建

yum install -y  curl openssh-server openssh-clients postfix cronie git nmap unzip wget lsof xz gcc make vim  curl gcc-c++ libtool

##注意修改主机名
cat >>/etc/hosts<<EOF
192.168.142.136   master.storm.com
EOF


cat >>/etc/profile<<EOF
export JAVA_HOME=/opt/tomcat/jdk1.8.0_77/
export CLASSPATH=/opt/tomcat/jdk1.8.0_77/lib/*.jar:/opt/tomcat/jdk1.8.0_77/jre/lib/*.jar
export ZOOKEEPER=/opt/zk
export PATH=\$PATH:/opt/tomcat/jdk1.8.0_77/bin:/opt/zk/bin
EOF

tar zxvf kafka_2.10-0.9.0.1.tgz

cat >/opt/kafka_2.10-0.9.0.1/config/server.properties<<EOF
broker.id=0
port=9092
listeners=PLAINTEXT://:9092
host.name=master.storm.com
num.network.threads=3
num.io.threads=8
advertised.host.name=master.storm.com
advertised.port=9092
auto.leader.rebalance.enable=true
delete.topic.enable=true
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=/data/kafka-logs
num.partitions=1
num.recovery.threads.per.data.dir=1
log.retention.hours=24
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
zookeeper.connect=master.storm.com:2181/kafka
zookeeper.connection.timeout.ms=6000
EOF

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

mkdir -p /data/zookeeper/

cat >/opt/confluent-2.0.1/etc/schema-registry/schema-registry.properties<<EOF
port=8081
kafkastore.connection.url=127.0.0.1:2181/kafka
kafkastore.topic=_schemas
debug=false
EOF

cat >/opt/confluent-2.0.1/etc/kafka-rest/kafka-rest.properties<<EOF
port=8082
id=kafka-rest-test-server
schema.registry.url=http://localhost:8081
zookeeper.connect=127.0.0.1:2181/kafka
EOF


##以下手动执行
##手动执行
source  /etc/profile

#需要手动在ZooKeeper中创建路径/kafka，使用如下命令连接到任意一台ZooKeeper服务器：
cd /opt/zk
bin/zkCli.sh

#在ZooKeeper执行如下命令创建chroot路径：
create /kafka ''
#执行如下命令：
cd /opt/kafka_2.10-0.9.0.1
/opt/kafka_2.10-0.9.0.1/bin/kafka-server-start.sh /opt/kafka_2.10-0.9.0.1/config/server.properties   >/dev/null 2>&1 &

##停止命令
##ps ax | grep -i 'kafka.Kafka' | grep -v grep | awk '{print $1}' | xargs kill

##查看创建的Topic，执行如下命令：
bin/kafka-topics.sh --create --zookeeper 192.168.142.136:2181/kafka  --replication-factor 1 --partitions 1 --topic mykafka

##修改Topic partitions数量
bin/kafka-topics.sh --alter --zookeeper 192.168.142.136:2181/kafka  --partitions 6 --topic  mykafka

##列出所有主题
bin/kafka-topics.sh --list --zookeeper 192.168.142.136:2181/kafka
bin/kafka-topics.sh --describe --zookeeper 192.168.142.136:2181/kafka --topic mykafka

##在一个终端，启动Producer，执行如下命令：
bin/kafka-console-producer.sh --broker-list 192.168.142.136:9092  --topic mykafka

##在另一个终端，启动Consumer，执行如下命令：
bin/kafka-console-consumer.sh --zookeeper 192.168.142.136:2181/kafka --topic mykafka --from-beginning

##删除topic
cd /opt/kafka_2.10-0.9.0.1
bin/kafka-topics.sh --delete --zookeeper 192.168.142.136:2181/kafka --topic mykafka
##执行后，该topic会被kafka标记为删除，如果要立刻删除配置中需配置delete.topic.enable=true，有配置无需执行下面zookeeper删除操作
##在zookeeper中手动删除相关的节点：
##[zk: localhost:2181(CONNECTED) 5] rmr /brokers/topics/mykafka


#######confluent启动
cd /opt/confluent-2.0.1/
bin/schema-registry-start etc/schema-registry/schema-registry.properties  >/dev/null 2>&1 &
##停止命令
##ps ax | grep -i 'schema-registry' | grep -v grep | awk '{print $1}' | xargs kill

cd /opt/confluent-2.0.1/
bin/kafka-rest-start etc/kafka-rest/kafka-rest.properties  >/dev/null 2>&1 &
##停止命令
##ps ax | grep -i 'kafka-rest' | grep -v grep | awk '{print $1}' | xargs kill



