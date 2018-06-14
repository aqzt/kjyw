#!/bin/bash
# Author:  ppabc <ppabc AT qq.com>
# Blog:  http://ppabc.cn
#

##添加Elasticsearch 源
cat > /etc/yum.repos.d/elk6.repo<<EOF
[elastic-6.x]
name=Elastic repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

##yum安装
yum install tree wget bash-c* epel* -y 	
	yum clean ; yum makecache
	yum update -y ; init 6
	yum install java-1.8.0-openjdk kibana logstash elasticsearch -y

