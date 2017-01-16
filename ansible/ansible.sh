#!/bin/bash
##   2016-06-06
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6

#安装Ansible，安装EPEL第三方yum源
rpm -Uvh epel-release-6-8.noarch.rpm
yum install -y gcc python-devel python-pip libffi-devel libxml2 openssl openssl-devel python-requests python-setuptools python-tornado python-simplejson PyYAML libyaml python-babel python-crypto python-crypto2.6  python-httplib2 python-jinja2-26 libselinux-python python-keyczar python-markupsafe python-paramiko python-pyasn1 python-jinja2 sshpass ansible

##安装ansible另一方法
##wget https://pypi.python.org/packages/source/a/ansible/ansible-2.1.0.0.tar.gz
##wget https://pypi.python.org/packages/source/s/setuptools/setuptools-19.6.2.tar.gz
##tar zxvf  setuptools-19.6.2.tar.gz
##cd setuptools-19.6.2
##python setup.py install
##cd ..
##tar zxvf  ansible-2.1.0.0.tar.gz
##cd ansible-2.1.0.0
##python setup.py build
##python setup.py install
##ansible --version


##添加环境变量以便vi能正常显示中文注释.
vi /etc/profile
##添加:
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
source /etc/profile

##修改主机及组配置
cd /etc/ansible
cp hosts hosts.bak
cat /dev/null > hosts
vi /etc/ansible/hosts
##添加:
[webservers]
192.168.142.136
192.168.142.139
[nginx]
192.168.142.137
192.168.142.138

#ssh无密码认证 DSA
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

##yum -y install openssh-clients
ssh-copy-id -i /root/.ssh/id_dsa.pub root@192.168.142.136
ssh-copy-id -i /root/.ssh/id_dsa.pub root@192.168.142.139

#ssh无密码认证 RSA
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

#注意文件是id_dsa.pub还是id_rsa.pub，否则会出现ssh-copy-id: ERROR: No identities found
ssh-copy-id -i /root/.ssh/id_rsa.pub root@192.168.142.136
ssh-copy-id -i /root/.ssh/id_rsa.pub root@192.168.142.139

##ansible使用ping模块
ansible all -m ping
ansible webservers -m ping


##command: 执行远程主机SHELL命令:
ansible webservers -m command -a "free -m"
ansible webservers -m command -a "df -h"

##command模块 [执行远程命令]
ansible testservers -m command -a 'uname -n'

#检查Ansible节点的运行时间（uptime）
ansible -m command -a "uptime" 'webservers'
#检查节点的内核版本
ansible -m command -a "uname -r" 'webservers'
#重定向输出到文件中
ansible -m command -a "df -Th" 'webservers' > /tmp/command-output.txt
ansible -m command -a "cat /tmp/command-output.txt" 'webservers'

##远程执行MASTER本地SHELL脚本.(类似scp+shell)
echo "df -h" > ~/test.sh
ansible webservers -m script -a "~/test.sh"

##script模块 [在远程主机执行主控端的shell/python脚本 ]
ansible testservers -m script -a '/etc/ansible/test.sh'

##shell模块 [执行远程主机的shell/python脚本]
ansible testservers -m shell -a 'bash /root/test.sh'

##raw模块 [类似于command模块、支持管道传递]
ansible testservers -m raw -a "ifconfig eth0 |sed -n 2p |awk '{print \$2}' |awk -F: '{print \$2}'"

##copy模块
##实现主控端向目标主机拷贝文件, 类似scp功能.
##该实例实现~/test.sh文件至webservers组目标主机/tmp下, 并更新文件owner和group
ansible webservers -m copy -a "src=~/test.sh dest=/tmp/ owner=root group=root mode=0755"
ansible all  -m copy -a "src=/root/cacti.sql dest=/opt/"

##stat模块
##获取远程文件状态信息, 包括atime, ctime, mtime, md5, uid, gid等信息.
ansible webservers -m stat -a "path=/etc/sysctl.conf"
ansible webservers -m stat -a "path=/etc/resolv.conf"

##get_url模块
##实现在远程主机下载指定URL到本地.
ansible webservers -m get_url -a "url=http://www.baidu.com dest=/tmp/index.html mode=0400 force=yes"

##yum模块
##Linux包管理平台操作,  常见都会有yum和apt, 此处会调用yum管理模式
ansible webservers -m yum -a "name=curl state=latest"
ansible webservers -m yum -a "name=nmap state=latest"
ansible all -m yum -a "state=present name=httpd"

##cron模块
##远程主机crontab配置
ansible webservers -m cron -a "name='check dir' hour='5,2' job='ls -alh > /dev/null'"
ansible all -m cron -a 'name="custom job" minute=*/3 hour=* day=* month=* weekday=* job="/usr/sbin/ntpdate time.windows.com"'

##service模块
##远程主机系统服务管理
ansible webservers -m service -a "name=crond state=stopped"
ansible webservers -m service -a "name=crond state=restarted"
ansible webservers -m service -a "name=crond state=reloaded"
##重启webservers组所有SSH服务.
ansible webservers -m service -a "name=sshd state=restarted"

##user服务模块
##远程主机系统用户管理
##添加用户:
ansible webservers -m user -a "name=johnd comment='John Doe'"
ansible webservers -m user -a "name=test comment='test'"

##yum install python-pip
##pip install passlib
##python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.encrypt(getpass.getpass())"
##添加一有密码的用户，用户test1密码123123
ansible webservers -m user -a 'name=test1 password="$6$rounds=656000$sn1Fn.0CnGR1zfka$UNmvy4M6k83/pdro07EjUdtTiuwDzj5lF0v3lPUmsPNXzGBOupf7JWXno/GkHRVkripaxrhWGovqxb6nBf8480"'
#检查是否添加正常
ansible -m command -a "grep johnd /etc/passwd" 'webservers'
##删除用户:
ansible webservers -m user -a "name=johnd state=absent remove=yes"

##模块file，可以修改用户与权限
ansible webservers -m file -a "dest=/tmp/test.sh mode=755 owner=test group=test" 

##synchronize模块：
##delete=yes  使两边的内容一样（即以推送方为主）
##compress=yes  开启压缩，默认为开启
##--exclude=.git  忽略同步.git结尾的文件
##将主控方/root/a目录推送到指定节点的/tmp目录下
ansible 10.1.1.113 -m synchronize -a 'src=/root/a dest=/tmp/ compress=yes'

##将10.1.1.113节点的/tmp/a目录拉取到主控节点的/root目录下
ansible 10.1.1.113 -m synchronize -a 'mode=pull src=/tmp/a dest=/root/'

##facts侦测模块
ansible webservers -m setup -a  "filter=ansible_eth[0-2]"

##Git模块
ansible webservers -m git -a "repo=https://xxx.com/tomcat.git dest=/data"



