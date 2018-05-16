#!/bin/bash
#
###
# Filename: install_mariadb.sh
# Author: roguo.wei - roguo.wei@gmail.com
# Description: 
# Last Modified: 2018-04-26 14:31
# Version: 1.0
###

INSTALL_DIR="/opt/app"
DATA_DIR="/opt/data"
MARIADB_GROUP="mysql"
MARIADB_USER="mysql"
MARIADB_VERSION="10.2.14"
ROOT_PASSWD="root"
#mariadb-10.2.14-linux-x86_64.tar.gz
TAR_NAME="mariadb-${MARIADB_VERSION}-linux-x86_64.tar.gz"
UNTAR_NAME="mariadb-${MARIADB_VERSION}-linux-x86_64"

# check mariadb user
echo -n "check MariaDB user... "
id -u ${MARIADB_USER} &> /dev/null
if [ $? -ne 0 ];then
 groupadd ${MARIADB_GROUP}
 useradd -g ${MARIADB_GROUP} ${MARIADB_USER}
fi
echo "ok"

# check install dir
[ ! -d "${INSTALL_DIR}" ] && mkdir -p ${INSTALL_DIR}
[ ! -d "${DATA_DIR}" ] && mkdir -p ${DATA_DIR}

# check mariadb file
if [ ! -f ${TAR_NAME} ];then
 wget http://mirrors.tuna.tsinghua.edu.cn/mariadb//mariadb-${MARIADB_VERSION}/bintar-linux-x86_64/mariadb-${MARIADB_VERSION}-linux-x86_64.tar.gz
fi

# untar file
echo -n "untar file ..."
tar -xf ${TAR_NAME} -C ${INSTALL_DIR}
ln -s ${INSTALL_DIR}/${UNTAR_NAME} ${INSTALL_DIR}/mysql
ln -s ${INSTALL_DIR}/${UNTAR_NAME} /usr/local/mysql
echo "ok"

# init db and config
echo -n "init db..."
${INSTALL_DIR}/mysql/scripts/mysql_install_db --user=${MARIADB_USER} --basedir=${INSTALL_DIR}/mysql --datadir=${DATA_DIR}
[ $? -ne 0 ] && exit 1
cp ${INSTALL_DIR}/mysql/support-files/mysql.server /etc/init.d/mysqld
echo "ok"

[ -f /etc/my.cnf ] && mv /etc/my.cnf{,.ori}
\cp -rf $(cd `dirname $0` && pwd)/my.cnf /etc/my.cnf

# set server id
IPADDR=$(/sbin/ifconfig eth0|grep "inet addr"|awk '{print $2}'|awk -F":" '{print $2}')
SERVER_ID=$(echo $IPADDR|awk -F"." '{print $4}')
sed -i "s#server-id = .*#server-id = ${SERVER_ID}#g" /etc/my.cnf
sed -i "s#datadir = .*#datadir = ${DATA_DIR}#g" /etc/my.cnf

# set purview
chown -R root ${INSTALL_DIR}/${UNTAR_NAME}
chown -R ${MARIADB_USER} ${DATA_DIR}
chmod +x /etc/init.d/mysqld

# start mariadb
${INSTALL_DIR}/mysql/bin/mysqld_safe --user=${MARIADB_USER} & &> /dev/null
[ $? -ne 0 ] && exit 1 || echo "mariadb started ok"

# set root passwd
sleep 10
${INSTALL_DIR}/mysql/bin/mysqladmin -uroot password "${ROOT_PASSWD}"
if [ $? -ne 0 ];then
 echo "change password for root failed!"
 exit 1
else
 echo "change password for root to :${ROOT_PASSWD}"
fi

# 
chkconfig mysqld on
ln -sv ${INSTALL_DIR}/mysql/include /usr/include/mysql
echo '/${INSTALL_DIR}/mysql/lib' > /etc/ld.so.conf.d/mysql.conf
ldconfig

# set path
echo -n "set path... "
cat >> /etc/profile << EOF
# mariadb path
PATH=\$PATH:${INSTALL_DIR}/mysql/bin
export PATH
EOF
echo "ok"
. /etc/profile

echo "mariadb installed successfully!"