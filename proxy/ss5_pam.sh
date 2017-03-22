#!/bin/bash
## ss5实现socke代理  2016-08-10
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 7

yum -y install gcc gcc-c++ automake make pam-devel openldap-devel cyrus-sasl-devel openssl-devel
wget http://jaist.dl.sourceforge.net/project/ss5/ss5/3.8.9-8/ss5-3.8.9-8.tar.gz
tar zxvf ss5-3.8.9-8.tar.gz
cd ss5-3.8.9
./configure && make && make install

##无分组无限制配置
#cat >/etc/opt/ss5/ss5.conf<<EOF
#set SS5_PAM_AUTH
#auth      0.0.0.0/0       -         u
#permit u        0.0.0.0/0       -       0.0.0.0/0       -       -       -       -       -
#EOF

#useradd test -s /sbin/nologin
#useradd aaa -s /sbin/nologin
#useradd bbb -s /sbin/nologin

/usr/sbin/useradd username1  -s /sbin/nologin
echo eUqO5VLWj9m3FXy6 | passwd  --stdin username1

/usr/sbin/useradd username2  -s /sbin/nologin
echo ltQQEmH72NDQ51Er | passwd  --stdin username2

/usr/sbin/useradd username3  -s /sbin/nologin
echo MauDmldzvnsX5iUo | passwd  --stdin username3

##创建分组
echo "username1">/etc/opt/ss5/ulimit
echo "username2" >>/etc/opt/ss5/ulimit
echo "username3" >/etc/opt/ss5/limit

##有分组 ，有限制配置
cat >/etc/opt/ss5/ss5.conf<<EOF
set SS5_PAM_AUTH
auth      0.0.0.0/0       -         u
permit u       0.0.0.0/0       -       0.0.0.0/0       -        -       ulimit       -       -
permit u       0.0.0.0/0       -       0.0.0.0/0       80       -       limit        -       -

permit u       0.0.0.0/0       -       0.0.0.0/0       -         -      ulimit       -       -
permit u       0.0.0.0/0       -       0.0.0.0/0       443       -      limit        -       -
EOF


echo "SS5_OPTS=\" -u root -b 0.0.0.0:11888\"" >>/etc/sysconfig/ss5
##使用默认端口
##echo "SS5_OPTS=\" -u root\"" >>/etc/sysconfig/ss5
##/etc/rc.d/init.d/ss5 文件修改自定义端口，默认为1080
##daemon /usr/sbin/ss5 -t $SS5_OPTS -b 0.0.0.0:11888

echo "auth        required     /usr/lib64/security/pam_unix.so">>/etc/pam.d/ss5

chmod 700 /etc/rc.d/init.d/ss5
chmod +x  /etc/rc.d/init.d/ss5

##启动ss5
service ss5 start

##停止ss5
#service ss5 stop

##加入开机自动启动 centos6
#chkconfig --add ss5
#chkconfig --level 345 ss5 on

##查看日志启动是否成功
#tail -f /var/log/ss5/ss5.log

