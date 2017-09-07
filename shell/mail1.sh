#!/bin/bash
## IMAP方式批量删除邮箱邮件 2017-08-05
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 7
## crontab定时 0 */20 * * * bash /opt/sh/mail1.sh 500 | telnet imap.189.cn 143
### 181503xxx@189.cn 替换为你的邮箱
### password123  替换为你的邮箱密码
### bash /opt/sh/mail1.sh 500 | telnet imap.189.cn 143

MAX_MESS=$1
[ $# -eq 0 ] && exit 1 || :
sleep 2
echo "A01 login 181503xxx@189.cn  password123"
sleep 1
echo "A02 LIST '' *"

sleep 2
echo "A03 Select INBOX"
sleep 2
for (( j = 2 ; j <= $MAX_MESS; j++ ))
do
echo "A09 Store $j +FLAGS (\Deleted)"

echo "A10 Expunge"
sleep 1
done
echo QUIT
date >> /tmp/mail1.log
