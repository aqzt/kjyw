#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
IP=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

#read config
. config

#init color function
. scripts/showcolor.sh

#init
. init.sh

#
# function to install nginx
# must specify $1
# $1 can be "with_php" or "without_php"
#
Install_Nginx(){
    is_install $NGINX_PREFIX d
    if [ $checked_env == 0 ];then
        check_env
        $checked_env == 1
    fi
    make_dir $NGINX_ROOT
    . scripts/nginx.sh
    nginx_download
    nginx_install
    nginx_main_conf
    nginx_fastcgi_params
    #\cp -rf conf/nginx/conf_example $NGINX_PREFIX/conf/
    make_dir $NGINX_PREFIX/conf/vhosts
    nginx_test_conf
    nginx_init_script "/etc/init.d/nginx"
    chmod a+x /etc/init.d/nginx
    if [ $1 == "without_php" ];then
        if [ ! -f $NGINX_ROOT/test.html ];then
            echo "It works!" >$NGINX_ROOT/test.html
        fi
    else
        if [ ! -f $NGINX_ROOT/test.php ];then
            echo "<?phpinfo();?>" >$NGINX_ROOT/test.php
        fi
    fi
    chkconfig --add nginx
    chkconfig nginx on
    clear_packages_dir
}

#
# function to install MySQL
# it's a simple function :)
#
Install_MySQL(){
    is_install mysql c
    is_install $MYSQL_PREFIX d
    is_install /etc/my.cnf f

    check_env
    . scripts/mysql.sh
    mysql_download
    mysql_install
    chkconfig --add mysqld
    chkconfig mysqld on
    clear_packages_dir
}

Install_MySQL_innodb(){
    is_install mysql c
    is_install $MYSQL_PREFIX d
    is_install /etc/my.cnf f

    check_env
    . scripts/mysql_innodb.sh
    mysql_download
    mysql_install
    chkconfig --add mysqld
    chkconfig mysqld on
    clear_packages_dir
}
#
# function to install Nginx and PHP
#
Install_PHP(){
    if [ "$PHP_CACHE"x == "x" ];then
        select_php_cache
    fi
    is_install php c
    is_install $PHP_PREFIX d

    check_env
    . scripts/php.sh
    php_lib_download
    php_download
    php_lib_install
    if [ ! -d $MYSQL_PREFIX ];then
        yum -y install mysql mysql-devel
        php_install without_mysql
    else
        php_install with_mysql
    fi
    php_ext_install
    php_config
    php_cache $PHP_CACHE
    php_fastcgi_init_script
    chmod a+x /etc/init.d/fastcgi
    chkconfig --add fastcgi
    chkconfig fastcgi on
    clear_packages_dir
}

#
# function to install lnmp
#
Install_lnmp(){
    select_php_cache
    Install_MySQL
    Install_PHP
    Install_Nginx with_php
    optimze_system
    lnmp_complete
    clear_packages_dir
}

CHECKED_ENV=0
copyright



