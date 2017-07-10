#!/bin/bash
## sftp开账号  限制主目录脚本

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
 
if [ $(whoami) != "root" ]; then
        echo "***********************************************************************"
        echo "Error: You must be root to run this script, please use root to run"
        echo " **********************************************************************"
        exit 1
fi
 
GROUPNAME="sftpchroot"
echo "***********************************************************************"
echo "The GroupName will chrootsftp into : [$GROUPNAME]. You can change it"
echo "***********************************************************************"
 
if [ "$GROUPNAME" = `cat /etc/group | grep "$GROUPNAME" | awk -F: '{print $1}'` ]; then
        echo "******************************************"
        echo "The GroupName: $GROUPNAME exist already!"
        echo "******************************************"
        echo "The next will add user into $GROUPNAME!"
        echo "******************************************"
else
        groupadd $GROUPNAME
        echo "**********************************************"
        echo "This group [ $GROUPNAME ] add successfully!"
        echo "**********************************************"
        sed -i 's/Subsystem\tsftp\t\/usr\/libexec\/sftp-server/Subsystem\tsftp\tinternal-sftp/g' /etc/ssh/sshd_config
        echo "Match Group $GROUPNAME" >> /etc/ssh/sshd_config
        echo "ChrootDirectory %h" >> /etc/ssh/sshd_config
        echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config
        /etc/init.d/sshd condrestart
fi
 
read -p "(Please input the UserName which into $GROUPNAME to be chrooted):" user
if [ "$user" = "" ]; then
        echo "*****************************************************************"
        echo "You must input UserName which will into $GROUPNAME to be chrooted!"
        echo "*****************************************************************"
        exit 2
fi
 
if [ ! -e /home/$user ]; then
        echo "***************************"
        echo "username=$user"
        echo "***************************"
        useradd -G $GROUPNAME $user
        chown root:$user /home/$user
        chmod 755 /home/$user
        mkdir /home/$user/.ssh
        chown $user:$user /home/$user/.ssh
        chmod 700 /home/$user/.ssh
        touch /home/$user/.ssh/authorized_keys
        chown $user:$user /home/$user/.ssh/authorized_keys
        chmod 600 /home/$user/.ssh/authorized_keys
        echo "***************************"
        echo Please set passwd for $
        echo "***************************"
        passwd $user
else
        echo "***************************"
        echo "$user is exist already!"
        echo "***************************"
        read -p "Are you sure to chroot $user to $GROUPNAME ? [y or n]" y_or_n
        if [ "$y_or_n" == 'y' ]; then
                usermod -G $GROUPNAME $user
                chown root:$user /home/$user
                chmod 755 /home/$user
                if [ ! -e /home/$user/.ssh ]; then
                        mkdir /home/$user/.ssh
                fi
                chown $user:$user /home/$user/.ssh
                chmod 700 /home/$user/.ssh
                if [ ! -f /home/$user/.ssh/authorized_keys ]; then
                        touch /home/$user/.ssh/authorized_keys
                fi
                chown $user:$user /home/$user/.ssh/authorized_keys
                chmod 600 /home/$user/.ssh/authorized_keys
        fi
fi
