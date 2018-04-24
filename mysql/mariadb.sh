###### 二进制自动安装数据库脚本root密码MANAGER将脚本和安装包放在/root目录即可###############
######数据库目录/usr/local/mysql############
######数据目录/data/mysql############
######日志目录/log/mysql############
######端口号默认3306其余参数按需自行修改############
##################
##转载 http://blog.51cto.com/suifu/1830575
#author：rrhelei@126.com#
##################
#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/opt/bin:/opt/sbin:~/bin
export PATH
# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install"
    exit 1
fi
clear
echo "========================================================================="
echo "A tool to auto-compile & install MariaDB 10.1.16 on Redhat/CentOS Linux "
echo "========================================================================="
cur_dir=$(pwd)
#set mysql root password
echo "==========================="
mysqlrootpwd="MANAGER"
echo -e "Please input the root password of mysql:"
read -p "(Default password: MANAGER):" mysqlrootpwd
if [ "$mysqlrootpwd" = "" ]; then
mysqlrootpwd="MANAGER"
fi
echo "==========================="
echo "MySQL root password:$mysqlrootpwd"
echo "==========================="
#which MySQL Version do you want to install?
echo "==========================="
isinstallmysql56="n"
echo "Install MariaDB 10.1.16,Please input y"
read -p "(Please input y , n):" isinstallmysql56
case "$isinstallmysql56" in
y|Y|Yes|YES|yes|yES|yEs|YeS|yeS)
echo "You will install MySQL 5.6.25"
isinstallmysql56="y"
;;
*)
echo "INPUT error,You will exit install MariaDB 10.1.16"
isinstallmysql56="n"
    exit
esac
get_char()
{
SAVEDSTTY=`stty -g`
stty -echo
stty cbreak
#dd if=/dev/tty bs=1 count=1 2> /dev/null
stty -raw
stty echo
stty $SAVEDSTTY
}
echo ""
echo "Press any key to start...or Press Ctrl+c to cancel"
char=`get_char`
# Initialize  the installation related content.
function InitInstall()
{
cat /etc/issue
uname -a
MemTotal=`free -m | grep Mem | awk '{print  $2}'`  
echo -e "\n Memory is: ${MemTotal} MB "
#Set timezone
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    #Delete Old Mysql program
rpm -qa|grep mysql
rpm -e mysql
#Disable SeLinux
if [ -s /etc/selinux/config ]; then
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
fi
    setenforce 0
}
#Installation of depend on and optimization options.
function InstallDependsAndOpt()
{
cd $cur_dir
cat >>/etc/security/limits.conf<<EOF
* soft nproc 65535
* hard nproc 65535
* soft nofile 65535
* hard nofile 65535
EOF
echo "fs.file-max=65535" >> /etc/sysctl.conf
}
#Install MySQL
function InstallMySQL56()
{
echo "============================Install MariaDB 10.1.16=================================="
cd $cur_dir
#Backup old my.cnf
#rm -f /etc/my.cnf
if [ -s /etc/my.cnf ]; then
    mv /etc/my.cnf /etc/my.cnf.`date +%Y%m%d%H%M%S`.bak
fi
#mysql directory configuration
groupadd mysql -g 512
useradd -u 512 -g mysql -s /sbin/nologin -d /home/mysql mysql
tar xvf /root/mariadb-10.1.16-linux-x86_64.tar.gz
mv /root/mariadb-10.1.16-linux-x86_64 /usr/local/mysql
mkdir -p /data/mysql
mkdir -p /log/mysql
chown -R mysql:mysql /data/mysql
chown -R mysql:mysql /usr/local/mysql
chown -R mysql:mysql /log
SERVERID=`ifconfig eth0 | grep "inet addr" | awk '{ print $2}'| awk -F. '{ print $3$4}'`
cat >>/etc/my.cnf<<EOF
[client]
port= 3306
socket= /tmp/mysql.sock
default-character-set=utf8
[mysql]
default-character-set=utf8
[mysqld]
port= 3306
socket= /tmp/mysql.sock
basedir= /usr/local/mysql
datadir= /data/mysql
open_files_limit    = 3072
back_log = 103
max_connections = 800
max_connect_errors = 100000
table_open_cache = 512
external-locking = FALSE
max_allowed_packet = 32M
sort_buffer_size = 2M
join_buffer_size = 2M
thread_cache_size = 51
query_cache_size = 32M
tmp_table_size = 96M
max_heap_table_size = 96M
slow_query_log = 1
slow_query_log_file = /log/mysql/slow.log
log-error = /log/mysql/error.log
long_query_time = 1
server-id = $SERVERID
log-bin = /log/mysql/mysql-bin
sync_binlog = 1
binlog_cache_size = 4M
max_binlog_cache_size = 8M
max_binlog_size = 1024M
expire_logs_days = 60
key_buffer_size = 32M
read_buffer_size = 1M
read_rnd_buffer_size = 16M
bulk_insert_buffer_size = 64M
character-set-server=utf8
default-storage-engine = InnoDB
binlog_format = row
innodb_buffer_pool_dump_at_shutdown = 1
innodb_buffer_pool_load_at_startup = 1
binlog_rows_query_log_events = 1
explicit_defaults_for_timestamp = 1
#log_slave_updates=1
#gtid_mode=on
#enforce_gtid_consistency=1
#innodb_write_io_threads = 8
#innodb_read_io_threads = 8
#innodb_thread_concurrency = 0
transaction_isolation = REPEATABLE-READ
innodb_additional_mem_pool_size = 16M
innodb_buffer_pool_size = 512M
#innodb_data_home_dir =
innodb_data_file_path = ibdata1:1024M:autoextend
innodb_flush_log_at_trx_commit = 1
innodb_log_buffer_size = 16M
innodb_log_file_size = 512M
innodb_log_files_in_group = 2
innodb_max_dirty_pages_pct = 50
innodb_file_per_table = 1
innodb_locks_unsafe_for_binlog = 0
wait_timeout = 14400
interactive_timeout = 14400
skip-name-resolve
[mysqldump]
quick
max_allowed_packet = 32M
EOF
/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/data/mysql --defaults-file=/etc/my.cnf --user=mysql
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod 700 /etc/init.d/mysqld
chkconfig --add mysql
chkconfig --level 2345 mysqld on
cat >> /etc/ld.so.conf.d/mysql-x86_64.conf<<EOF
/usr/local/mysql/lib
EOF
ldconfig
if [ -d "/proc/vz" ];then
ulimit -s unlimited
fi
/etc/init.d/mysqld start
cat >> /etc/profile <<EOF
export PATH=$PATH:/usr/local/mysql/bin
export LD_LIBRARY_PATH=/usr/local/mysql/lib
EOF
/usr/local/mysql/bin/mysqladmin -u root password $mysqlrootpwd
cat > /tmp/mysql_sec_script<<EOF
use mysql;
delete from mysql.user where user!='root' or host!='localhost';
flush privileges;
EOF
/usr/local/mysql/bin/mysql -u root -p$mysqlrootpwd -h localhost < /tmp/mysql_sec_script
#rm -f /tmp/mysql_sec_script
/etc/init.d/mysqld restart
source /etc/profile
echo "============================MariaDB 10.1.16 install completed========================="
}
function CheckInstall()
{
echo "===================================== Check install ==================================="
clear
ismysql=""
echo "Checking..."
if [ -s /usr/local/mysql/bin/mysql ] && [ -s /usr/local/mysql/bin/mysqld_safe ] && [ -s /etc/my.cnf ]; then
  echo "MySQL: OK"
  ismysql="ok"
  else
  echo "Error: /usr/local/mysql not found!!!MySQL install failed."
fi
if [ "$ismysql" = "ok" ]; then
echo "Install MariaDB 10.1.16 completed! enjoy it."
echo "========================================================================="
netstat -ntl
else
echo "Sorry,Failed to install MySQL!"
echo "You can tail /root/mysql-install.log from your server."
fi
}
#The installation log
InitInstall 2>&1 | tee /root/mysql-install.log
CheckAndDownloadFiles 2>&1 | tee -a /root/mysql-install.log
InstallDependsAndOpt 2>&1 | tee -a /root/mysql-install.log
InstallMySQL56 2>&1 | tee -a /root/mysql-install.log
CheckInstall 2>&1 | tee -a /root/mysql-install.log