#!/bin/bash
## gitlab_rpm 2016-05-16
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

##查询一个包是否被安装 
##rpm -q < rpm package name>
rpm -q wget
##列出所有被安装的rpm package 
rpm -qa
rpm -qa |grep nginx

##删除特定rpm包
##rpm -e <包的名字> 
rpm -e wget
rpm -e wget-1.12-8.el6.x86_64

## 删除原有软件包
rpm -qa | grep mysql  | xargs sudo rpm -e --nodeps
  
## 安装rpm包
rpm -ivh Percona-XtraDB-Cluster*.rpm

## 升级安装
rpm -Uvh  *.rpm
rpm -Uvh --force --nodeps *.rpm

