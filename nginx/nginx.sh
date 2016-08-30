#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
NGINX_ROOT="/data/www/wwwroot"
NGINX_PORT=80
NGINX_USER=daemon
NGINX_GROUP=daemon
NGINX_VERSION="nginx-1.8.1"
NGINX_PREFIX="/opt/nginx"
NGINX_PCRE_VERSION="pcre-8.37"
NGINX_COMPILE_COMMAND="./configure \
                        --user=$CONF_WWW_USER \
                        --group=$CONF_WWW_GROUP \
                        --prefix=$NGINX_PREFIX \
                        --with-http_stub_status_module \
                        --with-http_ssl_module \
                        --with-http_sub_module \
                        --with-pcre=../pcre-8.37 \
                        --with-md5=/usr/lib \
                        --with-sha1=/usr/lib \
                        --with-http_gzip_static_module"
yum -y install zlib zlib-devel openssl openssl-devel pcre pcre-devel gcc gcc-c++ make
tar zxvf $NGINX_PCRE_VERSION.tar.gz 
cd $NGINX_PCRE_VERSION
./configure && make && make install
cd ../
tar zxvf $NGINX_VERSION.tar.gz
cd $NGINX_VERSION
$NGINX_COMPILE_COMMAND
make -j8 && make install
   cat > $NGINX_PREFIX/conf/nginx.conf <<EOF
user  $NGINX_USER $NGINX_GROUP;
 
worker_processes 8;
 
pid $NGINX_PREFIX/logs/nginx.pid;
# [ debug | info | notice | warn | error | crit ]
#error_log  /data/logs/nginx_error.log;
error_log  /dev/null;
#Specifies the value for maximum file descriptors that can be opened by this process.
worker_rlimit_nofile 51200;
 
events
{
       use epoll;
 
       #maxclient = worker_processes * worker_connections / cpu_number
       worker_connections 51200;
}
 
http
{
       include       $NGINX_PREFIX/conf/mime.types;
       default_type  application/octet-stream;
       #charset  gb2312,utf-8;
       charset utf-8;

       log_format  main  '\$remote_addr - \$remote_user [\$time_local] \$request '
                         '"\$status" \$body_bytes_sent "\$http_referer" '
                         '"\$http_user_agent" "\$http_x_forwarded_for"';
 
       # access_log  /log/access.log  main;
       access_log  /dev/null;
 
       #error_page 502 =200 /.busy.jpg;
       #General Options
       server_names_hash_bucket_size 128;
       client_header_buffer_size 32k;
       large_client_header_buffers 4 32k;
       client_body_buffer_size    8m; #256k 
       #
       server_tokens off;
       ignore_invalid_headers   on;
       recursive_error_pages    on;
       server_name_in_redirect off;
      
       sendfile                 on;
 
       #timeouts
       keepalive_timeout 60;
       #test
       #client_body_timeout   3m;
       #client_header_timeout 3m;
       #send_timeout          3m;

      
       #TCP Options 
       tcp_nopush  on;
       tcp_nodelay on;

       #fastcgi options 
       fastcgi_connect_timeout 300;
       fastcgi_send_timeout 300;
       fastcgi_read_timeout 300;
       fastcgi_buffer_size 64k;
       fastcgi_buffers 4 64k;
       fastcgi_busy_buffers_size 128k;
       fastcgi_temp_file_write_size 128k;
 
       #hiden php version
       fastcgi_hide_header X-Powered-By;
    
       #size limits
       client_max_body_size       50m;

       gzip on;
       gzip_min_length  1k;
       gzip_buffers     4 16k;
       gzip_http_version 1.0;
       gzip_comp_level 2;
       gzip_types       text/plain application/x-javascript text/css application/xml;
       gzip_vary on; 
       
        proxy_temp_path            /dev/shm/proxy_temp;
        fastcgi_temp_path          /dev/shm/fastcgi_temp;
        client_body_temp_path      /dev/shm/client_body_temp; 

       #upstream web
       upstream web {
         server 127.0.0.1:80;
       }

       #upstream php
       upstream php {
         server 127.0.0.1:9000 max_fails=0;
         server 127.0.0.1:9001 max_fails=0;
         }
    
       #upstream
       fastcgi_next_upstream error timeout invalid_header http_500;

       #limit_zone   limit  \$binary_remote_addr  1m;

       #server {
       #        listen 80 default;
       #        rewrite ^(.*) http://www.baidu.com/ permanent;
       #}  
 
       #fastcgi cache
       #fastcgi_cache_path /nginxcache levels=1:2 keys_zone=two:10m inactive=1d max_size=3000m;
       #for example just for study! have fun!
       #include          $NGINX_PREFIX/conf/conf_example/*.conf ;
       include          vhosts/*.conf;
}
EOF
    cat > $NGINX_PREFIX/conf/fastcgi_params <<EOF
if (\$request_filename ~* (.*)\.php) {
    set \$php_url \$1;
}
if (!-e \$php_url.php) {
    return 403;
}

fastcgi_param  QUERY_STRING       \$query_string;
fastcgi_param  REQUEST_METHOD     \$request_method;
fastcgi_param  CONTENT_TYPE       \$content_type;
fastcgi_param  CONTENT_LENGTH     \$content_length;

fastcgi_param  SCRIPT_NAME        \$fastcgi_script_name;
fastcgi_param  REQUEST_URI        \$request_uri;
fastcgi_param  DOCUMENT_URI       \$document_uri;
fastcgi_param  DOCUMENT_ROOT      \$document_root;
fastcgi_param  SERVER_PROTOCOL    \$server_protocol;

fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
fastcgi_param  SERVER_SOFTWARE    nginx/\$nginx_version;

fastcgi_param  REMOTE_ADDR        \$remote_addr;
fastcgi_param  REMOTE_PORT        \$remote_port;
fastcgi_param  SERVER_ADDR        \$server_addr;
fastcgi_param  SERVER_PORT        \$server_port;
fastcgi_param  SERVER_NAME        \$server_name;

# PHP only, required if PHP was built with --enable-force-cgi-redirect
#fastcgi_param  REDIRECT_STATUS    200;
EOF
mkdir -p $NGINX_PREFIX/conf/vhosts/
    cat > $NGINX_PREFIX/conf/vhosts/test.conf <<EOF
server
    {
            listen  $NGINX_PORT;
            server_name  www.test.com;
            index index.php index.html index.htm;
            root   $NGINX_ROOT;
            #access_log /data/logs/access_test.com.log  combined;
            #error_log  /data/logs/error_test.com.log; 
            
            #expires                         
            location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)\$
            {
                expires 30d;
            }

            location ~ .*\.(js|css)?\$
            {
                expires      24h;
            }    
 
            location /webstatus {
                stub_status on;
                access_log off;
            }

            # location ~* ^/(attachments|images)/.*\.(php|php5)\$
            # {
            #    deny all;
            # }
 
            location ~ .*\.php?\$
            {
                fastcgi_pass 127.0.0.1:9000;
                #fastcgi_pass unix:/tmp/php-fcgi.sock;
                #fastcgi_pass php;
                fastcgi_index index.php;
                fastcgi_param  SCRIPT_FILENAME    \$document_root\$fastcgi_script_name;
                include fastcgi_params;
            }
         
    }
EOF

    cat > /etc/init.d/nginx <<EOF
#
# chkconfig: - 69 88
# description: this script is used for nginx
# author: qzao22(qzao22@qq.com)
#
#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ \$(id -u) != "0" ]; then
    echo "Error: You must be root to run this script!\n"
    exit 1
fi

NGINXDAEMON=$NGINX_PREFIX/sbin/nginx
PIDFILE=$NGINX_PREFIX/logs/nginx.pid

function_start()
{
    echo -en "\033[32;49;1mStarting nginx......\n"
    echo -en "\033[39;49;0m"  
    if [ -f \$PIDFILE ]; then
      printf "Nginx is runing!\n"
      exit 1
    else  
        \$NGINXDAEMON 
        printf "Nginx is the successful start!\n"
    fi
}

function_stop()
{
    echo -en "\033[32;49;1mStoping nginx......\n"
    echo -en "\033[39;49;0m" 
    if  [ -f \$PIDFILE ]; then
        kill \`cat \$PIDFILE\`
        printf "Nginx program is stoped\n"
    else  
        printf  "Nginx program is not runing!\n" 
    fi
}

function_reload()
{
    echo -en "\033[32;49;1mReload nginx......\n"
    echo -en "\033[39;49;0m"
    printf "Reload Nginx configure...\n"
    \$NGINXDAEMON -t
    kill -HUP \`cat \$PIDFILE\`
    printf "Nginx program is reloding!\n"
}

function_restart()
{
    echo -en "\033[32;49;1mRestart nginx......\n"
    echo -en "\033[39;49;0m" 
    printf "Reload Nginx configure...\n"
    \$NGINXDAEMON -t
    kill -HUP \`cat \$PIDFILE\`
    printf "Nginx program is reloding!\n"
}

function_kill()
{
    killall nginx
}

function_status()
{
    if ! ps -ef|grep 'nginx:' > /dev/null 2>&1
    then
        printf "Nginx is down!!!\n"
    else
        printf "Nginx is running now!\n"
    fi
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
elif [ "\$1" = "status" ]; then
    function_status
else
    echo -en "\033[32;49;1m Usage: nginx {start|stop|reload|restart|kill|status}\n"
    echo -en "\033[39;49;0m"
fi
EOF
chmod 777 /etc/init.d/nginx
echo ok
