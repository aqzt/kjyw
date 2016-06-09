#!/bin/bash
#addgroup hadoop
#adduser --ingroup hadoop hadoop
#ssh-keygen -t rsa
#ssh-copy-id -i $HOME/.ssh/id_rsa.pub hadoop@master
cat >> /etc/hosts <<EOF
192.168.1.31     hdfs1
192.168.1.32     hdfs2
192.168.1.33     hdfs3
192.168.1.34     hdfs4
192.168.1.35     hdfs5
192.168.1.36     hdfs6
EOF
path="/usr/local/java"
pwd=`pwd`
	if [ ! -d "$path" ];
	then
		cd $pwd
		mkdir -p /usr/local/java
		mv jdk-6u45-linux-x64.bin /usr/local/java/
		cd /usr/local/java/
		chmod 777 jdk-6u45-linux-x64.bin
		echo -e "\n" | ./jdk-6u45-linux-x64.bin
echo $pwd
	else
		echo java is already installed!
	fi
hadoop="/home/hadoop/hadoop"
if [ ! -d "$hadoop" ];
        then
#/usr/sbin/groupadd hadoop
#/usr/sbin/useradd hadoop -g hadoop
cd $pwd
tar zxvf hadoop-1.1.2.tar.gz
mkdir /home/hadoop
mv hadoop-1.1.2 /home/hadoop/hadoop
        else
                echo hadoop is already installed!
        fi
cat >> /etc/profile <<EOF
HADOOP_HOME=/home/hadoop/hadoop
JAVA_HOME=/usr/local/java/jdk1.6.0_45
JRE_HOME=/usr/local/java/jdk1.6.0_45/jre
EOF
echo "PATH=$JAVA_HOME/bin:$PATH:$HADOOP_HOME/bin" >> /etc/profile
echo "CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH" >> /etc/profile
echo "export JAVA_HOME CLASSPATH PATH HADOOP_HOME" >> /etc/profile
#PATH=$JAVA_HOME/bin:$PATH:$HADOOP_HOME/bin
#CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH
#export JAVA_HOME CLASSPATH PATH HADOOP_HOME
#cat >> /home/hadoop/.bashrc <<EOF
#export  PATH=/home/hadoop/hadoop/bin:$PATH
#EOF
source /etc/profile
cat >> /home/hadoop/.bashrc <<EOF
HADOOP_HOME=/home/hadoop/hadoop
JAVA_HOME=/usr/local/java/jdk1.6.0_45
JRE_HOME=/usr/local/java/jdk1.6.0_45/jre
EOF
echo "PATH=$JAVA_HOME/bin:$PATH:$HADOOP_HOME/bin" >> /home/hadoop/.bashrc
echo "CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH" >> /home/hadoop/.bashrc
echo "export JAVA_HOME CLASSPATH PATH HADOOP_HOME" >> /home/hadoop/.bashrc

cat >> /etc/sysctl.conf <<EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
chmod 777 /tmp
chown -R hadoop:hadoop /home/hadoop/hadoop
source /etc/profile
sysctl -p
cat > /home/hadoop/hadoop/conf/masters <<EOF
hdfs1
EOF
cat > /home/hadoop/hadoop/conf/slaves <<EOF
hdfs1
EOF
cat > /home/hadoop/hadoop/conf/core-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
<property>
<name>fs.default.name</name>
<value>hdfs://hdfs1:9000</value>
</property>
</configuration>
EOF
cat > /home/hadoop/hadoop/conf/hdfs-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
<property>
<name>dfs.name.dir</name>
<value>/home/hadoop/dfs/filesystem/name</value>
</property>
<property>
<name>dfs.data.dir</name>
<value>/home/hadoop/dfs/filesystem/data</value>
</property>
<property>
<name>dfs.replication</name>
<value>3</value>
</property>
<property>
<name>dfs.balance.bandwidthPerSec</name>
<value>1048576</value>
<description>
Specifies the maximum amount of bandwidth that each datanode can utilize for the balancing purpose in term of the number of bytes per second.
</description>
</property>
</configuration>
EOF
cat > /home/hadoop/hadoop/conf/mapred-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
<property>
<name>mapred.job.tracker</name>
<value>hdfs1:9001</value>
</property>
<property>
<name>mapred.tasktracker.map.tasks.maximum</name>
<value>4</value>
</property>
<property>
<name>mapred.tasktracker.reduce.tasks.maximum</name>
<value>4</value>
</property>
<property>
<name>mapred.system.dir</name>
<value>/home/hadoop/mapreduce/system</value>
</property>
<property>
<name>mapred.local.dir</name>
<value>/home/hadoop/mapreduce/local</value>
</property>
</configuration>
EOF
#cat > /home/hadoop/hadoop/conf/slaves <<EOF
#hdfs1
#EOF
#cat > /home/hadoop/hadoop/conf/slaves <<EOF
#hdfs1
#EOF
