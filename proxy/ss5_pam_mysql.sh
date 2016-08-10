#!/bin/bash
## ss5实现socke代理  2016-08-10
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 7

wget http://jaist.dl.sourceforge.net/project/ss5/ss5/3.8.9-8/ss5-3.8.9-8.tar.gz
tar zxvf ss5-3.8.9-8.tar.gz
cd ss5-3.8.9-8
./configure && make && make install

##配置SS5：
    # vi /etc/opt/ss5/ss5.conf
    ============+============+============+============+============
    #实现用户认证并限制带宽：
    set SS5_DNSORDER
    set SS5_PAM_AUTH
    auth 0.0.0.0/0 - u
    permit - 0.0.0.0/0 - 0.0.0.0/0 - - - 10240 -
    #如果要实现不同用户认证并分别限制带宽，在/etc/opt/ss5目录创建user和file两个文件，该文件中含有要认证的用户名：
    permit - 0.0.0.0/0 - 0.0.0.0/0 - - user 10240 -
    permit - 0.0.0.0/0 - 0.0.0.0/0 - - file 102400 -
    ============+============+============+============+============
##配置PAM认证：
    # vi /etc/pam.d/ss5
    ============+============+============+============+============
    auth optional /usr/lib/security/pam_mysql.so user=ss5 \
    passwd=121212 host=localhost db=ss5 table=user \
    usercolumn=username passwdcolumn=passwd crypt=2
    account required /usr/lib/security/pam_mysql.so user=ss5 \
    passwd=121212 host=localhost db=ss5 table=user \
    usercolumn=username passwdcolumn=passwd crypt=2
    ============+============+============+============+============
##安装PAM_MYSQL：
    # tar -zxvf pam_mysql-0.7RC1.tar.gz
    # cd pam_mysql-0.7RC1
    # ./configure --with-openssl --with-mysql=/usr/local/mysql
    # make
    # make install
    # echo "/usr/lib/security" >> /etc/ld.so.conf
    # ldconfig
##创建数据库:
    # mysqladmin -u root -pmysqldbserver create ss5
    # mysql -u root -pmysqldbserver
    mysql> use ss5;
    mysql> GRANT ALL PRIVILEGES ON ss5.* TO
    [email='ss5'@'localhost']'ss5'@'localhost'[/email]
     IDENTIFIED BY '121212';
    mysql> CREATE TABLE user (ID int not null auto_increment,USERNAME varchar(64), PASSWD varchar(255), primary key(ID) );
##添加测试用户：
    mysql> insert into user (username,passwd) values ('test',password('1234'));