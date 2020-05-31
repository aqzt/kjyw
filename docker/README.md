# 快速Docker安装

## 自动yum安装Docker，Docker配置yum源
- yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
- curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
- curl -o /etc/yum.repos.d/docker-ce.repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
- daemon.json k8s私有可以增加  "insecure-registries":["harbor.io", "k8s.gcr.io", "gcr.io", "quay.io"],
- 卸载docker命令 yum remove -y  docker-ce docker-common-*

## 使用方法
```
bash install-docker-18.09.8.sh
```

```
curl -s https://gitee.com/aqztcom/kjyw/raw/master/docker/install-docker-18.09.8.sh | bash
```

## 自动安装docker-compose
```
bash install-docker-compose.sh
```

```
curl -s https://gitee.com/aqztcom/kjyw/raw/master/docker/install-docker-compose.sh | bash
```