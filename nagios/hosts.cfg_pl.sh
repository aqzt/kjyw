#!/bin/bash
## nagios批量生成配置文件 2016-08-04
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6

mkdir /root/test

#生成IP列表
for((i=1;i<=254;i++));do echo 192.168.10.$i;done  > hosts.txt

for host in $(cat hosts.txt):
do
        echo "$host in progress";
###snmpwalk -r 1 -t 1 -v 2c  -c public  $host:161 sysDescr | awk -F ' ' '{print $1}'
commande=`snmpwalk -r 1 -t 1 -v 2c  -c public  $host:161 sysDescr | awk -F ' ' '{print $1}'`

echo $commande
if [ -z "$commande" ] ;        then
echo "No response"

                                else


cat >/root/test/$host.cfg<<EOF
define host{
        use                     meiyou-linux,host-pnp
        host_name               $host
        alias                   $host
        address                 $host
        }
EOF
echo -ne "$host,\c">>/root/test/hostgroup.conf
echo "Ok"
fi

done;



