#!/bin/bash
## snmpd.conf_centos6  2016-08-03
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6

yum install -y gcc  net-snmp

cat >/etc/snmp/snmpd.conf<<EOF
com2sec notConfigUser 127.0.0.1 public
com2sec notConfigUser 192.168.10.12 public
group notConfigGroup v1 notConfigUser
group notConfigGroup v2c notConfigUser
view systemview included .1.3.6.1.2.1.1
view systemview included .1.3.6.1.2.1.2
view systemview included .1.3.6.1.2.1.25.1.1
view all included  .1           80
access notConfigGroup "" any noauth exact all none none
dontLogTCPWrappersConnects yes
EOF

/sbin/chkconfig snmpd on
/sbin/service snmpd restart