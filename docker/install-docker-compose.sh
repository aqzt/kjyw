#!/bin/bash
## 自动安装docker-compose  2020-05-31
## 有问题反馈 https://aq2.cn/c/docker
## email: ppabc@qq.com
## robert yu
## redhat 7

## 版本发布地址：https://github.com/docker/compose/releases
## https://github.com/docker/compose/releases/download/1.25.5/docker-compose-Linux-x86_64
## https://github.com/docker/compose/releases/download/1.25.4/docker-compose-Linux-x86_64
##安装 
##curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose

##2. 添加执行权限
chmod +x /usr/local/bin/docker-compose

##3. 命令补全工具（此步骤可选）
##curl -L https://raw.githubusercontent.com/docker/compose/1.21.2/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
##具体参考：https://docs.docker.com/compose/completion/

##4. 测试安装结果
docker-compose --version