#!/bin/bash
## SSH持久化socket  2016-07-14
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6

##SSH持久化socket
cat /home/php/.ssh/config

Host *
  Compression yes
  ServerAliveInterval 60
  ServerAliveCountMax 5
  ControlMaster auto
  ControlPath ~/.ssh/sockets/%r@%h-%p
  ControlPersist 4h
  

##SSH配置优化
cat /etc/ssh/sshd_config
Port 22
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

##不建议启用这两个配置，会导致SSH慢
#GSSAPIAuthentication yes
#GSSAPICleanupCredentials yes