#!/bin/bash
#########################################
#Function:    linux drop port
#Usage:       bash linux_drop_port.sh
#Author:      Customer Service Department
#Company:     Alibaba Cloud Computing
#Version:     2.0
#########################################

check_os_release()
{
  while true
  do
    os_release=$(grep "Red Hat Enterprise Linux Server release" /etc/issue 2>/dev/null)
    os_release_2=$(grep "Red Hat Enterprise Linux Server release" /etc/redhat-release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "release 5" >/dev/null 2>&1
      then
        os_release=redhat5
        echo "$os_release"
      elif echo "$os_release"|grep "release 6" >/dev/null 2>&1
      then
        os_release=redhat6
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    os_release=$(grep "Aliyun Linux release" /etc/issue 2>/dev/null)
    os_release_2=$(grep "Aliyun Linux release" /etc/aliyun-release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "release 5" >/dev/null 2>&1
      then
        os_release=aliyun5
        echo "$os_release"
      elif echo "$os_release"|grep "release 6" >/dev/null 2>&1
      then
        os_release=aliyun6
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    os_release=$(grep "CentOS release" /etc/issue 2>/dev/null)
    os_release_2=$(grep "CentOS release" /etc/*release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "release 5" >/dev/null 2>&1
      then
        os_release=centos5
        echo "$os_release"
      elif echo "$os_release"|grep "release 6" >/dev/null 2>&1
      then
        os_release=centos6
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    os_release=$(grep -i "ubuntu" /etc/issue 2>/dev/null)
    os_release_2=$(grep -i "ubuntu" /etc/lsb-release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "Ubuntu 10" >/dev/null 2>&1
      then
        os_release=ubuntu10
        echo "$os_release"
      elif echo "$os_release"|grep "Ubuntu 12.04" >/dev/null 2>&1
      then
        os_release=ubuntu1204
        echo "$os_release"
      elif echo "$os_release"|grep "Ubuntu 12.10" >/dev/null 2>&1
      then
        os_release=ubuntu1210
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    os_release=$(grep -i "debian" /etc/issue 2>/dev/null)
    os_release_2=$(grep -i "debian" /proc/version 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "Linux 6" >/dev/null 2>&1
      then
        os_release=debian6
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    os_release=$(grep "openSUSE" /etc/issue 2>/dev/null)
    os_release_2=$(grep "openSUSE" /etc/*release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "13.1" >/dev/null 2>&1
      then
        os_release=opensuse131
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    break
    done
}

exit_script()
{
  echo -e "\033[1;40;31mInstall $1 error,will exit.\n\033[0m"
  rm -f $LOCKfile
  exit 1
}

config_iptables()
{
  iptables -I OUTPUT 1 -p tcp -m multiport --dport 21,22,23,25,53,80,135,139,443,445 -j DROP
  iptables -I OUTPUT 2 -p tcp -m multiport --dport 1433,1314,1521,2222,3306,3433,3389,4899,8080,18186 -j DROP
  iptables -I OUTPUT 3 -p udp -j DROP
  iptables -nvL
}

ubuntu_config_ufw()
{
  ufw deny out proto tcp to any port 21,22,23,25,53,80,135,139,443,445
  ufw deny out proto tcp to any port 1433,1314,1521,2222,3306,3433,3389,4899,8080,18186
  ufw deny out proto udp to any
  ufw status
}

####################Start###################
#check lock file ,one time only let the script run one time 
LOCKfile=/tmp/.$(basename $0)
if [ -f "$LOCKfile" ]
then
  echo -e "\033[1;40;31mThe script is already exist,please next time to run this script.\n\033[0m"
  exit
else
  echo -e "\033[40;32mStep 1.No lock file,begin to create lock file and continue.\n\033[40;37m"
  touch $LOCKfile
fi

#check user
if [ $(id -u) != "0" ]
then
  echo -e "\033[1;40;31mError: You must be root to run this script, please use root to execute this script.\n\033[0m"
  rm -f $LOCKfile
  exit 1
fi

echo -e "\033[40;32mStep 2.Begen to check the OS issue.\n\033[40;37m"
os_release=$(check_os_release)
if [ "X$os_release" == "X" ]
then
  echo -e "\033[1;40;31mThe OS does not identify,So this script is not executede.\n\033[0m"
  rm -f $LOCKfile
  exit 0
else
  echo -e "\033[40;32mThis OS is $os_release.\n\033[40;37m"
fi

echo -e "\033[40;32mStep 3.Begen to config firewall.\n\033[40;37m"
case "$os_release" in
redhat5|centos5|redhat6|centos6|aliyun5|aliyun6)
  service iptables start
  config_iptables
  ;;
debian6)
  config_iptables
  ;;
ubuntu10|ubuntu1204|ubuntu1210)
  ufw enable <<EOF
y
EOF
  ubuntu_config_ufw
  ;;
opensuse131)
  config_iptables
  ;;
esac

echo -e "\033[40;32mConfig firewall success,this script now exit!\n\033[40;37m"
rm -f $LOCKfile