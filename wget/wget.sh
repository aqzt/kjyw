#!/bin/bash
## storm 2016-06-28
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6
##wget实现断点下载整个文件目录

wget -t 0 -T 120 -np -c -r http://xxx.xxx.com/xxx
wget -t 0 -T 120 -np -c -r ftp://xxx:xxx@xxx.com/xxx
#其中“np”表示不跟随链接，只下载指定目录及子目录里的文件；-c 表示启动断点续传，其实下目录及子目录有-r就可以，
#简略就用映像用的-m参数，即：
wget -m -np http://xxx.xxx.com/xxx
wget -m -np ftp://xxx:xxx@xxx.com/xxx

#下载下载192.168.1.168首页并且显示下载信息Linux 
wget -d http://192.168.1.168
#下载192.168.1.168首页并且不显示任何信息
wget -q http://192.168.1.168
#下载filelist.txt中所包含的链接的所有文件
wget -i filelist.txt
#下载到指定目录,把文件file下载到/tmp目录下。
wget -P/tmp ftp://user:passwd@url/file

wget -r -np -nd http://example.com/packages/
#这条命令可以下载 http://example.com 网站上 packages 目录中的所有文件。其中，-np 的作用是不遍历父目录，-nd 表示不在本机重新创建目录结构。
wget -r -np -nd --accept=iso http://example.com/centos-5/i386/
#与上一条命令相似，但多加了一个 --accept=iso 选项，这指示Linux wget仅下载 i386 目录中所有扩展名为 iso 的文件。你也可以指定多个扩展名，只需用逗号分隔即可。
wget -i filename.txt
#此命令常用于批量下载的情形，把所有需要下载文件的地址放到 filename.txt 中，然后 Linux wget就会自动为你下载所有文件了。
wget -c http://example.com/really-big-file.iso
#这里所指定的 -c 选项的作用为断点续传。
wget -m -k (-H) http://www.example.com/
#该命令可用来镜像一个网站，Linux wget将对链接进行转换。如果网站中的图像是放在另外的站点，那么可以使用 -H 选项。

#下载某站点目录和子目录文件
wget -t 0 -T 120 -np -c -r --restrict-file-names=ascii  http://xxx.com/shell

#转换文件名乱码
python  rename.py -i utf-8 -o gbk -p /root/111 -u