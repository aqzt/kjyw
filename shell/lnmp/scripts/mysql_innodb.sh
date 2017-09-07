mysql_download(){
    if [ -s packages/$MYSQL_VERSION.tar.gz ]; then
        echo "$MYSQL_VERSION [found]"
    else
        echo "Error: $MYSQL_VERSION not found!!!download now......"
        wget http://www.paopao8.com/docs/soft/lnmp/packages/$MYSQL_VERSION.tar.gz -P packages/
    fi
}

mysql_my_cnf(){
    cat > $MYSQL_DATA_DIR/$MYSQL_PORT/my.cnf <<EOF
[client]
port    = $MYSQL_PORT
socket  = /tmp/mysql.sock

[mysqld]
user    = $MYSQL_USER
port    = $MYSQL_PORT
socket  = /tmp/mysql.sock

basedir = $MYSQL_PREFIX
datadir = $MYSQL_DATA_DIR/$MYSQL_PORT/data
pid-file = $MYSQL_DATA_DIR/$MYSQL_PORT/mysql.pid

#slow log
#also can be FILE,TABLE or TABLE or NONE
log_output=FILE
slow-query-log = 1
long_query_time = 5
slow_query_log_file = $MYSQL_DATA_DIR/$MYSQL_PORT/logs/slow.log

skip-name-resolve

# ****** MyISAM Engine options******
open_files_limit    = 10240
back_log = 600
max_connections = 5000
max_connect_errors = 6000
table_open_cache = 614
table_definition_cache = 614
external-locking = FALSE
max_allowed_packet = 32M

sort_buffer_size = 2M
join_buffer_size = 2M
thread_cache_size = 300
thread_concurrency = 8
#query_cache_size = 0
query_cache_size = 64M
query_cache_limit = 1M
query_cache_min_res_unit = 2k
thread_stack = 192K 
concurrent_insert = 2
default-storage-engine = innodb
transaction_isolation = READ-COMMITTED
tmp_table_size = 246M 
max_heap_table_size = 246M

# ****** master mysql db ******
#replicate_wild_do_table=www_bbs.%
#replicate_wild_do_table=www_www.%
#replicate_wild_ignore_table=mysql.%
#replicate_wild_ignore_table=test.%

server-id = 1
log-bin = $MYSQL_DATA_DIR/$MYSQL_PORT/logs/binlog/mysql-bin
log-error = $MYSQL_DATA_DIR/$MYSQL_PORT/logs/error.log
#log-slave-updates

binlog_cache_size = 4M
binlog_format = MIXED
max_binlog_cache_size = 8M
max_binlog_size = 1G

expire_logs_days = 7
key_buffer_size = 256M
read_buffer_size = 1M
read_rnd_buffer_size = 16M
bulk_insert_buffer_size = 64M
myisam_sort_buffer_size = 128M
myisam_max_sort_file_size = 10G
myisam_repair_threads = 1
myisam_recover

interactive_timeout = 120
wait_timeout = 120


# ****** InnoDB Engine options******
innodb_additional_mem_pool_size = 16M
innodb_buffer_pool_size = 512M
innodb_data_file_path = ibdata1:1024M:autoextend
innodb_file_io_threads = 4
innodb_flush_method = O_DIRECT
innodb_thread_concurrency = 20
innodb_flush_log_at_trx_commit = 0
innodb_log_buffer_size = 16M
innodb_log_file_size = 256M
innodb_log_files_in_group = 2
innodb_max_dirty_pages_pct = 75
innodb_lock_wait_timeout = 120
innodb_file_per_table

[mysqldump]
quick
max_allowed_packet = 32M
EOF
}

mysql_install(){
    cd packages/
    tar zxvf $MYSQL_VERSION.innodb.tar.gz 
    cd $MYSQL_VERSION

    /usr/sbin/groupadd $MYSQL_GROUP -g 27
    /usr/sbin/useradd -u 27 -g $MYSQL_GROUP -c "MySQL Server" $MYSQL_USER -s /sbin/nologin

    CHOST="x86_64-pc-linux-gnu"
    CFLAGS="-march=nocona -O3 -pipe"
    CXXFLAGS="${CFLAGS}"
    $MYSQL_COMPILE_COMMAND

    make -j8 && make install
    
    chmod +w $MYSQL_PREFIX
    chown -R $MYSQL_USER:$MYSQL_GROUP $MYSQL_PREFIX
    cd ../
 
    make_dir $MYSQL_DATA_DIR/$MYSQL_PORT/data
    make_dir $MYSQL_DATA_DIR/$MYSQL_PORT/logs/binlog
    make_dir $MYSQL_DATA_DIR/$MYSQL_PORT/logs/relaylog

    chown -R $MYSQL_USER:$MYSQL_GROUP $MYSQL_DATA_DIR
    mysql_my_cnf

    chown -R $MYSQL_USER:$MYSQL_GROUP $MYSQL_DATA_DIR
    ln -s $MYSQL_DATA_DIR/$MYSQL_PORT/my.cnf /etc/

    $MYSQL_PREFIX/bin/mysql_install_db \
        --basedir=$MYSQL_PREFIX \
        --datadir=$MYSQL_DATA_DIR/$MYSQL_PORT/data \
        --user=$MYSQL_USER \
        --defaults-file=$MYSQL_DATA_DIR/$MYSQL_PORT/my.cnf
    \cp $MYSQL_DATA_DIR/$MYSQL_PORT/my.cnf /etc > /dev/null 2>&1
    \cp $MYSQL_VERSION/support-files/mysql.server  /etc/rc.d/init.d/mysqld  > /dev/null 2>&1
    chmod 755 /etc/rc.d/init.d/mysqld
    chkconfig --add mysqld
    rm -rf /usr/bin/mysql* > /dev/null 2>&1
    cd $MYSQL_PREFIX/bin/
    for i in *; do ln -s $MYSQL_PREFIX/bin/$i /usr/bin/$i; done
    cd -
    cd ../
}

mysql_complete(){
cat << EOF
+-----------------------------------------------------------------+
        MYSQL INSTALL COMPLETE !
        MYSQL SCRIPTS: /etc/init.d/mysqld start
        LISTEN PORT:  $MYSQL_PORT
+-----------------------------------------------------------------+
EOF
}


