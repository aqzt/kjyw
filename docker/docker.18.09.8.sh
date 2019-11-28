#!/bin/bash

yum install -y yum-utils device-mapper-persistent-data lvm2 nfs-utils  conntrack-tools
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum makecache fast
yum install -y docker-ce-18.09.8   docker-ce-cli-18.09.8
systemctl daemon-reload 
systemctl enable docker
systemctl restart docker
systemctl status docker
docker info |grep Version
