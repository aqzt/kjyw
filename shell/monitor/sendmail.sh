#!/bin/bash
# mailq 查看邮件队列
# cat /var/log/maillog 查看发的邮件
# cat /var/log/maillog |wc -l 查看发的邮件数
# /usr/sbin/sendmail -q -v  强制邮件队列


yum install -y sendmail sendmail-cf dovecot cyrus-sasl cyrus-sasl-md5 cyrus-sasl-plain cyrus-sasl-lib
sed -i "/Addr=127.0.0.1/c  DAEMON_OPTIONS(\`Port=smtp,Addr=0.0.0.0, Name=MTA')dnl" /etc/mail/sendmail.mc
sed -i "/TRUST_AUTH_MECH/c TRUST_AUTH_MECH(\`EXTERNAL DIGEST-MD5 CRAM-MD5 LOGIN PLAIN')dnl" /etc/mail/sendmail.mc
sed -i "/confAUTH_MECHANISMS/c define(\`confAUTH_MECHANISMS',\`EXTERNAL GSSAPI DIGEST-MD5 CRAM-MD5 LOGIN PLAIN')dnl" /etc/mail/sendmail.mc 
m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf
sed -i "/protocols/c protocols =imap pop3 lmtp" /etc/dovecot/dovecot.conf
echo "$HOSTNAME" >> /etc/mail/local-host-names
echo "listen = *" >> /etc/dovecot/dovecot.conf
sed -i "/MECH/c MECH=shadow" /etc/sysconfig/saslauthd
/usr/sbin/groupadd mailuser
/usr/sbin/useradd -g mailuser -s /sbin/nologin testmail
passwd testmail
chkconfig sendmail on
chkconfig dovecot on
chkconfig saslauthd on
service sendmail restart
service dovecot restart
service saslauthd restart
testsaslauthd -u testmail -p mail123456
