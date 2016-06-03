#!/bin/bash
##   2016-05-30
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

#非常实用的运维shell命令


#1.显示消耗内存/CPU最多的10个进程

ps aux |sort-nk +4|tailps aux |sort-nk +3|tail
#2.查看Apache的并发请求数及其TCP连接状态

netstat -n|awk'/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
#3.找出自己最常用的10条命令及使用次数（或求访问最多的ip数）

sed-e's/| /\n/g' ~/.bash_history |cut-d''-f1|sort|uniq-c|sort-nr|head
#4.日志中第10个字段表示连接时间，求平均连接时间

cat access_log |grep “connect cbp” |awk ‘BEGIN{sum=0;count=0;}{sum+=$10;count++;}END{printf(“sum=%d,count=%d,avg=%f\n”,sum,count,sum/count)}’

#5.lsof命令

lsof abc.txt 显示开启文件abc.txt的进程 lsof -i :22 知道22端口现在运行什么程序 lsof -c abc 显示abc进程现在打开的文件 lsof -p12 看进程号为12的进程打开了哪些文件
#6.杀掉一个程序的所有进程

pkill -9 httpd killall-9 httpd
注意尽量不用-9，数据库服务器上更不能轻易用kill，否则造成重要数据丢失后果将不堪设想。

#7.rsync命令（要求只同步某天的压缩文件，而且远程目录保持与本地目录一致）

/usr/bin/rsync -azvR –password-file=/etc/rsync.secrets `find . -name “*$yesterday.gz” -type f ` storage@192.168.2.23::logbackup/13.21/

#8.把目录下*.sh文件改名为*.SH

find . -name"*.sh"|sed's/\(.*\)\.sh/mv \0 \1.SH/'|shfind . -name"*.sh"|sed's/\(.*\)\.sh/mv & \1.SH/'|sh （跟上面那个效果一样）
#9.ssh执行远程的程序，并在本地显示

ssh-n-l zouyunhao 192.168.2.14 "ls -al /home/zouyunhao"
#10. 直接用命令行修改密码

echo"zouyunhaoPassword"|passwd –stdin zouyunhao  ssh-keygen ssh-copy-id -i ~/.ssh/id_rsa.pub user@remoteServer
#12.以http方式共享当前文件夹的文件

$ python -m SimpleHTTPServer 在浏览器访问http://IP:8000/即可下载当前目录的文件。
#13.shell段注释

#:<<'echo hello,world!'
##14.查看服务器序列号

dmidecode |grep"Serial Number"
（查看机器其他硬件信息也可用这个命令）

 

#15.查看网卡是否有网线物理连接

/sbin/mii-tool
ethool eth0



