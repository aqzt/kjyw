#!/bin/bash
##   2016-07-21
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 7

# /etc/sysctl.conf
echo "NETWORKING_IPV6=no">>/etc/sysconfig/network

echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6

# /etc/sysctl.conf
cat >/etc/sysctl.conf<<EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl =15
net.ipv4.tcp_retries2 = 5
net.ipv4.tcp_fin_timeout = 5
net.ipv4.tcp_max_tw_buckets = 60000
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_max_orphans = 32768
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_wmem = 51200 131072 204800
net.ipv4.tcp_rmem = 51200 131072 204800
net.ipv4.ip_local_port_range = 1024 65000
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384
vm.overcommit_memory = 1
net.nf_conntrack_max = 6553500
net.netfilter.nf_conntrack_max = 6553500
net.netfilter.nf_conntrack_tcp_timeout_established = 180
EOF

sysctl -p

##SSH
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

service sshd restart

#sed -i 's/IPV6INIT=yes/IPV6INIT=no/g' /etc/sysconfig/network-scripts/ifcfg-eth0
#sed -i 's/IPV6INIT=yes/IPV6INIT=no/g' /etc/sysconfig/network-scripts/ifcfg-eth1

for ((i=0;i<=10;i++))
do
if [ -f  /etc/sysconfig/network-scripts/ifcfg-eth$i ]
        then
        sed -i 's/IPV6INIT=yes/IPV6INIT=no/g' /etc/sysconfig/network-scripts/ifcfg-eth$i
                echo $i
fi
done








