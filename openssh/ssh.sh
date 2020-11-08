#!/bin/bash
##   2016-05-30
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6

ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa -q -b 2048 -C "test@ppabc.cn"

#ssh无密码认证 RSA
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

#ssh无密码认证 DSA
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

#查看生产的密匙
cat ~/.ssh/id_dsa

##用ssh -v 显示详细的登陆信息查找原因：
ssh -v localhost

#拷贝本地生产的key到远程服务器端（两种方法）
#1
cat ~/.ssh/id_dsa.pub | ssh 远程用户名@远程服务器ip 'cat - >> ~/.ssh/authorized_keys'
scp ~/.ssh/id_dsa.pub username@远程机器IP:/userhome/.ssh/authorized_keys
ssh-copy-id  -i /root/.ssh/id_dsa.pub root@192.168.142.136

#2
scp ~/.ssh/id_dsa.pub test@10.0.0.13:/home/test/
##登陆远程服务器test@10.0.0.13 后执行：
cat /home/test/id_dsa.pub >>  ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys


##ssh密钥分发脚本
#!/bin/sh
read -p "输入远端服务器IP: " ip
##ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub root@$ip
ssh-copy-id -i ~/.ssh/id_rsa.pub root@$ip
ssh root@$ip 'sed -i "s/^#RSAAuthentication\ yes/RSAAuthentication\ yes/g" /etc/ssh/sshd_config'
ssh root@$ip 'sed -i "s/^#PubkeyAuthentication\ yes/PubkeyAuthentication yes/g" /etc/ssh/sshd_config'
ssh root@$ip 'sed -i "s/^#PermitRootLogin\ yes/PermitRootLogin\ yes/g" /etc/ssh/sshd_config'
ssh root@$ip 'service sshd restart'
hostname=`ssh root@${ip} 'hostname'`
echo "添加主机名和IP到本地/etc/hosts文件中"
echo "$ip    $hostname" >> /etc/hosts
echo "远端主机主机名称为$hostname, 请查看 /etc/hosts 确保该主机名和IP添加到主机列表文件中"
