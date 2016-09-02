#!/bin/bash
## clean_logs  2016-09-02
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## ubuntu

rm -rf /var/log/alternatives.log.*
rm -rf /var/log/auth.log.*
rm -rf /var/log/dmesg.*
rm -rf /var/log/dpkg.log.*
rm -rf /var/log/kern.log.*
rm -rf /var/log/syslog.*
rm -rf /var/log/ufw.log.*
rm -rf /var/log/wtmp.*
rm -rf /var/log/upstart/*.gz
rm -rf /var/log/upstart/*.log
cat /dev/null > /root/.bash_history
cat /dev/null > /var/log/dmesg
cat /dev/null > /var/log/lastlog
cat /dev/null > /var/log/syslog
cat /dev/null > /var/log/wtmp
cat /dev/null > /var/log/mail.log
cat /dev/null > /var/log/faillog
cat /dev/null > /var/log/udev
history -c