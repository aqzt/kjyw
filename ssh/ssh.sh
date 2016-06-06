#!/bin/bash
##   2016-05-30
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6

#ssh无密码认证
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

#查看生产的密匙
cat ~/.ssh/id_dsa

##用ssh -v 显示详细的登陆信息查找原因：
ssh -v localhost

#拷贝本地生产的key到远程服务器端（两种方法）
#1
cat ~/.ssh/id_rsa.pub | ssh 远程用户名@远程服务器ip 'cat - >> ~/.ssh/authorized_keys'
scp ~/.ssh/id_rsa.pub username@远程机器IP:/userhome/.ssh/authorized_keys

#2
scp ~/.ssh/id_dsa.pub test@10.0.0.13:/home/test/
##登陆远程服务器test@10.0.0.13 后执行：
cat /home/test/id_dsa.pub >>  ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys



