#!/bin/bash
mkdir -p /opt/nginx_bak_`date +%Y%m%d`
cp /opt/nginx/etc/nginx.conf /opt/nginx/etc/nginx.conf`date +%Y%m%d%H%M%S`
cp -R  /opt/nginx/etc /opt/nginx_bak_`date +%Y%m%d`
tar zxvf zlib-1.2.8.tar.gz
tar zxvf pcre-8.33.tar.gz
tar zxvf openssl-1.0.2k.tar.gz
tar zxvf nginx-1.10.2.tar.gz
cd nginx-1.10.2
./configure --prefix=/opt/nginx --sbin-path=/opt/nginx/sbin/nginx --conf-path=/opt/nginx/etc/nginx.conf --error-log-path=/opt/nginx/log/nginx.log --pid-path=/opt/nginx/var/run/nginx.pid --lock-path=/opt/nginx/var/lock/nginx.lock --http-log-path=/opt/nginx/log/access.log --http-client-body-temp-path=/opt/nginx/client_temp --http-proxy-temp-path=/opt/nginx/proxy_temp --http-fastcgi-temp-path=/opt/nginx/fastcgi_temp --http-uwsgi-temp-path=/opt/nginx/uwsgi_temp --http-scgi-temp-path=/opt/nginx/scgi_temp --with-pcre=/root/nginx/pcre-8.33 --with-openssl=/root/nginx/openssl-1.0.2k --with-zlib=/root/nginx/zlib-1.2.8 --user=nginx --group=nginx --with-http_ssl_module --with-http_v2_module --with-http_gzip_static_module --with-file-aio --with-ipv6 --with-http_realip_module --with-http_gunzip_module --with-http_secure_link_module --with-http_stub_status_module
make && make install

cp /etc/init.d/nginx /opt/nginx_bak_`date +%Y%m%d`/nginx.sh.`date +%Y%m%d%H%M%S`
cat > /etc/init.d/nginx <<EOF
#!/bin/sh
. /etc/rc.d/init.d/functions

if [ -f /etc/sysconfig/nginx ]; then
    . /etc/sysconfig/nginx
fi

prog=nginx
nginx=\${NGINX-/opt/nginx/sbin/nginx}
conffile=\${CONFFILE-/opt/nginx/etc/nginx.conf}
lockfile=\${LOCKFILE-/opt/nginx/var/lock/nginx.lock}
pidfile=\${PIDFILE-/opt/nginx/var/run/nginx.pid}
SLEEPMSEC=100000
RETVAL=0

start() {
    echo -n \$"Starting \$prog: "

    daemon --pidfile=\${pidfile} \${nginx} -c \${conffile}
    RETVAL=\$?
    echo
    [ \$RETVAL = 0 ] && touch \${lockfile}
    return \$RETVAL
}

stop() {
    echo -n \$"Stopping \$prog: "
    killproc -p \${pidfile} \${prog}
    RETVAL=\$?
    echo
    [ \$RETVAL = 0 ] && rm -f \${lockfile} \${pidfile}
}

reload() {
    echo -n \$"Reloading \$prog: "
    killproc -p \${pidfile} \${prog} -HUP
    RETVAL=\$?
    echo
}

upgrade() {
    oldbinpidfile=\${pidfile}.oldbin

    configtest -q || return 6
    echo -n \$"Staring new master \$prog: "
    killproc -p \${pidfile} \${prog} -USR2
    RETVAL=\$?
    echo
    /bin/usleep \$SLEEPMSEC
    if [ -f \${oldbinpidfile} -a -f \${pidfile} ]; then
        echo -n \$"Graceful shutdown of old \$prog: "
        killproc -p \${oldbinpidfile} \${prog} -QUIT
        RETVAL=\$?
        echo
    else
        echo \$"Upgrade failed!"
        return 1
    fi
}

configtest() {
    if [ "\$#" -ne 0 ] ; then
        case "\$1" in
            -q)
                FLAG=\$1
                ;;
            *)
                ;;
        esac
        shift
    fi
    \${nginx} -t -c \${conffile} \$FLAG
    RETVAL=\$?
    return \$RETVAL
}

rh_status() {
    status -p \${pidfile} \${nginx}
}

# See how we were called.
case "\$1" in
    start)
        rh_status >/dev/null 2>&1 && exit 0
        start
        ;;
    stop)
        stop
        ;;
    status)
        rh_status
        RETVAL=\$?
        ;;
    restart)
        configtest -q || exit \$RETVAL
        stop
        start
        ;;
    upgrade)
        upgrade
        ;;
    condrestart|try-restart)
        if rh_status >/dev/null 2>&1; then
            stop
            start
        fi
        ;;
    force-reload|reload)
        reload
        ;;
    configtest)
        configtest
        ;;
    *)
        echo \$"Usage: \$prog {start|stop|restart|condrestart|try-restart|force-reload|upgrade|reload|status|help|configtest}"
        RETVAL=2
esac

exit \$RETVAL
EOF
chmod 777 /etc/init.d/nginx
mkdir -p /opt/nginx/var/lock/
echo ok