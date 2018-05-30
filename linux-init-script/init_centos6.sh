#!/bin/bash
# init centos6
# 20160818

# 检查是否为root用户，脚本必须在root权限下运行
if [[ "$(whoami)" != "root" ]]; then
    echo "please run this script as root !" >&2
    exit 1
fi
echo -e "\033[31m the script only Support CentOS_6 x86_64 \033[0m"
echo -e "\033[31m system initialization script, Please Seriously. press ctrl+C to cancel \033[0m"

# 检查是否为64位系统，这个脚本只支持64位脚本
platform=`uname -i`
if [ $platform != "x86_64" ];then
    echo "this script is only for 64bit Operating System !"
    exit 1
fi

if [ "$1" == "" ];then
    echo "The host name is empty."
    exit 1
else
	hostname  $1
	hostname
	sed -i "/HOSTNAME=/d" /etc/sysconfig/network
	echo "HOSTNAME=$1" >>/etc/sysconfig/network
fi

cat << EOF
+---------------------------------------+
|   your system is CentOS 6 x86_64      |
|           start optimizing            |
+---------------------------------------+
EOF
sleep 1

# 安装必要支持工具及软件工具
yum_update(){
yum update -y
yum install -y nmap unzip wget vim lsof xz ntpdate
echo ok
}

# 设置时间同步 set time
zone_time(){
rm -rf /etc/localtime
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
cat > /etc/sysconfig/clock << EOF
ZONE="Asia/Shanghai"
UTC=false
ARC=false
EOF

/usr/sbin/ntpdate 0.cn.pool.ntp.org > /dev/null 2>&1
/usr/sbin/hwclock --systohc
/usr/sbin/hwclock -w
cat > /var/spool/cron/root << EOF
10 0 * * * /usr/sbin/ntpdate 0.cn.pool.ntp.org > /dev/null 2>&1
* * * * */1 /usr/sbin/hwclock -w > /dev/null 2>&1
EOF
chmod 600 /var/spool/cron/root
/sbin/service crond restart
sleep 1
}

# 修改文件打开数 set the file limit
limits_config(){
cat > /etc/rc.d/rc.local << EOF
#!/bin/bash

touch /var/lock/subsys/local
ulimit -SHn 1024000
EOF

sed -i "/^ulimit -SHn.*/d" /etc/rc.d/rc.local
echo "ulimit -SHn 1024000" >> /etc/rc.d/rc.local

sed -i "/^ulimit -s.*/d" /etc/profile
sed -i "/^ulimit -c.*/d" /etc/profile
sed -i "/^ulimit -SHn.*/d" /etc/profile
 
cat >> /etc/profile << EOF

ulimit -u 1024000
ulimit -d unlimited
ulimit -m unlimited
ulimit -s unlimited
ulimit -t unlimited
ulimit -v unlimited
ulimit -c unlimited
ulimit -SHn 1024000
EOF
 
source /etc/profile
ulimit -a
cat /etc/profile | grep ulimit

if [ ! -f "/etc/security/limits.conf.bak" ]; then
    cp /etc/security/limits.conf /etc/security/limits.conf.bak
fi

cat > /etc/security/limits.conf << EOF
* soft nofile 1024000
* hard nofile 1024000
* soft nproc  1024000
* hard nproc  1024000
EOF


if [ ! -f "/etc/security/limits.d/90-nproc.conf.bak" ]; then
    cp /etc/security/limits.d/90-nproc.conf /etc/security/limits.d/90-nproc.conf.bak
fi

cat > /etc/security/limits.d/90-nproc.conf << EOF
*          soft    nproc     1024000
root       soft    nproc     unlimited
EOF

sleep 1
}
 
# 优化内核参数 tune kernel parametres 
sysctl_config(){
if [ ! -f "/etc/sysctl.conf.bak" ]; then
    cp /etc/sysctl.conf /etc/sysctl.conf.bak
fi

#add
cat > /etc/sysctl.conf << EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl =15
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 5
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_max_tw_buckets = 60000
net.ipv4.tcp_max_orphans = 32768
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_wmem = 4096 16384 13107200
net.ipv4.tcp_rmem = 4096 87380 17476000
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.route.gc_timeout = 100
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.nf_conntrack_max = 6553500
net.netfilter.nf_conntrack_max = 6553500
net.netfilter.nf_conntrack_tcp_timeout_established = 180
vm.overcommit_memory = 1
vm.swappiness = 1
fs.file-max = 1024000
EOF
 
#reload sysctl
/sbin/sysctl -p
sleep 1
}

#关闭SELINUX disable selinux
selinux_config(){
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
sleep 1
}

# iptables防护墙规则设置
iptables_config(){
mkdir  -p /opt/sh
cat > /opt/sh/ipt.sh << EOF
#!/bin/bash
/sbin/iptables -F
/sbin/iptables -t raw -F

/sbin/iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
/sbin/iptables -A INPUT -s 127.0.0.1 -j ACCEPT
/sbin/iptables -A INPUT -m state --state UNTRACKED,ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -A OUTPUT -j ACCEPT
/sbin/iptables -A INPUT -s 192.168.10.152 -j ACCEPT
/sbin/iptables -A INPUT -s 192.168.20.102 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 80  -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 22  -j ACCEPT
/sbin/iptables -A INPUT -s 192.168.10.0/255.255.255.0 -p tcp --dport 8080  -j ACCEPT
/sbin/iptables -A INPUT -s 192.168.20.0/255.255.255.0 -p tcp --dport 8080  -j ACCEPT
/sbin/iptables -t raw -A PREROUTING -s 192.168.10.0/255.255.255.0 -p tcp --dport 80  -j NOTRACK
/sbin/iptables -t raw -A PREROUTING -s 192.168.20.0/255.255.255.0 -p tcp --dport 80  -j NOTRACK
/sbin/iptables -t raw -A OUTPUT -s 192.168.10.0/255.255.255.0 -p tcp --sport 80  -j NOTRACK
/sbin/iptables -t raw -A OUTPUT -s 192.168.20.0/255.255.255.0 -p tcp --sport 80  -j NOTRACK
/sbin/iptables -A INPUT   -s 192.168.10.0/255.255.255.0 -p icmp -j ACCEPT
/sbin/iptables -A INPUT   -s 192.168.20.0/255.255.255.0 -p icmp -j ACCEPT

/sbin/iptables -A INPUT -j REJECT
/sbin/iptables -A FORWARD -j REJECT

/sbin/service iptables save
echo ok
EOF
chmod  +x /opt/sh/ipt.sh
/opt/sh/ipt.sh
/sbin/service iptables restart

/sbin/iptables -nL
/sbin/iptables -t raw -L -n

#echo "/opt/sh/ipt.sh"  >>/etc/rc.d/rc.local
}


# SSH配置优化 set sshd_config
sshd_config(){
if [ ! -f "/etc/ssh/sshd_config.bak" ]; then
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
fi

cat >/etc/ssh/sshd_config<<EOF
Port 22
AddressFamily inet
ListenAddress 0.0.0.0
Protocol 2
SyslogFacility AUTHPRIV
PermitRootLogin yes
MaxAuthTries 6
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile	.ssh/authorized_keys
PasswordAuthentication yes
PermitEmptyPasswords no
UsePAM yes
UseDNS no
X11Forwarding yes
Subsystem       sftp    /usr/libexec/openssh/sftp-server
EOF
/sbin/service sshd restart
}


# 关闭ipv6  disable the ipv6
ipv6_config(){
cat  >>/etc/modprobe.d/dist.conf<<EOF
alias net-pf-10 off
alias ipv6 off
EOF
echo "alias net-pf-10 off" >> /etc/modprobe.conf
echo "alias ipv6 off" >> /etc/modprobe.conf
echo "127.0.0.1   localhost   localhost.localdomain">/etc/hosts
/sbin/chkconfig --level 35 ip6tables off
}


# 设置历史命令记录格式 history
history_config(){
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
export HISTTIMEFORMAT="{\"TIME\":\"%F %T\",\"IP\":\"\$(ip a | grep -E '192.168|172' | head -1 | awk '{print \$2}' | cut -d/ -f1)\",\"LI\":\"\$(who -u am i 2>/dev/null| awk '{print \$NF}'|sed -e 's/[()]//g')\",\"LU\":\"\$(who am i|awk '{print \$1}')\",\"NU\":\"\${USER}\",\"CMD\":\"" 
export PROMPT_COMMAND='history 1|tail -1|sed "s/^[ ]\+[0-9]\+  //"|sed "s/$/\"}/">> /var/log/command.log'
EOF
source /etc/bashrc
}

# 服务优化设置
service_config(){
chkconfig bluetooth off > /dev/null 2>&1
chkconfig cups off  > /dev/null 2>&1
chkconfig ip6tables off  > /dev/null 2>&1
chkconfig iptables on
chkconfig network on
chkconfig | grep -E "cups|ip6tables|bluetooth"
chmod +x /etc/rc.local
chmod +x /etc/rc.d/rc.local
#ls -l /etc/rc.d/rc.local
}

# 路由设置
route_config(){
#localip=`ip a|grep "inet "|awk -F" " '{print $2}'|awk -F"/" '{print $1}'|egrep "^192" |head -n 1 |awk -F '[.]' '{print $3}'`
#if [ "$localip" == "10" ];then
#	echo "/sbin/route add -net 192.168.20.0 netmask 255.255.255.0 gw 192.168.1.1">/opt/sh/route.sh
#	echo "/sbin/route -n">>/opt/sh/route.sh
#fi
#if [ "$localip" == "20" ];then
#	echo "/sbin/route add -net 192.168.10.0 netmask 255.255.255.0 gw 192.168.2.1">/opt/sh/route.sh
#	echo "/sbin/route -n">>/opt/sh/route.sh
#fi
#chmod +x /opt/sh/route.sh
#/opt/sh/route.sh
#echo "/opt/sh/route.sh"  >>/etc/rc.local
echo ok
}

# VIM设置
vim_config(){
cat > /root/.vimrc << EOF
set history=1000
EOF
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
    limits_config
    sysctl_config
    selinux_config
    iptables_config
    sshd_config
    ipv6_config
    history_config
    service_config
    route_config
    vim_config
    done_ok
}
main





