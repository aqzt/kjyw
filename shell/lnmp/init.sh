#!/bin/bash

copyright(){
    clear
    color grn
    cat << EOF
+--------------------------------------------------------------------------------+
|         === Welcome to lnmp for CentOS/RHEL    Installation! ===               |
+--------------------------------------------------------------------------------+
|                    This Installation Released by WWW .                         |
+--------------------------------------------------------------------------------+
|                           Easy to install lnmp!                                |
+--------------------------------------------------------------------------------+
|            Copyright: (C) 2012 WWW   Inc. All rights reserved.                 |
+--------------------------------------------------------------------------------+
EOF

    color res
    read -p "Now, I'll install lnmp, Press Enter to continue: " lnmp
    case "$lnmp" in
    '')
        show_option
    ;;
    *)
        exit 0
    ;;
    esac
}
select_php_cache(){
    cat << EOF
Which php cache module you want to install:
    (A): APC;
    (C): XCACHE;
    (E): Eaccelerator;
EOF
    read -p "Please select a php cache module (A,E,C Default: A): > " PHP_CACHE
    case "$PHP_CACHE" in
    ""|A|a)
        PHP_CACHE="a"
    ;;
    E|e)
        PHP_CACHE="e"
    ;;
    C|c)
        PHP_CACHE="c"
    ;;
    *)
        select_php_cache;
    ;;
    esac
}

show_option(){
    cat << EOF
Install Option:
    (N): Only compile and install Nginx;
    (M): Only compile and install MySQL;
    (I): Only compile and install MySQL innodb;
    (P): Only compile and install PHP;
    (A): Compile and install lnmp(Nginx+MySQL+PHP);
    (Q): Quit;
EOF
    read -p "Please select an option (N,M,P,A,Q Default: A): > " OPTION
    case "$OPTION" in
    ""|A|a)
        Install_lnmp
        lnmp_complete lnmp
        exit 0;
    ;;
    M|m)
        Install_MySQL
        lnmp_complete mysql
        exit 0;
    ;;
    I|i)
        Install_MySQL_innodb
        lnmp_complete mysql
        exit 0;
    ;;
    P|p)
        Install_PHP
        lnmp_complete php
        exit 0;
    ;;
    N|n)
        Install_Nginx without_php
        lnmp_complete nginx
        exit 0;
    ;;
    Q|q)
        exit 0;
    ;;
    *)
        show_option;
    ;;
    esac
}

check_env(){
    #install rpms
    if [ $CHECKED_ENV == 0 ];then
        yum -y install dialog ntp vim-enhanced vixie-cron gcc gcc-c++ gcc-g77 flex bison autoconf automake glibc \
                   glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel libtool* zlib-devel \
                   libxml2-devel libjpeg-devel libpng-devel libtiff-devel fontconfig-devel freetype-devel \
                   libXpm-devel gettext-devel curl curl-devel pam-devel e2fsprogs-devel krb5-devel libidn \
                   libidn-devel openssl openssl-devel openldap openldap-devel \
                   nss_ldap openldap-clients openldap-servers php-gmp gmp gmp* patch
        CHECKED_ENV=1
        sleep 2
    fi
    clear
}

make_dir(){
    if [ ! -d $1 ];then
        mkdir -p $1
    fi
}

clear_packages_dir(){
    echo "find"
    #find packages/* -type d|xargs rm -rf
    #find packages/ -name "*.patch"|xargs rm -rf
}

is_install(){
    if [ "$CONTINUE" == "a" ];then
        return
    fi
    if [ "$2"x == "x" ];then
        echo "error!"
        exit 1;
    fi
    if [ $2 == "d" ];then
        if [ -d $1 ];then
            read -p "$1 already exists, Continue? (y/n/a(yes to all)): " CONTINUE
        else
            CONTINUE="y"
        fi
    elif [ $2 == "c" ];then
        command -v $1 >/dev/null && read -p "$1 already exists, Continue? (y/n/a(yes to all)): " CONTINUE || CONTINUE="y"
    elif [ $2 == "f" ];then
        if [ -f $1 ];then
            read -p "$1 already exists, Continue? (y/n/a(yes to all)): " CONTINUE
        else
            CONTINUE="y"
        fi
    fi
    case "$CONTINUE" in
    y)
    ;;
    n)
        exit 0;
    ;;
    a)
    ;;
    *)
        is_install $1 $2;
    ;;
    esac
}
optimze_system(){
    . scripts/tuning/network.sh
    . scripts/tuning/tuning.sh
}
lnmp_complete(){
    if [[ $1 == "lnmp" ]];then
        /etc/rc.d/init.d/mysqld start
        /etc/init.d/nginx start
        /etc/init.d/fastcgi start
        color red
        echo "Congratulations! lnmp configuration complete!"
        color dred
        echo "You can visit http://$IP/test.php"
        color dgrn
        cat << EOF
+--------------------------------------------------------------------------------+
|                  === Installation Document Description ===                     |
+--------------------------------------------------------------------------------+
      MySQL SCRIPTS      :         /etc/init.d/mysqld start
      NGINX SCRIPTS      :         /etc/init.d/nginx start
      FASTCGI SCRIPTS    :         /etc/init.d/fastcgi start
      MySQL DATAPATH     :         $MYSQL_DATA_DIR/$MYSQL_PORT
      MYSQL PATH         :         $MYSQL_PREFIX
      MYSQL LISTEN PORT  :         $MYSQL_PORT
      PHP PATH           :         $PHP_PREFIX
      PHP CONFIG         :         $PHP_PREFIX/etc
      NGINX PATH         :         $NGINX_PREFIX
      NGINX LISTEN PORT  :         $NGINX_PORT
      NGINX DOCUMENTROOT :         $NGINX_ROOT
+--------------------------------------------------------------------------------+
|    Easy to install lnmp!   Have Fun^_^!     http://www.paopao8.com             |
+--------------------------------------------------------------------------------+
EOF
        echo -en "\033[39;49;0m"
   elif [[ $1 == "mysql" ]];then
        /etc/rc.d/init.d/mysqld start
        color red
        echo "Congratulations! MySQL configuration complete!"
        color dgrn
        cat << EOF
+--------------------------------------------------------------------------------+
|                  === Installation Document Description ===                     |
+--------------------------------------------------------------------------------+
      MySQL SCRIPTS      :         /etc/init.d/mysqld start
      MySQL DATAPATH     :         $MYSQL_DATA_DIR/$MYSQL_PORT
      MYSQL PATH         :         $MYSQL_PREFIX
      MYSQL LISTEN PORT  :         $MYSQL_PORT
+--------------------------------------------------------------------------------+
|    Easy to install lnmp!   Have Fun^_^!     http://www.paopao8.com             |
+--------------------------------------------------------------------------------+
EOF
        echo -en "\033[39;49;0m"
    elif [[ $1 == "php" ]];then
        /etc/init.d/fastcgi start
        color red
        echo "Congratulations! PHP configuration complete!"
        color dgrn
        cat << EOF
+--------------------------------------------------------------------------------+
|                  === Installation Document Description ===                     |
+--------------------------------------------------------------------------------+
      FASTCGI SCRIPTS    :         /etc/init.d/fastcgi start
      PHP PATH           :         $PHP_PREFIX
      PHP CONFIG         :         $PHP_PREFIX/etc
+--------------------------------------------------------------------------------+
|    Easy to install lnmp!   Have Fun^_^!     http://www.paopao8.com             |
+--------------------------------------------------------------------------------+
EOF
        echo -en "\033[39;49;0m"
    elif [[ $1 == "nginx" ]];then
        /etc/init.d/nginx start
        if [ $NGINX_PORT == "80" ];then
            URL=$IP
        else
            URL=$IP:$NGINX_PORT
        fi
        color red
        echo "Congratulations! Nginx configuration complete!"
        color dred
        echo "You can visit http://$URL/test.html"
        color dgrn
        cat << EOF
+--------------------------------------------------------------------------------+
|                  === Installation Document Description ===                     |
+--------------------------------------------------------------------------------+
      NGINX SCRIPTS      :         /etc/init.d/nginx start
      NGINX PATH         :         $NGINX_PREFIX
      NGINX LISTEN PORT  :         $NGINX_PORT
      NGINX DOCUMENTROOT :         $NGINX_ROOT
+--------------------------------------------------------------------------------+
|    Easy to install lnmp!   Have Fun^_^!     http://www.paopao8.com             |
+--------------------------------------------------------------------------------+
EOF
        echo -en "\033[39;49;0m"
    fi
}

check_sucess(){
    if [ $2 == "0" ];then
        return
    else
        color red
        echo "Some error occurred when install $1"
        echo -en "\033[39;49;0m"
        exit 1
    fi
}



