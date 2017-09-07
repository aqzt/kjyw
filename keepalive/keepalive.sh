#!/bin/bash
#
###
# Filename: install_keepalived.sh
# Author: roguo.wei - roguo.wei@gmail.com
# Description: 
# Last Modified: 2016-11-09 00:57
# Version: 1.0
###

KEEPALIVED_USER="keepalived"
KEEPALIVED_VERSION="1.2.24"
KEEPALIVED_INSTALL_DIR="/usr/local"

yum install -y kernel-devel openssl openssl-devel &> /dev/null
ln -s /usr/src/kernels/`uname -r`/ /usr/src/linux

# check keepalived user
id -u ${KEEPALIVED_USER=} &> /dev/null
[ $? -ne 0 ] && useradd -M -s /bin/bash ${KEEPALIVED_USER}

# check tar file
if [ ! -f keepalived-${KEEPALIVED_VERSION}.tar.gz ];then
 echo "keepalived tar file not exists."
 echo "download from offical website..."
 wget http://www.keepalived.org/software/keepalived-1.2.24.tar.gz
else
 tar xf keepalived-${KEEPALIVED_VERSION}.tar.gz
fi

# comline keepalived
pushd keepalived-${KEEPALIVED_VERSION}
./configure --sysconf=/etc &> /dev/null
make &> /dev/null
make install &> /dev/null
popd
/bin/cp /usr/local/sbin/keepalived /usr/bin/

# config log
sed -i 's@^KEEPALIVED_OPTIONS=.*@KEEPALIVED_OPTIONS="-D -d -S 0"@' /etc/sysconfig/keepalived
#cat >> "local0.* /var/log/keepalived/keepalived.log" /etc/rsyslog.conf
cat > /etc/rsyslog.d/keepalived.conf << EOF
local0.* /var/log/keepalived.log
&~
EOF
/etc/init.d/rsyslog restart &> /dev/null

# man config

# 
/etc/init.d/keepalived start
chmod +x /etc/init.d/keepalived
chkconfig keepalived on