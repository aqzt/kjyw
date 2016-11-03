#!/bin/bash
## shell常用命令  2016-11-03
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6和centos 7

简单的比如如何查看apache进程数
[root@localhost fd]# ps -ef|grep httpd|wc -l
1
如何统计apache的每秒访问数？
tail access_log  | awk '{print $1,$4}'
[root@localhost logs]# grep -c `date -d '3 second ago' +%T` access_log
0
2、将一个文本的奇数行和偶数行合并，第2行和第3行合并
[root@localhost bin]# cat 1
48      Oct     3bc1997 lpas    68.00   lvx2a   138
484     Jan     380sdf1 usp     78.00   deiv    344
483     nov     7pl1998 usp     37.00   kvm9d   644
320     aug     der9393 psh     83.00   wiel    293
231     jul     sdf9dsf sdfs    99.00   werl    223
230     nov     19dfd9d abd     87.00   sdiv    230
219     sept    5ap1996 usp     65.00   lvx2c   189
216     Sept    3zl1998 usp     86.00   kvm9e   234
[root@localhost bin]# sed '$!N;s/\n/  /g' 1
48      Oct     3bc1997 lpas    68.00   lvx2a   138  484     Jan     380sdf1 usp     78.00   deiv    344
483     nov     7pl1998 usp     37.00   kvm9d   644  320     aug     der9393 psh     83.00   wiel    293
231     jul     sdf9dsf sdfs    99.00   werl    223  230     nov     19dfd9d abd     87.00   sdiv    230
219     sept    5ap1996 usp     65.00   lvx2c   189  216     Sept    3zl1998 usp     86.00   kvm9e   234
[root@localhost bin]# sed -n -e 2p -e 3p 1|sed '$!N;s/\n/ /'
484     Jan     380sdf1 usp     78.00   deiv    344 483     nov     7pl1998 usp     37.00   kvm9d   644
3、read 命令5秒后自动退出
[root@localhost bin]# read -t 5
4、自动ftp上传
#!/bin/sh
ftp -n<<END_FTP
open 192.168.1.4
user codfei duibuqi   //用户名codfei 密码duibuqi
binary
prompt off    //关闭提示
mput test    //上传test
close
bye
END_FTP
   自动ssh登陆 从A到B然后再到c
#!/usr/bin/expect -f
set timeout 30
spawn sshcodfei@B
expect "password:"
send "pppppp\r"
expect "]*"
send "sshcodfei@C\r"
expect "password:"
send "pppppp\r"
interact

5、#打印第一个域
[root@localhost bin]# cat 3
eqeqedadasdD
eqeqdadfdfDD
fdsfdsfQWEDD
DSADASDSADSA
[root@localhost bin]#
[root@localhost bin]#
[root@localhost bin]# awk -F "" '{print $1}' 3
e
e
f
D
6、实现字符串翻转
[root@localhost bin]# cat 8
qweqewqedadaddas
[root@localhost bin]# rev 8
saddadadeqweqewq


