#!/bin/bash
## gitlab_rpm 2016-05-16
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

## 删除原有软件包
rpm -qa | grep mysql  | xargs sudo rpm -e --nodeps
  
## 安装rpm包
rpm -ivh Percona-XtraDB-Cluster*.rpm

## 升级安装
rpm -Uvh  *.rpm
rpm -Uvh --force --nodeps *.rpm
