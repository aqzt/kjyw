#!/bin/bash
## gitlab_rpm 2016-05-16
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

echo $1
echo $2
regex="\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\b"
ckStep1=`echo $1 | egrep $regex | wc -l`
if [ $ckStep1 -eq 0 ]
then
       echo "The string $1 is not a correct ipaddr!!!"
	   exit 0
else
ckStep2=`echo $2 | egrep $regex | wc -l`
if [ $ckStep2 -eq 0 ]
then
       echo "The string $2 is not a correct ipaddr!!!"
	   exit 0
else
rm -rf /data/nagios/hosts.cfg.log
rm -rf /data/nagios/services.cfg.log

cp /data/nagios/hosts.cfg.bak /data/nagios/hosts.cfg.log
cp /data/nagios/services.cfg.bak /data/nagios/services.cfg.log

sed -i "s/21.000.000.008/$1/g" /data/nagios/hosts.cfg.log
sed -i "s/192.0.0.008/$2/g" /data/nagios/hosts.cfg.log

sed -i "s/21.000.000.008/$1/g" /data/nagios/services.cfg.log
sed -i "s/192.0.0.008/$2/g" /data/nagios/services.cfg.log

check1=`cat /data/nagios/hosts.cfg|grep alias |grep $1`
if [ "$check1" == "" ];then
check2=`cat /data/nagios/services.cfg|grep alias |grep $2`
if [ "$check2" == "" ];then
cat /data/nagios/hosts.cfg.log >> /data/nagios/hosts.cfg
cat /data/nagios/services.cfg.log >> /data/nagios/services.cfg
echo ok

else
    echo $2
	echo Already exist
fi

else
    echo $1
	echo Already exist
fi
fi  
fi



