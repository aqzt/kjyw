#!/bin/bash
## nagios nrpe snmp 2016-08-05
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6

cat >/usr/local/nagios/etc/nrpe.cfg<<EOF
log_facility=daemon
pid_file=/var/run/nrpe.pid
server_port=5666
nrpe_user=nagios
nrpe_group=nagios
allowed_hosts=127.0.0.1,192.168.10.112
dont_blame_nrpe=0
allow_bash_command_substitution=0
debug=0
command_timeout=60
connection_timeout=300
command[check_users]=/usr/local/nagios/libexec/check_users -w 8 -c 12
command[check_load]=/usr/local/nagios/libexec/check_load -w 15,10,5 -c 30,25,20
command[check_mem]=/usr/local/nagios/libexec/check_mem.sh -w 75 -c 85
command[check_/]=/usr/local/nagios/libexec/check_disk -w 20% -c 10% -p /
command[check_/data]=/usr/local/nagios/libexec/check_disk -w 20% -c 10% -p /data
command[check_/opt]=/usr/local/nagios/libexec/check_disk -w 20% -c 10% -p /opt
command[check_ss]=/usr/local/nagios/libexec/check_ss.sh 1000 3000
command[check_eth0]=/usr/local/nagios/libexec/check_traffic.sh -V 2c -C public -H 127.0.0.1 -N eth0 -w 5000,5000 -c 10000,10000 -K -B
command[check_eth1]=/usr/local/nagios/libexec/check_traffic.sh -V 2c -C public -H 127.0.0.1 -N eth1 -w 5000,5000 -c 10000,10000 -K -B
EOF

em1=`ip a  |grep em1 | awk -F ": " '{print $2}' | head -n 1`
if [ -z "$em1" ] ; then
echo "No em1"
    else
sed -i 's/eth0/em1/g' /usr/local/nagios/etc/nrpe.cfg
fi
em2=`ip a  |grep em2 | awk -F ": " '{print $2}' | head -n 1`
if [ -z "$em2" ] ; then
echo "No em2"
    else
sed -i 's/eth1/em2/g' /usr/local/nagios/etc/nrpe.cfg
fi
eth0=`ip a  |grep eth0 | awk -F ": " '{print $2}' | head -n 1`
if [ -z "$eth0" ] ; then
echo "No eth0"
    else
echo "eth0"
fi
eth1=`ip a  |grep eth1 | awk -F ": " '{print $2}' | head -n 1`
if [ -z "$eth1" ] ; then
echo "No eth1"
    else
echo "eth1"
fi

#############snmp#####################

cat >/etc/snmp/snmpd.conf<<EOF
com2sec notConfigUser 127.0.0.1 public
com2sec notConfigUser 192.168.10.112 public
group notConfigGroup v1 notConfigUser
group notConfigGroup v2c notConfigUser
view systemview included .1.3.6.1.2.1.1
view systemview included .1.3.6.1.2.1.2
view systemview included .1.3.6.1.2.1.25.1.1
view all included  .1           80
access notConfigGroup "" any noauth exact all none none
dontLogTCPWrappersConnects yes
EOF

/sbin/service snmpd restart

chkconfig snmpd on

########################nagios############################

commande=`ps aux  |grep nagios |grep nrpe | grep -v 'grep' | awk '{print $2}'`
##echo $commande
if [ -z "$commande" ] ; then
echo "No nrpe"
    else
ps aux  |grep nagios |grep nrpe | grep -v 'grep' | awk '{print $2}' | xargs kill
fi

/usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d
echo ok
