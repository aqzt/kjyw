#!/bin/bash
# Author:  ppabc <ppabc AT qq.com>
# Blog:  http://ppabc.cn
#
# Version: 0.1 1-October-2014 ppabc AT qq.com
# Notes: init script  for CentOS/RadHat 5+ Debian 6+ and Ubuntu 12+ 
#
# This script's project home is:
#       https://github.com/ppabc/linux-init-script
#       

if [ -f /etc/redhat-release ];then
        OS=CentOS
elif [ ! -z "`cat /etc/issue | grep bian`" ];then
        OS=Debian
elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
        OS=Ubuntu
else
        echo -e "\033[31mDoes not support this OS, Please contact the author! \033[0m"
        kill -9 $$
fi

OS_command()
{
	if [ $OS == 'CentOS' ];then
	        echo -e $OS_CentOS | bash
	elif [ $OS == 'Debian' -o $OS == 'Ubuntu' ];then
		echo -e $OS_Debian_Ubuntu | bash
	else
		echo -e "\033[31mDoes not support this OS, Please contact the author! \033[0m"
		kill -9 $$
	fi
}