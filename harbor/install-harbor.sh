#!/bin/sh
## docker快速安装harbor
## 有问题可以反馈 https://aq2.cn/ 
## 先安装 docker 17.06.0-ce和 docker-compose 1.18.0以上版本
mkdir -p /opt/soft
cd /opt/soft
wget https://github.com/goharbor/harbor/releases/download/v1.10.2/harbor-offline-installer-v1.10.2.tgz

tar xvf harbor-offline-installer-v1.10.2.tgz

cd harbor
## vi harbor.yml 修改配置 和 HTTPS

bash install.sh
## 执行安装脚本
echo ok