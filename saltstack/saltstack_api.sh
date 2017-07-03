#!/bin/bash
## SaltStack安装  2017-07-03
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 7


##安装必备软件
yum -y install mariadb mariadb-devel mariadb-server wget epel-release python-devel gcc c++ make openssl openssl-devel passwd libffi libffi-devel
yum -y install salt-master salt-minion salt-api nginx
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py

##配置salt-api
pip install pyOpenSSL==0.15.1  -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com
useradd -M -s /sbin/nologin saltapi && echo "password"|/usr/bin/passwd saltapi --stdin
salt-call --local tls.create_self_signed_cert

##配置salt-master 我这里把soms解压到了/data/wwwroot下
cat > /etc/salt/master <<EOF
interface: 0.0.0.0

external_auth:
  pam:
    saltapi:
      - .*
      - '@wheel'
      - '@runner'
      - '@jobs'

rest_cherrypy:
  port: 8000
  ssl_crt: /etc/pki/tls/certs/localhost.crt
  ssl_key: /etc/pki/tls/certs/localhost.key

file_recv: True

include: /data/wwwroot/soms/saltconfig/*.conf
EOF

##配置好后，把服务启起来，并测试salt-api
systemctl start salt-master salt-api
curl -sSk https://localhost:8000/login -H 'Accept: application/x-yaml' -d username=saltapi -d password=password -d eauth=pam


##################  另一套配置                   ####################################################################################
################################################################################################################

##安装salt api
yum -y install salt-api pyOpenSSL    
chkconfig salt-api on    

##创建用户，saltapi认证使用
useradd -M -s /sbin/nologin kbson    
echo 'kbson' | passwd kbson --stdin    

##添加salt api配置
[root@operation ops]# cat /etc/salt/master.d/api.conf   
rest_cherrypy:    
  port: 8000    
  ssl_crt: /etc/pki/tls/certs/localhost.crt    
  ssl_key: /etc/pki/tls/certs/localhost.key  
external_auth:    
  pam:    
    kbson:              
      - .*  
      - '@wheel'  
      - '@runner'  


##生成自签名证书
[root@operation ops]# salt-call tls.create_self_signed_cert  
local:  
    Certificate "localhost" already exists  
##提示已经存在时，可以删除/etc/pki/tls/certs/localhost.crt  /etc/pki/tls/certs/localhost.key重新生成

##获取token
[root@operation ops]# curl -k https://192.168.56.102:8000/login  -H "Accept: application/x-yaml" -d username='kbson' -d password='kbson' -d eauth='pam'  
return:  
- eauth: pam  
  expire: 1480714218.787106  
  perms:  
  - .*  
  - '@wheel'  
  - '@runner'  
  start: 1480671018.787106  
  token: ab3749a9a0fe83386b8a5d558d10e346c252e336  
  user: kbson  

##重启salt-api后token会改变
##执行models，test.ping测试minion连通性
[root@operation ops]# curl -k https://192.168.56.102:8000 -H "Accept: application/x-yaml" -H "X-Auth-Token: ab3749a9a0fe83386b8a5d558d10e346c252e336" -d client='local' -d tgt='*' -d fun='test.ping'    
return:  
- operation: true  

##远程执行命令
[root@operation ops]# curl -k https://192.168.56.102:8000 -H "Accept: application/x-yaml" -H "X-Auth-Token: ab3749a9a0fe83386b8a5d558d10e346c252e336" -d client='local' -d tgt='*' -d fun='cmd.run'   -d arg='free -m'  
return:  
- operation: '             total       used       free     shared    buffers     cached  
  
    Mem:           988        932         56          1         19        107  
  
    -/+ buffers/cache:        805        182  
  
    Swap:         1983        382       1601'  

远程执行多个minion命令
[root@operation ops]# curl -k https://192.168.56.102:8000 -H "Accept: application/x-yaml" -H "X-Auth-Token: ab3749a9a0fe83386b8a5d558d10e346c252e336"  -d client='local' -d tgt='operation,slave01'  -d expr_form='list'  -d fun='cmd.run' -d arg='free -m'  
return:  
- operation: '             total       used       free     shared    buffers     cached  
  
  
    Mem:           988        925         63          1         21         81  
  
  
    -/+ buffers/cache:        821        166  
  
  
    Swap:         1983        393       1590'  
  slave01: '             total       used       free     shared    buffers     cached  
  
  
    Mem:          1870        622       1248          6         79        300  
  
  
    -/+ buffers/cache:        242       1628  
  
  
    Swap:         2047          0       2047'  
[root@operation ops]#  
执行wheel
查看minion key状态
[root@operation ops]# curl -k https://192.168.56.102:8000 -H "Accept: application/x-yaml" -H "X-Auth-Token: ab3749a9a0fe83386b8a5d558d10e346c252e336" -d client='wheel'  -d fun='key.list_all'  
return:  
- data:  
    _stamp: '2016-12-02T09:30:35.235660'  
    fun: wheel.key.list_all  
    jid: '20161202173034905379'  
    return:  
      local:  
      - master.pem  
      - master.pub  
      minions:  
      - operation  
      - slave01  
      minions_denied: []  
      minions_pre: []  
      minions_rejected: []  
    success: true  
    tag: salt/wheel/20161202173034905379  
    user: kbson  
  tag: salt/wheel/20161202173034905379  