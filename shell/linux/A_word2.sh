#!/bin/bash
## 2016-05-30
## http://www.aqzt.com
##email: ppabc@qq.com
##查看详细内容可以移步原文，http://bbs.chinaunix.net/thread-2283984-1-1.html

1101 linux中刻录iso的方法(hutuworm)
方法一：使用xcdroast，选择制作光碟，选择ISO文件，刻录!
参见http://www.xcdroast.org/xcdr098/faq-a15.html#17
方法二：找刻录机的命令：
cdrecord --scanbus
输出结果为：
0,0,0 0) 'ATAPI ' 'CD-R/RW 8X4X32 ' '5.EZ' Removable CD-ROM
刻录的命令：
cdrecord -v speed=8 dev=0,0,0 hutuworm.iso
方法三：使用k3b可以刻录CD/DVD 
k3b主页：http://www.k3b.org/ 
(实际上k3b是个图形界面，刻录CD利用了cdrecord，刻录DVD利用了dvd+rw-tools http://fy.chalmers.se/~appro/linux/DVD+RW/ )

1102 屏幕变花时怎么办(双眼皮的猪)
当您一不小心cat了一个并不是文本的文件的时候，这时屏幕会变花，那么您可以按两下"Enter"键，再敲"reset"，那么屏幕就恢复正常了....

1103 卸载软件包时如何得知具体包名(diablocom)
大家知道删除软件包的命令是rpm -e XXX，但是当我们不知道这个XXX的确切拼写时，可以用rpm -q -a查询所有安装的软件包或者用rpm -qa |grep xxxx查询出名字

1104 使用内存作linux下的/tmp文件夹(yulc)
在/etc/fstab中加入一行：
none /tmp tmpfs default 0 0
或者在/etc/rc.local中加入
mount tmpfs /tmp -t tmpfs -o size=128m
注：size=128m 表示/tmp最大能用128m
不管哪种方式，只要linux重启，/tmp下的文件全部消失

1105 用ls只列出目录(yulc)
ls -lF | grep ^d
ls -lF | grep /$
ls -F | grep /$

1106 在命令行下列出本机IP地址，而不是得到网卡信息(yulc)
ifconfig |grep "inet" |cut -c 0-36|sed -e 's/[a-zA-Z: ]//g'
hostname -i

1107 修改/etc/profile或者$HOME/.profile文件后如何立即生效(peter333)
#source /etc/profile (或者source .profile)

1108 bg和fg的使用(陈绪)
输入ctrl+z，当前一个任务会被挂起并暂停， 同时屏幕上返回进程号，此时用 "bg %进程号"，会把这个进程放到后台执行，而用" fg %进程号 "就能让这个进程放到前台来执行。另外，job命令用来查看当前的被bg的进程

1109 ctrl+s与ctrl+q(陈绪)
ctrl-s用来暂停向终端发送数据的，屏幕就象死了一样，可以用ctrl-q来恢复

1110 目录统计脚本(陈绪)
保存成total.sh，然后用total.sh 绝对路径，就能统计路径下目录的大小了
代码:
#!/bin/sh
du $1 --max-depth=1 | sort -n|awk '{printf "%7.2fM ----> %s\n",$1/1024,$2}'|sed 's:/.*/\([^/]\{1,\}\)$:\1:g'

1111 grep不显示本身进程(陈绪)
#ps -aux|grep httpd|grep -v grep
grep -v grep可以取消显示你所执行的grep本身这个进程，-v参数是不显示所列出的进程名

1112 删除目录中含输入关键字的文件(WongMokin)
find /mnt/ebook/ -type f -exec grep "在此输入关键字" {} \; -print -exec rm {} \;

1113 让cron中的任务不回馈信息, 本例5分钟检查一次邮件(WongMokin)
0-59/5 * * * * /usr/local/bin/fetchmail > /dev/null 2>&1

1114 在当前目录下解压rpm文件(陈绪)
cat kernel-ntfs-2.4.20-8.i686.rpm | rpm2cpio | pax -r

1115 合并两个Postscript或PDF文件(noclouds)
$ gs -q -dNOPAUSE -dBATCH -sDEVICE=pswrite \
-sOutputFile=bar.ps -f foo1.ps foo2.ps
$ gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
-sOutputFile=bar.pdf -f foo1.pdf foo2.pdf

1116 去掉apache的manual目录中的所有.en的后缀名(陈绪)
进入到manual目录
代码:find ./ -regex .*\.en|awk -F. '{ printf "mv %s.%s.%s.%s %s.%s.%s\n",$1,$2,$3,$4,$1,$2,$3}'|sh

1117 如何起多个X(noclouds)
startx默认以display :0.0起第一个X，通过传递参数给Xserver可以起多个X：
# startx -- :1.0
# startx -- :2.0
...
然后用Ctrl-Alt-F7/F8...切换。

1118 让一个程序在退出登陆后继续运行(noclouds,陈绪)
# <cmd>
# disown
或者是
nohup command &

1119 看Linux启动时屏幕的显示信息(陈绪)
在启动完后用命令dmesg查看

1120 让vi不响铃(sakulagi)
echo "set vb t_vb=" >> ~/.vimrc

1121 让fedora开机后自动login(dzho002)
1) rpm -ihv autologin-1.0.0-7mdk.i586 rpm
2) 建立文件 /etc/sysconfig/autologin
在里面加上一行.
USER = root

1122 如何配置让哪些服务启动(天外闲云，q1208c)
方法1 运行ntsysv或者setup命令，进入菜单进行配置
方法2 chkconfig --list 显示服务
chkconfig name on/off 打开/关闭“name”服务

1123 安全删除linux(天外闲云)
步骤1 Dos下使用fdisk /mbr或者用win2000/xp的光盘启动进入故障恢复控制台，使用命令fixmbr
步骤2 格式化linux分区为windows分区即可。

1124 用grub引导进文本界面(天外闲云)
进入grub之后，按a，输入 空格 3 就可以引导进入文本界面，但是不修改系统的运行级，只在当次有效。

1125 先测试patch是否运行正常，暂不将更改应用到kernel(jiadingjun)
patch --dry-run

1126 redhat和debian上的文件安装删除用法(NetDC)
删除一个软件包：
rpm -e <package-name>
dpkg -r <package-name>
显示一个软件包的内容：
rpm -qvl <package-name.rpm>
dpkg -c <package-name.deb>
显示所有已经安装的软件包：
rpm -qvia
dpkg -l
打印一个包的信息：
rpm -qpi <package-name.rpm>
dpkg -I <package-name.deb>
检验包characteristics：
rpm -Va
debsums -a
检验一个文件属于哪个包：
rpm -qf </path/to/file>
dpkg -S </path/to/file>
安装新软件包：
rpm -Uvh <package-name.rpm>
dpkg -i <package-name.deb>

1127 如何使新用户首次登陆后强制修改密码(猫小)
#useradd -p '' testuser; chage -d 0 testuser

1128 日志维护工具logrotate(hotbox)
在/etc/logrotate.conf中配置，作用：定义log文件达到预定的大小或时间时，自动压缩log文件

1129 Linux中默认的管理员叫什么(陈绪)
root

1130 如何产生一个长度固定（例如文件长度为1M）字节的空文件，即每个字节的值全为0x00(sakulagi)
dd if=/dev/zero of=/tmp/zero_file bs=1024 count=1024

1131 RedHat Linux里修改时间的步骤(hutuworm)
1. 设置你的时区： timeconfig里选择Asia/Shanghai （如果你位于GMT+8中国区域）
2. 与标准时间服务器校准： ntpdate time.nist.gov
2.5 当然，如果你是李嘉诚，也可以跟自己的手表校准： date -s STRING （STRING格式见man date）
3. 写回硬件时钟： hwclock --systohc

1132 查找当前目录下文件并更改扩展名(零二年的夏天)
更改所有.ss文件为.aa
# find ./ -name "*.ss" -exec rename .ss .aa '{}' \;

1133 patch的使用(天才※樱木)
语法是patch [options] [originalfile] [patchfile]
例如：
patch -p[num] <patchfile
-p参数决定了是否使用读出的源文件名的前缀目录信息，不提供-p参数，则忽略所有目录信息，-p0（或者-p 0）表示使用全部的路径信息，-p1将忽略第一个"/"以前的目录，依此类推。如/usr/src/linux-2.4.16/Makefile这样的文件名，在提供-p3参数时将使用linux-2.4.16/Makefile作为所要patch的文件。
对于刚才举的Linux内核源码2.4.16升级包的例子，假定源码目录位于/usr/src/linux中，则在当前目录为/usr/src时使用"patch -p0 <patch-2.4.16"可以工作，在当前目录为/usr/src/linux时，"patch -p1<patch-2.4.16"也可以正常工作。

1134 将file.txt里的123改为456(hutuworm)
方法1 
sed 's/123/456/g' file.txt > file.txt.new
mv -f file.txt.new file.txt
方法2
vi file.txt
输入命令：
:%s/123/456/g
:wq

1135 将一个分区格式化为ext3日志文件系统(hutuworm)
mkfs -j /dev/xxxx

1136 开启硬盘ATA66 (laixi781211)
/sbin/hdparm -d1 -X68 -c3 -m16 /dev/hda

1137 查看当前运行级别(双眼皮的猪)
runlevel

1138 查看当前登陆身份(双眼皮的猪)
(1)who am i
(2)whoami
(3)id
注意(1)跟(2)的小区别

1139 删除rpm -e删除不了的包(wwwzc)
1、如果在删除包之前删除了包的目录
rpm -e --noscripts
2、如果系统里一个包被装两次（由于某些异常引起的）
rpm -e multi-installed-pkgs --allmatches

1140 如何定制用户登录时显示的信息(jiadingjun)
在/etc目录下放一个名字叫motd的文本文件实现的，例如，建立自己的/etc/motd: 
$cat /etc/motd 
welcome to my server ! 
那么，当用户登录系统的时候会出现这样的信息： 
Last login: Thu Mar 23 15:45:43 from *.*.*.* 
welcome to my server !

1141 用命令清空Root回收站中的文件(dtedu)
cd /var/.Trash-root 
rm -rf *

1142 在Red Hat上加Simsun.ttc字体(陈绪)
以Red Hat 7.3为例，安装时选取简体中文安装，先复制一个simsun.ttc到/usr/X11R6/lib/X11/font/TrueType，改名为simsun.ttf；然后进入/usr/X11R6/lib/X11/font/TrueType目录下，运行ttmkfdir > fonts.dir命令；接着用vi编辑fonts.dir文件，把有simsun.ttf行修改如下:
simsun.ttf -misc-SimSun-medium-r-normal--0-0-0-0-c-0-ascii-0
simsun.ttf -misc-SimSun-medium-r-normal--0-0-0-0-c-0-iso10646-1
simsun.ttf -misc-SimSun-medium-r-normal--0-0-0-0-p-0-iso8859-15
simsun.ttf -misc-SimSun-medium-r-normal--0-0-0-0-p-0-iso8859-1
simsun.ttf -misc-SimSun-medium-r-normal--0-0-0-0-c-0-gb2312.1980-0 
simsun.ttf -misc-SimSun-medium-r-normal--0-0-0-0-p-0-gb2312.1980-0 
simsun.ttf -misc-SimSun-medium-r-normal--0-0-0-0-m-0-gb2312.1980-0 
simsun.ttf -misc-SimSun-medium-r-normal--0-0-0-0-p-0-gbk-0
接着运行cat fonts.dir > fonts.scale命令，修改/etc/X11/XF86config-4, 在Section“Files”加上下面这一行：
FontPath “/usr/X11R6/lib/X11/fonts/TrueType”
最后回到KDE桌面里, 在“开始”→“选项”→“观感”→“字体”，将所有字体改为Simsun。

1143 Unicon和Zhcon的区别和作用(陈绪)
Unicon是内核态的中文平台，基于修改Linux FrameBuffer和Virtual Console（fbcon）实现的。由于是在系统底层实现的，所以兼容性极好，可以直接支持gpm鼠标。但是相对比较危险，稍有漏洞就可能会危及系统安全。Zhcon是用户态的中文平台，有点像UCDOS。

1144 如何卸载tar格式安装的软件(陈绪)
进入安装该软件的原代码目录，运行make uninstall。如果不行，也可以查看一下Makefile文件，主要是看install部分，从其中找出tar格式的文件被复制到了什么路径，然后进入相应的目录进行删除即可。

1145 定制linux提示符 (陈绪)
在bash中提示符是通过一个环境变量$PS1指定的。用export $PS1查看现在的值，比较直观常用的提示符可以设定为export PS1=“[\u@\h \W]\$”。其中\u代表用户名，\h代表主机名，\W代表当前工作目录的最后一层，如果是普通用户\$则显示$，root用户显示#。

1146 在vi中搜索了一个单词，该单词以高亮显示，看起来很不舒服，怎么能将它去掉(陈绪)
在vi的命令模式下输入:nohlsearch就可以了。另外可以在~/.vimrc中写上下面的语句就会有高亮显示：
set hlsearch
加上下面的语句就不会有高亮显示：
set nohlsearch

1147 如何找出系统中所有的*.cpp、*.h文件(陈绪)
用find命令就可以了。不过如果从根目录查找消耗资源较高，使用下面的命令就可以：
find / -name "*.cpp" -o -name "*.h"

1148 如安装Debian需要几张盘就够了？7张盘全部都要下载吗？(陈绪)
如果经常有网络环境的话，下载第一张就可以了。要是没有网络环境的话不推荐使用Debian，因为Debian主要依赖网络来更新软件。实在要安装的话，要下载全部7张盘，否则可能会出现需要的软件包找不到的问题。

1149 Debian第一张光盘为什么有两个版本？debian-30r1-i386-binary-1.iso和debian-30r1-i386-binary-1_NONUS.iso该下载哪一个呢？它们有什么区别？(陈绪)
因为含有“non-US”（不属美国）的软件不能合法地存放在架设于美国境内的服务器中。以前，其原因通常是因为软件含有严密的密码编码，而今天，则是因为程序使用了美国专利保护的演算法。每个人应该取用“non-US”来供私人用途所用；而没有这个标识的iso则只对架设在美国的镜像及供应商才有用处。其它二进制的光盘则不会含有任何“US-sensitive”（与美国相关的）软件，它们和其它种binary-1光盘一样运作得很好。因此，个人使用还是下载debian-30r1-i386-binary-1_NONUS.iso版本。

1150 为何我使用umount /mnt/cdrom命令的时候出现device is busy这样的语句，不能umount(陈绪)
在使用umount的时候一定要确保已退出/mnt/cdrom这个目录，退出这个目录就可以使用umount /mnt/cdrom了。

1151 我使用的是笔记本电脑，怎么才能在控制台下显示现在还剩多少电量呢？ (陈绪)
使用apm -m就可以看到还有多少分钟了，具体参数可以用man apm查看。

1152 为什么我进入Linux的终端窗口时，man一条命令出来的都是乱码呢？ (陈绪)
这是因为你的字符集设置有问题。临时解决办法可以使用export LANG=“en_US”。要想不必每次都修改的话，在/etc/sysconfig/i18n文件里面修改LANG=“en_US”就可以了。也可以针对某个用户来做，这样就可以改变个人的界面语言，而不影响别的用户。命令如下：# cp /etc/sysconfig/i18n $HOME/.i18n。

1153 编译内核的时候出错，提示“Too many open files”，请问怎么处理 (陈绪)
这是因为file-max默认值（8096）太小。要解决这个问题，可以root身份执行下列命令（或将它们加入/etc/rcS.d/*下的init脚本）：
# echo "65536"  > /proc/sys/
最后进入解压后的目录，运行安装命令。
# cd vmware-linux-tools
# ./install.pl

1154 本来装有Linux与Windows XP，一次将Windows XP重装后，发现找不到Linux与Windows XP的启动选单，请问如何解决(陈绪)
首先光盘启动，进入rescue模式，运行GRUB，进入grub提示符grub>，然后敲入下面的语句，重启就好了。
root (hd0,2)，setup (hd0)

1155 安装了一台Linux服务器，想自己编译内核，一步一步做下来，GRUB也添加进去了，但出现“kernel Panic:VFS:Unable to mount root fs on 0:00”的错误，请问是怎么回事？(陈绪)
一般情况下initrd这个文件在台式机上不是必须的，但是在有SCSI设备的服务器上却是必须的。有可能因为编译内核的时候没有产生initrd那个文件，所以会有上面的错误提示。用户可以使用mkinitrd命令来生成一个initrd.img文件，然后加入GRUB，重启试一试。

1156 如何设置用户登录后的欢迎信息？(陈绪)
修改/etc/motd文件，往里面写入文本，就能使用户通过Telnet正确登录后，执行Shell之前得到相应的提示信息。
motd就是“messages of the day”，也就是当日信息的意思。管理员可以往里面写一些需要注意的事项或通知等来提醒正式用户。

1157 我下载了rcs5.7，用./configure && make && make install时报错如下：./conf.sh: testing permissions ... ./conf.sh: This command should not be run with superuser permissions. 我是以root用户身份登录编译安装的，为什么会这样？(陈绪)
有些软件确实因为考虑到安全等其它原因不能用root用户编译。这时只要用其它用户编译，到make install这步时，如果该软件安装在不属于编译时的用户的主目录下时，需要使用su命令转换为root用户再执行make install。

1158 我在安装USBView时失败，具体情况如下： #rpm -ivh usbview-1.0-9.src.rpm warning:usbview-1.0-9.src.rpm:V3 DSAsignature:NOKEY,key IDab42a60e (陈绪)
这行代码说明安装失败是因为你的系统上没有安装合适的钥匙来校验签名。要使该软件包通过校验，可以通过导入Red Hat的公匙来解决，具体的方式是在Shell下运行如下命令：
#rpm -import /usr/share/rhn/RPM-GPG-KEY
（注意大小写）

1159 如何防止某个关键文件被修改？(陈绪)
在Linux下，有些配置文件是不允许任何人（包括root）修改的。为了防止被误删除或修改，可以设定该文件的“不可修改位(immutable) ”。命令如下：
# chattr +i /etc/fstab
如果需要修改文件则采用下面的命令：
# chattr -i /etc/fstab

1160 怎样限制一个用户可以启动的进程数？(陈绪)
先确定一下/etc/pam.d/login文件中下面一行的存在：
session required /lib/security/pam_limits.so
然后编辑/etc/security/limits.conf，在里面可以设置限制用户的进程数、CPU占用率和内存使用率等，如hard nproc 20就是指限制20个进程，具体可以看man。

1161 如何限制Shell命令记录大小 ？(陈绪)
默认情况下，bash会在文件$HOME/.bash_history中存放多达500条命令记录。有时根据具体的系统不同，默认记录条数不同。系统中每个用户的主目录下都有一个这样的文件。为了系统的安全，在此强烈建议用户限制该文件的大小。用户可以编辑/etc/profile文件，修改其中的选项如下：
HISTFILESIZE=30 或 HISTSIZE=30
这样就将记录的命令条数减少到30条。

1162 我想将开机时显示的信息保留下来，以检查电脑出了问题的地方，请问怎么办？(陈绪)
可输入下面的命令:
#dmesg > bootmessage
该命令将把开机时显示的信息重定向输出到一个文件bootmessage中。

1163 我想在注销时删除命令记录，请问怎么做？(陈绪，mhxkcu)
编辑/etc/skel/.bash_logout文件，增加如下行:
rm -f $HOME/.bash_history
这样，系统中的所有用户在注销时都会删除其命令记录。
如果只需要针对某个特定用户，如root用户进行设置，则可只在该用户的主目录下修改/$HOME/.bash_logout文件，增加相同的一行即可。

1164 编译内核，支持ntfs的步骤(platinum，陈绪)
1. # cd /usr/src/linux-2.4
2. # make menuconfig
3. 选中File System下的NTFS file system support (read only)为M
4. # uname -a
2.4.21-27.0.2.EL
5. # vi Makefile
确保前几行为
VERSION = 2
PATCHLEVEL = 4
SUBLEVEL = 21
EXTRAVERSION = -27.0.2.EL
6. # make dep
7. # make modules SUBDIRS=fs/ntfs
8. # mkdir /lib/moduels/2.4.21-27.0.2.EL/kernel/fs/ntfs
9. # cp -f fs/ntfs/*.o /lib/moduels/2.4.21-27.0.2.EL/kernel/fs/ntfs/
10. # depmod -a
11. # modprobe ntfs
12. # lsmod
确保有ntfs在里面

1165 如何使用ssh通道技术(陈绪)
本文讨论所有机器均为Linux操作系统。
比如说我的机器是A，中间服务器为B，目标服务器是C。
从A可以ssh到B，从B可以ssh到C，但是A不能直接ssh到C。
现在展示利用ssh通道技术从A直接传输文件到C。
1. ssh -L1234:C:22 root@B
input B's password
2. scp -P1234 filename root@localhost:
input C's password

1166 使用rpm命令时没有任何响应，如何解决 (初学摄影)
rm -rf /var/lib/rpm/__db.*

1167 向登陆到同一台服务器上的所有用户发一条信息(陈绪)
1)输入wall并回车
2)输入要发送的消息
3)结束时按“Control-d”键,消息即在用户的控制窗口中显示

1168 输入短消息到单个用户(陈绪)
1)输入write username，当用户名出现在多个终端时，在用户名后可加tty,以表示在哪个tty下的用户。
2)输入要发送的消息。
3)结束时按“Control-d”键,消息即在用户的控制窗口中显示。
4）对于接收消息方，可以设定是否允许别人送消息给你。
指令格式为：mesg n[y]
%write liuxhello! Everybody, I’llcome.
%
用户控制窗口中显示的消息:Message from liux on ttyp1 at 10:00…hello! Everybody, I’llcome.EOF
当使用CDE或OpenWindows等窗口系统时，每个窗口被看成是一次单独的登录；如果用户登录次数超过一次则消息直接发送到控制窗口。

1169 发送文件中的消息到单个用户(陈绪)
如果有一个较长的消息要发送给几个用户，用文件方式：
1)创建要发送的消息文本的文件filename.
2)输入write username<filename回车，用cat命令创建包含短消息的文件：
% cat >messagehello! Everybody, I’llcome.
% write liux<messagewrite:liux logged in more than once…write to console
% 用户在一个以上窗口登录，消息显示在控制窗口中Message from liux on ttyp1 at 10:00…hello! Everybody, I’llcome.EOF 

1170 向远程机器上的所有用户发送消息(陈绪)
使用rwall(向所有人远程写)命令同时发送消息到网络中的所有用户。
rwall hostname file
当使用CDE或OpenWindows等窗口系统时,每个窗口被看成是一次单个的登录;
如果用户登录次数超过一次则消息直接发送到控制窗口。

1171 向网络中的所有用户发送消息(陈绪)
发送消息到网络中的所有用户
1)输入rwall -n netgroup并回车
2)输入要发送的消息
3)结束时按“Control-d”键，消息即在系统每个用户的控制窗口中显示，下面是系统管理员发消息到网络组Eng每个用户的例子：
% rwall -n EngSystem will be rebooted at 11:00.(Control-d)
%
用户控制窗口中的消息:Broadcast message from root on console…System will be rebooted at 11:00.EOF
注意：也可以通过rwall hostname（主机名）命令到系统的所有用户。

1172 我需要编译内核，内核源码在哪里？(platinum)
1、一般在发行版的盘里都有，比如 RedHat，一般在第二、第三张上
　　2.4 内核的叫 kernel-source-2.4.xx-xx.rpm
　　2.6 内核的叫 kernel-devel-2.6.xx-xx.rpm
2、去 www.kernel.org 下载一份你喜欢的

1173 将top的结果输出到文件中(bjweiqiong)
top -d 2 -n 3 -b >test.txt
可以把top的结果每隔2秒，打印3次，这样后面页的进程也能够看见了

1174 vim中改变全文大小写的方法(陈绪)
光标放在全文开头
gUG 所有字母变大写
guG 所有字母变小写
g~G 所有字母，大写变小写，小写变大写

1175 如何升级安装ubuntu(陈绪)
以ubuntu 7.04->7.10为例。
mount -o loop /media/ubuntu-7.10-alternate-i386.iso /cdrom
gksu "sh /cdrom/cdromupgrade"
如果需要代理：
export http_proxy=http://proxy.server.ip/; gksu "sh /cdrom/cdromupgrade"

1176 文件不均匀切分方法(qintel)
$dd if=source of=target.1 bs=1M count=10
$dd if=source of=target.2 bs=1M skip=10
source被分为target.1和target.2两个文件，其中target.1为source的前10M部分；target.2为source的减去10M后的部分。

1177 我在Windows下不小心把swap分区格式化了，请问有什么命令可以恢复(陈绪)
使用mkswap命令建立swap分区，再使用swapon命令启用swap分区即可。关于命令的使用，举例如下：
# mkswap /dev/sda7
# swapon /dev/sda7

1178 如何防止别人修改某文件(陈绪)
对系统中的一些关键文件和个人重要资料，可以通过文件权限来保护，例如将文件属性设为600。另外，如果Linux使用的是ext2或ext3文件系统，还可以使用“chattr”命令，给文件加上i属性，即使root用户也不能直接修改或删除这类文件，以有效防止意外修改情况的发生。具体命令如下：
# chattr +i passwd
去除i属性使用如下命令：
# chattr –i passwd

1179 批量修改扩展名(白清杰)
for i in *.mp3; do mv $i `basename $i .mp3`.bak ;done
即可将以.mp3结尾的文件改名为.mp3.bak结尾

2001 让apache的默认字符集变为中文(陈绪)
vi httpd.conf，找到 AddDefaultCharset ISO-8859-1 一行
apache版本如果是1.*，改为 AddDefaultCharset GB2312
如果是2.0.1-2.0.52，改为 AddDefaultCharset off
然后运行/etc/init.d/httpd restart重启apache即可生效。
注意：对于2.0.53以上版本，不需要修改任何配置，即可支持中文。

2002 永久更改ip(陈绪)
ifconfig eth0 新ip
然后编辑/etc/sysconfig/network-scripts/ifcfg-eth0，修改ip

2003 从Linux上远程显示Windows桌面(lnx3000)
安装rdesktop包

2004 手动添加默认网关(陈绪)
以root用户，执行: route add default gw 网关的IP
想更改网关
1 vi /etc/sysconfig/network-scripts/ifcfg-eth0
更改GATEWAY
2 /etc/init.d/network restart

2005 redhat 8.0上msn和qq(陈绪)
下载Gaim 0.58版：
gaim-0.58-2.i386.rpm
下载QQ插件 for gcc2.9版：
libqq-0.0.3-ft-0.58-gcc296.so.gz
将下载的文件放入/temp目录，然后将系统中已有的Gaim删除，即在终端仿真器中键入命令：rpm -e gaim。
开始安装
打开终端仿真器，继续执行下列命令安装Gaim 0.58版，即：
cd /temp　　　　　　　　　(进入temp目录)
rpm -ivh gaim-0.58-2.i386.rpm　(安装软件)
当安装成功后，你就可以在GNOME或KDE桌面建立Gaim图标了。
继续安装QQ插件，即键入命令：
gunzip libqq-0.0.3-ft-0.58-gcc296.so.gz (解压缩文件）
cp libqq-0.0.3-ft-0.58-gcc296.so /usr/lib/gaim (复制插件到gaim库目录中)
软件设置
首次启动Gaim 0.85版时，会出现的登录界面。先选择“插件”，在插件对话框中点击“加载”，分别将libmsn.so和libqq-0.0.3-ft-0.58-gcc296.so文件装入，确认后关闭。然后再选择“所有帐号”，在出现的帐号编辑器中继续点击“增加”，当出现的修改帐号页面时，我们就可以输入自己的QQ或MSN号了，登录名填写QQ号码或MSN邮箱，密码填写对应的QQ或MSN密码，Alias填写自己的昵称，协议选择相应的QQ或MSN，其他的设置按默认的即可。当全部设置完成后就可以登录使用了。
由于MS对msn的协议经常升级，导致linux上的gaim和msn插件必须升级，目前尚无万无一失的解决方案，请见谅

2006 查出22端口现在运行什么程序(陈绪)
lsof -i

2007 查看本机的IP，gateway, dns(陈绪)
IP：
以root用户登录，执行ifconfig。其中eth0是第一块网卡，lo是默认的设备
Gateway:
以root用户登录，执行netstat -rn，以0.0.0.0开头的一行的Gateway即为默认网关
也可以查看/etc/sysconfig/network文件，里面有指定的地址！
DNS：
more /etc/resolv.conf，内容指定如下：
nameserver 202.96.69.38
nameserver 202.96.64.38

2008 RH8.0命令行下改变ping 的TTL值(cgweb，lnx)
方法1(重启后有效)：
#sysctl -w net.ipv4.ip_default_ttl=N
(N=0~255),若N>255,则ttl=0
方法2(重启后无效)：
#echo N(N为0～255) > /proc/sys/net/ipv4/ip_default_ttl

2009 开启LINUX的IP转发(houaq)
编辑/etc/sysctl.conf, 例如，将
net.ipv4.ip_forward = 0
变为
net.ipv4.ip_forward = 1
重启后生效，用sysctl -a查看可知

2010 mount局域网上其他windows机器共享出的目录(陈绪)
mount -t smbfs -o username=guest,password=guest //machine/path /mnt/cdrom

2011 允许｜禁止root通过SSH登陆(Fun-FreeBSD)
修改sshd_config:PermitRootLogin no|yes

2012 让root直接telnet登陆(陈绪，platinum)
方法1：
编辑/etc/pam.d/login，去掉
auth required /lib/security/pam_securetty.so 这句话
方法2：
vi /etc/securetty
添加
pts/0
pts/1
...

2013 在linux接adsl设备(wind521)
需要一个运转正常的Linux + 至少一块网卡 + 宽带设备已经申请完毕，同时已经开通。目前市场上大概有几种ADSL设备，他们工作的方式有一些细微的差别。
就是通过虚拟拨号来完成上网的这一过程，也就是利用pppoe设备来进行虚拟拨号的叫作全向猫，就是一种加电后自动的进行拨号的工作，然后留给我们的接口是RJ45，大连地区一般留给我们的网关都是10.0.0.2,这种设备最容易对付，最后是直接分配给用户一个固定的IP，相对大家来说也比较容易对付
1.第一种需要进行拨号：
这几种设备都是通过eth接口与计算机进行通讯的，所以先将硬件设备的连接作好，尤其是宽带猫的，一定要确认无误（否则一会儿要不去可不算我的事情）
然后启动系统，确认系统上是否安装rp-pppoe这个软件（通过rpm -qa|grep pppoe来查找），如没有安装的用户，在光盘里或是到网上去down一个来，安装上后，以root用户执行adsl-setup，这样就进入了adsl的资料的设定状态，要求输入申请宽带的用户名以及其他一些信息，确认没有问题，接受直至最后（里面都是E文，但是一看即能懂，比较简单，有关一个防火墙的设置，我一般都不用，选0，大家可以具体考虑）。
配置完成后，以root用户执行adsl-start，这样将进行adsl的拨号工作，正常就会一下上线，如有什么具体问题，去看一下日志（/var/log/messages）里面告诉你什么了。
停掉adsl，执行adsl-stop就可以了（很简单的）
2.另外两种比较容易对付：
  全向猫：只要将你的网卡的IP设置成一个10网段的IP，然后网关指到全向猫的IP，上（10.0.0.2)，基本上不有太大的问题
　固定IP：就像配置本地儿的网卡一样，将IP，网关，DNS都按申请来的填写上就可以搞定了

2014 让linux自动同步时间(shunz)
vi /etc/crontab
加上一句：
00 0 1 * * root rdate -s time.nist.gov

2015 linux的网上资源有哪些(陈绪)
国外
http://www.lesswatts.org/
http://www.moblin.org/
http://www.clutter-project.org/
http://lwn.net/
http://www.tldp.org/
http://www.yolinux.com/(flying-dance big big pig)
http://www.justlinux.com/
http://www.linuxtoday.com/
http://www.linuxquestions.org/
http://www.fokus.gmd.de/linux/
http://www.linux-tutorial.info/
http://public.[url]www.planetmirror.com/[/url]
http://www.freebsdforums.org/forums/
http://www.netfilter.org/documentation/
http://www-106.ibm.com/developerworks/linux/

国内
http://www.linuxpk.com/
http://www.fanqiang.com/
http://www.linuxsir.com/
http://www.chinaunix.net/
http://www.linuxfans.org/(deadcat)
http://www.linuxeden.com/
http://www.linuxforum.net/
http://freesoft.online.sh.cn/
http://www-900.ibm.com/developerWorks/cn/linux/index.shtml
http://www.neweasier.com/software.html
http://www.blueidea.com/bbs/archivecontent.asp?id=635906(sqh)
http://westlinux.ywzc.net/(onesun)

2016 改变sshd的端口(陈绪)
在/etc/ssh/sshd_config中加入一行：Port 2222，/etc/init.d/sshd restart重启守护进程

2017 改变telnet的端口(陈绪)
将/etc/services文件中telnet对应的端口号21改为你想要的值，/etc/init.d/xinetd restart重启守护进程

2018 终端模式有问题(sakulagi)
export TERM=vt100

2019 模仿超级终端，LINUX里什么程序连接路由器和交换机(alstone)
minicom

2020 ssh上来能不能不自动断线(wind521，双眼皮的猪)
修改自己HOME目录下的.bash_profile文件，加上
export TMOUT=1000000  (以秒为单位)
然后运行source .bash_profile

2021 用什么工具做入侵检测(陈绪)
snort

2022 Linux下检测程序内存泄漏的工具(陈绪)
cchecker或是efence库都可以

2023 linux下如何监视所有通过本机网卡的数据(陈绪)
tcpdump或者iptraf

2024 为什么root执行好多命令都说command not found(陈绪)
你是telnet上来，然后su成root的吧，改改你的su命令格式，应该是su - root

2025 关闭用户的POP3权限(tiansgx)
把POP3的端口关了就可以了。 在文件/etc/services中找到这一行 pop-3 110/tcp 把这一行前加个'#',把它注释掉就可以了。

2026 linux下播放flash动画(myxfc)
linux下播放flash动画用这个东西，不会造成浏览器的关闭(其他的插件不好用）
首先下载flash播放动画在linux的插件
http://www.collaborium.org/onsit ... /flash_linux.tar.gz
tar zxvf flash_linux.tar.gz
打开包之后,会看到Linux文件夹
在linux文件颊里有两个文件libflashplayer.so 和shockwaveflash.class,把这两个文件拷贝到你的浏览器里的插件里(浏览器不一样,插件的位置可能也不一样)
/usr/lib/mozilla-1.0.1/plugins,就可以了 

2027 锁定wu-ftp用户目录(wangla)
编辑ftpaccess文件
restricted-uid *
这一句很重要，限制了ftp用户在自己的目录里。

2028 服务器怎么不让telnet(知秋一叶)
服务器上必须启动telnet服务 && 服务器的防火墙优先级应该设为低

2029 防止任何人使用su命令成为root(xiaohu0)
1.vi /etc/pam.d/su
auth sufficient /lib/security/pam_rootok.so debug
auth required /lib/security/pam_wheel.so group=wheel
2.在/etc/pam. d/su配置文件中定义了wheel组.

2030 如何使lynx浏览器能够浏览中文网页(Ghost_Vale)
浏览简体中文网页就的修改如下设置
Save options to disk: [X]
Display and Character Set
Display character set : [Chinese________________________]
Assumed document character set(!): [iso-8859-1______]
CJK mode (!) : [ON_]
然后移到最下面的 Accept Changes 按下 Enter 保存就可以了
当然你的系统要支持简体中文才可以

2031 网卡激活了，却上不了网，怎么办？(Slock，双眼皮的猪)
traceroute，看看到底是在那一块被阻住的。
1.ping自己
2.ping网关
3.ping DNS
4.traceroute DNS
如果一切正常
nslookup www.sina.com.cn
ping sina的address
traceroute sina的address
基本上就可以知道结果了

2032 在redhat9下配samba,win2000能访问，win98不能访问？(squall2003)
如果是wind98必需修改注册表：HKEY_LOCAL_MACHINE/system/correntcontrolset/services/Vxd/VNETSUP下建个D值：EnablePlainTextpasswd，键值1

2033 如何得到网卡的MAC地址(陈绪，hutuworm)
arp -a | awk '{print $4}'
ifconfig eth0 | head -1 | awk '{print $5}' 

2034 如何得到网卡的IP地址(mb)
ifconfig eth0 |awk '/inet addr/ {split($2,x,":");print x[2]}'

2035 如何修改Linux机器所在的工作组(hutuworm)
vi /etc/samba/smb.conf，修改workgroup = 一行，将组名写在后面。

2036 一块网卡如何绑定两个ip(linuxloveu)
#cd /etc/sysconfig/network-scripts
#cp ifcfg-eth0 ifcfg-eth0:1
#vi ifcfg-eth0:1
修改IP和设备名
Debian下一个网卡绑定多个ip的方法(NetDC)
修改/etc/network/interfaces
auto eth0
iface eth0 inet static
address 172.16.3.123
netmask 255.255.255.0
network 172.16.3.0
broadcast 172.16.3.255
gateway 172.16.3.1

auto eth0:1
iface eth0:1 inet static
address 10.16.3.123
netmask 255.255.0.0
network 10.16.0.0
broadcast 10.16.255.255
修改/etc/network/ifstate
lo=lo
eth0=eth0
eth0:1=eth0:1
然后/etc/init.d/networking restart就可以了。
一个网卡绑定多ip另一法(hotbox)
在/etc/sysconfig/network-scripts/下创建一个文件：ifcfg-ethX-rangeX （"X"为网卡号）
文件内容：
IPADDR_START=<start ip>
IPADDR_END=<end ip>
CLONENUM=0
可以有256个ip

2037 一个ip如何绑定两块网卡(hutuworm)
假设192.168.0.88是ip,192.168.0.1是网关:
/sbin/modprobe bonding miimon=100 mode=1
/sbin/ifdown eth0
/sbin/ifdown eth1
/sbin/ifconfig bond0 192.168.0.88
/sbin/ifenslave bond0 eth0 eth1
/sbin/route add default gw 192.168.0.1

2038 192.168.1.0/24(双眼皮的猪)
它与192.168.1.0/255.255.255.0是等价的，只是表示方式不同....

2039 linux下清空arp表的命令(NetDC)
#arp -d -a(适用于bsd)
for HOST in `arp | sed '/Address/d' | awk '{ print $1}'` ; do arp -d $HOST; done

2040 使用ntp协议从服务器同步时间(NetDC)
ntpdate NTP-SERVER 例：ntpdate 172.16.2.1 

2041 host命令的用法(陈绪)
host能够用来查询域名，它还能得到更多的信息
host -t mx example.com可以查询出example.com的MX记录，以及处理mail的host的名字
host -l example.com会返回所有注册在example.com下的域名
host -a example.com则会显示这个主机的所有域名信息.

2042 立刻让LINUX支持NAT(platinum)
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -I POSTROUTING -j MASQUERADE

2043 rh8.0下rcp的用法设置(zhqh1)
只对root用户生效
1、在双方root用户根目录下建立.rhosts文件,并将双方的hostname加进去.在此之前应在双方的/etc/hosts文件中加入对方的IP和hostname
2、把rsh服务启动起来，redhat默认是不启动的。方法：用执行ntsysv命令，在rsh选项前用空格键选中，确定退出。 然后执行：service xinetd restart即可。
3、到/etc/pam.d/目录下，把rsh文件中的auth required /lib/security/pam_securetty.so一行用“#”封掉即可。

2044 在ethX设备上，使LINUX支持网络广播功能（默认是不支持的）(platinum)
ip route add 255.255.255.255 dev ethX

2045 路由设置手册(NetDC)
查看路由信息：
netstat -rn
route -n
手工增加一条路由：
route add -net 192.168.0.0 netmask 255.255.255.0 gw 172.16.0.1
手工删除一条路由：
route del -net 192.168.0.0 netmask 255.255.255.0 gw 172.16.0.1
好了，下面到了重要的了，让系统启动的时候自动启用路由设置。
在redhat中添加一条路由，修改文件/etc/sysconfig/static-routes
any net 192.168.0.0 netmask 255.255.255.0 gw 172.16.0.1
在debian中添加一条路由，

方法一：修改/etc/network/interfaces
代码:
auto eth0
iface eth0 inet static
        address 172.16.3.222
        netmask 255.255.0.0
        network 172.16.0.0
        broadcast 172.16.255.255
        gateway 172.16.2.1
   up route add -net 192.168.0.0 netmask 255.255.255.0 gw 172.16.0.1
   down route del -net 192.168.0.0 netmask 255.255.255.0 gw 172.16.0.1
方法二：在/etc/network/if-up.d目录下建立一个简单的脚本文件，如static-route$（记得以$符号结尾，要不有个run-parts会跑出来告诉你一些东西）脚本最简单的就好啦，如：
代码:
#!/bin/bash
route add -net 192.168.0.0 netmask 255.255.255.0 gw 172.16.0.1
嘿嘿，你也可以猜到/etc/network/目录下的其他目录的作用了吧。
发觉在debian中这个route的设置其实只是它的那些配置文件的一个比较简单的应用而已，你完全可以做更复杂的应用。

2046 利用ssh复制文件(platinum)
假如A、B都有SSH服务，现在在A的SSH里
1、从A复制B（推过去）
scp -rp /path/filename username@remoteIP:/path
2、从B复制到A（拉过来）
scp -rp username@remoteIP:/path/filename /path
如果其中一个不是LINUX系统，可以在WINDOWS上用SecureFX软件

2047 samba3.0中文显示问题的解决办法(linuxzfp, jiadingjun)
在samba 3.0的配置文件中(/etc/samba/smb.conf)的[global]中加入下面两句：
unix charset=cp936 
重启服务
service smb restart

2048 临时修改网卡MAC地址的方法
关闭网卡：/sbin/ifconfig eth0 down 
然后改地址：/sbin/ifconfig eth0 hw ether 00:AA:BB:CCD:EE 
然后启动网卡:/sbin/ifconfig eth0 up

2049 conntrack 表满的处理方法(cgweb)
前段时间配置的iptables+squid做的proxy server ,一直工作正常。今天我上控制台上发现 
Jun 18 12:43:36 red-hat kernel: ip_conntrack: table full, dropping packet. 
Jun 18 12:49:51 red-hat kernel: ip_conntrack: table full, dropping packet. 
Jun 18 12:50:57 red-hat kernel: ip_conntrack: table full, dropping packet. 
Jun 18 12:57:38 red-hat kernel: ip_conntrack: table full, dropping packet. 

IP_conntrack表示连接跟踪数据库(conntrack database)，代表NAT机器跟踪连接的数目，连接跟踪表能容纳多少记录是被一个变量控制的，它可由内核中的ip- sysctl函数设置。每一个跟踪连接表会占用350字节的内核存储空间，时间一长就会把默认的空间填满，那么默认空间时多少？我以redhat为例在内存为64MB的机器上时4096,内存为128MB是 8192,内存为256MB是16376，那末就能在/proc/sys/net/ipv4/ip_conntrack_max里查看、设置。 
例如：增加到81920，可以用以下命令: 
echo "81920" > /proc/sys/net/ipv4/ip_conntrack_max 

那样设置是不会保存的，要重启后保存可以在/etc/sysctl.conf中加： 
net.ipv4.ip_conntract_max =81920 
按照此方法改变后一切正常，要是在满了可以加大其值.

2050 Linux下怎么使用BT(atz0001)
azureus，http://azureus.sourceforge.net/

2051 Linux下查看光纤网卡的工作模式(sakulagi)
主板上PCI—X插槽中插入一块64位的光纤网卡，在LINUX9.0的环境下，要知道它是否工作在64位模式下，可使用getconf WORD_BIT

2052 在线更新RHEL的另类途径(hutuworm)
1.安装相应的APT包： 
Red Hat EL 2.1 - i386 
rpm -ihv http://dag.wieers.com/packages/a ... .0.el2.dag.i386.rpm 
Red Hat EL 3 - i386 
rpm -ihv http://dag.wieers.com/packages/a ... .1.el3.dag.i386.rpm 
Red Hat EL 3 - x86_64 
rpm -ihv http://dag.wieers.com/packages/a ... .el3.dag.x86_64.rpm 
2.在线更新 
apt-get update 
apt-get upgrade

2053 SOCKS5启动后一段时间停止工作。用命令ps auxw | grep socks5查看，发现有很多SOCKS defunct进程，为什么(陈绪)
主要是打补丁的问题。如果socks5-tar.gz是没打过补丁的版本，必须下一个带补丁的v1.0-r11版本，重新安装、运行问题就可以解决了。

2054 在VMware WorkStation 4.0.5中安装Debian 3.0时，提示找不到硬盘，需要SCSI的驱动。但是我用的是IDE硬盘，请问该怎么办？ (陈绪)
由于VMware将用户划分的硬盘空间虚拟成SCSI硬盘，而Debian安装盘中没有对应的驱动，而安装其它Linux版本时，有的在一开始会加载SCSI驱动，所以没有这个问题。用户可以修改VMware的配置，将其改为模拟IDE硬盘就可以了。

2055 如何让Linux网关后面的WIN32下的用户直接点击FTP连接下载？(platinum)
modprobe ip_nat_ftp

2056 请问用户的IP是动态的，如何在Squid中限定在同一时间内同一账户在线的数量？(陈绪)
例如限制单个用户只能打开12个HTTP连接，采用下面的方法：
acl all src 0.0.0.0/0.0.0.0
acl limit maxconn 12
acl localnet src 192.168.0.0/24
http_access deny localnet maxconn
http_access allow localnet
http_access deny all

2057 如果我用Squid代理的代理服务器在192.168.1.0这个网段里，例如它的IP是192.168.1.1，我有一些客户端在192.168.2.0这个网段内，怎样设置才能通过这个代理服务器出去？(陈绪)
如果不用透明代理，直接在浏览器的代理选项里设置就可以了。否则首先是在代理服务器的网卡上再挂一个IP为192.168.2.1，添加相应的路由，再修改Squid的squid.conf文件里的监听地址和端口等，最后在192.168.2.0网段的客户端设置其网关为 192.168.2.1，再直接在浏览器的代理选项里设置一下就可以了。

2058 如何使用netrc文件进行自动FTP？(陈绪)
在自己的home目录下建立一个权限为600，后缀名为.netrc的文件，内容如下：
machine 172.168.15.1 login admin password admin
这样用户以后每次登录FTP服务器172.168.15.1的时候，系统都会帮用户以用户名admin、密码admin登录。用户利用这个特征可以实现自动FTP。例如用户想要每天6:00到172.168.15.1机器上面获得/admin目录下的文件admin.txt，可以按如下方法做。
建立一个文件ftp_cmd，内容如下：
cd admin
get amin.txt
bye
然后使用crontab -e设置定时任务：
0 6 * * * ftp 172.168.15.1 < ftp_cmd

2059 怎样得到ipchains的日志？(陈绪)
用户设置规则的时候必须加入-l参数才会在/etc/messages里面做记录。不过建议还是不加的好，不然用户的/etc/messages会变得非常大。

2060 如何不显示其它用户的消息？(陈绪)
用户可以使用mesg n来禁止别人给自己发送信息，其实就是禁止别人往自己的终端上面的写的权限。当别人试图再使用write给自己发送信息时，发送者将会看见提示如下：
write: user has messages disabled on pts/n

2061 minicom彩色显示(双眼皮的猪)
minicom -s进行serial port配置,然后配置好以后, 
minicom -o -c on 
-o表示不初始化 
-c on表示color on

2062 启用SELinux的Apache的配置文件httpd.conf里面修改DocumentRoot无用或者出现403 Forbidden错误(arbor)
# chcon -u system_u -t httpd_sys_content_t -R website目录 

2063 apache2 的log文件位置如何自定义目录(tomi)
编辑httpd.conf里的 
ErrorLog /var/log/http/error_log          <== 这是管errorlog的 
CustomLog /var/log/http/access_log common        <== 这是管accesslog的

2064 更改eth0是否混杂模式(wwy)
网卡eth0改成混杂模式：
ifconfig eth0 promisc
关闭混杂模式：
ifconfig eth0 -promisc

2065 字符界面下的ftp中，下载整个文件夹(陈绪)
1. lftp IP
2. > user username
password
3. > mirror -c --parallel=number remotedir localdir
3a. > help mirror

2066 如何让ssh只允许指定的用户登录(xinyv，好好先生，wolfg，我爱钓鱼)
方法1：在/etc/pam.d/sshd文件中加入
auth   required   pam_listfile.so  item=user  sense=allow  file=/etc/sshusers  onerr=fail
然后在/etc下建立sshusers文件,编辑这个文件,加入你允许使用ssh服务的用户名,重新起动sshd服务即可。
方法2：pam规则也可以写成deny的
auth   required   pam_listfile.so  item=user  sense=deny  file=/etc/sshusers  onerr=succeed
方法3：在sshd_config中设置AllowUsers，格式如
AllowUsers a b c
重启sshd服务，则只有a/b/c3个用户可以登陆。

2067 在Linux下如何绑定IP地址和硬件地址(陈绪)
可以编辑一个地址对应文件，里面记录了IP地址和硬件地址的对应关系，然后执行“arp –f 地址对应文件”。如果没有指定地址对应文件，则通常情况下一默认文件/etc/ethers为准。地址对应文件的格式如下：
192.168.0.1 00:0D:61:27:58:93
192.168.0.2 00:40:F4:2A:2E:5C
192.168.0.3 00:0A:EB:5E:BA:8E

2068 已知网络中一个机器的硬件地址，如何知道它所对应的IP地址(陈绪)
在Linux下，假定要查“00:0A:EB:27:17:B9”这样一个硬件地址所对应的IP地址，可以使用以下命令：
# cat /proc/net/arp |grep 00:0A:EB:27:17:B9
192.168.2.54 0x1 0x6 00:0A:EB:27:17:B9 *eth2
另外，还可以用“arp -a”命令查询：
# arp –a|grep 00:0A:EB:27:17:B9
（192.168.2.54）at 00:0A:EB:27:17:B9[ether] on eth2

2069 基于Apache的HTTPD或Sendmail服务在启动时被挂起了，如何解决此问题(陈绪)
遇到此类问题，请确认/etc/hosts文件中是否包含如下一行：
127.0.0.1 localhost.localdomain localhost
127.0.0.1 是网络的回路地址。

2070 如何使Linux系统对ping不反应(陈绪)
要使Linux对ping没反应，也就是使Linux系统忽略I CMP包。用如下命令可以达到此目的：
# echo 1 > /proc/sys/net/ipv4/icmp-echo-ignore-all
若想恢复，可用如下命令：
# echo 0 > /proc/sys/net/ipv4/icmp-echo-ignore-all

2071 压缩传输文件或目录(FunBSD)
传输到远程：tar czf - www | ssh server "tar zxf -"
压缩到远程：tar czf - www | ssh server "cat > www.tar.gz"
解压到远程：ssh server "tar zxf -" < www.tar.gz
解压到本地：ssh server "cat www.tar.gz" | tar zxf -

2072 rsync同步压缩传输文件或目录(FunBSD)
rsync -aze ssh --delete sample_dir/ remote_host:remote_dir/sample_dir/
目录最后的/不能少

2073 无需输入密码使用ssh密钥登录 (FunBSD)
ssh-keygen -b 1024 -t rsa
ssh server "mkdir .ssh; chmod 0700 .ssh"
scp ~/.ssh/id_rsa.pub server:~/.ssh/authorized_keys
这样就不在提示密码，直接可以登录server了
对文件复制、同步等操作都比较方便
在ssh_config里加入这两句就更方便了
ForwardAgent yes
StrictHostKeyChecking no

2074 wget下载整个网站(陈绪)
wget -t0 -c -nH -np -b -m -P /localdir http://freesoft.online.sh.cn/mirrors/ftp.redhat.com -o wget.log

2075 命令行下发送带附件的邮件(陈绪)
方法1.    uuencode <in_file> <remote_file> | mail -s "title" mail@address
<in_file> 本地需要作为附件的文件名。
<remote_file> 邮件中的附件文件名，可以和<in_file>不同，其实内容一样。
方法2.    cat <mailcontent.txt> | mutt -s "title" -a <attachfile> mail@address
<mailcontent.txt>邮件正文内容。
<attachfile>本地需要作为附件的文件名。

2076 高效率使用1000兆网卡(陈绪)
系统加载模块时，可以根据实际情况调节参数，使网卡工作在最佳状态。驱动重新提供的可选择参数有速率、工作模式、自适应和流控等
在Linux下，可以定义合法速率参数为0、10、100和1000。却省为0，表示网卡工作在自适应状态下，其他值分别为10Mb、100Mb和1000Mb。
工作模式有全、半双工方式。0表示适应；1表示半双工；2表示全双工。
自适应方式的有效期值范围0~3。0表示不设置流控；1表示仅对Rx流控；2表示仅对Tz流控；3表示对Rx/Tx双向流控。缺省为3

2077 管理SSH监听端口(陈绪)
从安全角度考虑，SSH应当取代Telnet。目前在Linux上使用广泛的SSH服务器软件sshd-config（默认路径是 /etc/ssh/sshd-config）文件中，Port 22是sshd监听的端口，即为连接到主机时需要使用的端口。使用以下代码可以指定sshd监听的接口地址：
ListenAddress 192.168.0.254
这样，就可以避免向未知的用户提供登录服务

2078 不重新编译httpd，增加动态模块(以deflate模块为例)(陈绪)
1 进入httpd源代码目录
cd /usr/local/src/httpd-2.2.6
2 执行httpd安装后目录中的bin/apxs文件
/usr/local/apache2/bin/apxs -cia modules/metadata/mod_deflate.c
3 重新启动httpd
service httpd restart

2079 不重新编译php，增加动态模块(以mbstring模块为例)(陈绪)
1 进入php源代码目录中的mbstring所在目录
cd /usr/local/src/php-5.2.4/ext/mbstring/
2 执行php安装后目录中的bin/phpize文件
/usr/local/php/bin/phpize
3 进入php源代码目录
cd /usr/local/src/php-5.2.4/
4 执行上述目录中的configure文件
./configure --prefix=/usr/local/src/php-5.2.4/ext/mbstring --with-php-config=/usr/local/php/bin/php-config
5 make; make install
将mbstring.so安装到/usr/local/php/lib/php/extensions/no-debug-non-zts-20060613/中
6 编辑php.ini，加入一行
extension=mbstring.so
7 重新启动httpd
service httpd restart

2080 让apache解析.perl脚本(cnangel)
一个.perl的文件，是perl写的模块，如果放在web上，人家要么直接下载或者用记事本直接打开。为了保护代码不被COPY，需要在httpd.conf中，加入AddHandler cgi-script .perl一行，然后重启apache

2081 如何修改网卡MAC地址(陈绪)
在/etc/sysconfig/nework-scripts/ifcfg-ethx文件中加入如下代码：
MACADDR=00:11:33:44:55
即你想要的mac地址
然后键入以下命令：
service network restart

2082 如何变更Sendmail邮件的默认存储位置(陈绪)
如果Sendmail使用Procmail作为MDA（邮件投递代理）的话，可以使用Procmail来指定接收邮件的默认存储位置。方法如下：
1.建立/etc/procmailrc文件；
2.编辑/etc/procmailrc文件，指定环境变量“MAIL”的路径，比如设为“$HOME/mbox”等。

2083 Linux下tar和rsync的区别(陈绪)
tar命令用来建立最初的副本，rsync命令则是用来获取最后一个副本建立以来所发生的变更。在不存在任何目标文件时，tar比rsync要快。如果两个文件系统差异很小，则rsync比tar快许多。

2084 查看Apache的并发请求数及其TCP连接状态(白清杰)
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
SYN_RECV表示正在等待处理的请求数；ESTABLISHED表示正常数据传输状态；TIME_WAIT表示处理完毕，等待超时结束的请求数。

----------------------------程序开发篇--------------------------
3001 linux下调试core文件(陈绪)
gdb <progname> <core>
<progname>:出错产生core dump的可执行程序。
<core>: core dump的文件名，缺省是“core”

3002 gcc abc.c得到的a.out不能运行(陈绪)
./a.out

3003 c++ 编译时为什么出错信息说cout没定义(陈绪)
include头文件完后加入 using namespace std;

3004 新编译生成的gcc ，使用的标准连接库都在/usr/local/lib 下了，但使用的缺省的连接路径是 /usr/lib 怎样添加？（除了在每次编译时 增加 -L /usr/local/lib 以外)(sakulagi, hutuworm)
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
写到~/.bash_profile里面。
增加一种简便办法：
将/usr/local/lib加入/etc/ld.so.conf，然后运行一次ldconfig

3005 RH9下GCC的安装(一起走过的日子，hutuworm)
三种方法选一：
(1)利用CD上rpm安装
CD-1:compat-gcc-7.3-2.96.118.i386.rpm
CD-1:compat-gcc-c++-7.3-2.96.118.i386.rpm
CD-1:libgcc-3.2.2-5.i386.rpm
CD-2:compat-gcc-g77-7.3-2.96.118.i386.rpm
CD-2:compat-gcc-java-7.3-2.96.118.i386.rpm
CD-2:compat-gcc-objc-7.3-2.96.118.i386.rpm
CD-2:gcc-3.2.2-5.i386.rpm
CD-2:gcc-c++-3.2.2-5.i386.rpm
CD-2:gcc-g77-3.2.2-5.i386.rpm
CD-2:gcc-gnat-3.2.2-5.i386.rpm
CD-2:gcc-java-3.2.2-5.i386.rpm
CD-2:gcc-objc-3.2.2-5.i386.rpm
比如碰到系统提示：
warning : gcc-3.2.2-5.i386.rpm : V3 DSA signature :MOKEY key ID db42a60e
error : Failed dependencies :
binutils >=2.13.90.0.18-9 is needed by gcc-3.2.2-5
glibc-devel >=2.3.2-11.9 is needed by gcc-3.2.2-5...
就先安裝glibc-devel包，依此类推
(2)更好的方法就是在X-window下选“主菜单”──>“系统设置”──>“添加/删除应用程序”──>“开发工具”中的gcc并安装它
(3) up2date gcc便可自动解决dependency问题

3006 shell脚本为何无法运行(GOD_Father)
第一，脚本权限要为可执行 #chmod +x test.sh
第二，脚本所在的目录在环境变量PATH中，或者直接执行 #./test.sh

3007 查看某个文件被哪些进程在读写(bjweiqiong)
lsof 文件名

3008  查看某个进程打开了哪些文件(bjweiqiong)
lsof –c 进程名
lsof –p 进程号

3009  lsof是什么意思(bjweiqiong)
list open files

3010 lsof用法小全(bjweiqiong)
lsof abc.txt 显示开启文件abc.txt的进程
lsof -i :22 知道22端口现在运行什么程序
lsof -c nsd 显示nsd进程现在打开的文件
lsof -g gid 显示归属gid的进程情况
lsof +d /usr/local/ 显示目录下被进程开启的文件
lsof +D /usr/local/ 同上，但是会搜索目录下的目录，时间较长
lsof -d 4  显示使用fd为4的进程
lsof -i 用以显示符合条件的进程情况
语法: lsof -i[46] [protocol][@hostname|hostaddr][:service|port]
46 --> IPv4 or IPv6
protocol --> TCP or UDP
hostname --> Internet host name
hostaddr --> IPv4位置
service --> /etc/service中的 service name (可以不只一個)
port --> 埠號 (可以不只一個)
例子: TCP:25 - TCP and port 25
@1.2.3.4 - Internet IPv4 host address 1.2.3.4
tcp@ohaha.ks.edu.tw:ftp - TCP protocol host:ohaha.ks.edu.tw service name:ftp
lsof -n 不将IP转换为hostname，预设是不加上-n参数
例子: lsof -i tcp@ohaha.ks.edu.tw:ftp -n
lsof -p 12  看进程号为12的进程打开了哪些文件    
lsof +|-r [t] 控制lsof不断重复执行，缺省是15s刷新
-r，lsof会永远不断的执行，直到收到中断讯号
+r，lsof会一直执行，直到没有档案被显示
例子：不断查看目前ftp连接的情况：lsof -i tcp@ohaha.ks.edu.tw:ftp -r
lsof -s 列出打开文件的大小，如果没有大小，则留下空白
lsof -u username  以UID，列出打开的文件

3011 让某用户只能ftp，不能ssh/telnet(魏琼)
vi /etc/passwd
将用户行中的/bin/bash改为/bin/false即可

----------------------------经典图书篇--------------------------
4001 GNU/Linux高级网络应用服务指南(陈绪)
linuxaid网站
机械工业出版社
优点：又全又精，全都是实战之作
缺点：针对版本较低，为redhat 6.2

4002 Linux Apache Web Server管理指南(Linux Apache Web Server Administration)(陈绪)
Charles Aulds 马树奇/金燕译
电子工业出版社
优点：目前我还没有发现哪个关于apache的问题这本书没有讲过
缺点：针对1.3.x，最新的针对2.0.*的英文版已出，中文版待出

4003 Linux内核情景分析(陈绪)
毛德操/胡希明
浙江大学出版社
优点：太透彻了，没法不懂
缺点：还是版本问题，内核更新太快了，不过还是必读

4004 Unix环境高级编程(陈绪)
Richard Stevens
机械工业出版社
优点：博大精深
缺点：初学者是很难理解的，否则怎么叫《高级编程》呢？

4005 编程精粹--Microsoft编写优质无错c程序秘诀(陈绪)
Steve Maguire
电子工业出版社
优点：不说了，作者是微软的资深工程师
缺点：很难找了，1994年出的

###4006 Understanding the Linux Kernel, 2nd Edition(hutuworm，albcamus)     
Daniel P. Bovet & Marco Cesati
#O'Reilly出版社
优点：读了这本书之后，你就会明白在什么情况下Linux具有最佳的性能，以及它如何面对挑战，在各种环境中提供进程调度、文件访问和内存管理时的优良的系统响应。作者通过解释其重要性来引入每一个题目，并将内核操作与Unix程序员和用户熟悉的系统调用或实用程序联系起来。一本很全面的Linux内核原理书。书中以2.6.11为示例版本，着重讲述了
x86平台的Linux内核实现。我觉得看完ULK3就是高手了:) 而且由于书中着重介绍了X86体系结构，也称得上半个x86专家了。

4007 UNIX操作系统教程(英文版)(弱智)     
Syed Mansoor Sarwar等
机械工业出版社
特点：浅显易懂，着重unix基础概念和整体理解，顺便复习英语。
另外：机械工业出版社已经出版了中文版，名称：UNIX 教程

4008 UNIX编程环境(弱智)     
Brian W.Kernighan, Rob Pike  陈向群等译
机械工业出版社
特点：浅显，深入浅出讲解如何使用UNIX及各种工具，简单介绍Unix编程环境；对比“UNIX环境高级编程”，此书适合新手入门。

4009 The Art of UNIX Programming(hutuworm)     
Eric Steven Raymond
http://catb.org/~esr/writings/taoup/html/
优点： E.S. Raymond的经典著作

4010 unix网络编程--卷一 套接口API和X/Open传输接口API(slg1972)     
Richard Stevens
清华大学出版社
优点：详细地讲解unix网络的编程

4011 unix网络编程--卷二 进程间通讯(slg1972)
Richard Stevens
清华大学出版社
优点：详细讲解unix的进程之间，线程之间的关系，及各种不同标准的进程编程的异同

4012 unix网络编程--卷三 应用程序(slg1972, hutuworm)     
未出，因为Richard Stevens大师英年早逝，再也不可能完成这计划中的第三卷了。据说其未竟稿可能由Gary R. Wright整理续写出来，但是自大师驾鹤以来一直杳无音信

4013 基于C++ CORBA高级编程(slg1972) 
Michi Henning，Steve Vinoski
清华大学出版社
优点：中间件的好书，通向corba应用的必备资料。

4014 unix linux网管通鉴(odin_free) 
电子版的，包括本版精华
优点：我见过关于unix知识最全面、最实用的chm文档，相当于一个小型网站，里面支持全文检索，推荐所有还没有的兄弟姐妹们下载

4015 www.chinaoy.com(aomin5555) 
不错，挺全的，图书下载的好网址：
redhat linux9.0 官方入门指南
·redhat linux9.0 官方安装指南
·redhat linux9.0 官方定制设置手册
·redhat linux基础教程
·Linux 参考大全
·清华论坛linux精华
·Linux系统管理员指南中文手册
·Linux网站建设和维护全攻略
·redhat linux8.0 安装手册
·Linux环境database管理员指南 

4016 Linux Advanced Routing & Traffic Control(hutuworm) 
专门讲LINUX IPROUTE2的书，大概100页左右，www.lartc.org
中文版在：http://www.lartc.org/LARTC-zh_CN.GB2312.pdf

4017 Debian User强烈推荐看的书(NetDC) 
Debian Reference （Debian参考手册）
http://qref.sourceforge.net/
简体中文版的pdf文档。
http://qref.sourceforge.net/Debian/reference/reference.zh-cn.pdf

4018 高级Bash脚本编程指南--中文版(hutuworm) 
Mendel Cooper著
http://doc.linuxpk.com/doc/abs/
优点：Bash编程的圣经，而且该书作者不断在更新其内容，一两个月就会翻新一个版本，值得一读，一读再读

4019 JAVA完美经典(陈绪)
江义华 编著 林彩瑜 文编 
中国铁道出版社
定价：65元
优点：不愧是台湾同胞的力作，讲解清楚，知识全面，我看了之后，感到很有收获

4020 Thinking in JAVA(陈绪)
Burce Eckel著
到http://www.BruceEckel.com下载最新版本
优点：经典之作，深入剖析java的核心问题

4021 APACHE2中文手册(陈绪)
Apache官方著
http://doc.linuxpk.com/doc/apache/
优点：官方手册，全面深入。

4022 MYSQL中文手册(陈绪)
Mysql官方著
http://doc.linuxpk.com/doc/mysql/
优点：官方手册，全面深入。

4023 PHP中文手册(陈绪)
Php官方著
http://doc.linuxpk.com/doc/php/
优点：官方手册，全面深入。

4024 VIM中文手册(陈绪)
Vim官方著
http://doc.linuxpk.com/doc/vim/
优点：官方手册，全面深入。

4025 Linux 内核设计与实现-第2 版LKD2 (albcamus)
入门推荐，从入门开始，介绍了诸如中断、系统调用、虚拟文件系统、同步与互斥、内存管理、进程控制等方面，内容比较浅显易懂，是入门的好书。
优点： 适合入门 (个人认为，没有比LKD2更优秀的内核入门图书)
缺点： 内容不够深入，覆盖面不广。(对高手来说估计就像休闲材料)

4026 Linux 设备驱动程序-3rd LDD3 (albcamus)
LDD3写的很精彩。但如果要学会写具体的驱动程序，还是得参照硬件的datasheet，读一个内核中现成的驱动程序。
FYI : 内核中自带的驱动程序skeleton: drivers/net/pci-skeleton.c和drivers/usb/usb-skeleton.c，分别是为PCI/USB驱动程序员提供的参考代码。

4027 现代体系结构上的Unix 系统 - 内核程序员的SMP 和Caching 技术 (albcamus)
这本书着重讲解各种体系结构上的Unix实现注意事项，e.g. SMP的同步与互斥、Cache一致性问题。
优点： 作者知识面非常广，原理讲得很清楚。
缺点： 94年的书，比较旧

4028 下载技术图书的推荐网站(陈绪)
http://www.freebooksclub.net/


----------------------------数据库相关篇--------------------------
5001 mysql的数据库存放在什么地方(陈绪) 
1. 如果使用rpm包安装，应该在/var/lib/mysql目录下，以数据库名为目录名
2. 如果源码安装在/usr/local/mysql中，应该在/usr/local/mysql/var中，以数据库名为目录名

5002 从mysql中导出和导入数据(陈绪) 
导出数据库
mysqldump 数据库名 > 文件名
导入数据库
mysqladmin create 数据库名
mysql 数据库名 < 文件名

5003 忘了mysql的root口令怎么办(陈绪) 
# service mysql stop
# mysqld_safe --skip-grant-tables &
# mysqladmin -u user password 'newpassword''
# mysqladmin flush-privileges

5004 快速安装php/mysql(陈绪)
确保使用系统自带的apache，从安装光盘中找出所有以mysql及php-mysql开头的rpm包，然后运行#rpm -ivh mysql*.rpm php-mysql*.rpm; mysql_install_db; service mysql start

5005 修改mysql的root口令(陈绪，yejr) 
大致有2种方法：
1、mysql>mysql -uroot -pxxx mysql
mysql>update user set password=password('new_password') where user='user';
mysql>flush privileges;
2、格式：mysqladmin -u用户名 -p旧密码 password 新密码
#mysqladmin -uroot -password ab12
注：因为开始时root没有密码，所以-p旧密码一项就可以省略了

5006 如何使用rpm方式安装mysql(yejr) 
首先下载合适的rpm包，例如下载了文件 MySQL-5.0.19-0.i386.rpm
用一下方法安装：
#rpm -ivhU MySQL-5.0.19-0.i386.rpm
通常情况下，安装完这个rpm包后，只具备有mysqld服务功能，其它相关的client程序和开发包还需要另外安装
#rpm -ivhU MySQL-devel-5.0.19-0.i386.rpm
#rpm -ivhU MySQL-client-5.0.19-0.i386.rpm

5007 如何安装已经编译好了的mysql二进制包(yejr) 
首先下载合适的二进制包，例如下载了文件 mysql-standard-4.1.13-pc-linux-gnu-i686.tar.gz
#groupadd mysql
#useradd -g mysql mysql
#cd /usr/local
#tar zxf mysql-standard-4.1.13-pc-linux-gnu-i686.tar.gz
#ln -s mysql-standard-4.1.13-pc-linux-gnu-i686 mysql
#cd mysql
#scripts/mysql_install_db --user=mysql
#chgrp -R mysql *
#bin/mysqld_safe --user=mysql &
有什么个性化的配置，可以通过创建 /etc/my.cnf 或者 /usr/local/mysql/data/my.cnf，增加相关的参数来实现

5008 如何自己编译mysql(yejr) 
以redhat linux 9.0为例：
下载文件 mysql-4.1.13.tar.gz
#tar zxf mysql-4.1.13.tar.gz
#cd mysql-4.1.13
#./configure --prefix=/usr/local/mysql --enable-assembler \
--with-mysqld-ldflags=-all-static --localstatedir=/usr/local/mysql/data \
--with-unix-socket-path=/tmp/mysql.sock --enable-assembler \
--with-charset=complex --with-low-memory --with-mit-threads
#make
#make install
#groupadd mysql
#useradd -g mysql mysql
#chgrp -R mysql /usr/local/mysql/
#/usr/local/mysql/bin/mysqld_safe --user=mysql &
有什么个性化的配置，可以通过创建 /etc/my.cnf 或者 /usr/local/mysql/data/my.cnf，增加相关的参数来实现

5009 如何登录mysql(yejr)
使用mysql提供的客户端工具登录
#PATH_TO_MYSQL/bin/mysql -uuser -ppassword dateabase

5010 mysqld起来了，却无法登录，提示"/var/lib/mysql/mysql.sock"不存在(yejr)
这种情况大多数是因为你的mysql是使用rpm方式安装的，它会自动寻找 /var/lib/mysql/mysql.sock 这个文件，
通过unix socket登录mysql。
常见解决办法如下：
1、创建/修改文件 /etc/my.cnf，至少增加/修改一行
[mysql]
[client]
socket = /tmp/mysql.sock
#在这里写上你的mysql.sock的正确位置，通常不是在 /tmp/ 下就是在 /var/lib/mysql/ 下
2、指定IP地址，使用tcp方式连接mysql，而不使用本地sock方式
#mysql -h127.0.0.1 -uuser -ppassword
3、为 mysql.sock 加个连接，比如说实际的mysql.sock在 /tmp/ 下，则
# ln -s /tmp/mysql.sock /var/lib/mysql/mysql.sock即可

5011 如何新增一个mysql用户(yejr)
格式：grant select on 数据库.* to 用户名@登录主机 identified by "密码"
例1、增加一个用户test1密码为abc，让他可以在任何主机上登录，并对所有数据库有查询、插入、修改、删除的权限。首先用以root用户连入MYSQL，然后键入以下命令：
mysql>grant select,insert,update,delete on *.* to test1@"%" Identified by "abc";
但例1增加的用户是十分危险的，你想如某个人知道test1的密码，那么他就可以在internet上的任何一台电脑上登录你的mysql数据库并对你的数据可以为所欲为了，解决办法见例2。
例2、增加一个用户test2密码为abc,让他只可以在localhost上登录，并可以对数据库mydb进行查询、插入、修改、删除的操作（localhost指本地主机，即MYSQL数据库所在的那台主机），这样用户即使用知道test2的密码，他也无法从internet上直接访问数据库，只能通过MYSQL主机上的web页来访问了。
mysql>grant select,insert,update,delete on mydb.* to test2@localhost identified by "abc";
如果你不想test2有密码，可以再打一个命令将密码消掉。
mysql>grant select,insert,update,delete on mydb.* to test2@localhost identified by "";
另外，也可以通过直接往user表中插入新纪录的方式来实现

5012 如何查看mysql有什么数据库(yejr)
mysql>show databases;

5013 如何查看数据库下有什么表(yejr)
mysql>show tables;

5014 导出数据的几种常用方法(yejr) 
1、使用mysqldump
#mysqldump -uuser -ppassword -B database --tables table1 --tables table2 > dump_data_20051206.sql
详细的参数
2、backup to语法
mysql>BACKUP TABLE tbl_name[,tbl_name...] TO '/path/to/backup/directory';
详细请查看mysql手册
3、mysqlhotcopy
#mysqlhotcopy db_name [/path/to/new_directory]
或
#mysqlhotcopy db_name_1 ... db_name_n /path/to/new_directory
或
#mysqlhotcopy db_name./regex/
详细请查看mysql手册
4、select into outfile
详细请查看mysql手册
5、客户端命令行
#mysql -uuser -ppassword -e "sql statements" database > result.txt
以上各种方法中，以mysqldump最常用

5015 如何在命令行上执行sql语句(yejr)
#mysql -uuser -ppassword -e "sql statements" database

5016 导入备份出来文件的常见方法(yejr)
1、由mysqldump出来的文件
#mysql -uuser -ppassword [database] < dump.sql
2、文件类型同上，使用source语法
mysql>source /path_to_file/dump.sql;
3、按照一定格式存储的文本文件或csv等文件
#mysqlimport [options] database file1 [file2....]
详细请查看mysql手册
4、文件类型同上，也可以使用load data语法导入
详细请查看mysql手册

5017 让mysql以大内存方式启动(陈绪)
将/usr/share/mysql下的某个mysql-*.cnf(如1G内存时为mysql-huge.cnf)拷贝为/etc/mysql.cnf文件，并重启mysql

5018 mysql为什么一直有临时文件(yejr)
主要是进行排序，或者修改索引，repair,check table 等时候产生的，直接删除就行了。

5019 mysql是否支持跨库事务(yejr)
只要使用innodb，是可以支持的，例如这么用：
start transaction;
insert into yejr.a values (1);
insert into test.b values (2);
commit;
但是也有例外，例如事务过程中有create table等隐含自动提交的语句，则会有问题，具体看手册的 "Implicit Transaction Commit and Rollback" 部分

5020 如何快速创建相同结构的表(yejr)
1. 快速创建相同结构的表，包括索引：
mysql> SHOW CREATE TABLE a;
CREATE TABLE `a` (
`name` varchar(50) default NULL,
   KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
mysql> CREATE TABLE b LIKE a;
mysql> SHOW CREATE TABLE b;
CREATE TABLE `b` (
  `name` varchar(50) default NULL,
   KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
2. 快速创建一个相同结构的表，但是不创建索引：
mysql> SHOW CREATE TABLE a;
CREATE TABLE `a` (
  `name` varchar(50) default NULL,
   KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
mysql> CREATE TABLE c SELECT * FROM a LIMIT 0;
mysql> SHOW CREATE TABLE c;
CREATE TABLE `c` (
  `name` varchar(50) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

5021 解决php连接oracle时的乱码问题(白清杰)
1. 装好Linux服务器，设置好服务端的字符集（如：ZHS16GBK为中文）
2. 查看客户端查看服务端的语言，
sql>select * from V$NLS_PARAMETERS Where PARAMETER='NLS_LANGUAGE';
比如是"SIMPLIFIED CHINESE"
sql>select * from V$NLS_PARAMETERS Where PARAMETER='NLS_TERRITORY';
比如是"CHINA"
sql>select * from V$NLS_PARAMETERS Where PARAMETER='NLS_CHARACTERSET';
比如是"ZHS16GBK"
3.在Apache启动脚本里加入环境变量：
export NLS_LANG="SIMPLIFIED CHINESE"_CHINA_CHS16GBK
(在/etc/init.d/httpd里加入，源代码安装的Apache写一个脚本调用apachectl)
4.OK.
5.注意：
a.如果是简体中文环境，请用上面的参数
b.NLS_LANG是在客户端设置，由"语言_国家.字符集"组成，中文对应为：SIMPLIFIED CHINESE_CHINA_CHS16GBK
c.如果只设置了export NLS_LANG="SIMPLIFIED CHINESE"，很多繁体字无法识别。
其他解决方法
方法二
如果不能正确显示中文,一般在httpd.conf文件里加上这一行应该就可以了.
AddDefaultCharset GB2312
方法三
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<?header("content-Type: text/html; charset=gb2312"); ?>
备注：
安装oracle的数据库选择字符集为unicode，可以避免很多字符集的问题
export NLS_LANG = SIMPLIFIED CHINESE_CHINA.ZHS16GBK