#!/bin/bash
##Linux MYSQL  密码重置脚本
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

mysql_root_password="$RANDOM***$RANDOM"
/etc/init.d/mysqld stop
/usr/local/mysql-5.1.66/bin/mysqld_safe --skip-grant-tables >/dev/null 2>&1 &
sleep 10
/usr/local/mysql-5.1.66/bin/mysql -u root mysql << EOF
update user set password = Password('$mysql_root_password') where User = 'root';
EOF

reset_status=`echo $?`
if [ $reset_status = "0" ]; then
killall mysqld
sleep 10
/etc/init.d/mysqld start
echo $mysql_root_password > /tmp/mysql.txt
else
printf "failed!\n"
fi
rm -rf $0