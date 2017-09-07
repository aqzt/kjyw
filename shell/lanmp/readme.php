------------------------- 自动安装过程 -------------------------


此安装包包含的软件及版本为：
nginx：1.0.15、1.2.5、1.4.4（删除老版本1.0.4）
apache：2.2.22、2.4.2
mysql：5.1.73、5.5.35、5.6.15
php：5.3.18、5.4.23、5.5.7（删除老版本5.2.17）
php扩展：memcache、Zend Engine/OPcache
ftp：（yum/apt-get安装）
phpwind：8.7 GBK
phpmyadmin：3.2.2.2

安装步骤：

xshell/xftp上传sh目录

chmod –R 777 sh
cd sh
./install.sh

安装完成后请查看account.log文件，数据库密码在里面。


以下为此脚本在阿里云linux系统测试记录（抽样测试）:
centos 5.8/64位/4核4G/50数据盘       --->测试ok
centos 5.8/64位/1核512M/30G数据盘    --->测试ok

centos 6.3/64位/1核512M/无数据盘     --->测试ok
centos 6.3/64位/4核4G/50G数据盘      --->测试ok

redhat 5.7/64位/4核4G/50数据盘       --->测试ok
redhat 5.7/64位/1核512M/无数据盘     --->测试ok


ubuntu 12.04/64位/4核4G/50G数据盘    --->测试ok
ubuntu 12.04/64位/1核512M/无数据盘   --->测试ok


debian 6.0.6/64位/1核512M/无数据盘   --->测试ok
debian 6.0.6/64位/1核512M/30G数据盘  --->测试ok

