#!/bin/bash
## snmpd.conf_centos6  2016-08-03
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 7



cat >/etc/snmp/snmpd.conf<<EOF
com2sec notConfigUser  127.0.0.1 public
com2sec notConfigUser  192.168.10.12 public
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

/sbin/service snmpd restart

