#!/bin/bash
rm -rf nginx-1.8.1
if [ ! -f nginx-1.8.1.tar.gz ];then
  wget http://nginx.org/download/nginx-1.8.1.tar.gz
fi
tar zxvf nginx-1.8.1.tar.gz
cd nginx-1.8.1
./configure --user=www \
--group=www \
--prefix=/opt/nginx \
--with-http_stub_status_module \
--without-http-cache \
--with-http_ssl_module \
--with-http_gzip_static_module
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
chmod 775 /opt/nginx/logs
chown -R www:www /opt/nginx/logs
chmod -R 775 /data/www
chown -R www:www /data/www
cd ..
cp -fR  config-nginx/* /opt/nginx/conf/
sed -i 's/worker_processes  2/worker_processes  '"$CPU_NUM"'/' /opt/nginx/conf/nginx.conf
chmod 755 /opt/nginx/sbin/nginx
#/opt/nginx/sbin/nginx
mv /opt/nginx/conf/nginx /etc/init.d/
chmod +x /etc/init.d/nginx
/etc/init.d/nginx start