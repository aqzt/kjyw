#!/bin/bash
# init centos6
# 20160621
 
# 检查是否为root用户，脚本必须在root权限下运行 #
if [[ "$(whoami)" != "root" ]]; then
    echo "please run this script as root !" >&2
    exit 1
fi
echo -e "\033[31m the script only Support CentOS_6 x86_64 \033[0m"
echo -e "\033[31m system initialization script, Please Seriously. press ctrl+C to cancel \033[0m"
 
 
# 按Y继续默认N，其他按键全部退出 #
yn="n"
echo "please input [Y\N]"
echo -n "default [N]: "
read yn
if [ "$yn" != "y" -a "$yn" != "Y" ]; then
   echo "bye-bye!"
   exit 0
fi
 
 
# 倒计时 #
for i in `seq -w 3 -1 1`
  do
    echo -ne "\b>>>>>$i";
    sleep 1;
  done
echo -e "\b\Good Luck"
 
 
# 检查是否为64位系统，这个脚本只支持64位脚本
platform=`uname -i`
if [ $platform != "x86_64" ];then
    echo "this script is only for 64bit Operating System !"
    exit 1
fi
echo "the platform is ok"
 
 
# 安装必要支持工具及软件工具
yum -y install redhat-lsb vim unzip openssl openssl-devel gcc gcc-c++ lsof nmap
# clear
echo "Tools installation is complete"
 
 
# 检查系统版本为centos 6
distributor=`lsb_release -i | awk '{print $NF}'`
version=`lsb_release -r | awk '{print substr($NF,1,1)}'`
if [ $distributor != 'CentOS' -o $version != '6' ]; then
    echo "this script is only for CentOS 6 !"
    exit 1
fi
# clear
cat << EOF
+---------------------------------------+
|   your system is CentOS 6 x86_64      |
|           start optimizing            |
+---------------------------------------+
EOF
sleep 3
 
 
# instll repo
yum_update(){
#make the 163.com as the default yum repo
if [ ! -e "/etc/yum.repos.d/bak" ]; then
    mkdir /etc/yum.repos.d/bak
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/bak/CentOS-Base.repo.backup
fi
 
#add
#wget http://mirrors.163.com/.help/CentOS6-Base-163.repo -O /etc/yum.repos.d/CentOS-Base.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
 
#add the third-party repo
#rpm -Uvh http://download.Fedora.RedHat.com/pub/epel/6/x86_64/epel-release-6-5.noarch.rpm 
#rpm -Uvh ftp://ftp.muug.mb.ca/mirror/centos/6.8/extras/x86_64/Packages/epel-release-6-8.noarch.rpm
rpm -Uvh http://mirrors.aliyun.com/epel/epel-release-latest-6.noarch.rpm
#add the epel
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
 
 
#update the system
#yum clean all && yum makecache
#yum -y update glibc\*
#yum -y update yum\* rpm\* python\* 
#yum -y update
echo -e "\033[31m yum update ok \033[0m"
sleep 1
}
 
 
#time zone
zone_time(){
#install ntp
yum -y install ntp
 
#time zone
if [ `date +%z` != "+0800" ]; then
    rm -rf /etc/localtime
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
cat > /etc/sysconfig/clock << EOF
ZONE="Asia/Shanghai"
UTC=false
ARC=false
EOF
 
if [ `date +%z` != "+0800" ]; then
    echo "The Shanghai time zone error"
    rm -rf /etc/localtime
    ln -sf /usr/share/zoneinfo/Asia/Chongqing /etc/localtime
cat > /etc/sysconfig/clock << EOF
ZONE="Asia/Chongqing"
UTC=false
ARC=false
EOF
 
if [ `date +%z` != "+0800" ]; then
    echo "The Chongqing time zone error"
    rm -rf /etc/localtime
 
    ln -sf /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime
cat > /etc/sysconfig/clock << EOF
ZONE="Asia/Hang_Kong"
UTC=false
ARC=false
EOF
 
if [ `date +%z` != "+0800" ]; then
    echo "The Hang_Kong time zone error， To write Shanghai time zone "
    echo -e "\033[31m time zone error , please manual settings \033[0m"
    rm -rf /etc/localtime
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
cat > /etc/sysconfig/clock << EOF
ZONE="Asia/Shanghai"
UTC=false
ARC=false
EOF
fi
fi
fi
fi
 
echo "Present time zone:"`date +%z`
cat /etc/sysconfig/clock
echo -e "\033[31m time zone ok \033[0m"
sleep 1
 
 
# set time
echo "update time please wait!"
/usr/sbin/ntpdate 210.72.145.44 > /dev/null 2>&1
#sed -i "/ntpdate/s/^/#/g" /var/spool/cron/root
sed -i "/ntpdate/d" /var/spool/cron/root
sed -i "/hwclock/d" /var/spool/cron/root
cat >> /var/spool/cron/root << EOF
*/5 * * * * /usr/sbin/ntpdate 210.72.145.44 > /dev/null 2>&1
* * * * */1 /usr/sbin/hwclock -w > /dev/null 2>&1
EOF
chmod 600 /var/spool/cron/root
/sbin/service crond restart
echo -e "\033[31m time zone ok \033[0m"
sleep 1
}
 
 
# set hosts
hosts(){
#修改hostname为127.0.0.1
if [ "$(hostname -i)" != "127.0.0.1" ]; then
    sed -i "s@^127.0.0.1\(.*\)@127.0.0.1 `hostname`\1@" /etc/hosts
fi
 
hostname -i
echo -e "\033[31m hosts ok \033[0m"
sleep 1
}
 
 
#set the file limit
limits_config(){
#修改文件打开数
sed -i "/^ulimit -SHn.*/d" /etc/rc.local
echo "ulimit -SHn 102400" >> /etc/rc.local
 
sed -i "/^ulimit -s.*/d" /etc/profile
sed -i "/^ulimit -c.*/d" /etc/profile
sed -i "/^ulimit -SHn.*/d" /etc/profile
 
cat >> /etc/profile << EOF
#
#
#
ulimit -c unlimited
ulimit -s unlimited
ulimit -SHn 102400
EOF
 
source /etc/profile
ulimit -a
cat /etc/profile | grep ulimit
echo -e "\033[31m hosts ok \033[0m"
 
if [ ! -f "/etc/security/limits.conf.bak" ]; then
    cp /etc/security/limits.conf /etc/security/limits.conf.bak
fi
sed -i "/^*.*soft.*nofile/d" /etc/security/limits.conf
sed -i "/^*.*hard.*nofile/d" /etc/security/limits.conf
sed -i "/^*.*soft.*nproc/d" /etc/security/limits.conf
sed -i "/^*.*hard.*nproc/d" /etc/security/limits.conf
cat > /etc/security/limits.conf << EOF
#
#
#
#
#---------custom-----------------------
#
*           soft   nofile       65535
*           hard   nofile       65535
*           soft   nproc        65535
*           hard   nproc        65535
EOF
cat /etc/security/limits.conf | grep "^*           .*"
echo -e "\033[31m limits ok \033[0m"
sleep 1
}
 
 
# tune kernel parametres #优化内核参数
sysctl_config(){
#delete
if [ ! -f "/etc/sysctl.conf.bak" ]; then
    cp /etc/sysctl.conf /etc/sysctl.conf.bak
fi

#add
cat > /etc/sysctl.conf << EOF
#
#
#
#
#-------custom---------------------------------------------
#
net.ipv4.ip_forward = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096    87380   4194304
net.ipv4.tcp_wmem = 4096    16384   4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
#net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_synack_retries = 2
#net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
#net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_time = 30
net.ipv4.ip_local_port_range = 1024    65535
#net.ipv4.tcp_tw_len = 1
EOF
 
#buckets
echo 6000 > /proc/sys/net/ipv4/tcp_max_tw_buckets
 
#delete
sed -i "/^kernel.shmmax/d" /etc/sysctl.conf
sed -i "/^kernel.shmall/d" /etc/sysctl.conf
 
#add
shmmax=`free -l |grep Mem |awk '{printf("%d\n",$2*1024*0.9)}'`
shmall=$[$shmmax/4]
echo "kernel.shmmax = "$shmmax >> /etc/sysctl.conf
echo "kernel.shmall = "$shmall >> /etc/sysctl.conf
 
#bridge
#modprobe bridge
#lsmod|grep bridge
 
#reload sysctl
/sbin/sysctl -p
echo -e "\033[31m sysctl ok \033[0m"
sleep 1
}
 
 
# control-alt-delete
set_key(){
#set the control-alt-delete to guard against the miSUSE
sed -i 's#^exec /sbin/shutdown -r now#\#exec /sbin/shutdown -r now#' /etc/init/control-alt-delete.conf
cat /etc/init/control-alt-delete.conf | grep /sbin/shutdown
echo -e "\033[31m control-alt-delete ok \033[0m"
sleep 1
}
 
 
#disable selinux #关闭SELINUX
selinux(){
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0
echo -e "\033[31m selinux ok \033[0m"
sleep 1
}
 
 
#set sshd_config UseDNS
ssh_GSS(){
#sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config
sed -i '/^#UseDNS/s/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/g' /etc/ssh/sshd_config
/etc/init.d/sshd restart
cat /etc/ssh/sshd_config | grep -i usedns
cat /etc/ssh/sshd_config | grep -i PermitEmptyPasswords
echo -e "\033[31m sshd ok \033[0m"
sleep 1
}
 
 
#define the backspace button can erase the last character typed
backspace_button(){
sed -i "/^stty erase ^H/d" /etc/profile
echo 'stty erase ^H' >> /etc/profile
sed -i "/^syntax.*/d" /root/.vimrc
echo "syntax on" >> /root/.vimrc
echo -e "\033[31m backspace ok \033[0m"
cat /etc/profile | grep -i "stty erase ^H"
cat /root/.vimrc | grep -i "syntax"
sleep 1
}
 
 
#stop some crontab
stop_crond(){
if [ ! -e "/etc/cron.daily.bak" ]; then
    mkdir /etc/cron.daily.bak
    mv /etc/cron.daily/makewhatis.cron /etc/cron.daily.bak > /dev/null 2>&1
    mv /etc/cron.daily/mlocate.cron /etc/cron.daily.bak > /dev/null 2>&1
fi
echo -e "\033[31m crond ok \033[0m"
sleep 1
}
 
 
#disable some service
dissable_service(){
chkconfig bluetooth off > /dev/null 2>&1
chkconfig cups off  > /dev/null 2>&1
chkconfig ip6tables off  > /dev/null 2>&1
chkconfig | grep -E "cups|ip6tables|bluetooth"
echo -e "\033[31m service ok \033[0m"
sleep 1
}
 
 
#disable the ipv6
stop_ipv6(){
cat > /etc/modprobe.d/ipv6.conf << EOFI
#
#
#
#---------------custom-----------------------
#
alias net-pf-10 off
options ipv6 disable=1
EOFI
sed -i "/^NETWORKING_IPV6.*/d" /etc/sysconfig/network
echo "NETWORKING_IPV6=off" >> /etc/sysconfig/network
cat /etc/sysconfig/network | grep NETWORKING_IPV6
echo -e "\033[31m ipv6 ok \033[0m"
sleep 1
}
 
 
#language..
inittab(){
if [ -z "$(cat /etc/redhat-release | grep '6\.')" ];then
    sed -i 's/3:2345:respawn/#3:2345:respawn/g' /etc/inittab
    sed -i 's/4:2345:respawn/#4:2345:respawn/g' /etc/inittab
    sed -i 's/5:2345:respawn/#5:2345:respawn/g' /etc/inittab
    sed -i 's/6:2345:respawn/#6:2345:respawn/g' /etc/inittab
    sed -i 's/ca::ctrlaltdel/#ca::ctrlaltdel/g' /etc/inittab
    sed -i 's@LANG=.*$@LANG="en_US.UTF-8"@g' /etc/sysconfig/i18n
else
    sed -i 's@^ACTIVE_CONSOLES.*@ACTIVE_CONSOLES=/dev/tty[1-2]@' /etc/sysconfig/init
    sed -i 's@^start@#start@' /etc/init/control-alt-delete.conf
fi
/sbin/init q
 
#locale
echo $LANG
echo -e "\033[31m inittab ok \033[0m"
sleep 1
}
 
 
# iptables
iptables(){
#add iptables
yum -y install iptables
 
#iptables conf bak
if [ ! -e "/etc/sysconfig/iptables.bak" ]; then
    cp /etc/sysconfig/iptables /etc/sysconfig/iptables.bak > /dev/null 2>&1
fi
 
#add config
cat > /etc/sysconfig/iptables << EOF
# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -s 192.168.142.1 -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
EOF
/sbin/service iptables restart
source /etc/profile
chkconfig iptables on
/sbin/iptables -L -v
chkconfig | grep iptables
echo -e "\033[31m iptables ok \033[0m"
sleep 1
}
 
 
# others
other(){
# initdefault
sed -i 's/^id:.*$/id:3:initdefault:/' /etc/inittab
/sbin/init q
cat /etc/inittab | grep "id:"
 
# PS1 /tmp/
sed -i "/^PS1=.*/d" /etc/profile
echo 'PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\h \[\e[35;40m\]\W\[\e[0m\]]\\$ \[\e[33;40m\]"' >> /etc/profile
 
# HISTSIZ
sed -i 's/^HISTSIZE=.*$/HISTSIZE=300/' /etc/profile
cat /etc/profile | grep "^HISTSIZE"
 
# Record command
sed -i "/^export PROMPT_COMMAND=.*/d" /root/.bash_profile
echo "export PROMPT_COMMAND='{ msg=\$(history 1 | { read x y; echo \$y; });user=\$(whoami); echo \$(date \"+%Y-%m-%d %H:%M:%S\"):\$user:\`pwd\`/:\$msg ---- \$(who am i); } >> /tmp/\`hostname\`.\`whoami\`.history-timestamp'" >> /root/.bash_profile

#history
export HISTFILESIZE=10000000
export HISTSIZE=1000000
export PROMPT_COMMAND="history -a"
export HISTTIMEFORMAT="%Y-%m-%d_%H:%M:%S "
##export HISTTIMEFORMAT="{\"TIME\":\"%F %T\",\"HOSTNAME\":\"\$HOSTNAME\",\"LI\":\"\$(who -u am i 2>/dev/null| awk '{print \$NF}'|sed -e 's/[()]//g')\",\"LU\":\"\$(who am i|awk '{print \$1}')\",\"NU\":\"\${USER}\",\"CMD\":\""
cat >>/etc/bashrc<<EOF
alias vi='vim'
HISTDIR='/var/log/command.log'
if [ ! -f \$HISTDIR ];then
touch \$HISTDIR
chmod 666 \$HISTDIR
fi
export HISTTIMEFORMAT="{\"TIME\":\"%F %T\",\"IP\":\"\$(ip a | grep -E '192.168|172' | head -1 | awk '{print$2}' | cut -d/ -f1)\",\"LI\":\"\$(who -u am i 2>/dev/null| awk '{print \$NF}'|sed -e 's/[()]//g')\",\"LU\":\"\$(who am i|awk '{print \$1}')\",\"NU\":\"\${USER}\",\"CMD\":\"" 
export PROMPT_COMMAND='history 1|tail -1|sed "s/^[ ]\+[0-9]\+  //"|sed "s/$/\"}/">> /var/log/command.log'
EOF
source /etc/bashrc


# Wrong password five times locked 180s
sed -i "/^auth        required      pam_tally2.so deny=5 unlock_time=180/d" /etc/pam.d/system-auth
sed -i '4a auth        required      pam_tally2.so deny=5 unlock_time=180' /etc/pam.d/system-auth
source /etc/profile
cat /etc/pam.d/system-auth | grep "auth        required      pam_tally2.so"
echo -e "\033[31m other ok \033[0m"
sleep 1
}
 
 
# done
done_ok(){
cat << EOF
+-------------------------------------------------+
|               optimizer is done                 |
|   it's recommond to restart this server !       |
|             Please Reboot system                |
+-------------------------------------------------+
EOF
}
 
 
# main
main(){
    yum_update
    zone_time
    hosts
    limits_config
    sysctl_config
    set_key
    selinux
    ssh_GSS
    backspace_button
    stop_crond
    dissable_service
    stop_ipv6
    inittab
    iptables
    other
    done_ok
}
main

