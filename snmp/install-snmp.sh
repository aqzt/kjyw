#!/bin/bash
#the shell is install net-snmp
path=`pwd`

if [ $# -lt 1 ];then
        echo "执行格式:$0 本机业务IP"
        exit
fi

#del old soft
sed -i '/net-snmp/d' /etc/profile
sed -i '/net-snmp/d' /etc/rc.local
rm -f /var/log/snmpd.log
rm -rf /var/net-snmp
rm -rf /usr/local/net-snmp

rpm -e net-snmp-libs-5.3.2.2-7.el5 --allmatches --nodeps
echo "安装检索中Zzz.."
sleep 1
#install rpm snmp
for i in lm_sensors-2.10.7-4.el5.x86_64.rpm net-snmp-libs-5.3.2.2-14.el5_7.1.x86_64.rpm  net-snmp-5.3.2.2-14.el5_7.1.x86_64.rpm net-snmp-utils-5.3.2.2-14.el5_7.1.x86_64.rpm
do
	word=`echo $i|awk -F "el5" '{print $1}'`
	if [ `rpm -qa |grep -c $word` -lt 1 ];then
		rpm -ivh ${path}/source/$i
	else
		echo "$i已安装！"
	fi
done

cd $path
cp -f ./source/snmpd.conf /etc/snmp/snmpd.conf

echo "Snmp安装完毕"
echo "启动snmp服务Zzz."、
sleep 2
service snmpd start
if [ `ps -ef |grep -v grep | grep -c snmpd` -lt 1 ];then
	echo "snmp启动成功"
fi

echo "设置开始自启动"
chkconfig --add snmpd
chkconfig --level 345 snmpd on

if [ `chkconfig snmpd --list |grep -E "启用|on" -c` -lt 1 ];then
	echo "设置自启动成功！"
fi
if [ `rpm -qa |grep snmp -c` -eq 3  ];then
	echo "检查安装包完整性通过!"
fi
if [ `netstat -ln |grep -c 161` -eq 1 ];then 
	if [ `snmpget -v 1 -c public $1 sysUpTime.0 |grep -c Error` -eq 0 ];then
		echo "Snmp安装成功，并测试通过！"
	fi
fi

