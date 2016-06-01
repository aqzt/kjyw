#!/bin/bash

useradd -s /sbin/nologin nagios
mkdir /usr/local/nagios
chown -R nagios.nagios /usr/local/nagios
##yum -y install vim gcc gcc-c++ make perl  perl* perl-devel libpng-devel libxml2 libxml2-devel mysql-devel libart_lgpl-devel pango-devel* cairo-devel
yum -y install vim gcc gcc-c++ make perl-Time-HiRes perl-devel libpng-devel libxml2 libxml2-devel mysql-devel libart_lgpl-devel pango-devel* cairo-devel
cp -rf /usr/lib64/libpng* /usr/lib/
tar -xzf nagios-4.1.1.tar.gz
cd nagios-4.1.1
./configure --prefix=/usr/local/nagios
make all
make install
make install-init
make install-commandmode
make install-config
cd
tar -xzf nagios-plugins-2.1.1.tar.gz
cd nagios-plugins-2.1.1
./configure --prefix=/usr/local/nagios
make
make install
cd
#之前旧版装nagios汉化包
#tar -xvf nagios-cn-3.2.0.tar.bz2
#cd nagios-cn-3.2.0
#./configure
#make all
#make install
#cd
tar xzf httpd-2.0.63.tar.gz
cd httpd-2.0.63
./configure --prefix=/usr/local/apache2
make
make install
cd
tar -xzf php-5.3.2.tar.gz
cd php-5.3.2
./configure --prefix=/usr/local/php --with-apxs2=/usr/local/apache2/bin/apxs --with-zlib --with-gd
make
make install
cd
tar -xzf rrdtool-1.4.5.tar.gz
cd rrdtool-1.4.5
./configure --prefix=/usr/local/rrdtool
make
make install
cd
tar -xzf pnp4nagios-0.6.25.tar.gz
cd pnp4nagios-0.6.25
./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-rrdtool=/usr/local/rrdtool/bin/rrdtool --with-perfdata-dir=/usr/local/nagios/share/perfdata
##./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-rrdtool=/usr/bin/rrdtool --with-perfdata-dir=/usr/local/nagios/share/perfdata
make all
make install
make install-config
make install-init  


#/usr/bin/htpasswd -c /usr/local/nagios/etc/htpasswd Arthur
#/etc/init.d/nagios start
#/usr/bin/htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin


