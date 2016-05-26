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

. check_os.sh
# init
if [ "$OS" == 'CentOS' ];then
	 echo CentOS
elif [ "$OS" == 'Debian' ];then
 	 echo Debian
elif [ "$OS" == 'Ubuntu' ];then
 	 echo Ubuntu
fi