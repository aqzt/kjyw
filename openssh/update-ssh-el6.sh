#!/bin/bash
# Centos6下Openssh-8.2p1离线rpm安装包下载
# https://aq2.cn/131.html

NowTime=$(/bin/date +%Y%m%d%H%M%S)

if [[ "$(whoami)" != "root" ]]; then
    echo "please run this script as root !" >&2
    exit 1
fi

if [[ ! -f  /bin/cp  ]]; then
    echo "/bin/cp file exists" >&2
    exit 1
fi
if [[ ! -d "/opt/backup/openssh_bak" ]];then
  mkdir -p /opt/backup/openssh_bak/
  /bin/cp /etc/pam.d/sshd /opt/backup/openssh_bak/sshd.bak
  /bin/cp /etc/pam.d/system-auth /opt/backup/openssh_bak/system-auth.bak
  /bin/cp /etc/ssh/sshd_config /opt/backup/openssh_bak/
  /bin/cp /etc/ssh/ssh_config /opt/backup/openssh_bak/
  /bin/cp /etc/ssh/ssh*key /opt/backup/openssh_bak/
else
  mkdir -p "/opt/backup/openssh_$NowTime/"
  /bin/cp /etc/pam.d/sshd "/opt/backup/openssh_$NowTime/sshd.bak"
  /bin/cp /etc/pam.d/system-auth "/opt/backup/openssh_$NowTime/system-auth.bak"
  /bin/cp /etc/ssh/sshd_config "/opt/backup/openssh_$NowTime/"
  /bin/cp /etc/ssh/ssh_config "/opt/backup/openssh_$NowTime/"
  /bin/cp /etc/ssh/ssh*key "/opt/backup/openssh_$NowTime/"
fi

yum localinstall openssh-*.rpm -y
chmod 600 /etc/ssh/ssh_host_*_key
/bin/cp /opt/backup/openssh_bak/sshd.bak /etc/pam.d/sshd
echo -e '
Port 22
AddressFamily inet
ListenAddress 0.0.0.0
Protocol 2
SyslogFacility AUTHPRIV
PermitRootLogin yes
MaxAuthTries 6
PubkeyAuthentication yes
AuthorizedKeysFile      .ssh/authorized_keys
PasswordAuthentication yes
PermitEmptyPasswords no
UsePAM yes
UseDNS no
X11Forwarding yes
Subsystem       sftp    /usr/libexec/openssh/sftp-server
' > /etc/ssh/sshd_config

chkconfig sshd on
service sshd restart

ssh -V