#!/bin/bash
## SSH持久化socket  2016-07-14
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6

##SSH持久化socket
cat >/home/php/.ssh/config<<EOF
Host *
  Compression yes
  ServerAliveInterval 60
  ServerAliveCountMax 5
  ControlMaster auto
  ControlPath ~/.ssh/sockets/%r@%h-%p
  ControlPersist 4h
EOF

cat /home/php/.ssh/config


##SSH配置优化
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

cat /etc/ssh/sshd_config


##SSH禁止IPv6,只要ipv4
AddressFamily inet
ListenAddress 0.0.0.0

##不建议启用这两个配置，会导致SSH慢
#GSSAPIAuthentication yes
#GSSAPICleanupCredentials yes