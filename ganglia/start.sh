#!/bin/bash
## ganglia 2016-05-30
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

OS_CENTOS6(){
wget http://mirrors.aliyun.com/epel/epel-release-latest-6.noarch.rpm
rpm -Uvh epel-release-latest-6.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

##只装ganglia服务器端
yum install ganglia ganglia-devel ganglia-gmetad ganglia-gmond ganglia-web ganglia-gmond-python

#启动命令
#service gmond start
#service httpd start
#service gmetad start

##只装ganglia客户端
yum install -y  ganglia ganglia-gmond

#启动客户端命令
service gmond start
}

OS_CENTOS7(){
wget http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh epel-release-latest-7.noarch.rpm

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7


##只装ganglia服务器端
yum install ganglia ganglia-devel ganglia-gmetad ganglia-gmond ganglia-web ganglia-gmond-python

#启动命令
#service gmond start
#service httpd start
#service gmetad start

##只装ganglia客户端
yum install -y  ganglia ganglia-gmond

#启动客户端命令
service gmond start
}

OS_SYSTEM(){
if [ -f /etc/redhat-release ];then
##      OS=CentOS
    if [ ! -z "`cat /etc/redhat-release | grep CentOS |grep "release 7"`" ];then
            OS=CentOS7
    elif [ ! -z "`cat /etc/redhat-release | grep CentOS |grep "release 6"`" ];then
            OS=CentOS6
    else
		echo $OS
    fi
elif [ ! -z "`cat /etc/issue | grep bian`" ];then
        OS=Debian
elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
        OS=Ubuntu
else
        echo -e "\033[31mDoes not support this OS, Please contact the author! \033[0m"
fi
		echo $OS
}

OS_command()
{
	if [ $OS == 'CentOS6' ];then
	        OS_CENTOS6
	elif [ $OS == 'CentOS7' ];then
	        OS_CENTOS7
	else
		echo -e "\033[31mDoes not support this OS, Please contact the author! \033[0m"
	fi
}

OS_SYSTEM
OS_command
echo ok