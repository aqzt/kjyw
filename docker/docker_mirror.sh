#!/bin/bash
## Docker配置 换镜像源  2017-03-15
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## redhat 7

##cp -n /lib/systemd/system/docker.service /etc/systemd/system/docker.service
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

##systemctl enable docker && systemctl start docker
systemctl daemon-reload
service docker restart