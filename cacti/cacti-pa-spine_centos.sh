#!/bin/sh

# Install cacti 0.8.7g on CentOS linux
# This shell will be auto install the following :
# 1) cacit 0.8.7g with :
# 		data_source_deactivate.patch
# 		graph_list_view.patch
# 		html_output.patch
# 		ldap_group_authenication.patch
# 		script_server_command_line_parse.patch
# 		ping.patch
# 		poller_interval.patch
# 2) pa 2.9
# 3) spine 0.8.7g with:
# 		unified_issues.patch
# 4) plugins :
#		settings v0.7
#		clog v1.6
#		monitor v1.2
#		realtime v0.43
#		cycle v1.2
#		thold v0.43
#		ntop v0.2
#		boost v4.3
#		discovery v1.1
#		weathermap v0.97a
#		flowview v0.6
#		mactrack v2.9
#		routerconfigs v0.3
#		syslog v1.21
#		aggregate v0.75
#		loginmod v1.0
#		docs v0.2
#		ReportIt v0.73
#		mobile v0.1
#		rrdclean v0.41
#		tools v0.3
#		ssl v0.1
#		domains v0.1
# 5) Ntop
# Make by Patrick.Ru @ China
# E-Mail : patrick.ru@hotmail.com
# Date : 25-Jun-2011

# config for the rpmforge-release
echo $(date) --\> configing for the rpmforge-release... >> /var/log/cacti_install.log
yum install -y wget
if [ "$HOSTTYPE" == "x86_64" ]; then
wget http://apt.sw.be/redhat/el5/en/x86_64/rpmforge/RPMS/apt-0.5.15lorg3.94a-5.el5.rf.x86_64.rpm
wget http://apt.sw.be/redhat/el5/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm
elif [ "$HOSTTYPE" == "i386" ]; then
wget http://apt.sw.be/redhat/el5/en/i386/rpmforge/RPMS/apt-0.5.15lorg3.94a-5.el5.rf.i386.rpm
wget http://apt.sw.be/redhat/el5/en/i386/rpmforge/RPMS/rpmforge-release-0.5.2-2.el5.rf.i386.rpm
fi
rpm -Uvh *.rpm
rm *.rpm
echo $(date) --\> configed for the rpmforge-release! >> /var/log/cacti_install.log

# install httpd
echo $(date) --\> installing httpd... >> /var/log/cacti_install.log
yum install -y httpd
chkconfig httpd on
service httpd start
echo $(date) --\> installed httpd! >> /var/log/cacti_install.log
# install mysql-server
echo $(date) --\> installing mysql-server... >> /var/log/cacti_install.log
yum install -y mysql-server
chkconfig mysqld on
service mysqld start
mysqladmin -u root password dbadmin
echo $(date) --\> installed mysql-server! >> /var/log/cacti_install.log
# install php
echo $(date) --\> installing php... >> /var/log/cacti_install.log
yum install -y php php-gd php-mysql php-cli php-ldap php-snmp php-mbstring php-mcrypt
chkconfig snmpd on
service snmpd start
echo $(date) --\> installed php! >> /var/log/cacti_install.log
# restart httpd service
echo $(date) --\> restarting httpd... >> /var/log/cacti_install.log
service httpd restart
echo $(date) --\> restarted httpd! >> /var/log/cacti_install.log
# install rrdtool
echo $(date) --\> installing rrdtool... >> /var/log/cacti_install.log
yum install -y rrdtool 
echo $(date) --\> installed rrdtool! >> /var/log/cacti_install.log
# install net-snmp
echo $(date) --\> installing net-snmp-utils... >> /var/log/cacti_install.log
yum install -y net-snmp-utils 
echo $(date) --\> installed net-snmp-utils! >> /var/log/cacti_install.log

# download cacit 0.8.7g and patch
if [ -d  /usr/src/cacti ]; then 
	echo $(date) --\> folder: /usr/src/cacti is exist. >> /var/log/cacti_install.log
else
	mkdir /usr/src/cacti
	echo $(date) --\> create folder: /usr/src/cacti. >> /var/log/cacti_install.log
fi

cd /usr/src/cacti
if [ ! -f ./cacti-0.8.7g.tar.gz ];  then
	echo $(date) --\> downloading cacti-0.8.7g.tar.gz... >> /var/log/cacti_install.log
	wget http://www.cacti.net/downloads/cacti-0.8.7g.tar.gz
	if [ $? = 0 ]; then 
		echo $(date) --\> downloaded cacti-0.8.7g.tar.gz! >> /var/log/cacti_install.log
	else
		rm -f cacti-0.8.7g.tar.gz
		echo $(date) --\> download cacti-0.8.7g.tar.gz fault! >> /var/log/cacti_install.log
		exit
	fi
else 
  echo $(date) --\> cacti-0.8.7g.tar.gz is exist! >> /var/log/cacti_install.log
fi
if [ ! -f ./cacti-plugin-0.8.7g-PA-v2.9.tar.gz ];  then
	echo $(date) --\> downloading cacti-plugin-0.8.7g-PA-v2.9.tar.gz... >> /var/log/cacti_install.log
	wget http://www.cacti.net/downloads/pia/cacti-plugin-0.8.7g-PA-v2.9.tar.gz
	if [ $? = 0 ]; then
		echo $(date) --\> downloaded cacti-plugin-0.8.7g-PA-v2.9.tar.gz! >> /var/log/cacti_install.log
	else
		rm -f cacti-plugin-0.8.7g-PA-v2.9.tar.gz
		echo $(date) --\> download cacti-plugin-0.8.7g-PA-v2.9.tar.gz fault! >> /var/log/cacti_install.log
		exit
	fi
else 
	echo $(date) --\> cacti-plugin-0.8.7g-PA-v2.9.tar.gz is exist! >> /var/log/cacti_install.log
fi
if [ ! -f ./data_source_deactivate.patch ];  then
	echo $(date) --\> downloading data_source_deactivate.patch... >> /var/log/cacti_install.log
	wget http://www.cacti.net/downloads/patches/0.8.7g/data_source_deactivate.patch
	if [ $? = 0 ]; then
		echo $(date) --\> downloaded data_source_deactivate.patch! >> /var/log/cacti_install.log
	else
		rm -f data_source_deactivate.patch
		echo $(date) --\> download data_source_deactivate.patch fault! >> /var/log/cacti_install.log
		exit
	fi
else 
	echo $(date) --\> data_source_deactivate.patch is exist! >> /var/log/cacti_install.log
fi
if [ ! -f ./graph_list_view.patch ];  then
	echo $(date) --\> downloading graph_list_view.patch... >> /var/log/cacti_install.log
	wget http://www.cacti.net/downloads/patches/0.8.7g/graph_list_view.patch
	if [ $? = 0 ]; then
		echo $(date) --\> downloaded graph_list_view.patch! >> /var/log/cacti_install.log
	else
		rm -f graph_list_view.patch
		echo $(date) --\> download graph_list_view.patch fault! >> /var/log/cacti_install.log
		exit
	fi
else
	echo $(date) --\> graph_list_view.patch is exist! >> /var/log/cacti_install.log
fi
if [ ! -f ./html_output.patch ];  then  
	echo $(date) --\> downloading html_output.patch... >> /var/log/cacti_install.log
	wget http://www.cacti.net/downloads/patches/0.8.7g/html_output.patch
	if [ $? = 0 ]; then
		echo $(date) --\> downloaded html_output.patch! >> /var/log/cacti_install.log
	else
		rm -f html_output.patch
		echo $(date) --\> download html_output.patch fault! >> /var/log/cacti_install.log
		exit
	fi
else
	echo $(date) --\> html_output.patch is exist! >> /var/log/cacti_install.log
fi
if [ ! -f ./ldap_group_authenication.patch ];  then  
	echo $(date) --\> downloading ldap_group_authenication.patch... >> /var/log/cacti_install.log
	wget http://www.cacti.net/downloads/patches/0.8.7g/ldap_group_authenication.patch
	if [ $? = 0 ]; then
		echo $(date) --\> downloaded ldap_group_authenication.patch! >> /var/log/cacti_install.log
	else
		rm -f ldap_group_authenication.patch
		echo $(date) --\> download ldap_group_authenication.patch fault! >> /var/log/cacti_install.log
		exit
	fi
else
	echo $(date) --\> ldap_group_authenication.patch is exist! >> /var/log/cacti_install.log
fi
if [ ! -f ./script_server_command_line_parse.patch ];  then
	echo $(date) --\> downloading script_server_command_line_parse.patch... >> /var/log/cacti_install.log
	wget http://www.cacti.net/downloads/patches/0.8.7g/script_server_command_line_parse.patch
	if [ $? = 0 ]; then
		echo $(date) --\> downloaded script_server_command_line_parse.patch! >> /var/log/cacti_install.log
	else
		rm -f script_server_command_line_parse.patch
		echo $(date) --\> download script_server_command_line_parse.patch fault! >> /var/log/cacti_install.log
		exit
	fi
else
	echo $(date) --\> script_server_command_line_parse.patch is exist! >> /var/log/cacti_install.log
fi
if [ ! -f ./ping.patch ];  then
	echo $(date) --\> downloading ping.patch... >> /var/log/cacti_install.log
	wget -N http://www.cacti.net/downloads/patches/0.8.7g/ping.patch
	if [ $? = 0 ]; then
		echo $(date) --\> downloaded ping.patch! >> /var/log/cacti_install.log
	else
		rm -f ping.patch
		echo $(date) --\> download ping.patch fault! >> /var/log/cacti_install.log
		exit
	fi
else
	echo $(date) --\> ping.patch is exist! >> /var/log/cacti_install.log
fi
if [ ! -f ./poller_interval.patch ];  then
	echo $(date) --\> downloading poller_interval.patch... >> /var/log/cacti_install.log
	wget -N http://www.cacti.net/downloads/patches/0.8.7g/poller_interval.patch
	if [ $? = 0 ]; then
		echo $(date) --\> downloaded poller_interval.patch! >> /var/log/cacti_install.log
	else
		rm -f poller_interval.patch
		echo $(date) --\> download poller_interval.patch fault! >> /var/log/cacti_install.log
		exit
	fi
else
	echo $(date) --\> poller_interval.patch is exist! >> /var/log/cacti_install.log
fi

# extract and patch cacti-0.8.7g
echo $(date) --\> extracting cacti-0.8.7g.tar.gz... >> /var/log/cacti_install.log
tar zxvf cacti-0.8.7g.tar.gz
if [ $? = 0 ]; then
	echo $(date) --\> extracted cacti-0.8.7g.tar.gz! >> /var/log/cacti_install.log
else
	rm -rf cacti-0.8.7g
	echo $(date) --\> extract cacti-0.8.7g.tar.gz fault! >> /var/log/cacti_install.log
	exit
fi	
echo $(date) --\> extracting cacti-plugin-0.8.7g-PA-v2.9.tar.gz... >> /var/log/cacti_install.log
tar zxvf cacti-plugin-0.8.7g-PA-v2.9.tar.gz
if [ $? = 0 ]; then
	echo $(date) --\> extracted cacti-plugin-0.8.7g-PA-v2.9.tar.gz! >> /var/log/cacti_install.log
else
	rm -rf cacti-plugin-arch
	echo $(date) --\> extract cacti-plugin-0.8.7g-PA-v2.9.tar.gz fault! >> /var/log/cacti_install.log
	exit
fi

mv cacti-0.8.7g/* /var/www/html/
rm -rf cacti-0.8.7g
cd /var/www/html

echo $(date) --\> patching file data_source_deactivate.patch... >> /var/log/cacti_install.log
patch -p1 -N < /usr/src/cacti/data_source_deactivate.patch
if [ $? = 0 ]; then
	echo $(date) --\> patched file data_source_deactivate.patch! >> /var/log/cacti_install.log
else
	echo $(date) --\> patch file data_source_deactivate.patch fault! >> /var/log/cacti_install.log
	exit
fi
echo $(date) --\> patching file graph_list_view.patch... >> /var/log/cacti_install.log
patch -p1 -N < /usr/src/cacti/graph_list_view.patch
if [ $? = 0 ]; then
	echo $(date) --\> patched file graph_list_view.patch! >> /var/log/cacti_install.log
else
	echo $(date) --\> patch file graph_list_view.patch fault! >> /var/log/cacti_install.log
	exit
fi
echo $(date) --\> patching file html_output.patch... >> /var/log/cacti_install.log
patch -p1 -N < /usr/src/cacti/html_output.patch
if [ $? = 0 ]; then
	echo $(date) --\> patched file html_output.patch! >> /var/log/cacti_install.log
else
	echo $(date) --\> patch file html_output.patch fault! >> /var/log/cacti_install.log
	exit
fi
echo $(date) --\> patching file ldap_group_authenication.patch... >> /var/log/cacti_install.log
patch -p1 -N < /usr/src/cacti/ldap_group_authenication.patch
if [ $? = 0 ]; then
	echo $(date) --\> patched file ldap_group_authenication.patch! >> /var/log/cacti_install.log
else
	echo $(date) --\> patch file ldap_group_authenication.patch fault! >> /var/log/cacti_install.log
	exit
fi
echo $(date) --\> patching file script_server_command_line_parse.patch... >> /var/log/cacti_install.log
patch -p1 -N < /usr/src/cacti/script_server_command_line_parse.patch
if [ $? = 0 ]; then
	echo $(date) --\> patched file script_server_command_line_parse.patch! >> /var/log/cacti_install.log
else
	echo $(date) --\> patch file script_server_command_line_parse.patch fault! >> /var/log/cacti_install.log
	exit
fi
echo $(date) --\> patching file ping.patch... >> /var/log/cacti_install.log
patch -p1 -N < /usr/src/cacti/ping.patch
if [ $? = 0 ]; then
	echo $(date) --\> patched file ping.patch! >> /var/log/cacti_install.log
else
	echo $(date) --\> patch file ping.patch fault! >> /var/log/cacti_install.log
	exit
fi
echo $(date) --\> patching file poller_interval.patch... >> /var/log/cacti_install.log
patch -p1 -N < /usr/src/cacti/poller_interval.patch
if [ $? = 0 ]; then
	echo $(date) --\> patched file poller_interval.patch! >> /var/log/cacti_install.log
else
	echo $(date) --\> patch file poller_interval.patch fault! >> /var/log/cacti_install.log
	exit
fi

# patch for pa 2.9
echo $(date) --\> patching file cacti-plugin-0.8.7g-PA-v2.9.diff... >> /var/log/cacti_install.log
patch -p1 -N --dry-run < /usr/src/cacti/cacti-plugin-arch/cacti-plugin-0.8.7g-PA-v2.9.diff
if [ $? = 0 ]; then
	patch -p1 -N < /usr/src/cacti/cacti-plugin-arch/cacti-plugin-0.8.7g-PA-v2.9.diff
	if [ $? = 0 ]; then
		echo $(date) --\> patched file cacti-plugin-0.8.7g-PA-v2.9.diff! >> /var/log/cacti_install.log
	else
		echo $(date) --\> patch file cacti-plugin-0.8.7g-PA-v2.9.diff fault! >> /var/log/cacti_install.log
		exit
	fi
else
	echo $(date) --\> pre-patch file cacti-plugin-0.8.7g-PA-v2.9.diff fault! >> /var/log/cacti_install.log
	exit
fi

# create database for cacti
echo $(date) --\> Creating database cacti... >> /var/log/cacti_install.log
mysql -u root -pdbadmin -e 'CREATE DATABASE `cacti` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;'
if [ $? = 0 ]; then
	echo $(date) --\> Created database cacti! >> /var/log/cacti_install.log
else
	echo $(date) --\> Create database cacti fault! >> /var/log/cacti_install.log
	exit
fi
echo $(date) --\> Creating database user cactiuser... >> /var/log/cacti_install.log
mysql -u root -pdbadmin -e "CREATE USER 'cactiuser'@'localhost' IDENTIFIED BY 'cactiuser';"
if [ $? = 0 ]; then
	echo $(date) --\> Created database user cactiuser! >> /var/log/cacti_install.log
else
	echo $(date) --\> Create database user cactiuser fault! >> /var/log/cacti_install.log
	exit
fi
echo $(date) --\> Granting database permission... >> /var/log/cacti_install.log
mysql -u root -pdbadmin -e 'GRANT ALL PRIVILEGES ON `cacti` . * TO 'cactiuser'@'localhost';'
if [ $? = 0 ]; then
	echo $(date) --\> Granted database permission! >> /var/log/cacti_install.log
else
	echo $(date) --\> Grant database permission fault! >> /var/log/cacti_install.log
	exit
fi
# import cacti database
echo $(date) --\> Importing cacti.sql... >> /var/log/cacti_install.log
mysql -u cactiuser -pcactiuser cacti < /var/www/html/cacti.sql
if [ $? = 0 ]; then
	echo $(date) --\> Imported cacti.sql! >> /var/log/cacti_install.log
else
	echo $(date) --\> Import cacti.sql fault! >> /var/log/cacti_install.log
	exit
fi
# import PLA database
echo $(date) --\> Importing pa.sql... >> /var/log/cacti_install.log
mysql -u cactiuser -pcactiuser cacti < /usr/src/cacti/cacti-plugin-arch/pa.sql
if [ $? = 0 ]; then
	echo $(date) --\> Imported pa.sql! >> /var/log/cacti_install.log
else
	echo $(date) --\> Import pa.sql fault! >> /var/log/cacti_install.log
	exit
fi
# setting folder permission
chown -R apache:apache /var/www/html/
/etc/init.d/httpd restart

# create crond job for cacti
if [ ! -f /etc/cron.d/cacti ]; then
	touch /etc/cron.d/cacti
	echo "*/5 * * * * apache php /var/www/html/poller.php >/dev/null 2>&1" > /etc/cron.d/cacti
	echo $(date) --\> Create cron for cacti! >> /var/log/cacti_install.log
else
	echo $(date) --\> /etc/cron.d/cacti is exist! no update! >> /var/log/cacti_install.log
fi

# install compile tools for compiling spine
echo $(date) --\> installing compile tools for compile spine... >> /var/log/cacti_install.log
yum install -y gcc-c++ libtool net-snmp-devel openssl-devel mysql mysql-devel
echo $(date) --\> installed compile tools for compile spine! >> /var/log/cacti_install.log

# download spine and patch
cd /usr/src/cacti
if [ ! -f ./cacti-spine-0.8.7g.tar.gz ];  then
	echo $(date) --\> downloading cacti-spine-0.8.7g.tar.gz... >> /var/log/cacti_install.log
	wget http://www.cacti.net/downloads/spine/cacti-spine-0.8.7g.tar.gz
	if [ $? = 0 ]; then
		echo $(date) --\> downloaded cacti-spine-0.8.7g.tar.gz! >> /var/log/cacti_install.log
	else
		rm -f cacti-spine-0.8.7g.tar.gz
		echo $(date) --\> download cacti-spine-0.8.7g.tar.gz fault! >> /var/log/cacti_install.log
		exit
	fi
else
	echo $(date) --\> cacti-spine-0.8.7g.tar.gz is exist! >> /var/log/cacti_install.log
fi
if [ ! -f ./unified_issues.patch ];  then
	echo $(date) --\> downloading unified_issues.patch... >> /var/log/cacti_install.log
	wget http://www.cacti.net/downloads/spine/patches/0.8.7g/unified_issues.patch
	if [ $? = 0 ]; then
		echo $(date) --\> downloaded unified_issues.patch! >> /var/log/cacti_install.log
	else
		rm -f unified_issues.patch
		echo $(date) --\> download unified_issues.patch fault! >> /var/log/cacti_install.log
		exit
	fi
else
	echo $(date) --\> unified_issues.patch is exist! >> /var/log/cacti_install.log
fi

# extract and patch spine-0.8.7g
echo $(date) --\> extracting cacti-spine-0.8.7g.tar.gz... >> /var/log/cacti_install.log
tar zxvf cacti-spine-0.8.7g.tar.gz 
if [ $? = 0 ]; then
	echo $(date) --\> extracted cacti-spine-0.8.7g.tar.gz! >> /var/log/cacti_install.log
else
	rm -rf cacti-0.8.7g
	echo $(date) --\> extract cacti-spine-0.8.7g.tar.gz fault! >> /var/log/cacti_install.log
	exit
fi
cd cacti-spine-0.8.7g 
echo $(date) --\> patching file unified_issues.patch... >> /var/log/cacti_install.log
patch -p1 -N < ../unified_issues.patch
if [ $? = 0 ]; then
	echo $(date) --\> patched file unified_issues.patch! >> /var/log/cacti_install.log
else
	echo $(date) --\> patch file unified_issues.patch fault! >> /var/log/cacti_install.log
	exit
fi

# compile spine 0.8.7g
echo $(date) --\> configuring spine 0.8.7g... >> /var/log/cacti_install.log
./configure 
if [ $? = 0 ]; then
	echo $(date) --\> configured spine 0.8.7g! >> /var/log/cacti_install.log
else
	echo $(date) --\> configured spine 0.8.7g fault! >> /var/log/cacti_install.log
	exit
fi
echo $(date) --\> making spine 0.8.7g... >> /var/log/cacti_install.log
make 
if [ $? = 0 ]; then
	echo $(date) --\> made spine 0.8.7g! >> /var/log/cacti_install.log
else
	echo $(date) --\> made spine 0.8.7g fault! >> /var/log/cacti_install.log
	exit
fi
echo $(date) --\> installing spine 0.8.7g... >> /var/log/cacti_install.log
make install 
if [ $? = 0 ]; then
	echo $(date) --\> installed spine 0.8.7g! >> /var/log/cacti_install.log
	cp /usr/local/spine/etc/spine.conf.dist  /usr/local/spine/etc/spine.conf
else
	echo $(date) --\> installed spine 0.8.7g fault! >> /var/log/cacti_install.log
fi

# install plugins for cacti 0.8.7g
cd /usr/src/cacti
# install settings v0.7-1
echo $(date) --\> installing settings... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:settings-v0.7-1.tgz -O settings.tgz
tar zxvf settings*.tgz -C /var/www/html/plugins
if [ -e /var/www/html/plugins/settings ];then
	echo $(date) --\> installed settings! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed settings fault! >> /var/log/cacti_install.log
fi
# install clog v1.6-1
echo $(date) --\> installing clog... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:clog-v1.6-1.tgz -O clog.tgz 
tar zxvf clog*.tgz -C /var/www/html/plugins 
if [ -e /var/www/html/plugins/clog ];then
	echo $(date) --\> installed clog! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed clog fault! >> /var/log/cacti_install.log
fi
# install monitor v1.2-1
echo $(date) --\> installing monitor... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:monitor-v1.2-1.tgz -O monitor.tgz
tar zxvf monitor*.tgz -C /var/www/html/plugins 
if [ -e /var/www/html/plugins/monitor ];then
	echo $(date) --\> installed monitor! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed monitor fault! >> /var/log/cacti_install.log
fi
# install realtime v0.43-1
echo $(date) --\> installing realtime... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:realtime-v0.43-1.tgz -O realtime.tgz
tar zxvf realtime*.tgz -C /var/www/html/plugins
mkdir /var/www/html/plugins/realtime/cache
if [ -e /var/www/html/plugins/realtime ];then
	echo $(date) --\> installed realtime! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed realtime fault! >> /var/log/cacti_install.log
fi
# install cycle v1.2-1
echo $(date) --\> installing cycle... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:cycle-v1.2-1.tgz -O cycle.tgz
tar zxvf cycle*.tgz -C /var/www/html/plugins
if [ -e /var/www/html/plugins/cycle ];then
	echo $(date) --\> installed cycle! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed cycle fault! >> /var/log/cacti_install.log
fi
# install thold v0.43
echo $(date) --\> installing thold... >> /var/log/cacti_install.log
wget http://cactiusers.org/downloads/thold.tar.gz 
tar zxvf thold*.tar.gz -C /var/www/html/plugins 
if [ -e /var/www/html/plugins/thold ];then
	echo $(date) --\> installed thold! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed thold fault! >> /var/log/cacti_install.log
fi
# install ntop v0.2-1
echo $(date) --\> install ntop... >> /var/log/cacti_install.log
yum install ntop -y
if [ $? = 0 ]; then
	ntop --set-admin-password=ntopadmin
	echo "/usr/bin/ntop > /dev/null 2>&1" >> /etc/rc.d/rc.local
	ntop&
	echo $(date) --\> installed ntop! >> /var/log/cacti_install.log
	echo $(date) --\> installing ntop... >> /var/log/cacti_install.log
	wget http://docs.cacti.net/_media/plugin:ntop-v0.2-1.tgz -O ntop.tgz 
	tar zxvf ntop*.tgz -C /var/www/html/plugins
	if [ -e /var/www/html/plugins/ntop ];then
		echo $(date) --\> installed ntop! >> /var/log/cacti_install.log
	else
		echo $(date) --\> installed ntop fault! >> /var/log/cacti_install.log
	fi
else
	echo $(date) --\> installed ntop fault! >> /var/log/cacti_install.log
fi
# install boost v4.3-1
echo $(date) --\> installing boost... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:boost-v4.3-1.tgz -O boost.tgz
tar zxvf boost*.tgz -C /var/www/html/plugins
if [ -e /var/www/html/plugins/boost ];then
	echo $(date) --\> installed boost! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed boost fault! >> /var/log/cacti_install.log
fi
# install discovery v1.1-1
echo $(date) --\> installing discovery... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:discovery-v1.1-1.tgz -O discovery.tgz
tar zxvf discovery*.tgz -C /var/www/html/plugins
if [ -e /var/www/html/plugins/discovery ];then
	echo $(date) --\> installed discovery! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed discovery fault! >> /var/log/cacti_install.log
fi
# install weathermap v0.97a
echo $(date) --\> installing weathermap... >> /var/log/cacti_install.log
yum install -y unzip
wget http://www.network-weathermap.com/files/php-weathermap-0.97a.zip
unzip php-weathermap-0.97a.zip -d /var/www/html/plugins/
if [ -e /var/www/html/plugins/weathermap ];then
	echo $(date) --\> installed weathermap! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed weathermap fault! >> /var/log/cacti_install.log
fi
# install flowview v0.6
echo $(date) --\> installing flowview... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:flowview-latest.tgz -O flowview.tgz
tar zxvf flowview*.tgz -C /var/www/html/plugins
mv -f /var/www/html/plugins/flowview* /var/www/html/plugins/flowview
if [ -e /var/www/html/plugins/flowview ];then
	echo $(date) --\> installed flowview! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed flowview fault! >> /var/log/cacti_install.log
fi
# install mactrack v2.9-1
echo $(date) --\> installing mactrack... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:mactrack-v2.9-1.tgz -O mactrack.tgz
tar zxvf mactrack*.tgz -C /var/www/html/plugins 
if [ -e /var/www/html/plugins/mactrack ];then
	echo $(date) --\> installed mactrack! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed mactrack fault! >> /var/log/cacti_install.log
fi
# install routerconfigs v0.3-1
echo $(date) --\> installing routerconfigs... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:routerconfigs-v0.3-1.tgz -O routerconfigs.tgz 
tar zxvf routerconfigs*.tgz -C /var/www/html/plugins 
mkdir /var/www/html/plugins/routerconfigs/backups
if [ -e /var/www/html/plugins/routerconfigs ];then
	echo $(date) --\> installed routerconfigs! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed routerconfigs fault! >> /var/log/cacti_install.log
fi
# install syslog v1.21-1
echo $(date) --\> installing syslog... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:syslog-v1.21-1.tgz -O syslog.tgz
tar zxvf syslog*.tgz -C /var/www/html/plugins
if [ -e /var/www/html/plugins/syslog ];then
	echo $(date) --\> installed syslog! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed syslog fault! >> /var/log/cacti_install.log
fi
# install aggregate v0.75
echo $(date) --\> installing aggregate... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:aggregate-v0.75.tgz -O aggregate.tgz
tar zxvf aggregate*.tgz -C /var/www/html/plugins
if [ -e /var/www/html/plugins/aggregate ];then
	echo $(date) --\> installed aggregate! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed aggregate fault! >> /var/log/cacti_install.log
fi
# install loginmod v1.0
echo $(date) --\> installing loginmod... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:loginmod-latest.tgz -O loginmod.tgz
tar zxvf loginmod*.tgz -C /var/www/html/plugins
mv -f /var/www/html/plugins/loginmod* /var/www/html/plugins/loginmod
if [ -e /var/www/html/plugins/loginmod ];then
	echo $(date) --\> installed loginmod! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed loginmod fault! >> /var/log/cacti_install.log
fi
# install docs v0.2
echo $(date) --\> installing docs... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:docs_v0.2.tar.gz -O docs.tar.gz
tar zxvf docs*.tar.gz -C /var/www/html/plugins 
mv -f /var/www/html/plugins/docs* /var/www/html/plugins/docs
if [ -e /var/www/html/plugins/docs ];then
	echo $(date) --\> installed docs! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed docs fault! >> /var/log/cacti_install.log
fi
# install ReportIt v0.73
echo $(date) --\> installing ReportIt... >> /var/log/cacti_install.log
wget http://nchc.dl.sourceforge.net/project/cacti-reportit/cacti-reportit/reportit_v073/reportit_v073.tar.gz -O reportit.tar.gz
tar zxvf reportit*.tar.gz -C /var/www/html/plugins 
if [ -e /var/www/html/plugins/reportit ];then
	echo $(date) --\> installed ReportIt! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed ReportIt fault! >> /var/log/cacti_install.log
fi
# install mobile v0.1
echo $(date) --\> installing mobile... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:mobile-latest.tgz -O mobile.tgz
tar zxvf mobile*.tgz -C /var/www/html/plugins 
mv -f /var/www/html/plugins/mobile* /var/www/html/plugins/mobile
if [ -e /var/www/html/plugins/mobile ];then
	echo $(date) --\> installed mobile! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed mobile fault! >> /var/log/cacti_install.log
fi
# install rrdclean v0.41
echo $(date) --\> installing rrdclean... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:rrdclean-v0.41.tgz -O rrdclean.tgz 
tar zxvf rrdclean*.tgz -C /var/www/html/plugins
mkdir -p /var/www/rra/backup
mkdir -p /var/www/rra/archive
if [ -e /var/www/html/plugins/rrdclean ];then
	echo $(date) --\> installed rrdclean! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed rrdclean fault! >> /var/log/cacti_install.log
fi
# install tools v0.3
echo $(date) --\> installing tools... >> /var/log/cacti_install.log
wget http://cactiusers.org/downloads/tools.tar.gz 
tar zxvf tools*.tar.gz -C /var/www/html/plugins
if [ -e /var/www/html/plugins/tools ];then
	echo $(date) --\> installed tools! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed tools fault! >> /var/log/cacti_install.log
fi
# install ssl v0.1
echo $(date) --\> installing ssl... >> /var/log/cacti_install.log
wget http://cactiusers.org/downloads/ssl.tar.gz
tar zxvf ssl*.tar.gz -C /var/www/html/plugins
if [ -e /var/www/html/plugins/ssl ];then
	echo $(date) --\> installed ssl! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed ssl fault! >> /var/log/cacti_install.log
fi
# install domains v0.1-1
echo $(date) --\> installing domains... >> /var/log/cacti_install.log
wget http://docs.cacti.net/_media/plugin:domains-v0.1-1.tgz -O domains.tgz
tar zxvf domains*.tgz -C /var/www/html/plugins
if [ -e /var/www/html/plugins/domains ];then
	echo $(date) --\> installed domains! >> /var/log/cacti_install.log
else
	echo $(date) --\> installed domains fault! >> /var/log/cacti_install.log
fi
# setting the plugins files's permission
chown -R apache:apache /var/www/html/

echo $(date) --\> All install finised! >> /var/log/cacti_install.log
