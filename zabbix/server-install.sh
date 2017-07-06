#!/bin/sh
echo "脚本作者:火星小刘 web:www.huoxingxiaoliu.com email:xtlyk@163.com"

#sleep 10
zabbix_version=3.0.9
zabbixdir=`pwd`
ip=`ip addr |grep inet |egrep -v "inet6|127.0.0.1" |awk '{print $2}' |awk -F "/" '{print $1}'`
release=`cat /etc/redhat-release | awk -F "release" '{print $2}' |awk -F "." '{print $1}' |sed 's/ //g'`

cat $zabbixdir/README.md



#sleep 10
echo "当前目录为:$zabbixdir"
echo "本机ip为:$ip"
echo "安装mysql、apache、php等相关组件"
sleep 3

if [ $release = 7 ];then
	rpm -Uvh http://mirrors.isu.net.sa/pub/fedora/fedora-epel/7/x86_64/e/epel-release-7-6.noarch.rpm
	yum -y install php-xml unixODBC unixODBC-devel  php-xmlrpc php-mbstring php-mhash patch java-devel wget unzip libxml2 libxml2-devel httpd mariadb mariadb-devel mariadb-server php php-mysql php-common php-mbstring php-gd php-odbc php-pear curl curl-devel net-snmp net-snmp-devel perl-DBI php-xml ntpdate  php-bcmath zlib-devel glibc-devel curl-devel gcc automake libidn-devel openssl-devel net-snmp-devel rpm-devel OpenIPMI-devel
	systemctl start mariadb.service
elif [ $release = 6 ];then
	yum remove php.x86_64 php-cli.x86_64 php-common.x86_64 php-gd.x86_64 php-ldap.x86_64 php-mbstring.x86_64 php-mcrypt.x86_64 php-mysql.x86_64 php-pdo.x86_64 -y
	rpm -Uvh http://mirrors.isu.net.sa/pub/fedora/fedora-epel/6/i386/epel-release-6-8.noarch.rpm
	rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm
	yum install unixODBC unixODBC-devel patch java-devel wget unzip libxml2 libxml2-devel httpd mysql mysql-server  curl curl-devel net-snmp net-snmp-devel perl-DBI ntpdate zlib-devel mysql-devel glibc-devel gcc-c++ gcc automake mysql libidn-devel openssl-devel net-snmp-devel rpm-devel OpenIPMI-devel php56w.x86_64 php56w-cli.x86_64 php56w-common.x86_64 php56w-gd.x86_64 php56w-ldap.x86_64 php56w-mbstring.x86_64 php56w-mcrypt.x86_64 php56w-mysql.x86_64 php56w-pdo.x86_64 php56w-bcmath php56w-xml -y
	service mysqld start
fi

echo "同步服务器时间"
ntpdate asia.pool.ntp.org
echo "创建zabbix用户"
groupadd zabbix
useradd -g zabbix zabbix
sleep 5


echo "设置数据库root密码,默认为123321"
sleep 3
mysqladmin  -uroot password "123321"


echo "创建zabbix数据库，和用户名密码"
echo "create database IF NOT EXISTS zabbix default charset utf8 COLLATE utf8_general_ci;" | mysql -uroot -p123321
echo "grant all privileges on zabbix.* to zabbix@'localhost' identified by 'zabbix';" | mysql -uroot -p123321
echo "flush privileges;" | mysql -uroot -p123321

echo "安装zabbix-${zabbix_version}"
sleep 3
if [ ! -f zabbix-${zabbix_version}.tar.gz ];then
	wget http://netix.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/${zabbix_version}/zabbix-${zabbix_version}.tar.gz
fi

tar zxvf $zabbixdir/zabbix-${zabbix_version}.tar.gz
cd $zabbixdir/zabbix-${zabbix_version}
echo `pwd`
./configure --prefix=/usr/local/zabbix/ --enable-server --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2 --enable-java
sleep 3

CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi

make install
mkdir /var/www/html/zabbix
cp -r $zabbixdir/zabbix-${zabbix_version}/frontends/php/* /var/www/html/zabbix
cp $zabbixdir/simkai.ttf /var/www/html/zabbix/fonts
sed -i "s/DejaVuSans/simkai/g" /var/www/html/zabbix/include/defines.inc.php

#cd /var/www/html/zabbix
#wget https://raw.githubusercontent.com/OneOaaS/graphtrees/master/graphtree3-0-1.patch
#patch  -Np0 <graphtree3-0-1.patch


echo "创建zabbix数据库配置档"
rm -f /var/www/html/zabbix/conf/zabbix.conf.php
cat > /var/www/html/zabbix/conf/zabbix.conf.php <<END
<?php
// Zabbix GUI configuration file.
global \$DB;

\$DB['TYPE']     = 'MYSQL';
\$DB['SERVER']   = 'localhost';
\$DB['PORT']     = '0';
\$DB['DATABASE'] = 'zabbix';
\$DB['USER']     = 'zabbix';
\$DB['PASSWORD'] = 'zabbix';

// Schema name. Used for IBM DB2 and PostgreSQL.
\$DB['SCHEMA'] = '';

\$ZBX_SERVER      = 'localhost';
\$ZBX_SERVER_PORT = '10051';
\$ZBX_SERVER_NAME = '';

\$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
?>
END

echo "导入zabbix数据库"
sleep 3

cd $zabbixdir/zabbix-${zabbix_version}
mysql -uzabbix -pzabbix -hlocalhost zabbix < database/mysql/schema.sql
mysql -uzabbix -pzabbix -hlocalhost zabbix < database/mysql/images.sql
mysql -uzabbix -pzabbix -hlocalhost zabbix < database/mysql/data.sql
echo "创建启动init"
sleep 3
cp misc/init.d/tru64/zabbix_agentd /etc/init.d/
cp misc/init.d/tru64/zabbix_server /etc/init.d/
chmod +x /etc/init.d/zabbix_*
sed -i 's:DAEMON=/usr/local/sbin/zabbix_server:DAEMON=/usr/local/zabbix/sbin/zabbix_server:g' /etc/init.d/zabbix_server
sed -i 's:DAEMON=/usr/local/sbin/zabbix_agentd:DAEMON=/usr/local/zabbix/sbin/zabbix_agentd:g' /etc/init.d/zabbix_agentd
sed -i 's:DBUser=root:DBUser=zabbix:g' /usr/local/zabbix/etc/zabbix_server.conf
sed -i '/# DBPassword=/a\DBPassword=zabbix' /usr/local/zabbix/etc/zabbix_server.conf
echo "设置php.ini相关参数"
sleep 3
cp /etc/php.ini /etc/php.ini.zabbixbak
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php.ini
sed -i '/max_input_time =/s/60/300/' /etc/php.ini
sed -i '/mbstring.func_overload = 0/a\mbstring.func_overload = 1' /etc/php.ini
sed -i '/post_max_size =/s/8M/32M/' /etc/php.ini
sed -i '/;always_populate_raw_post_data = -1/a\always_populate_raw_post_data = -1' /etc/php.ini
sed -i '/;date.timezone =/a\date.timezone = PRC' /etc/php.ini

echo "设置apache"
sleep 3
sed -i '/#ServerName www.example.com:80/a\ServerName zabbix' /etc/httpd/conf/httpd.conf 
if [ $release = 7 ];then
	systemctl start httpd.service
elif [ $release = 6 ];then
	service httpd start
fi


echo "启动zabbix"
/etc/init.d/zabbix_server restart
/etc/init.d/zabbix_agentd restart
/usr/local/zabbix/sbin/zabbix_java/startup.sh

echo "数据库默认root密码zabbix123321;zabbix-Database name:zabbix/User:zabbix/Password:zabbix"
cp $zabbixdir/zabbix-${zabbix_version}.tar.gz /var/www/html/zabbix
echo "打开http://$ip/zabbix，进行下一步安装"
