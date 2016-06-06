#!/bin/bash
##   2016-06-06
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6

#http://mirrors.sohu.com/fedora-epel/
rpm -Uvh http://mirrors.sohu.com/fedora-epel/epel-release-latest-6.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

rpm -Uvh http://mirrors.sohu.com/fedora-epel/epel-release-latest-7.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7


#http://download.fedoraproject.org/pub/epel/
rpm -Uvh http://ftp.riken.jp/Linux/fedora/epel//epel-release-latest-6.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

rpm -Uvh http://ftp.riken.jp/Linux/fedora/epel//epel-release-latest-7.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7


#http://mirrors.aliyun.com/epel/
rpm -Uvh http://mirrors.aliyun.com/epel/epel-release-latest-6.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

rpm -Uvh http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

