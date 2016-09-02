#!/bin/bash
## clean_logs  2016-09-02
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6

rm -rf /var/log/audit/audit.*
rm -rf /var/log/secure-*
rm -rf /var/log/messages-*
rm -rf /var/log/spooler-*
rm -rf /var/log/yum.log-*
rm -rf /var/log/maillog-*
rm -rf /var/log/cron-*
rm -rf /var/log/btmp-*
rm -rf /var/log/dracut.log-*
rm -rf /var/log/dmesg.old

cat /dev/null > /root/.bash_history
cat /dev/null > /var/log/anaconda.syslog
cat /dev/null > /var/log/anaconda.xlog
cat /dev/null > /var/log/dmesg
cat /dev/null > /var/log/lastlog
cat /dev/null > /var/log/syslog
cat /dev/null > /var/log/wtmp
cat /dev/null > /var/log/btmp
cat /dev/null > /var/log/maillog
cat /dev/null > /var/log/messages
cat /dev/null > /var/log/maillog
cat /dev/null > /var/log/secure
cat /dev/null > /var/log/cron
history -c
