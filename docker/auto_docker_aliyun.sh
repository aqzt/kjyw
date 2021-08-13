#!/bin/bash
## 自动yum安装Docker，Docker配置yum源  2018-06-19
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## redhat 7

##配置yum源
TIME=$(date +%Y%m%d%H%M%S)
mkdir /opt/bak-$TIME
mv /etc/yum.repos.d/*.repo /opt/bak-$TIME/
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
rpm -Uvh http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
yum-config-manager --add-repo http://mirrors.selinux.cn/help/docker-aliyun.repo
yum makecache fast
yum makecache

##安装
yum install -y yum-utils device-mapper-persistent-data lvm2
yum -y install docker-ce
chkconfig docker on

##配置docker源
tee /etc/systemd/system/docker.service <<-'EOF'
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network.target firewalld.service

[Service]
Type=notify
ExecStart=/usr/bin/dockerd --registry-mirror=https://4ux5p520.mirror.aliyuncs.com
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TimeoutStartSec=0
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

##启动
service docker start
systemctl daemon-reload
service docker restart
docker version
