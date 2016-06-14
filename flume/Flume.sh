#!/bin/bash
## kafka flume 2016-06-14
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6
##kafka  apache-flume 搭建
##Flume从1.6.0开始，官方已经直接支持Kafka的sink了。这样就非常方便的可以将从Flume采集的数据，发送给Kafka。

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

tar zxvf apache-flume-1.6.0-bin.tar.gz

cat >/opt/apache-flume-1.6.0-bin/conf/flume-env.sh<<EOF
export JAVA_HOME=/opt/tomcat/jdk1.8.0_77/
export JAVA_OPTS="-Xms100m -Xmx200m -Dcom.sun.management.jmxremote"
EOF

cat >/opt/apache-flume-1.6.0-bin/conf/tail_kafka.conf<<EOF
a1.sources = r1
a1.sinks = k1
a1.channels = c1


a1.sources.r1.type = exec
a1.sources.r1.channels = c1
a1.sources.r1.command = tail -f /data/nginx/log/test_kafka.flume.com.log


a1.sinks.k1.type = org.apache.flume.sink.kafka.KafkaSink
a1.sinks.k1.topic = mykafka
a1.sinks.k1.brokerList = master.storm.com:9092
a1.sinks.k1.requiredAcks = 1
a1.sinks.k1.batchSize = 20
a1.sinks.k1.channel = c1


a1.channels.c1.type = memory
a1.channels.c1.capacity = 1000
a1.channels.c1.transactionCapacity = 100


a1.sources.r1.channels = c1
a1.sinks.k1.channel = c1
EOF

mkdir -p /data/nginx/log


##以下手动执行
##手动执行
source  /etc/profile

cd /opt/apache-flume-1.6.0-bin
bin/flume-ng agent -c conf/ -f conf/tail_kafka.conf -n a1 -Dflume.root.logger=INFO,console  >/dev/null 2>&1 &


##在一个终端，启动Consumer，执行如下命令：
bin/kafka-console-consumer.sh --zookeeper 192.168.142.136:2181 --topic mykafka --from-beginning

##访问NGINX的域名
curl  test_kafka.flume.com
##生成NGINX的日志会在Consumer显示出来

##停止命令
##ps ax | grep -i 'kafka-rest' | grep -v grep | awk '{print $1}' | xargs kill

