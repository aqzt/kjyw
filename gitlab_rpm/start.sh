#!/bin/bash
## gitlab_rpm 2016-05-16
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

OS_CENTOS6(){
yum install -y  curl openssh-server openssh-clients postfix cronie git nmap unzip wget lsof xz gcc make vim  curl
service postfix start
chkconfig postfix on
lokkit -s http -s ssh
curl -LJO https://mirror.tuna.tsinghua.edu.cn/gitlab-ce/yum/el6/gitlab-ce-8.7.5-ce.0.el6.x86_64.rpm
rpm -i gitlab-ce-8.7.5-ce.0.el6.x86_64.rpm
curl -LJO https://mirror.tuna.tsinghua.edu.cn/gitlab-ci-multi-runner/yum/el6/gitlab-ci-multi-runner-1.1.4-1.x86_64.rpm
rpm -i gitlab-ci-multi-runner-1.1.4-1.x86_64.rpm
gitlab-ctl reconfigure
gitlab-runner restart
gitlab-ctl restart
}

OS_CENTOS7(){
yum install -y gcc make gcc-c++ automake lrzsz openssl-devel zlib-* bzip2-* readline* zlib-* bzip2-* git nmap unzip wget lsof xz net-tools vim  curl policycoreutils openssh-server openssh-clients postfix
systemctl enable sshd
systemctl start sshd
systemctl enable postfix
systemctl start postfix
curl -LJO https://mirror.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-8.7.5-ce.0.el7.x86_64.rpm
rpm -i gitlab-ce-8.7.5-ce.0.el7.x86_64.rpm
curl -LJO https://mirror.tuna.tsinghua.edu.cn/gitlab-ci-multi-runner/yum/el7/gitlab-ci-multi-runner-1.1.4-1.x86_64.rpm
rpm -i gitlab-ci-multi-runner-1.1.4-1.x86_64.rpm
gitlab-ctl reconfigure
gitlab-runner restart
gitlab-ctl restart
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