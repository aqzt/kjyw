#!/bin/bash
## mail  2016-07-22
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 7
##定时更换/etc/mail.rc配置文件
##0 */12 * * * /data/shell/mail.sh
check=`cat /tmp/mail_check.log`
if [ "$check" == "1" ];then
cat >/etc/mail.rc<<EOF
set hold
set append
set ask
set crt
set dot
set keep
set emptybox
set indentprefix="> "
set quote
set sendcharsets=iso-8859-1,utf-8
set showname
set showto
set newmail=nopoll
set autocollapse
ignore received in-reply-to message-id references
ignore mime-version content-transfer-encoding
fwdretain subject date from to
set bsdcompat
set from=test1@nagios.com smtp=192.168.1.12
set smtp-auth-user=test1@nagios.com smtp-auth-password=testtest20160722a smtp-auth=login
EOF
echo "2" > /tmp/mail_check.log
fi


if [ "$check" == "2" ];then
cat >/etc/mail.rc<<EOF
set hold
set append
set ask
set crt
set dot
set keep
set emptybox
set indentprefix="> "
set quote
set sendcharsets=iso-8859-1,utf-8
set showname
set showto
set newmail=nopoll
set autocollapse
ignore received in-reply-to message-id references
ignore mime-version content-transfer-encoding
fwdretain subject date from to
set bsdcompat
set from=test2@nagios.com smtp=192.168.1.15
set smtp-auth-user=test2@nagios.com smtp-auth-password=testtest20160722b smtp-auth=login
EOF
echo "1" > /tmp/mail_check.log
fi
date >> /tmp/mail_time.log






