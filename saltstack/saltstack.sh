#!/bin/bash
## SaltStack安装  2017-07-03
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 7

##安装基础：
##参考文档：https://docs.saltstack.com/en/latest/topics/installation/rhel.html
##1.导入SaltStack仓库key：
wget https://repo.saltstack.com/yum/rhel7/SALTSTACK-GPG-KEY.pub
rpm --import SALTSTACK-GPG-KEY.pub
#rm -f SALTSTACK-GPG-KEY.pub
##2.创建新的YUM源文件并“/etc/yum.repos.d/saltstack.repo”编辑如下内容
####################
# Enable SaltStack's package repository
[saltstack-repo]
name=SaltStack repo for RHEL/CentOS 7
baseurl=https://repo.saltstack.com/yum/rhel7
enabled=1
gpgcheck=1
gpgkey=https://repo.saltstack.com/yum/rhel7/SALTSTACK-GPG-KEY.pub
##3.安装SaltStack软件
#yum clean expire-cache
#yum update
##安装salt-minion, salt-master
yum install salt-master
yum install salt-minion
##4.修改配置文件
minion:
vi /etc/salt/minion
  master: 192.168.56.101
 
cat  /etc/salt/minion | grep "^  master"
  master: 192.168.56.101
  
##在master:
vi /etc/salt/master
  interface: 192.168.56.101
cat  /etc/salt/master | grep "^  interface"
  interface: 192.168.56.101
##注意：master和interface前面有两个空格，如果没有启动的时候回出现错误；
##5.启动服务：
Master
chkconfig salt-master on
systemctl restart salt-master.service
Minion
chkconfig salt-minion on
systemctl restart salt-minion.service
##6，测试saltstack
##查看minion列表：
salt-key -L
Accepted Keys:
Denied Keys:
Unaccepted Keys:
Docker
Rejected Keys:
##接收所有key：
salt-key -A
##在这个过程中会提示Y确认，确认即可；
##显示结果：
Accepted Keys:
Docker
Denied Keys:
Unaccepted Keys:
Rejected Keys:
##简单ping测试：
salt 'Docker' test.ping
Docker:
    True
常见问题：
minion无法连接master
解决问题方法：
##查看debug信息：
salt-minion -l debug

