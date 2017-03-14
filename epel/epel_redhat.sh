#!/bin/bash
## redhat7.2配置yum源  2017-03-13
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## redhat 7

yum update
yum install -y wget
rpm -aq|grep yum|xargs rpm -e --nodeps
rpm -aq|grep python-iniparse|xargs rpm -e --nodeps
wget http://mirrors.163.com/centos/7.3.1611/os/x86_64/Packages/yum-3.4.3-150.el7.centos.noarch.rpm
wget http://mirrors.163.com/centos/7.3.1611/os/x86_64/Packages/python-iniparse-0.4-9.el7.noarch.rpm
wget http://mirrors.163.com/centos/7.3.1611/os/x86_64/Packages/yum-metadata-parser-1.1.4-10.el7.x86_64.rpm
wget http://mirrors.163.com/centos/7.3.1611/os/x86_64/Packages/yum-plugin-fastestmirror-1.1.31-40.el7.noarch.rpm
wget http://mirrors.163.com/.help/CentOS7-Base-163.repo
rpm -ivh *.rpm
mkdir -p /tmp/repo
mv /etc/yum.repos.d/*.repo /tmp/repo/

###7.3.1611这个版本需查看163源上的URL地址确定
sed -i 's/$releasever/7.3.1611/g' CentOS7-Base-163.repo
cat CentOS7-Base-163.repo > /etc/yum.repos.d/rhel-debuginfo.repo
yum clean all
yum install -y epel-release