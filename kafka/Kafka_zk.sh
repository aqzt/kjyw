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
listeners=PLAINTEXT://:9092
num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=/tmp/kafka-logs
num.partitions=1
num.recovery.threads.per.data.dir=1
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
zookeeper.connect=master.storm.com:2181
zookeeper.connection.timeout.ms=6000
EOF

cat >/opt/kafka_2.10-0.9.0.1/config/zookeeper.properties<<EOF
dataDir=/data/zookeeper/
clientPort=2181
maxClientCnxns=50
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
zookeeper.connect=127.0.0.1:2181
EOF


##以下手动执行
##手动执行
source  /etc/profile

#执行如下命令：
cd /opt/kafka_2.10-0.9.0.1
/opt/kafka_2.10-0.9.0.1/bin/zookeeper-server-start.sh /opt/kafka_2.10-0.9.0.1/config/zookeeper.properties   >/dev/null 2>&1 &

/opt/kafka_2.10-0.9.0.1/bin/kafka-server-start.sh /opt/kafka_2.10-0.9.0.1/config/server.properties   >/dev/null 2>&1 &

##bin/zookeeper-server-start.sh config/zookeeper.properties    >/dev/null 2>&1 &
##bin/kafka-server-start.sh config/server.properties     >/dev/null 2>&1 &

##停止命令
##ps ax | grep -i 'kafka.Kafka' | grep -v grep | awk '{print $1}' | xargs kill

##查看创建的Topic，执行如下命令：
bin/kafka-topics.sh --create --zookeeper 192.168.142.136:2181 --replication-factor 1 --partitions 1 --topic mykafka
##bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test

##列出所有主题
bin/kafka-topics.sh --list --zookeeper 192.168.142.136:2181

##在一个终端，启动Producer，执行如下命令：
bin/kafka-console-producer.sh --broker-list 192.168.142.136:9092  --topic mykafka
##bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test 

##在另一个终端，启动Consumer，执行如下命令：
bin/kafka-console-consumer.sh --zookeeper 192.168.142.136:2181 --topic mykafka --from-beginning
##bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --from-beginning

#######confluent启动
cd /opt/confluent-2.0.1/
bin/schema-registry-start etc/schema-registry/schema-registry.properties  >/dev/null 2>&1 &
##停止命令
##ps ax | grep -i 'schema-registry' | grep -v grep | awk '{print $1}' | xargs kill

cd /opt/confluent-2.0.1/
bin/kafka-rest-start etc/kafka-rest/kafka-rest.properties  >/dev/null 2>&1 &
##停止命令
##ps ax | grep -i 'kafka-rest' | grep -v grep | awk '{print $1}' | xargs kill

