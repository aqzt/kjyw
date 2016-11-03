#!/bin/bash
##   2016-06-06
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6

yum -y install gcc+ gcc-c++

##访问https://github.com/creationix/nvm查看
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash
##Haraka指定版本
nvm install v0.10.33
##指定版本v4.4.4
nvm install v4.4.4
npm install -g pm2
pm2 list


##修改环境变量方法
##vi /etc/profile
##export PATH=/root/.nvm/versions/node/v4.4.5/bin:/usr/local/jdk/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin:/root/bin
##export PATH=$PATH:/root/.nvm/versions/node/v4.4.4/bin


##修改npm源地址
npm config set registry http://registry.npm.taobao.org
##或者
echo "registry=http://registry.npm.taobao.org"  > /root/.npmrc

##查看npm源地址
npm config get registry


