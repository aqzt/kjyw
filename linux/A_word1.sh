#!/bin/bash
## 2016-05-30
## http://www.aqzt.com
##email: ppabc@qq.com
##查看详细内容可以移步原文，http://bbs.chinaunix.net/thread-2283984-1-1.html

###1001 修改主机名(陈绪)
vi /etc/sysconfig/network，修改HOSTNAME一行为"HOSTNAME=主机名"(没有这行？那就添加这一行吧)，然后运行命令" hostname 主机名"。一般还要修改/etc/hosts文件中的主机名。这样，无论你是否重启，主机名都修改成功。

###1002 Red Hat Linux启动到文字界面(不启动xwindow)(陈绪)
vi /etc/inittab
id:x:initdefault:
x=3:文本方式 x=5:图形方式

###1003 linux的自动升级更新问题(hutuworm，NetDC，陈绪)
对于redhat，在www.redhat.com/corp/support/errata/找到补丁，6.1以后的版本带有一个工具up2date，它能够测定哪些rpm包需要升级，然后自动从redhat的站点下载并完成安装。
升级除kernel外的rpm: up2date –u
升级包括kernel在内的rpm: up2date -u –f
最新的redhat和fedora可以使用yum命令或者yumex图形前端来升级更新。

Gentoo升级方法
更新portage tree：  emerge –sync
更新/安装软件包： emerge [软件包名] （如安装vim:  emerge vim）

Debian跟别的发行版还是有很大的差别的，用Debian做服务器维护更加方便。Debian下升级软件：
apt-get update
apt-get upgrade
前提：配置好网络和/etc/apt/sources.list，也可以用apt-setup设置。

###1004 windows下看linux分区的软件(陈绪，hutuworm)
Paragon.Ext2FS.Anywhere.2.5.rar和explore2fs-1.00-pre4.zip
现在不少Linux发行版安装时缺省基于LVM建分区，所以explore2fs也与时俱进地开始支持LVM2：
http://www.chrysocome.net/downloads/explore2fs-1.08beta9.zip

###1005 mount用法(sakulagi，sxsfxx，aptkevin)
fat32的分区 mount -o codepage=936,iocharset=cp936 /dev/hda7 /mnt/cdrom
ntfs的分区 mount -o iocharset=cp936 /dev/hda7 /mnt/cdrom
iso文件 mount -o loop /abc.iso /mnt/cdrom
软盘 mount /dev/fd0 /mnt/floppy
USB闪存 mount /dev/sda1 /mnt/cdrom
在有scsi硬盘的计算机上，如果用上面的命令挂载usb闪存，则会mount到/boot分区。这种情况，应该先用fdisk -l /dev/sd? 来看看到底usb闪存盘是在哪个设备下(通常会是sdb或者sdc)。比如某台机器上，就是在sdc1上面。
所有/etc/fstab内容 mount -a
可以指定文件格式"-t 格式", 格式可以为vfat, ext2, ext3等.
访问DVD mount -t iso9660 /dev/dvd /mnt/cdrom或mount -t udf /dev/dvd /mnt/cdrom
注意：dvd的格式一般为iso9660或udf之一

###1006 在vmware的LINUX中使用本地硬盘的FAT分区(陈绪)
将本地的FAT分区共享，然后在VMWARE中使用SMBFS挂上。可以将如下的行放到/etc/fstab中：
//win_ip/D$ /mnt/d smbfs defaults,auto,username=win_name,password=win_pass,codepage=936,iocharest=gb2312 0 0
其中win_ip是你的windows的IP地址；
D$是你的windows里面共享的D盘的共享名；
/mnt/d是要将该分区mount到linux的目录；
win_name和win_pass是你的WINDOWS里面可以读取该分区的用户，比如你的管理员名和密码。
如果你运行了/etc/rc.d/init.d/netfs，那么在启动的时候就会自动挂载这个分区。

###1007.a 删除名为-a的文件(陈绪)
rm ./-a
rm -- -a  告诉rm这是最后一个选项，参见getopt
ls -i 列出inum，然后用find . -inum inum_of_thisfile -exec rm '{}' \;

###1007.b 删除名为\a的文件(陈绪)
rm \\a

###1007.c 删除名字带的/和‘\0'文件(陈绪)
这些字符是正常文件系统所不允许的字符，但可能在文件名中产生，如unix下的NFS文件系统在Mac系统上使用
1.解决的方法，把NFS文件系统在挂到不过滤'/'字符的系统下删除含特殊文件名的文件。
2.也可将错误文件名的目录其它文件移走，ls -id 显示含该文件目录的inum，umount 文件系统， 
clri清除该目录的inum，fsck，mount，check your lost+found，rename the file in it.
最好是通过WINDOWS FTP过去就可以删除任何文件名的文件了!

###1007.d 删除名字带不可见字符的文件(陈绪)
列出文件名并转储到文件：ls -l  >aaa
然后编辑文件的内容加入rm命令使其内容成为删除上述文件的格式：
vi aaa
[rm -r *******
]
把文件加上执行权限 chmod +x aaa
执行 $aaa

###1007.e 删除文件大小为零的文件(陈绪)
rm -i `find ./ -size 0`
find ./ -size 0 -exec rm {} \;
或
find ./  -size 0 | xargs rm -f &
或
for file in *   #自己定义需要删除的文件类型
do
    if [ ! -s ${file} ]
    then
        rm ${file}

        echo "rm $file Success!"
    fi
done

###1008 redhat设置滚轮鼠标(mc###1011)
进入X后，选择鼠标的配置，选择wheel mouse(ps/2)就可以了，
如果鼠标表现异常，重启计算机即可。
(或者su, vi /etc/X11/XF86Config, 把PS/2 改成 ImPS/2) 

###1009 加装xwindow(陈绪)
用linux光盘启动，选择升级，然后单独选择包，安装即可

###10###10 删除linux分区(陈绪)
做一张partition magic的启动软盘,启动后删除. 或者用win2000的启动光盘启动,然后删除.

###1011 如何退出man(陈绪)
q

###1012 不编译内核，mount ntfs分区(陈绪,hutuworm,qintel)
原装rh8，未升级或编译内核
1. 上google.com搜索并下载 kernel-ntfs-2.4.18-14.i686.rpm
2. rpm -ivh kernel-ntfs-2.4.18-14.i686.rpm
3. mkdir /mnt/c
4. mount -t ntfs /dev/hda1 /mnt/c
或
Read only: http://www.linux-ntfs.org/
Read/Write: http://www.jankratochvil.net/project/captive/

###1013 tar 分卷压缩和合并(WongMokin，Waker)
以每卷500M为例
tar分卷压缩：tar cvzpf - somedir | split -d -b 500m
tar多卷合并：cat x* > mytarfile.tar.gz

###1014 使用lilo/grub时找回忘记了的root口令(陈绪)
三种办法：
1.在系统进入单用户状态，直接用passwd root去更改
2.用安装光盘引导系统，进行linux rescue状态，将原来/分区挂接上来,作法如下：
cd /mnt
mkdir hd
mount -t auto /dev/hdaX(原来/分区所在的分区号） hd
cd hd
chroot ./

passwd root
这样可以搞定
3.将本机的硬盘拿下来，挂到其他的linux系统上，采用的办法与第二种相同
rh8中
一. lilo
   1. 在出现 lilo: 提示时键入 linux single
      画面显示 lilo:  linux single
   2. 回车可直接进入linux命令行
   3. #vi /etc/shadow
      将第一行，即以root开头的一行中root:后和下一个:前的内容删除，
      第一行将类似于
      root::......
      保存
   4. #reboot重启，root密码为空
二. grub
   1. 在出现grub画面时，用上下键选中你平时启动linux的那一项(别选dos哟)，然后按e键
   2. 再次用上下键选中你平时启动linux的那一项(类似于kernel /boot/vmlinuz-2.4.18-14 ro root=LABEL=/)，然后按e键
   3. 修改你现在见到的命令行，加入single，结果如下：
      kernel /boot/vmlinuz-2.4.18-14 single ro root=LABEL=/
   4. 回车返回，然后按b键启动，即可直接进入linux命令行
   5. #vi /etc/shadow
      将第一行，即以root开头的一行中root:后和下一个:前的内容删除，
      第一行将类似于
      root::......
      保存
   6. #reboot重启，root密码为空

###1015 使ctrl + alt + del失效(陈绪)
vi /etc/inittab
将ca::ctrlaltdel:/sbin/shutdown -t3 -r now这行注释掉，就可以了

###1016 如何看出redhat的版本是7还是8(hutuworm)

cat /proc/version或者cat /etc/redhat-release或者cat /etc/issue

###1017 文件在哪个rpm中(无双)
上www.rpmfind.net上搜，或者rpm -qf 文件名得到

###1018 把man或info的信息存为文本文件(陈绪)
以 tcsh 为例：
man tcsh | col -b > tcsh.txt
info tcsh -o tcsh.txt -s

###1019 利用现存两个文件，生成一个新的文件(陈绪)
前提条件：每个文件中不得有重复行
1. 取出两个文件的并集(重复的行只保留一份)
2. 取出两个文件的交集(只留下同时存在于两个文件中的文件)
3. 删除交集，留下其他的行
1. cat file1 file2 | sort | uniq
2. cat file1 file2 | sort | uniq -d
3. cat file1 file2 | sort | uniq -u

###1020 设置com1口，让超级终端通过com1口进行登录(陈绪)
确认有/sbin/agetty，编辑/etc/inittab，添加
7:2345:respawn:/sbin/agetty /dev/ttyS0 9600
9600bps是因为联路由器缺省一般都是这种速率，也可以设成
19200、38400、57600、115200
修改/etc/securetty，添加一行：ttyS0，确保root用户能登录
重启机器，就可以拔掉鼠标键盘显示器（启动时最好还是要看看输出信息）了

###1021 删除目录下所有文件包括子目录(陈绪)
rm -rf 目录名

###1022 查看系统信息(陈绪)
cat /proc/cpuinfo - CPU (i.e. vendor, Mhz, flags like mmx)
cat /proc/interrupts - 中断
cat /proc/ioports - 设备IO端口
cat /proc/meminfo - 内存信息(i.e. mem used, free, swap size)
cat /proc/partitions - 所有设备的所有分区
cat /proc/pci - PCI设备的信息
cat /proc/swaps - 所有Swap分区的信息
cat /proc/version - Linux的版本号 相当于 uname -r
uname -a - 看系统内核等信息

###1023 去掉多余的回车符(陈绪)
sed 's/^M//' test.sh > back.sh， 注意^M是敲ctrl_v ctrl-m得到的
或者 dos2unix filename

###1024 切换X桌面(lnx3000)
如果你是以图形登录方式登录linux，那么点击登录界面上的session（任务）即可以选择gnome和kde。如果你是以文本方式登录，那执行switchdesk gnome或switchdesk kde，然后再startx就可以进入gnome或kde。
(或者vi ~/.xinitrc，添加或修改成exec gnome-session 或exec startkde，
然后用startx启动X)

###1025 通用的声卡驱动程序(lnx3000)
OSS www.opensound.com/   ALSA www.alsa-project.org/

###1026 改变redhat的系统语言/字符集(beming/mc###1011)
修改 /etc/sysconfig/i18n 文件，如
LANG="en_US"，xwindow会显示英文界面，
LANG="zh_CN.GB18030"，xwindow会显示中文界面。
还有一种方法
cp /etc/sysconfig/i18n $HOME/.i18n
修改 $HOME/.i18n 文件，如
LANG="en_US"，xwindow会显示英文界面，
LANG="zh_CN.GB18030"，xwindow会显示中文界面。
这样就可以改变个人的界面语言，而不影响别的用户
(Debian不支持GB18030(RH的zysong字库是有版权的)
现在好像没有Free的GBK和GB18030字库
vi .bashrc
export LANG=zh_CN.GB2312
export LC_ALL=zh_CN.GB2312) 

###1027 把屏幕设置为90列(陈绪)
stty cols 90

###1028 使用md5sum文件(陈绪)
md5sum isofile > hashfile, 将 md5sum 档案与 hashfile 档案内容比对, 验证杂凑值
是否一致 md5sum –c hashfile

###1029 一次解压多个zip文件(陈绪)
unzip "*"，注意引号不能少

###1030 看pdf文件(陈绪)
使用xpdf或者安装acrobat reader for linux

###1031 查找权限位为S的文件(陈绪)
find . -type f \( -perm -04000 -o -perm -02000 \) -exec ls -lg {} \;

###1032 装中文输入法(陈绪，hutuworm)
以redhat8为例，xwindow及其终端下的不用说了，缺省就安装了，用ctrl-space呼出。
现在讨论纯console，请到http://zhcon.sourceforge.net/下载zhcon-0.2.1.tar.gz，放在任一目录中，tar xvfz zhcon-0.2.1.tar.gz，cd zhcon-0.2.1，./configure，make，make install。安装结束，要想使用，请运行zhcon，想退出，运行exit。

###1033 把弹出的光盘收回来(beike)
#eject －t

###1034 cd光盘做成iso文件(弱智)
cp /dev/cdrom xxxx.iso

###1035 快速观看开机的硬件检测(弱智)
dmesg | more

###1036 查看硬盘的使用情况(陈绪)
df -k 以K为单位显示
df -h 以人性化单位显示，可以是b,k,m,g,t..

###1037 查看目录的大小(陈绪)
du -sh dirname
-s 仅显示总计
-h 以K、M、G为单位，提高信息的可读性。KB、MB、GB是以###1024为换算单 位， -H以###1000为换算单位。

###1038 查找或删除正在使用某文件的进程(wwwzc)
fuser filename
fuser -k filename

###1039 安装软件(陈绪)
rpm -ivh aaa.rpm
tar xvfz aaa.tar.gz; cd aaa; ./configure; make; make install

###1040 字符模式下设置/删除环境变量(陈绪)
bash下
设置：export 变量名=变量值
删除：unset 变量名
csh下
设置：setenv 变量名 变量值
删除：unsetenv 变量名

###1041 ls如何看到隐藏文件(即以.开头的文件)(双眼皮的猪)
ls -a
l. (适用于redhat)

###1042 rpm中的文件安装到哪里去了(陈绪)
rpm -qpl aaa.rpm

###1043 使用src.rpm(陈绪)
rpmbuild --rebuild *.src.rpm

###1044 vim中显示颜色或不显示颜色(陈绪，sakulagi)
首先确保安装了vim-enhanced包，然后，vi ~/.vimrc;  如果有syntax on，则显示颜色，syntax off，则不显示颜色。
另外，关于vi的syntax color，还有一点是终端类型（环境变量TERM）的设置。比如通常要设置成xterm或xterm-color才能使用syntax color。尤其是从Linux远程登陆到其他的Unix上。

###1045 linux是实时还是分时操作系统(陈绪)
分时

###1046 make bzImage -j的j是什么意思(wind521)
-j主要是用在当你的系统硬件资源比较大的时候，比较富裕的时候，用这个可以来加快编译的速度，如-j 3      

###1047 源码包怎么没有(陈绪)
你没有安装源代码，你把你光盘上rpm -i *kernel*source*.rpm装上，就可以看到你的源代码了。

###1048 修改系统时间(陈绪，laixi781211，hutuworm)
date -s “2003-04-14 cst”，cst指时区，时间设定用date -s 18:###10
修改后执行clock -w 写到CMOS
hwclock --systohc
set the hardware clock to the current system time

###1049 开机就mount上windows下的分区(陈绪)
自动将windows的d盘挂到/mnt/d上，用vi打开/etc/fstab，加入以下一行
/dev/hda5 /mnt/d vfat defaults,codepage=936,iocharset=cp936 0 0
注意，先得手工建立一个/mnt/d目录

###1050 linux怎么用这么多内存(陈绪)
为了提高系统性能和不浪费内存，linux把多的内存做了cache，以提高io速度

###1051 FSTAB 最后的配置项里边最后两个数字是什么意思(lnx3000)
第一个叫fs_freq,用来决定哪一个文件系统需要执行dump操作，0就是不需要；
第二个叫fs_passno,是系统重启时fsck程序检测磁盘的顺序号
1 是root文件系统，2 是别的文件系统。fsck按序号检测磁盘，0表示该文件系统不被检测
dump 执行ext2的文件系统的备份操作
fsck 检测和修复文件系统 

###1052 linux中让用户的密码必须有一定的长度,并且符合复杂度(eapass)
vi /etc/login.defs，改PASS_MIN_LEN

###1053 linux中的翻译软件(陈绪，hutuworm)
星际译王 xdict
console下还有个dict工具，通过DICT协议到dict.org上查11本字典，例如：dict RTFM

###1054 不让显示器休眠(陈绪)
setterm -blank 0
setterm -blank n (n为等待时间)

###1055 用dat查询昨天的日期(gadfly)
date --date='yesterday'

###1056 xwindow下如何截屏(陈绪)
Ksnapshot或者gimp

###1057 解压小全(陈绪,noclouds)
tar -I或者bunzip2命令都可以解压.bz2文件
tar xvfj example.tar.bz2
tar xvfz example.tar.gz
tar xvfz example.tgz
tar xvf example.tar
unzip example.zip
tar -jvxf some.bz，就是把tar的zvxf 改成jvxf
zip/tar rh8下有一个图形界面的软件file-roller可以做这件事。另外可以用unzip *.zip解开zip文件，unrar *.rar解开rar文件，不过unrar一般系统不自带，要到网上下载。
# rpm2cpio example.rpm │ cpio -div
# ar p example.deb data.tar.gz | tar zxf -
Alien提供了.tgz, .rpm, .slp和.deb等压缩格式之间的相互转换：
http://sourceforge.net/projects/alien
sEx提供了几乎所有可见的压缩格式的解压接口：
http://sourceforge.net/projects/sex

###1057-2 tar压缩、解压用法（platinum）
解压：x
压缩：c
针对gz：z
针对bz2：j
用于显示：v

解压实例
gz文件：tar xzvf xxx.tar.gz
bz2文件：tar xjvf xxx.tar.bz2

压缩实例
gz文件：tar czvf xxx.tar.gz /path
bz2文件：tar cjvf xxx.tar.bz2 /path

###1058 在多级目录中查找某个文件的方法(青海湖)
find /dir -name filename.ext 
du -a | grep filename.ext 
locate filename.ext

###1059 不让普通用户自己改密码(myxfc)
[root@xin_fc etc]# chmod 511 /usr/bin/passwd 
又想让普通用户自己改密码
[root@xin_fc etc]# chmod 4511 /usr/bin/passwd 

###1060 显卡实在配不上怎么办(win_bigboy)
去http://www.redflag-linux.com/ ，下了xfree86 4.3安装就可以了.

###1061 超强删除格式化工具(弱智)
比PQMagic安全的、建立删除格式化的小工具：sfdisk.exe for msdos
http://www.wushuang.net/soft/sfdisk.zip

###1062 如何让xmms播放列表里显示正确的中文(myxfc)
-*-*-*-*-*-iso8859-1,-misc-simsun-medium-r-normal--12-*-*-*-*-*-gbk-0,*-r-
把这个东西完全拷贝到你的字体里面
操作方法:
右键单击xmms播放工具的任何地方
会看到一个"选项",然后选择"功能设定"选择"fonts"
然后把上面的字体完整的拷贝到"播放清单"和 "user x font

###1063 redhat linux中播放mp3文件(hehhb)
原带的xmms不能播放MP3(无声)，要安装一个RPM包：rpm -ivh xmms-mp3-1.2.7-13.p.i386.rpm。打开xmms，ctl-p，在font栏中先在上半部的小框内打勾，再选择 “fixed(misc) gbk-0 13”号字体即可显示中文歌曲名。在音频输出插件中选择 "开放音频系统驱动程序 1.2.7 [lioOSS.so]，即可正常播放MP3文件。

###1064 安装中文字体(hehhb)
先下载 http://freshair.netchina.com.cn/~George/sm.sh
(参考文献: http://www.linuxeden.com/edu/doctext.php?docid=2679)
SimSun18030.ttc在微软网站可下载，http://www.microsoft.com/china/windows2000/downloads/18
030.asp　它是个msi文件，在 mswindows中安装用的，装好后在windows目录下的fonts
目录里面就可以找到它。把simsun.ttc，SimSun18030.ttc，tahoma.ttf，tahomabd.ttf
拷贝到/usr/local/temp，然后下载的shell文件也放到这个目录里，然后打开终端
cd /usr/local/temp
chmod 755 sm.sh
./sm.sh

###1065 装载windows分区的FAT32、FAT16文件系统(hehhb，NetDC)
以root身份进入KDE，点击桌面上的“起点”图标，在/mnt目录下建立如下文件夹：c,d,e,f,g,usb.分别用作windows下各分区和usb闪盘。
用文本编辑器打开/etc/fstab 文件.加入如下:
/dev/hda1 /mnt/c vfat iocharset=gb2312,umask=0,codepage=936 0 0
/dev/hda5 /mnt/d vfat iocharset=gb2312,umask=0,codepage=936 0 0
/dev/hda6 /mnt/e vfat iocharset=gb2312,umask=0,codepage=936 0 0
/dev/hda7 /mnt/f vfat iocharset=gb2312,umask=0,codepage=936 0 0
/dev/hda8 /mnt/g vfat iocharset=gb2312,umask=0,codepage=936 0 0
/dev/cdrom /mnt/cdrom udf,iso9660 noauto,iocharset=gb2312,owner,kudzu,ro 0 0
/dev/sda1 /mnt/usb vfat iocharset=gb2312,umask=0,codepage=936 0 0
存盘退出. 重新启动后即可正常访问FAT32或FAT16格式分区,解决显示WINDOWS分区下和光盘中文文件名乱码
问题。其中共六列，每列用Tab键分开。注意此方法只能mount上Fat 分区格式，sda1是闪盘。
另外，如果还出现乱码，可以改为iocharset=utf8。 

###1066 在X下使用五笔和拼音,区位输入法(hmkart)
从http://www.fcitx.org/上下载fcitx的rpm包安装即可

###1067 在Linux下如何解压rar文件(hmkart)
http://www.linuxeden.com/download/softdetail.php?softid=883
下载rar for Linux 3.2.0，解压开后make
然后可以用unrar e youfilename.rar解压rar文件

###1068 硬盘安装后怎么添加/删除rpm包(sakulagi)
redhat-config-packages --isodir=<PATH>
可以指定iso文件所在的目录

###1069 字符下控制音量(grub007，天外闲云)
使用aumix。另外，要保存oss的音量大小，步骤为：
1、用aumix将音量调整为你们满意的音量
2、用root用户进入/usr/lib/oss下(oss的默认安装目录)
3、执行./savemixer ./mixer.map
4、ok，以后oss开启之后就是你在第一步调整的音量了。
ps:阅读该目录下的README可以得到更多的有用信息。

###1070 用dd做iso(grub007)
dd if=/dev/cdrom of=/tmp/aaa.iso

###1071 删除几天以前的所有东西(包括目录名和目录中的文件)(shally5)
find . -ctime +3 -exec rm -rf {} \;
或
find ./ -mtime +3 -print|xargs rm -f -r

###1072 用户的crontab在哪里(hutuworm)
/var/spool/cron/下以用户名命名的文件

###1073 以不同的用户身份运行程序(陈绪)
su - username -c "/path/to/command"
有时候需要运行特殊身份的程序, 就可以让su来做

###1074 如何清空一个文件(陈绪)
> filename

###1075 为什么OpenOffice下不能显示中文(allen1970)
更改字体设置
tools->options->font replacement
Andale Sans UI -> simsun

###1076 如何备份Linux系统(Purge)
Symantec Ghost 7.5以后的版本支持Ext3 native复制 

###1077 linux上的partition magic(wwwzc)
Linux下一个有用的分区工具: parted
可以实时修改分区大小, 删除/建立分区.     

###1078 /proc/sys/sem中每项代表什么意思? (sakulagi)
/proc/sys/sem内容如下
250 32000 32 128
这4个参数依次为SEMMSL(每个用户拥有信号量最大数量),SEMMNS(系统信号量最大数量),SEMOPM(每次semop系统调用操作数),SEMMNI(系统信号量集最大数量) 

###1079 Grub 引导菜单里 bigmem smp up 都是什么意思？(lnx3000)
smp: （symmetric multiple processor）对称多处理器模式
bigmem: 支持1G 以上内存的优化内核
up:（Uni processor） 单处理器的模式

###1080 Oracle的安装程序为什么显示乱码？(lnx3000)
现在Oracle的安装程序对中文的支持有问题，只能使用英文界面来安装，在执行runinstaller之前，执行：export LANG=C;export LC_ALL=C     

###1081 linux下文件和目录的颜色代表什么(sakulagi,弱智)
蓝色表示目录；绿色表示可执行文件；红色表示压缩文件；浅蓝
色表示链接文件；灰色表示其它文件；红色闪烁表示链接的文件有问题了；黄色是设备文件，包括block, char, fifo。
用dircolors -p看到缺省的颜色设置，包括各种颜色和“粗体”，下划线，闪烁等定义。     

###1082 查看有多少活动httpd的脚本(陈绪)
#!/bin/sh
while (true)
do
pstree |grep "*\[httpd\]$"|sed 's/.*-\([0-9][0-9]*\)\*\[httpd\]$/\1/'
sleep 3
done

###1083 如何新增一块硬盘(好好先生)
一、关机，物理连接硬盘
如果是IDE硬盘，注意主、从盘的设置；如果是SCSI硬盘，注意选择一个没有被使用的ID号。
二、开机，检查硬盘有没有被linux检测到
dmesg |grep hd*(ide硬盘)
dmesg |grep sd*(SCSI硬盘)
或者 less /var/log/dmesg
如果你没有检测到你的新硬盘，重启，检查连线，看看bios有没有认出它来。
三、分区
你可以使用fdisk，Sfdisk或者parted（GNU分区工具,linux下的partition magic)
四、格式化
mkfs
五、修改fstab
vi /etc/fstab

###1084 linux下怎么看分区的卷标啊 (q1208c)
e2label /dev/hdxn, where x=a,b,c,d....; n=1,2,3...     

###1085 RH8,9中安装后如何添加新的语言包(好好先生)
一.8.0中
1.放入第一张光盘
2.cd /mnt/cdrom/Redhat/RPMS
3.rpm -ivh ttfonts-ZH_CN-2.11-29.noarch.rpm(简体中文,你可以用tab键来补齐后面的部分,以免输入有误)
4.rpm -ivh ttfonts-ZH_TW-2.11-15.noarch.rpm(繁体中文)
如果你还想装日文、韩文,试试第二张光盘上的ttfonts*.rpm.
二.9.0中
9.0不在第一张盘上,在第三张盘上.rpm包名分别为:
ttfonts-zh_CN-2.12-1.noarch.rpm(简体中文)
ttfonts-zh_TW-2.11-19.noarch.rpm (繁体中文)

###1086 终端下抓屏(tsgx)
cat /dev/vcsX >screenshot 其中，X表示第X个终端
还可以运行script screen.log，记录屏幕信息到screen.log里。一会记录到你exit为此。这也是抓屏的好方法。
这是在debian的cookbook上看到的。在RH9上能用。没有在其它的系统上测试过。

###1087 让一个程序在退出登陆后继续运行(NetDC，双眼皮的猪)
#nohup 程序名 &
或者使用disown命令也可以

###1088 man命令不在路径中，如何查看非标准的man文件(陈绪)
nroff -man /usr/man/man1/cscope.1 | more

###1089 cp时显示进度(陈绪)
cp -r -v dir1 dir2
cp -a -d -v dir1 dir2

###1090 编辑/etc/inittab后直接生效(陈绪)
#init q

###1091 让linux连续执行几个命令，出错停止(陈绪)
command1 && command2 && command3

###1092 如何将grub安装到mbr(陈绪, NetDC)
grub> root (hd0, 0)
grub> setup (hd0)
也可以用#grub-install /dev/hda来安装grub。

###1093 安装时把grub(lilo)写到linux分区的引导区还是主引导扇区(MBR)(陈绪)
如果你想电脑一启动就直接进入操作系统启动菜单就把grub(lilo)写到MBR上，如果写到linux分区的引导区则要用引导盘引导。建议写到 MBR，方便点，至于说写到MBR不安全，该怎么解释呢？每装一次win98，MBR都会被修改一次，大家觉得有什么不安全的吗？

###1094 如何让多系统共存(陈绪)
98系统的话用lilo(grub)引导，2k/nt则使用osloader引导多系统

###1095 如何在图形界面和控制台（字符界面）之间来回切换(陈绪)
a.图形界面到控制台：Ctr+Alt+Fn(n=1,2,3,4,5,6)。
b.各控制台之间切换：Alt+Fn(n=1,2,3,4,5,6)。
c.控制台到图形：Alt+F7

###1096 Redhat linux常用的命令(陈绪)
<1>ls：列目录。
用法：ls或ls dirName，参数：-a显示所有文件，-l详细列出文件。
<2>mkdir：建目录。
用法：mkdir dirName，参数：-p建多级目录，如：mkdir a/b/c/d/e/f -p
<3>mount：挂载分区或镜像文件(.iso,.img)文件。
用法：
a.磁盘分区：mount deviceName mountPoint -o options，其中deviceName是磁盘分区的设备名，比如/dev/hda1,/dev/cdrom,/dev/fd0，mountPoint 是挂载点，它是一个目录，options是参数，如果分区是linux分区，一般不用-o options，如果是windows分区那options可以是iocharset=cp936，这样windows分区里的中文文件名就能显示出来了。用例：比如/dev/hda5是linux分区，我要把它挂到目录a上（如没目录a那就先mkdir a），mount /dev/hda5 a，这样目录a里的东西就是分区hda5里的东西了，比如hda1是windows分区，要把它挂到b上，mount /dev/hda1 b -o iocharset=cp936。
b.镜像文件：mount fileName mountPoint -o loop，fileName是镜像文件名(*.iso,*.img)，其它的不用说了，跟上面一样。用例：如我有一个a.iso光盘镜像文件，mount a.iso a -o loop，这样进入目录a你就能浏览a.iso的内容了，*.img文件的用法一样。
<4>find：查找文件。
用法：find inDir -name filename，inDir是你要在哪个目录找，filename是你要找的文件名(可以用通配符)，用通配符时filename最好用单引号引起来，否则有时会出错，用例：find . -name test*，在当前目录查找以test开头的文件。
<5>grep：在文件里查找指定的字符串。
用法：grep string filename，在filename(可用通配符)里查找string(最好用双引号引起来)。参数：-r在所有子目录里的filename里找。用例：grep hello *.c -r在当前目录下（包括子目录）的所有.c文件里查找hello。
<5>vi：编辑器。
用法：vi filename。filename就是你要编辑的文本文件。用了执行vi filename后，你可能会发现你无法编辑文本内容，不要着急，这是因为vi还没进入编辑状态，按a或i就可以进入编辑状态了，进入编辑状态后你就可以编辑文本了。要退出编辑状态按Esc键就可以了。以下操作均要在非编辑状态下。查找文本：输入/和你要查找的文本并回车。退出：输入: 和q并回车，如果你修改了文本，那么你要用:q!回车才能退出。保存：输入: w回车，如果是只读文件要用: w!。保存退出：输入: wq回车，如果是只读就: wq!回车。取消：按u就可以了，按一次就取消一步，可按多次取消多步。复制粘贴一行文本：把光标移到要复制的行上的任何地方，按yy（就是连按两次 y），把光标移到要粘贴地方的上一行，按p，刚才那行文本就会被插入到光标所在行的下一行，原来光标所在行后面所有行会自动下移一行。复制粘贴多行文本：跟复制一行差不多，只是yy改成先输入要复制的行数紧接着按yy，后面的操作一样。把光标移到指定行：输入:和行号并回车，比如移到123行:123回车，移到结尾:$回车。

###1097 linux文本界面下如何关闭pc喇叭(labrun)
将/etc/inputrc中的set bell-style none 前的＃去掉，或echo "set bell-style none" >> ~/.bashrc

###1098 重装windows导致linux不能引导的解决办法(好好先生)
如果没有重新分区，拿linux启动盘(或者第一张安装光盘)引导，进入rescue模式。首先找到原来的/分区mount在什么地方。redhat通常是/mnt/sysimage. 执行"chroot /mnt/sysimage". 如果是grub，输入grub-install /dev/hd*(根据实际情况)；如果是lilo，输入lilo -v，然后重新启动。如果分区有所改变，对应修改/etc/lilo.conf和/boot/grub/grub.conf然后再执行上述命令。

###1099 为什么装了LINUX后win2K很慢(lnx3000，好好先生)
老问题了，你在2000是不是能看见Linux的逻辑盘，但不能访问？
在磁盘管理里，选中这个盘，右击->更改"驱动器名和路径"->"删除"就可以了，注意不是删除这个盘!

###1100 将linux发布版的iso文件刻录到光盘的方法(陈绪)
借用windows中的nero软件，选择映象文件刻录，选择iso文件，刻录即可！