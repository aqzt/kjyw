#!/bin/bash
yum install -y make gcc bc openssl-devel net-snmp net-snmp-devel net-snmp-utils

/usr/sbin/useradd -s /sbin/nologin nagios

tar zxvf  nagios-plugins-2.1.1.tar.gz
cd nagios-plugins-2.1.1
./configure && make && make install
cd ..
chown nagios.nagios /usr/local/nagios
chown -R nagios.nagios /usr/local/nagios/libexec

tar zxvf nrpe-2.15.tar.gz
cd nrpe-2.15
./configure && make all && make install-plugin && make install-daemon && make install-daemon-config
cd ..

Network_Card1=`/sbin/ip a|grep -B1 221.111 |grep inet | awk -F ' ' '{print $7}'`
Network_Card2=`/sbin/ip a|grep -B1 192.168 |grep inet | awk -F ' ' '{print $7}'`


cat >/usr/local/nagios/etc/nrpe.cfg<<EOF
log_facility=daemon
pid_file=/var/run/nrpe.pid
server_port=5666
nrpe_user=nagios
nrpe_group=nagios
allowed_hosts=127.0.0.1,192.168.1.12
dont_blame_nrpe=0
allow_bash_command_substitution=0
debug=0
command_timeout=60
connection_timeout=300
command[check_users]=/usr/local/nagios/libexec/check_users -w 2 -c 6
command[check_load]=/usr/local/nagios/libexec/check_load -w 19,15,12 -c 30,25,20
command[check_/]=/usr/local/nagios/libexec/check_disk -w 12% -c 10% -p /
command[check_/data]=/usr/local/nagios/libexec/check_disk -w 20% -c 10% -p /data
command[check_/opt]=/usr/local/nagios/libexec/check_disk -w 12% -c 10% -p /opt
command[check_ss]=/usr/local/nagios/libexec/check_ss.sh 1000 3000
command[check_$Network_Card1]=/usr/local/nagios/libexec/check_traffic.sh -V 2c -C nagios_test@1128 -H 127.0.0.1 -N $Network_Card1 -w 5000,5000 -c 10000,10000 -K -B
command[check_$Network_Card2]=/usr/local/nagios/libexec/check_traffic.sh -V 2c -C nagios_test@1128 -H 127.0.0.1 -N $Network_Card2 -w 15000,15000 -c 30000,30000 -K -B
command[check_disk]=/usr/local/nagios/libexec/check_disk.sh 90 90 95
command[check_secure]=/usr/local/nagios/libexec/check_secure.sh 15
EOF


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
cat >/etc/snmp/snmpd.conf<<EOF
com2sec notConfigUser 127.0.0.1 nagios_test@1128
com2sec notConfigUser 192.168.1.12 nagios_test@1128
group notConfigGroup v1 notConfigUser
group notConfigGroup v2c notConfigUser
view systemview included .1.3.6.1.2.1.1
view systemview included .1.3.6.1.2.1.2
view systemview included .1.3.6.1.2.1.25.1.1
view all included  .1           80
access notConfigGroup "" any noauth exact all none none
dontLogTCPWrappersConnects yes
EOF


fi


if [ $OS == 'CentOS7' ];then
cat >/etc/snmp/snmpd.conf<<EOF
com2sec notConfigUser  127.0.0.1 nagios_test@1128
com2sec notConfigUser  192.168.1.12 nagios_test@1128
group   notConfigGroup v1           notConfigUser
group   notConfigGroup v2c           notConfigUser
view    systemview    included   .1.3.6.1.2.1.1
view    systemview    included   .1.3.6.1.2.1.25.1.1
access  notConfigGroup ""      any       noauth    exact  all  none none
view all    included  .1                               80
syslocation Unknown (edit /etc/snmp/snmpd.conf)
syscontact Root <root@localhost> (configure /etc/snmp/snmp.local.conf)
dontLogTCPWrappersConnects yes
smuxpeer .1.3.6.1.4.1.674.10892.1
EOF
chmod  755 /bin/which


fi

#############snmp#####################
##cp -rf snmpd.conf /etc/snmp/
service snmpd restart
chkconfig snmpd on
##systemctl enable snmpd.service
cp -rf sh/*.sh /usr/local/nagios/libexec/
chown nagios.nagios /usr/local/nagios/libexec/*.sh
chmod -R 777 /usr/local/nagios/libexec/*.sh
########################nagios############################
ps -ef | grep 'nagios' | grep 'nrpe' | grep -v 'grep' | awk '{print $2}' | xargs kill
/usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d
echo "/usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d" >> /etc/rc.local

mkdir  -p /opt/sh/
cat >/opt/sh/ssh_secure.sh<<EOF
echo "Nov 10 18:07:37 test sshd[11079]: Accepted password for root from 192.168.1.1 port 59557 ssh2" > /tmp/ssh.log
tail -n 99 /var/log/secure  | grep sshd | grep ssh2 >> /tmp/ssh.log
echo "\$(date)"
EOF

cat >> /var/spool/cron/root << EOF
*/3 * * * * /opt/sh/ssh_secure.sh
EOF
chmod 777 /opt/sh/ssh_secure.sh
chmod 600 /var/spool/cron/root
/sbin/service crond restart



