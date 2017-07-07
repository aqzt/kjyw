#!/bin/bash
## rsync限速  2016-07-14
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6
##dd命令使用详解

1.命令简介 
dd 的主要选项：

指定数字的地方若以下列字符结尾乘以相应的数字:

b=512, c=1, k=1024, w=2, xm=number m

if=file #输入文件名，缺省为标准输入。 
of=file #输出文件名，缺省为标准输出。 
ibs=bytes #一次读入 bytes 个字节(即一个块大小为 bytes 个字节)。 
obs=bytes #一次写 bytes 个字节(即一个块大小为 bytes 个字节)。 
bs=bytes #同时设置读写块的大小为 bytes ，可代替 ibs 和 obs 。 
cbs=bytes #一次转换 bytes 个字节，即转换缓冲区大小。 
skip=blocks #从输入文件开头跳过 blocks 个块后再开始复制。 
seek=blocks #从输出文件开头跳过 blocks 个块后再开始复制。(通常只有当输出文件是磁盘或磁带时才有效)。 
count=blocks #仅拷贝 blocks 个块，块大小等于 ibs 指定的字节数。 
conv=conversion[,conversion...] #用指定的参数转换文件。

 

转换参数: 
ascii 转换 EBCDIC 为 ASCII。 
ebcdic 转换 ASCII 为 EBCDIC。 
ibm 转换 ASCII 为 alternate EBCDIC. 
block 把每一行转换为长度为 cbs 的记录，不足部分用空格填充。 
unblock 使每一行的长度都为 cbs ，不足部分用空格填充。 
lcase 把大写字符转换为小写字符。 
ucase 把小写字符转换为大写字符。 
swab 交换输入的每对字节。 
noerror 出错时不停止。 
notrunc 不截短输出文件。 
sync 把每个输入块填充到ibs个字节，不足部分用空(NUL)字符补齐。

2.实例分析 
2.1.数据备份与恢复

2.1.1整盘数据备份与恢复

备份： 
dd if=/dev/hdx of=/dev/hdy #将本地的/dev/hdx整盘备份到/dev/hdy 
dd if=/dev/hdx of=/path/to/image #将/dev/hdx全盘数据备份到指定路径的image文件 
dd if=/dev/hdx | gzip >/path/to/image.gz 
#备份/dev/hdx全盘数据，并利用gzip工具进行压缩，保存到指定路径

恢复：

dd if=/path/to/image of=/dev/hdx #将备份文件恢复到指定盘 
gzip -dc /path/to/image.gz | dd of=/dev/hdx #将压缩的备份文件恢复到指定盘

2.1.2.利用netcat远程备份 
dd if=/dev/hda bs=16065b | netcat < targethost-IP > 1234 #在源主机上执行此命令备份/dev/hda

netcat -l -p 1234 | dd of=/dev/hdc bs=16065b #在目的主机上执行此命令来接收数据并写入/dev/hdc

netcat -l -p 1234 | bzip2 > partition.img 
netcat -l -p 1234 | gzip > partition.img 
#以上两条指令是目的主机指令的变化分别采用bzip2 gzip对数据进行压缩，并将备份文件保存在当前目录。

2.1.3.备份MBR 
备份： dd if=/dev/hdx of=/path/to/image count=1 bs=512 
备份磁盘开始的512Byte大小的MBR信息到指定文件

恢复： dd if=/path/to/image of=/dev/hdx 
将备份的MBR信息写到磁盘开始部分

2.1.4.备份软盘 
dd if=/dev/fd0 of=disk.img count=1 bs=1440k 
将软驱数据备份到当前目录的disk.img文件

2.1.5.拷贝内存资料到硬盘 
dd if=/dev/mem of=/root/mem.bin bs=1024 
将内存里的数据拷贝到root目录下的mem.bin文件

2.1.6.从光盘拷贝iso镜像 
dd if=/dev/cdrom of=/root/cd.iso 
拷贝光盘数据到root文件夹下，并保存为cd.iso文件

2.2.增加Swap分区文件大小 
dd if=/dev/zero of=/swapfile bs=1024 count=262144 #创建一个足够大的文件（此处为256M） 
mkswap /swapfile #把这个文件变成swap文件 
swapon /swapfile #启用这个swap文件 
/swapfile swap swap defaults 0 0 #在每次开机的时候自动加载swap文件, 需要在 /etc/fstab 文件中增加一行

2.3.销毁磁盘数据 
dd if=/dev/urandom of=/dev/hda1 
利用随机的数据填充硬盘，在某些必要的场合可以用来销毁数据。执行此操作以后，/dev/hda1将无法挂载，创建和拷贝操作无法执行。

2.4.磁盘管理

2.4.1.得到最恰当的block size 
dd if=/dev/zero bs=1024 count=1000000 of=/root/1Gb.file 
dd if=/dev/zero bs=2048 count=500000 of=/root/1Gb.file 
dd if=/dev/zero bs=4096 count=250000 of=/root/1Gb.file 
dd if=/dev/zero bs=8192 count=125000 of=/root/1Gb.file 
通过比较dd指令输出中所显示的命令执行时间，即可确定系统最佳的block size大小

2.4.2测试硬盘读写速度 
dd if=/root/1Gb.file bs=64k | dd of=/dev/null 
dd if=/dev/zero of=/root/1Gb.file bs=1024 count=1000000 
#通过上两个命令输出的执行时间，可以计算出测试硬盘的读／写速度
#数据传输时间 Ttransfer是指完成传输所请求的数据所需要的时间，它取决于数据传输率，其值等于数据大小除以数据传输率。目前IDE/ATA能达到133MB/s，SATA II可达到300MB/s的接口数据传输率，数据传输时间通常远小于前两部分消耗时间。简单计算时可忽略。
#测/data目录所在磁盘的纯写速度：
time dd if=/dev/zero of=/data/1Gb.file bs=8k count=1000000

#测/data目录所在磁盘的纯读速度：
time dd if=/data/1Gb.file of=/dev/null bs=8k count=1000000

#测读写速度：
time dd if=/data/1Gb.file of=/tmp/test bs=8k count=1000000


2.4.3.修复硬盘 
dd if=/dev/sda of=/dev/sda 
当硬盘较长时间（比如1，2年）放置不使用后，磁盘上会产生magnetic flux point。当磁头读到这些区域时会遇到困难，并可能导致I/O错误。当这种情况影响到硬盘的第一个扇区时，可能导致硬盘报废。上边的命令有可能使这些数据起死回生。且这个过程是安全，高效的。