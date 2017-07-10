php_lib_download(){
    for i in "$PHP_LIBICONV_VERSION.tar.gz" "$PHP_LIBMCRYPT_VERSION.tar.gz" "$PHP_MHASH_VERSION.tar.gz" "$PHP_MCRYPT_VERSION.tar.gz" 
    do
        if [ -s packages/$i ]; then
            echo "$i [found]"
        else
            echo "Error: $i not found!!!download now......"
            wget http://www.paopao8.com/docs/soft/lnmp/packages/$i -P packages/
        fi
    done
}
php_lib_install(){
    cd packages/
    tar zxvf $PHP_LIBICONV_VERSION.tar.gz 
    cd $PHP_LIBICONV_VERSION
    ./configure --prefix=/usr/local && make && make install
    cd ..


    tar zxvf $PHP_LIBMCRYPT_VERSION.tar.gz
    cd $PHP_LIBMCRYPT_VERSION/
    ./configure --prefix=/usr && make && make install

    cd libltdl/
    ./configure --enable-ltdl-install
    make && make install
    cd ../../

    tar zxvf $PHP_MHASH_VERSION.tar.gz
    cd $PHP_MHASH_VERSION
    ./configure --prefix=/usr && make && make install
    ldconfig
    cd ../

    ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
    ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
    ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
    ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
    ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a
    ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la
    ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so
    ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
    ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1

    #ln -sf lib
    ln -sf /usr/lib64/libjpeg.so /usr/lib/
    ln -sf /usr/lib64/libpng.so /usr/lib/
    ln -sf /usr/lib64/libldap* /usr/lib/


    tar zxvf $PHP_MCRYPT_VERSION.tar.gz
    cd $PHP_MCRYPT_VERSION
    /sbin/ldconfig
    ./configure --prefix=/usr && make && make install
    cd ..

    echo "/usr/lib" >> /etc/ld.so.conf
    echo "/usr/local/lib" >> /etc/ld.so.conf
    ldconfig

    cd ../
}

php_download(){
    for i in "$PHP_VERSION.tar.gz" \
             "$PHP_FPM_VERSION.diff.gz" \
             "$PHP_SUHOSIN_VERSION.patch.gz" \
             "$PHP_MAX_INPUT_VARS.patch.gz" \
             "$PHP_APC_VERSION.tgz" \
             "$PHP_EAC_VERSION.tar.bz2" \
             "$PHP_LIB_VERSION.tar.gz" \
             "$PHP_MC_EXT_VERSION.tgz" \
             "$PHP_MCD_EXT_VERSION.tgz" \
             "$PHP_MCD_VERSION.tar.gz" \
             "$PHP_LIBMC_VERSION.tar.gz" \
             "$PHP_IMAGICK_SOFT.tar.gz" \
             "$PHP_IMAGICK_VERSION.tgz"
    do
        if [ -s packages/$i ]; then
            echo "$i [found]"
        else
            echo "Error: $i not found!!!download now......"
            wget http://www.paopao8.com/docs/soft/lnmp/packages/$i -P packages/
        fi
    done
}

php_fastcgi_init_script(){
    cat > /etc/init.d/fastcgi <<EOF
#
# chkconfig: - 70 88
# description: this script is used for php-cgi
#
#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ \$(id -u) != "0" ]; then
    echo "Error: You must be root to run this script!\n"
    exit 1
fi

PHPCGI=$PHP_PREFIX/sbin/php-fpm

function_start()
{
    echo -en "\033[32;49;1mStarting php-cgi......\n"
    echo -en "\033[39;49;0m"  
    \$PHPCGI start
    printf "php-cgi is the successful started!\n"
}

function_stop()
{
    echo -en "\033[32;49;1mStoping php-cgi......\n"
    echo -en "\033[39;49;0m"  
    \$PHPCGI stop
    printf "php-cgi is the successful stoped!\n"
}

function_reload()
{
    echo -en "\033[32;49;1mReloading php-cgi......\n"
    echo -en "\033[39;49;0m"  
    \$PHPCGI reload
    printf "php-cgi is the successful reloaded!\n"
}

function_restart()
{
    echo -en "\033[32;49;1mRestarting php-cgi......\n"
    echo -en "\033[39;49;0m"  
    \$PHPCGI restart
    printf "php-cgi is the successful restarted!\n"
}

function_kill()
{
    killall php-cgi
}

if [ "\$1" = "start" ]; then
    function_start
elif [ "\$1" = "stop" ]; then
    function_stop
elif [ "\$1" = "reload" ]; then
    function_reload
elif [ "\$1" = "restart" ]; then
    function_restart
elif [ "\$1" = "kill" ]; then
    function_kill
else
    echo -en "\033[32;49;1m Usage: fastcgi {start|stop|reload|restart|kill}\n"
    echo -en "\033[39;49;0m"
fi
EOF
}

php_fpm_conf() {
    cat > $PHP_PREFIX/etc/php-fpm.conf <<EOF
<?xml version="1.0" ?>
<configuration>

	All relative paths in this config are relative to php's install prefix

	<section name="global_options">

		Pid file
		<value name="pid_file">$PHP_PREFIX/logs/php-fpm.pid</value>

		Error log file
		<value name="error_log">$PHP_PREFIX/logs/php-fpm.log</value>

		Log level
		<value name="log_level">notice</value>

		When this amount of php processes exited with SIGSEGV or SIGBUS ...
		<value name="emergency_restart_threshold">10</value>

		... in a less than this interval of time, a graceful restart will be initiated.
		Useful to work around accidental curruptions in accelerator's shared memory.
		<value name="emergency_restart_interval">1m</value>

		Time limit on waiting child's reaction on signals from master
		<value name="process_control_timeout">5s</value>

		Set to 'no' to debug fpm
		<value name="daemonize">yes</value>

	</section>

	<workers>

		<section name="pool">

			Name of pool. Used in logs and stats.
			<value name="name">default</value>

			Address to accept fastcgi requests on.
			Valid syntax is 'ip.ad.re.ss:port' or just 'port' or '/path/to/unix/socket'
			<value name="listen_address">127.0.0.1:9000</value>

			<value name="listen_options">

				Set listen(2) backlog
				<value name="backlog">-1</value>

				Set permissions for unix socket, if one used.
				In Linux read/write permissions must be set in order to allow connections from web server.
				Many BSD-derrived systems allow connections regardless of permissions.
				<value name="owner"></value>
				<value name="group"></value>
				<value name="mode">0666</value>
			</value>

			Additional php.ini defines, specific to this pool of workers.
			<value name="php_defines">
				<value name="sendmail_path">/usr/sbin/sendmail -t -i</value>	
		    	<value name="display_errors">0</value>								
			</value>

			Unix user of processes
			<value name="user">$PHP_FPM_USER</value>				

			Unix group of processes
		    <value name="group">$PHP_FPM_GROUP</value>	

			Process manager settings
			<value name="pm">

				Sets style of controling worker process count.
				Valid values are 'static' and 'apache-like'
				<value name="style">static</value>

				Sets the limit on the number of simultaneous requests that will be served.
				Equivalent to Apache MaxClients directive.
				Equivalent to PHP_FCGI_CHILDREN environment in original php.fcgi
				Used with any pm_style.
				<value name="max_children">$PHP_FPM_MAX_CHILDREN</value>

				Settings group for 'apache-like' pm style
				<value name="apache_like">

					Sets the number of server processes created on startup.
					Used only when 'apache-like' pm_style is selected
					<value name="StartServers">20</value>

					Sets the desired minimum number of idle server processes.
					Used only when 'apache-like' pm_style is selected
					<value name="MinSpareServers">5</value>

					Sets the desired maximum number of idle server processes.
					Used only when 'apache-like' pm_style is selected
					<value name="MaxSpareServers">35</value>

				</value>

			</value>

			The timeout (in seconds) for serving a single request after which the worker process will be terminated
			Should be used when 'max_execution_time' ini option does not stop script execution for some reason
			'0s' means 'off'
			<value name="request_terminate_timeout">30s</value>

			The timeout (in seconds) for serving of single request after which a php backtrace will be dumped to slow.log file
			'0s' means 'off'
			<value name="request_slowlog_timeout">5s</value>

			The log file for slow requests
			<value name="slowlog">logs/slow.log</value>

			Set open file desc rlimit
			<value name="rlimit_files">65535</value>

			Set max core size rlimit
			<value name="rlimit_core">0</value>

			Chroot to this directory at the start, absolute path
			<value name="chroot"></value>

			Chdir to this directory at the start, absolute path
			<value name="chdir"></value>

			Redirect workers' stdout and stderr into main error log.
			If not set, they will be redirected to /dev/null, according to FastCGI specs
			<value name="catch_workers_output">yes</value>

			How much requests each process should execute before respawn.
			Useful to work around memory leaks in 3rd party libraries.
			For endless request processing please specify 0
			Equivalent to PHP_FCGI_MAX_REQUESTS
			<value name="max_requests">$PHP_FPM_MAX_REQUESTS</value>

			Comma separated list of ipv4 addresses of FastCGI clients that allowed to connect.
			Equivalent to FCGI_WEB_SERVER_ADDRS environment in original php.fcgi (5.2.2+)
			Makes sense only with AF_INET listening socket.
			<value name="allowed_clients">127.0.0.1</value>

			Pass environment variables like LD_LIBRARY_PATH
			All \$VARIABLEs are taken from current environment
			<value name="environment">
				<value name="HOSTNAME">\$HOSTNAME</value>
				<value name="PATH">/usr/local/bin:/usr/bin:/bin</value>
				<value name="TMP">/tmp</value>
				<value name="TMPDIR">/tmp</value>
				<value name="TEMP">/tmp</value>
				<value name="OSTYPE">\$OSTYPE</value>
				<value name="MACHTYPE">\$MACHTYPE</value>
				<value name="MALLOC_CHECK_">2</value>
			</value>

		</section>

	</workers>

</configuration>
EOF
}
php_install() {

    cd packages/

    #gzip -d $PHP_SUHOSIN_VERSION.patch.gz
    tar zxvf $PHP_VERSION.tar.gz
    gzip -cd $PHP_FPM_VERSION.diff.gz | patch -d $PHP_VERSION -p1
    cd $PHP_VERSION
    #patch -p 1 -i ../$PHP_SUHOSIN_VERSION.patch
    patch -p1 < ../php-5.2.17-max-input-vars.patch

    if [ $1 == "with_mysql" ];then
        $PHP_COMPILE_COMMAND_WITH_MYSQL
        check_sucess php $?
    else
        machine=`uname -m`
        if [ $machine == "x86_64" ];then
            export LDFLAGS=-L/usr/lib64/mysql
        fi
        $PHP_COMPILE_COMMAND_WITHOUT_MYSQL
        check_sucess php $?
    fi

    make ZEND_EXTRA_LIBS='-liconv' -j8
    make install
    cp -Rf php.ini-dist $PHP_PREFIX/etc/php.ini
    cd ../../

    php_fpm_conf
}

php_ext_install() {

    cd packages/
    tar zxvf $PHP_LIB_VERSION.tar.gz
    cd $PHP_LIB_VERSION
    ./configure && make -j9 && make install
    cd ..

    tar zxvf $PHP_MCD_VERSION.tar.gz
    cd $PHP_MCD_VERSION
    ./configure --prefix=$PHP_MCD_PREFIX
    make -j9 && make install
    cd ..

    # php mecache.so
    tar zxvf $PHP_MC_EXT_VERSION.tgz
    cd $PHP_MC_EXT_VERSION
    $PHP_PREFIX/bin/phpize
    ./configure --with-php-config=$PHP_PREFIX/bin/php-config
    make -j8 && make install
    cd ..
    # php memached.so
    tar zxvf $PHP_LIBMC_VERSION.tar.gz
    cd $PHP_LIBMC_VERSION
    ./configure --prefix=$PHP_LIBMC_PREFIX --with-memcached=$PHP_MCD_PREFIX/bin/memcached
    make -j9 && make install
    cd ..

    tar zxvf $PHP_MCD_EXT_VERSION.tgz
    cd $PHP_MCD_EXT_VERSION
    $PHP_PREFIX/bin/phpize
    ./configure --with-php-config=$PHP_PREFIX/bin/php-config --with-libmemcached-dir=$PHP_LIBMC_PREFIX
    make -j9 && make install
    cd ../

    # imagic
    tar zxvf $PHP_IMAGICK_SOFT.tar.gz
    cd $PHP_IMAGICK_SOFT_VERSION/   
    $PHP_IMAGICK_COMPILE_COMMAND
    make -j9 && make install
    cd ..

    tar zxvf $PHP_IMAGICK_VERSION.tgz
    cd $PHP_IMAGICK_VERSION/
    $PHP_PREFIX/bin/phpize 
    ./configure --with-php-config=$PHP_PREFIX/bin/php-config
    make -j9 && make install

    cd ../../
}
# % config php % 
php_config() {
    sed -i '/expose_php/ {s/On/Off/g};/magic_quo tes_gpc/ {s/On/Off/g};/upload_max_filesize/ {s/.*/upload_max_filesize = 10M/};/output_buffering/ {s/Off/On/g}' $PHP_PREFIX/etc/php.ini
    sed -i 's/error_reporting = E_ALL \& ~E_NOTICE/error_reporting = E_WARNING \& E_ERROR/g' $PHP_PREFIX/etc/php.ini
    sed -i '/display_errors/ {s/On/Off/g};/log_errors/ {s/Off/On/g};/short_open_tag/ {s/Off/On/g}' $PHP_PREFIX/etc/php.ini
    sed -i "s#;error_log = filename#error_log = /tmp/php-error.log#g" $PHP_PREFIX/etc/php.ini
    sed -i "s#;always_populate_raw_post_data = On#always_populate_raw_post_data = On#g" $PHP_PREFIX/etc/php.ini

    cat >>$PHP_PREFIX/etc/php.ini<<EOF
extension_dir = "$PHP_PREFIX/lib/php/extensions/no-debug-non-zts-20060613/"
extension = "memcache.so"
;extension = "memcached.so"
extension = "imagick.so"
EOF
}

#function to install apc
install_apc(){
    cd packages/
    tar zxvf $PHP_APC_VERSION.tgz
    cd $PHP_APC_VERSION
    $PHP_PREFIX/bin/phpize
    ./configure \
    --enable-apc \
    --enable-apc-mmap \
    --with-php-config=$PHP_PREFIX/bin/php-config
    make -j8 && make install
    cd ../../
    # apc php.ini
    cat >>$PHP_PREFIX/etc/php.ini<<EOF
extension = "apc.so"
apc.enabled=1
apc.shm_segments=1
apc.shm_size=128
apc.ttl=7200
apc.user_ttl=7200
apc.num_files_hint=1024
apc.mmap_file_mask="/tmp/apc.XXXXXX"
apc.enable_cli=1
EOF
}

install_xcache(){
    cd packages/
    tar zxvf $PHP_XCACHE_VERSION.tar.gz
    tar zxvf $PHP_ZEND_VERSION.tar.gz
    mkdir -p /usr/local/Zend/
    cp $PHP_ZEND_VERSION/data/5_2_x_comp/ZendOptimizer.so /usr/local/Zend/
    cd $PHP_XCACHE_VERSION
    $PHP_PREFIX/bin/phpize
    ./configure -with-php-config=/usr/local/php-5.2.17/bin/php-config -enable-xcache -enable-xcache-coverager -enable-inline-optimization -disable-debug
    make -j8 && make install
    cp -R htdocs /data/www/wwwroot/
    mkdir -p /tmp/xcache
    
    cd ../../
    # apc php.ini
    cat >>$PHP_PREFIX/etc/php.ini<<EOF
extension = "xcache.so"
xcache.admin.auth = On
xcache.admin.user = "admin"
xcache.admin.pass = "5f4dcc3b5aa765d61d8327deb882cf99"
xcache.size         = 32M
xcache.shm_scheme   = "mmap"
xcache.count        = 4
xcache.slots        = 8K
xcache.ttl          = 0
xcache.gc_interval  = 0
xcache.var_size     = 16M
xcache.var_count    = 1
xcache.var_slots    = 8K
xcache.var_ttl      = 0
xcache.var_maxttl   = 0
xcache.var_gc_interval =     300
xcache.test         = Off
xcache.readonly_protection = Off
xcache.mmap_path    =   "/dev/zero"
xcache.coredump_directory =   ""
xcache.cacher       = On
xcache.stat         = On
xcache.optimizer    = Off
[xcache.coverager]
xcache.coverager    = On
xcache.coveragedump_directory = "/tmp/xcache"
zend_optimizer.optimization_level=1023
zend_optimizer.encoder_loader=1
zend_extension="/usr/local/Zend/ZendOptimizer.so"
EOF
}

#function to install ea
install_ea(){
    cd packages/
    tar jxvf $PHP_EAC_VERSION.tar.bz2 
    cd $PHP_EAC_VERSION
    $PHP_PREFIX/bin/phpize
    ./configure --enable-eaccelerator=shared --with-php-config=$PHP_PREFIX/bin/php-config
    make && make install
    cd ../../

    # ea php.ini
    make_dir "/usr/local/eaccelerator_cache"
    chmod a+w /usr/local/eaccelerator_cache

    cat >>$PHP_PREFIX/etc/php.ini<<EOF
extension = "eaccelerator.so"
eaccelerator.shm_size="64"
eaccelerator.cache_dir="/usr/local/eaccelerator_cache"
eaccelerator.enable="1"
eaccelerator.optimizer="1"
eaccelerator.check_mtime="1"
eaccelerator.debug="0"
eaccelerator.filter=""
eaccelerator.shm_max="0"
eaccelerator.shm_ttl="3600"
eaccelerator.shm_prune_period="3600"
eaccelerator.shm_only="0"
eaccelerator.compress="1"
eaccelerator.compress_level="9"
EOF
}

# % php cache %
php_cache() {    
    if [ $1 == "a" ];then
        install_apc
    elif [ $1 == "c" ];then
        install_xcache
    else
        install_ea
    fi 
}


