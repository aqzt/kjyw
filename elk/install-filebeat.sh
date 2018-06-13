#!/bin/bash
# Author:  ppabc <ppabc AT qq.com>
# Blog:  http://ppabc.cn
#

##添加Elasticsearch 源
cat > /etc/yum.repos.d/elk.repo<<EOF
[elasticsearch-5.x]
name=Elasticsearch repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md

EOF

##yum安装filebeat
yum install -y filebeat

##修改filebeat配置文件
cat > /etc/filebeat/filebeat.yml<<EOF
filebeat.prospectors:

- input_type: log
  paths:
    - /data/nginx/logs/error.log
  document_type: nginx-error

- input_type: log
  paths:
    - /data/nginx/logs/access.log
  document_type: nginx-access

output.logstash:

  hosts: ["127.0.0.1:5044"]

EOF

##重启filebeat生效
service  filebeat  restart