#!/bin/bash
## 自动yum安装Docker，Docker配置yum源  2018-05-16
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## redhat 7

##安装
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://mirrors.selinux.cn/help/docker-aliyun.repo
yum makecache fast
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