# welcome
cat << EOF
+--------------------------------------------------------------+
|         === Welcome to Centos System init ===                |
+--------------------------------------------------------------+
EOF

# disable ipv6
cat << EOF
+--------------------------------------------------------------+
|         === Welcome to Disable IPV6 ===                      |
+--------------------------------------------------------------+
EOF
echo "alias net-pf-10 off" >> /etc/modprobe.conf
echo "alias ipv6 off" >> /etc/modprobe.conf
/sbin/chkconfig --level 35 ip6tables off
echo "ipv6 is disabled!"

# disable selinux
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config 
echo "selinux is disabled,you must reboot!"

# vim
sed -i "8 s/^/alias vi='vim'/" /root/.bashrc
cat >/root/.vimrc<<EOF
syntax on
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
EOF


# init_ssh
sed -i '/GSSAPI/ {s/yes/no/g};/UseDNS/ {s/.*/UseDNS no/};/^SyslogFacility/ {s/AUTHPRIV/local5/g}' /etc/ssh/sshd_config 
sed -i '/StrictHostKeyChecking/ {s/.*/StrictHostKeyChecking no/}' /etc/ssh/ssh_config
sed -i '$ a\# save sshd messages also to sshd.log \nlocal5.* \t\t\t\t\t\t /var/log/sshd.log'  /etc/syslog.conf  
echo "Configured SSH initialization!"

# chkser
# tunoff services
#--------------------------------------------------------------------------------
cat << EOF
+--------------------------------------------------------------+
|         === Welcome to Tunoff services ===                   |
+--------------------------------------------------------------+
EOF
#---------------------------------------------------------------------------------
for i in `ls /etc/rc3.d/S*`
do
             CURSRV=`echo $i|cut -c 15-`

echo $CURSRV
case $CURSRV in
         crond | irqbalance | microcode_ctl | network | random | sendmail | sshd | syslog | local | mysqld | nginx | fastcgi )
     echo "Base services, Skip!"
     ;;
     *)
         echo "change $CURSRV to off"
         chkconfig --level 235 $CURSRV off
         service $CURSRV stop
     ;;
esac
done

# set ntpdate
# crontab
crontab -l >> /tmp/crontab2.tmp
echo '15 1 * * * /usr/sbin/ntpdate ntp.api.bz;/usr/sbin/hwclock -w > /dev/null 2>&1' >> /tmp/crontab2.tmp
crontab /tmp/crontab2.tmp
rm /tmp/crontab2.tmp

echo -e "\033[32;49;1mInitialization complete"
echo -en "\033[39;49;0m"

