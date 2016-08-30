#!/bin/bash
## ss5实现socke代理  2016-08-10
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 7

yum -y install gcc gcc-c++ automake make pam-devel openldap-devel cyrus-sasl-devel  openssl-devel
wget http://jaist.dl.sourceforge.net/project/ss5/ss5/3.8.9-8/ss5-3.8.9-8.tar.gz
tar zxvf ss5-3.8.9-8.tar.gz
cd ss5-3.8.9-8
./configure && make && make install

cat >/etc/opt/ss5/ss5.passwd<<EOF
test 123123
aaa  123123
bbb  123123
EOF


##无分组无限制配置
cat >/etc/opt/ss5/ss5.conf<<EOF
auth      0.0.0.0/0       -         u
permit u        0.0.0.0/0       -       0.0.0.0/0       -       -       -       -       -
EOF


##创建分组
echo "test">/etc/opt/ss5/ulimit
echo "aaa" >>/etc/opt/ss5/ulimit
echo "bbb" >/etc/opt/ss5/limit

##有分组 ，有限制配置
cat >/etc/opt/ss5/ss5.conf<<EOF
auth      0.0.0.0/0       -         u
permit u       0.0.0.0/0       -       0.0.0.0/0       -        -       ulimit       -       -
permit u       0.0.0.0/0       -       0.0.0.0/0       80       -       limit        -       -

permit u       0.0.0.0/0       -       0.0.0.0/0       -         -      ulimit       -       -
permit u       0.0.0.0/0       -       0.0.0.0/0       443       -      limit        -       -
EOF


echo "SS5_OPTS=\" -u root -b 0.0.0.0:10888\"" >>/etc/sysconfig/ss5
##使用默认端口
##echo "SS5_OPTS=\" -u root\"" >>/etc/sysconfig/ss5
##/etc/rc.d/init.d/ss5 文件修改自定义端口，默认为1080
##daemon /usr/sbin/ss5 -t $SS5_OPTS -b 0.0.0.0:10888

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
tail -f /var/log/ss5/ss5.log

