#!/bin/bash
## 自动yum安装Docker，Docker配置yum源  2020-05-31
## 有问题反馈 https://aq2.cn/c/docker
## email: ppabc@qq.com
## robert yu
## redhat 7

##安装
## yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
## curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
## curl -o /etc/yum.repos.d/docker-ce.repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
## daemon.json k8s私有可以增加  "insecure-registries":["harbor.io", "k8s.gcr.io", "gcr.io", "quay.io"],
## 卸载docker命令 yum remove -y  docker-ce docker-common-*


yum-config-manager --add-repo https://mirrors.aliyun.com/repo/Centos-7.repo
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum makecache fast
yum install -y yum-utils device-mapper-persistent-data lvm2 nfs-utils  conntrack-tools
yum install -y docker-ce-18.09.8   docker-ce-cli-18.09.8


##配置docker源
mkdir -p /etc/docker
if [[ -f /etc/docker/daemon.json  ]] ; then
	/usr/bin/cp /etc/docker/daemon.json /etc/docker/daemon.json.bak.`date "+%Y%m%d%H%M%S"`
fi
echo -e '
{
 "storage-driver": "overlay2",
 "storage-opts": [ "overlay2.override_kernel_check=true" ],
 "registry-mirrors": ["https://4ux5p520.mirror.aliyuncs.com"],
 "exec-opts": ["native.cgroupdriver=systemd"],
 "data-root": "/data/docker", 
 "log-driver": "json-file",
 "log-opts": {
 "max-size": "100m"
 }
}
' > /etc/docker/daemon.json


##启动
systemctl daemon-reload 
systemctl enable docker
systemctl restart docker
docker version