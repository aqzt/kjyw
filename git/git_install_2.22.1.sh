#!/bin/bash
##############
##Author: yul1
##Date: 2019-09-13 11:11:27
##LastEditors: yul1
##LastEditTime: 2019-09-13 11:13:45
##Description: 
##############
wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.12.2.tar.gz
##cd git-2.22.1/
cd git-2.22.1/ || exit
make prefix=/usr/local all
yum install curl-devel expat-devel gettext-devel  openssl-devel zlib-devel
make prefix=/usr/local all
make prefix=/usr/local install
git version