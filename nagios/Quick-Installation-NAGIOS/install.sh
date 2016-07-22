#!/bin/bash
echo "脚本作者:火星小刘 web:www.huoxingxiaoliu.com email:xtlyk@163.com "

sleep 3

nagiosdir=`pwd`
ip=`ip addr |grep inet |egrep -v "inet6|127.0.0.1" |awk '{print $2}' |awk -F "/" '{print $1}'`
nagios_version=4.1.1
nagios_plugins_version=2.1.1
pnp4nagios_sersion=0.6.25

echo "当前目录为:$nagiosdir"
echo "本机ip为:$ip"

echo "安装开始前请仔细阅读README.md"
cat $nagiosdir/README.md

echo "本代码为交互代码，个别地方需要手动输入.报警邮箱设置方法如下:vi /etc/mail.rc 添加你的发件邮箱地址已经smtp，如下 set from=xtlyk@163.com smtp=smtp.163.com set smtp-auth-user=xtlyk@163.com smtp-auth-password=000000 smtp-auth=login 可以通过一下命令测试 echo "Hello World" | mail xtlyk@163.com"
read -p  "Are you sure install nagios(y) or quit(n):" isY
if [ "${isY}" != "y" ] && [ "${isY}" != "Y" ];then   
exit 1
fi

#yum update -y
echo "先安装相关组件"
sleep 2
yum install -y wget httpd php php-devel php-gd gcc glibc glibc-common gd gd-devel make net-snmp zip unzip

echo "安装nagios-"${nagios_version}""
sleep 2
#wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-${nagios_version}.tar.gz
tar zxvf nagios-${nagios_version}.tar.gz

#创建nagios用户
useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios

cd nagios-${nagios_version}

./configure --prefix=/usr/local/nagios --with-command-group=nagcmd --with-nagios-group=nagcmd

make all
make install 
make install-init  
make install-config 
make install-commandmode 
make install-webconf 

cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/

chown -R nagios:nagcmd /usr/local/nagios/libexec/eventhandlers

/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

service nagios start
cd ..

echo "配置httpd"
sleep 2

sed -i 's/User\ apache/User\ nagios/g' /etc/httpd/conf/httpd.conf
sed -i 's/Group\ apache/Group\ nagcmd/g' /etc/httpd/conf/httpd.conf

echo "ServerName nagios" >> /etc/httpd/conf/httpd.conf

echo "nagios web默认登陆用户名:nagiosadmin 密码:nagios"

htpasswd -cmb /usr/local/nagios/etc/htpasswd.users nagiosadmin nagios

echo "安装nagios-plugins"
sleep 2
#wget http://nagios-plugins.org/download/nagios-plugins-${nagios-plugins_version}.tar.gz
tar zxvf nagios-plugins-${nagios_plugins_version}.tar.gz

cd nagios-plugins-${nagios_plugins_version}

./configure --prefix=/usr/local/nagios --with-nagios-user=nagios --with-nagios-group=nagcmd --with-command-user=nagios --with-command-group=nagcmd
make
make install
cd ..


echo "为nagios安装图标pnp4nagios"
sleep 2

yum install -y perl-Time-HiRes rrdtool  rrdtool-perl
#if [ ! -f pnp4nagios-${pnp4nagios_sersion}.tar.gz ];then
#wget http://nchc.dl.sourceforge.net/project/pnp4nagios/PNP-0.6/pnp4nagios-${pnp4nagios_sersion}.tar.gz
tar zxvf pnp4nagios-${pnp4nagios_sersion}.tar.gz

cd pnp4nagios-${pnp4nagios_sersion}
./configure --prefix=/usr/local/pnp4nagios/ --with-nagios-user=nagios --with-nagios-group=nagcmd
make all
make install
make install-webconf
make install-config
make install-init

cd /usr/local/pnp4nagios/etc/
mv misccommands.cfg-sample misccommands.cfg
mv nagios.cfg-sample nagios.cfg
mv rra.cfg-sample rra.cfg
cd pages
mv web_traffic.cfg-sample web_traffic.cfg
cd ../check_commands
mv check_all_local_disks.cfg-sample check_all_local_disks.cfg
mv check_nrpe.cfg-sample check_nrpe.cfg
mv check_nwstat.cfg-sample check_nwstat.cfg

cd $nagiosdir

#sed -i 's/process_performance_data=0/process_performance_data=1/g' /usr/local/nagios/etc/nagios.cfg
#sed -i 's/#host_perfdata_command=process-host-perfdata/host_perfdata_command=process-host-perfdata/g' /usr/local/nagios/etc/nagios.cfg
#sed -i 's/#service_perfdata_command=process-service-perfdata/service_perfdata_command=process-service-perfdata/g' /usr/local/nagios/etc/nagios.cfg

mv /usr/local/nagios/etc/objects/commands.cfg       /usr/local/nagios/etc/objects/commands.cfgbak

cp $nagiosdir/commands.cfg                          /usr/local/nagios/etc/objects/

mv /usr/local/nagios/etc/objects/templates.cfg      /usr/local/nagios/etc/objects/templates.cfgbak

cp $nagiosdir/templates.cfg                         /usr/local/nagios/etc/objects/

mv /usr/local/nagios/etc/nagios.cfg 		    /usr/local/nagios/etc/nagios.cfgbak

cp $nagiosdir/nagios.cfg 			    /usr/local/nagios/etc/

#sed -i 's/#service_perfdata_file=/usr/local/pnp4nagios/var/service-perfdata/service_perfdata_file=/usr/local/pnp4nagios/var/service-perfdata/g' /usr/local/nagios/etc/nagios.cfg

#sed -i 's/#service_perfdata_file=/usr/g' /usr/local/nagios/etc/nagios.cfg

mv /usr/local/pnp4nagios/share/install.php /usr/local/pnp4nagios/share/install.phpbak

chown nagios.nagcmd -R /usr/local/pnp4nagios/

chown nagios.nagcmd -R /usr/local/nagios/

chmod 777 -R /var/lib/php/session/

echo "1" >/var/www/html/index.html
echo "配置邮件报警"
yum install -y mailx sendmail

read -p  "请输入发送邮箱:" From
echo "163:smtp.163.com**********126:smtp.126.com*******qq:smtp.qq.com"
read -p  "请输入发送邮箱的smtp服务器:" Smtp
read -p  "请输入发送邮箱密码:" Passwd

echo "set from=$From smtp=$Smtp set smtp-auth-user=$From smtp-auth-password=$Passwd smtp-auth=login" >> /etc/mail.rc

chkconfig httpd on
service httpd restart
chkconfig nagios on
service nagios restart
chkconfig npcd on
service npcd restart


echo "安装结束，打开浏览器输入:http://$ip/nagios 访问"
echo "下面启动sendmail邮件服务,启动较慢,请耐心等待"
chkconfig sendmail on
service sendmail start
