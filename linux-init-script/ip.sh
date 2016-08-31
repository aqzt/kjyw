#!/bin/bash
## 设置IP  2016-08-31
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

#nmcli con show |grep enp0s3 | awk -F '[ ]+' '{print $2}'
#nmcli device show enp0s3
#nmcli device show enp0s3 | awk 'NR==3'
#bash ip.sh enp0s3 10.0.2.18 255.255.255.0 10.0.2.2
#bash ip.sh enp0s8 192.168.56.104 255.255.255.0 192.168.56.1 dg

if [ "$1" == "" ];then
    echo "1 is empty.example:ip.sh eth0 192.168.1.10 255.255.255.0 192.168.1.1"
    exit 1
fi
if [ "$2" == "" ];then
    echo "2 is empty.example:ip.sh eth0 192.168.1.10 255.255.255.0 192.168.1.1"
    exit 1
fi
if [ "$3" == "" ];then
    echo "3 is empty.example:ip.sh eth0 192.168.1.10 255.255.255.0 192.168.1.1"
    exit 1
fi
if [ "$4" == "" ];then
    echo "4 is empty.example:ip.sh eth0 192.168.1.10 255.255.255.0 192.168.1.1"
    exit 1
fi

ID1=$1
ID5=$5
###删除网关或DNS
dg_ddg(){
if [ "$ID5" == "dg" ];then
    sed -i '/GATEWAY=/d' /etc/sysconfig/network-scripts/ifcfg-$ID1
fi
if [ "$ID5" == "ddg" ];then
    sed -i '/GATEWAY=/d' /etc/sysconfig/network-scripts/ifcfg-$ID1
	sed -i '/DNS1=/d' /etc/sysconfig/network-scripts/ifcfg-$ID1
	sed -i '/DNS2=/d' /etc/sysconfig/network-scripts/ifcfg-$ID1
fi
if [ "$ID5" == "dd" ];then
	sed -i '/DNS1=/d' /etc/sysconfig/network-scripts/ifcfg-$ID1
	sed -i '/DNS2=/d' /etc/sysconfig/network-scripts/ifcfg-$ID1
fi
}

###系统判断
if [ -f /etc/redhat-release ];then
        OS=CentOS
check_OS1=`cat /etc/redhat-release | awk -F '[ ]+' '{print $3}' | awk -F '.' '{print $1}'`
check_OS2=`cat /etc/redhat-release | awk -F '[ ]+' '{print $4}' | awk -F '.' '{print $1}'`
if [ "$check_OS1" == "6" ];then
    OS=CentOS6
fi
if [ "$check_OS2" == "7" ];then
    OS=CentOS7
fi
elif [ ! -z "`cat /etc/issue | grep bian`" ];then
        OS=Debian
elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
        OS=Ubuntu
else
        echo -e "\033[31mDoes not support this OS, Please contact the author! \033[0m"
fi

	if [ $OS == 'CentOS6' ];then

###centos6修改
if [ -f "/etc/sysconfig/network-scripts/ifcfg-$1" ]; then

time=`date +%Y-%m-%d_%H_%M_%S`
cp /etc/sysconfig/network-scripts/ifcfg-$1 /tmp/ifcfg-$1.$time


HWADDR=`/sbin/ip a|grep -B1 $1 | awk 'NR==3' |awk -F '[ ]+' '{print $3}'`
sed -i '/BOOTPROTO=/d' /etc/sysconfig/network-scripts/ifcfg-$1
sed -i '/HWADDR=/d' /etc/sysconfig/network-scripts/ifcfg-$1
sed -i '/ONBOOT=/d' /etc/sysconfig/network-scripts/ifcfg-$1
sed -i '/IPADDR=/d' /etc/sysconfig/network-scripts/ifcfg-$1
sed -i '/NETMASK=/d' /etc/sysconfig/network-scripts/ifcfg-$1
sed -i '/GATEWAY=/d' /etc/sysconfig/network-scripts/ifcfg-$1
sed -i '/DNS1=/d' /etc/sysconfig/network-scripts/ifcfg-$1
sed -i '/DNS2=/d' /etc/sysconfig/network-scripts/ifcfg-$1
echo "BOOTPROTO=static" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "HWADDR=$HWADDR" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "ONBOOT=yes" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "IPADDR=$2" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "NETMASK=$3" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "GATEWAY=$4" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "DNS1=114.114.114.114" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "DNS2=223.5.5.5" >>/etc/sysconfig/network-scripts/ifcfg-$1

dg_ddg

cat /etc/sysconfig/network-scripts/ifcfg-$1
echo "$1 ok"

else

HWADDR=`/sbin/ip a|grep -B1 $1 | awk 'NR==3' |awk -F '[ ]+' '{print $3}'`
echo "TYPE=Ethernet" >/etc/sysconfig/network-scripts/ifcfg-$1
echo "DEVICE=$1" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "NM_CONTROLLED=yes" >>/etc/sysconfig/network-scripts/ifcfg-$1

echo "BOOTPROTO=static" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "HWADDR=$HWADDR" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "ONBOOT=yes" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "IPADDR=$2" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "NETMASK=$3" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "GATEWAY=$4" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "DNS1=114.114.114.114" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "DNS2=223.5.5.5" >>/etc/sysconfig/network-scripts/ifcfg-$1

dg_ddg

cat /etc/sysconfig/network-scripts/ifcfg-$1

fi
		echo CentOS6
	fi
	if [ $OS == 'CentOS7' ];then

###centos7修改
if [ -f "/etc/sysconfig/network-scripts/ifcfg-$1" ]; then

time=`date +%Y-%m-%d_%H_%M_%S`
cp /etc/sysconfig/network-scripts/ifcfg-$1 /tmp/ifcfg-$1.$time


UUID=`nmcli con show |grep $1 | awk -F '[ ]+' '{print $2}'`
sed -i '/BOOTPROTO=/d' /etc/sysconfig/network-scripts/ifcfg-$1
sed -i '/IPV6INIT=/d' /etc/sysconfig/network-scripts/ifcfg-$1
sed -i '/ONBOOT=/d' /etc/sysconfig/network-scripts/ifcfg-$1
sed -i '/UUID=/d' /etc/sysconfig/network-scripts/ifcfg-$1
sed -i '/IPADDR=/d' /etc/sysconfig/network-scripts/ifcfg-$1
sed -i '/NETMASK=/d' /etc/sysconfig/network-scripts/ifcfg-$1
sed -i '/GATEWAY=/d' /etc/sysconfig/network-scripts/ifcfg-$1
sed -i '/DNS1=/d' /etc/sysconfig/network-scripts/ifcfg-$1
sed -i '/DNS2=/d' /etc/sysconfig/network-scripts/ifcfg-$1
echo "IPV6INIT=no" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "BOOTPROTO=static" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "ONBOOT=yes" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "UUID=$UUID" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "IPADDR=$2" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "NETMASK=$3" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "GATEWAY=$4" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "DNS1=114.114.114.114" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "DNS2=223.5.5.5" >>/etc/sysconfig/network-scripts/ifcfg-$1

dg_ddg

cat /etc/sysconfig/network-scripts/ifcfg-$1
echo "$1 ok"

else

UUID=`nmcli con show |grep $1 | awk -F '[ ]+' '{print $2}'`
echo "TYPE=Ethernet" >/etc/sysconfig/network-scripts/ifcfg-$1
echo "DEFROUTE=yes" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "PEERDNS=yes" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "PEERROUTES=yes" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "IPV4_FAILURE_FATAL=no" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "NAME=$1" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "DEVICE=$1" >>/etc/sysconfig/network-scripts/ifcfg-$1

echo "IPV6INIT=no" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "BOOTPROTO=static" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "ONBOOT=yes" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "UUID=$UUID" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "IPADDR=$2" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "NETMASK=$3" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "GATEWAY=$4" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "DNS1=114.114.114.114" >>/etc/sysconfig/network-scripts/ifcfg-$1
echo "DNS2=223.5.5.5" >>/etc/sysconfig/network-scripts/ifcfg-$1

dg_ddg

cat /etc/sysconfig/network-scripts/ifcfg-$1

fi
echo CentOS7
fi






