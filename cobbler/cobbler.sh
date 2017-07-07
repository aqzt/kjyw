#!/bin/bash
#
###
# Filename: install_cobbler.el6.sh
# Author: roguo.wei - roguo.wei@gmail.com
# Description: 
# Last Modified: 2017-04-07 10:20
# Version: 1.0
###

server_ip=10.10.2.100

# install epel
echo "install epel..."
#yum list |grep -E '^epel'
rpm -qa |grep -i epel &> /dev/null
if [ $? -eq 0 ];then
 echo "epel alread installed"
else
 rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
 if [ $? -eq 0 ];then
 echo "epel install successfully"
 else
 echo "epel install faild"
 exit 1
 fi
fi

# disable selinux
echo "disable selinux..."
sed -i '/^SELINUX=/ s/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
#getenforce
sestatus

# disable iptables
echo "disable iptables..."
service iptables stop
chkconfig iptables off

# install cobbler
for i in cobbler cobbler-web tftp tftp-server xinetd dhcp httpd mod_wsgi mod_ssl rsync 
do
 rpm -qc ${i} &> /dev/null
 if [ $? -ne 0 ];then
 echo -n "install ${i}..."
 yum install -y ${i} &> /dev/null
 if [ $? -eq 0 ];then
 echo "ok"
 else
 echo "faild"
 fi
 else
 echo "${i} alread installed"
 fi
done

# install packages what cobbler needs
for i in pykickstart debmirror python-ctypes python-cheetah python-netaddr python-simplejson python-urlgrabber PyYAML syslinux cman fence-agents createrepo mkisofs yum-utils
do
 rpm -qc ${i} &> /dev/null
 if [ $? -ne 0 ];then
 echo -n "install ${i}..."
 yum install -y ${i} &> /dev/null
 if [ $? -eq 0 ];then
 echo "ok"
 else
 echo "faild"
 fi
 else
 echo "${i} alread installed"
 fi
done

echo -n "configing cobbler..."
# config httpd
sed -i "s/#ServerName www.example.com:80/ServerName ${server_ip}:80/" /etc/httpd/conf/httpd.conf
sed -i 's/#LoadModule/LoadModule/g' /etc/httpd/conf.d/wsgi.conf

# config tftp
sed -i '/disable/c disable = no' /etc/xinetd.d/tftp
#sed -i '/disable/c disable = no' /etc/cobbler/tftpd.template

# config rsysnc
sed -i -e 's/= yes/= no/g' /etc/xinetd.d/rsync

# config debmirror
sed -i -e 's/@dists=.*/#@dists=/' /etc/debmirror.conf 
sed -i -e 's/@arches=.*/#@arches=/' /etc/debmirror.conf

# config cobbler
pwd=$(openssl passwd -1 -salt 'random-phrase-here' '111111')
sed -i "s@default_password_crypted: .*@default_password_crypted: ${pwd}@" /etc/cobbler/settings
sed -i "s/server: 127.0.0.1/server: ${server_ip}/g" /etc/cobbler/settings
sed -i "s/next_server: 127.0.0.1/next_server: ${server_ip}/g" /etc/cobbler/settings
# pxe安装 只允许一次，防止误操作( 在正式环境有用。实际测试来，这个功能可以屏蔽掉 )
sed -i 's/pxe_just_once: 0/pxe_just_once: 1/g' /etc/cobbler/settings
sed -i 's/manage_rsync: 0/manage_rsync: 1/g' /etc/cobbler/settings
sed -i 's/manage_dhcp: 0/manage_dhcp: 1/g' /etc/cobbler/settings

# config dhcp
cp /etc/cobbler/dhcp.template{,.ori}
sed -i 's/DHCPDARGS=.*/DHCPDARGS=eth0/' /etc/sysconfig/dhcpd
cat dhcp.template > /etc/cobbler/dhcp.template

echo "ok"

chkconfig httpd on
chkconfig xinetd on
chkconfig cobblerd on
chkconfig dhcpd on
/etc/init.d/httpd restart
/etc/init.d/xinetd restart
/etc/init.d/cobblerd restart
echo -e "\ncobbler get-loaders..."
cobbler get-loaders
echo -e "\ncobbler sync..."
cobbler sync
echo -e "\ncobbler check..."
cobbler check
/etc/init.d/dhcpd restart