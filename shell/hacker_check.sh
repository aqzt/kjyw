#!/bin/bash
##   2016-05-30
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

#Linux入侵检查实用指令

1
可以得出filename正在运行的进程
#pidof filename
2
可以通过文件或者tcp udp协议看到进程
#fuser -n tcp port
3
可以看文件修改时间，大小等信息
#stat filename
4
看加载模块
#lsmod
5
看rpc服务开放
#rpcinfo -p
6
看网卡是否混杂模式(promiscuous mod)
#dmesg|grep eth0

7
看命令是否被更改，象md5sum一样
#rpm -Vf /bin/ls
rpm -Vf /bin/ps正常无输出，否则输出SM5….T /bin/su之类提示
如果rpm的数据库被修改则不可靠了，只能通过网络或则cdrom中的rpm数据库来比较
如：rpm -Vvp ftp://mirror.site/dir/RedHat/RPMS/fileutils-3.16-10.i386.rpm
以下常用命令需要检查
/usr/bin/chfn
usr/bin/chsh
/bin/login
/bin/ls
/usr/bin/passwd
/bin/ps
/usr/bin/top
/usr/sbin/in.rshd
/bin/netstat
/sbin/ifconfig
/usr/sbin/syslogd
/usr/sbin/inetd
/usr/sbin/tcpd
/usr/bin/killall
/sbin/pidof
/usr/bin/find

8
如果检查的是已经确认被黑客攻击的机器，完美建议：
1.dd一个备份硬盘上
2.mount 一个光驱，上面有静态编译好的程序ls ps netstat等常用工具
3.用nc把执行步骤输出到远程机器上

9
用md5sum保存一个全局的文件
find /sbin -type f|xargs md5sum >1st
检查是否改变
md5sum -c 1st|grep OK

10
避免在已经攻击的机器上过多写操作，可以：
1.在另一个机器192.168.20.191上运行
nc -L -p 1234 >some_audit_output.log 注意L是大写，可以永久侦听
2.被攻击机器上运行
command|nc 192.168.20.191 1234
或
script >/mnt/export.log
检测完毕后用ctrl+d保存记录

11
通过进程查找可疑程序方法：
1.netstat -anp 这步主要靠经验，把可疑的都记录下来
2.进入内存目录 cd /proc/3299
3. ls -la，一般exe可以看到执行文件路径，
4.再进入fd目录查看文件句柄，至此一般都可以找出执行程序
5.ps -awx 把刚才可疑的进程观察一遍

12
如果hacker把日志删除了：
1.查找所有未被删除彻底的日志，比如history，sniffer日志
2./proc/pid/fd 目录里提示已经删除的文件
l-wx—— 1 root root 64 Aug 10 20:54 15 -> /var/log/httpd/error_log (deleted)
l-wx—— 1 root root 64 Aug 10 20:54 18 -> /var/log/httpd/ssl_engine_log (deleted)
l-wx—— 1 root root 64 Aug 10 20:54 19 -> /var/log/httpd/ssl_mutex.800 (deleted)
l-wx—— 1 root root 64 Aug 10 20:54 20 -> /var/log/httpd/access_log (deleted)
l-wx—— 1 root root 64 Aug 10 20:54 21 -> /var/log/httpd/access_log (deleted)
l-wx—— 1 root root 64 Aug 10 20:54 22 -> /var/log/httpd/ssl_request_log (deleted)
l-wx—— 1 root root 64 Aug 10 20:54 23 -> /var/log/httpd/ssl_mutex.800 (deleted)
lrwx—— 1 root root 64 Aug 10 20:54 3 -> /var/run/httpd.mm.800.sem (deleted)
lrwx—— 1 root root 64 Aug 10 20:54 4 -> /var/log/httpd/ssl_scache.sem (deleted)

3.用静态编译的lsof |grep deleted查看哪些被删除
COMMAND PID USER FD TYPE DEVICE SIZE NODE NAME
gpm 1650 root 1u REG 8,2 5 149743 /var/run/gpm208raa (deleted)

4.得到文件inode号，这里是149743
5.使用sleuthkit工具来恢复，
df /var得出硬盘位置是sda1
icat /dev/sda1 149743
6.把恢复的文件仔细查看，一般都可以找到痕迹了

这样会使分析编译后的程序困难
gcc -04 -evil.c -o evil
strip ./evil

1.file查看文件类型，是否静态编译、是否strip过
2.strings显示程序中的asicc字符串,通过字符串再到google上找
3.strace是跟踪系统调用（这个还不知道怎么样用）strace -p pid
4.gdb（更不会用啦）

13
有些进程不在进程里显示，但在/proc中有痕迹，可比较找出隐藏的进程
proc是伪文件系统，为/dev/kmem提供一个结构化的接口，便于系统诊断并查看每一个正在运行的可执行文件的环境
#ps -ef|awk ‘{print $2}’|sort -n|uniq >1
#ls /porc |sort -n|uniq >2
#diff 1 2

14
应急工具tct，里面有许多使用工具，包括icat等数据恢复
如果在被攻击的机器取证，可以mount一块硬盘，也可以备份到网络中，方法：
a.在网络机器运行 nc -L -p 1234 >abc.img
b.肉鸡运行 dd if=/dev/hdb5 count 20000 bs=1024|nc 192.168.0.1 1234 -w 3
如果备份过大，则可以侦听多个端口，执行多个dd拷贝，然后把文件合并 cat 2 >>1.img

15
ldd可以显示一个可执行程序所依赖的动态库,但间接依赖库无法显示出来
[root@rh9bk root]# ldd /bin/ls
libtermcap.so.2 => /lib/libtermcap.so.2 (0×40022000)
libc.so.6 => /lib/tls/libc.so.6 (0×42000000)
/lib/ld-linux.so.2 => /lib/ld-linux.so.2 (0×40000000)
strace工具是一个调试工具，它可以显示出一个程序在执行过程中的所有系统调用，
[root@rh9bk root]# strace -eopen /bin/ls >/dev/null
open(“/etc/ld.so.preload”, O_RDONLY) = -1 ENOENT (No such file or directory)
open(“/etc/ld.so.cache”, O_RDONLY) = 3
open(“/lib/libtermcap.so.2″, O_RDONLY) = 3
open(“/lib/tls/libc.so.6″, O_RDONLY) = 3
open(“/usr/lib/locale/locale-archive”, O_RDONLY|O_LARGEFILE) = 3
open(“.”, O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
open(“/etc/mtab”, O_RDONLY) = 3
open(“/proc/meminfo”, O_RDONLY) = 3

strace -o out telnet 192.168.100.100
o参数的含义是将strace的输出信息生成到out文件中，这个文件名是可以随意制定的。
我们打开out文件会发现大量的系统调用信息，我们关心的主要是open这个系统调用的信息，open是用来打开文件的，不仅调用动态库要先用open打开，读取配置文件也使用open，所以用sed写一个简单的脚本就可以输出out文件中所有的open信息
sed -n -e ‘/^open/p’ out
输出信息如下：
open(“/etc/ld.so.preload”, O_RDONLY) = -1 ENOENT (No such file or directory)
open(“/etc/ld.so.cache”, O_RDONLY) = 3
open(“/lib/libutil.so.1″, O_RDONLY) = 3
open(“/usr/lib/libncurses.so.5″, O_RDONLY) = 3
open(“/lib/i686/libc.so.6″, O_RDONLY) = 3
open(“/etc/resolv.conf”, O_RDONLY) = 3
open(“/etc/nsswitch.conf”, O_RDONLY) = 3
open(“/etc/ld.so.cache”, O_RDONLY) = 3
open(“/lib/libnss_files.so.2″, O_RDONLY) = 3
open(“/etc/services”, O_RDONLY) = 3
open(“/etc/host.conf”, O_RDONLY) = 3
open(“/etc/hosts”, O_RDONLY) = 3
open(“/etc/ld.so.cache”, O_RDONLY) = 3
open(“/lib/libnss_nisplus.so.2″, O_RDONLY) = 3
open(“/lib/libnsl.so.1″, O_RDONLY) = 3
open(“/var/nis/NIS_COLD_START”, O_RDONLY) = -1 ENOENT (No such file or directory)
open(“/etc/ld.so.cache”, O_RDONLY) = 3
open(“/lib/libnss_dns.so.2″, O_RDONLY) = 3
open(“/lib/libresolv.so.2″, O_RDONLY) = 3
open(“/etc/services”, O_RDONLY) = 3
open(“/root/.telnetrc”, O_RDONLY) = -1 ENOENT (No such file or directory)
open(“/usr/share/terminfo/l/linux”, O_RDONLY) = 4
从输出中可以发现ldd显示不出来的几个库
/lib/libnss_dns.so.2 ，
/lib/libresolv.so.2 ，
/lib/libnsl.so.1，
/lib/libnss_nisplus.so.2，
/lib/libnss_files.so.2

strace -o aa -ff -p PID会产生aa名称开头的多个文件

grep open aa* | grep -v -e No -e null -e denied| grep WR 查看其打开调用的文件信息。

16
要把日志发送到日志主机步骤:
a.vi /etc/syslog.conf *.* @192.168.20.163 把所有日志发送到192.168.20.163
b.service syslog restart
c.在192.168.20.163安装kiwisyslogd
d.远程登陆,故意输入错误密码,可看到日志主机上马上有报警,也可以tcpdump port 514观察

17
如果知道黑客是0927入侵的，则：
touch -t 09270000 /tmp/a
find / \( -newer /tmp/a -o -cnewer /tmp/a \) -l
这样那天改变和创建的文件被列出

18
整盘复制
dd if=/dev/sda of=/dev/sdb bs=1024
分区复制 测试过
dd if=/dev/sda1 of=/abc bs=1024 这里是保存在了根分区，用mount查看是sda2
启动另一个linux
输入：mount /dev/sda2 /mnt
这里可以看到刚才的abc文件，输入：mount aa /tmp -o loop
这里看到就是刚才镜像的文件内容

#19 find
#查找指定字符的文件（测试发现二进制也可以发现，是strings后的内容）
find /tmp -type f -exec grep “no exist” {} \; -print
find /etc/rc.d -name ‘*crond’ -exec file {} ;
##匹配字符串，找出存在字符串文件
find /data -name "*.php" -type f -print0|xargs -0 egrep "(phpspy|c99sh|milw0rm|eval\(base64_decode|spider_bc)"|awk -F: '{print $1}'|sort|uniq
find /data -name "*.php" -type f -print0|xargs -0 egrep "aaa"|awk -F: '{print $1}'|sort|uniq
find . -name "*.php" -type f -print0| xargs -0 egrep  "aaa|bbb"| egrep "aaa"

##首先确定黑客IP，然后通过find命令检查日志文件中，含有黑IP的日志，从而排查程序漏洞点！

##查找/etc/rc.d目录下面所有以crond结束的文件，并使用file指令查看其属性，注意：exec和file间是一个空格，file和{}间是一个空格，file和;之间是一个空格，;是一个整体。

#20
#kill -SIGSEGV 进程号 
#会产生一个core文件，用strings可以看信息，用一个c程序可以重新构建它的可执行程序，study/unix/下保存一个文章。测试没产生core，原因不详。


##当前目前(及子目录)下，所有的log文件中搜索字符串hacked by:
find . -name "*.log" | xargs fgrep "hacked by"






