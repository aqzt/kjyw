#!/bin/bash
## Docker配置yum源，yum安装Docker  2017-03-13
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## redhat 7

tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

yum install -y docker-engine
service docker start
chkconfig docker on
