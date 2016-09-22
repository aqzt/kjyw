#!/bin/bash
## pigz  2016-09-22
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6
## 

###yum install pigz
wget http://zlib.net/pigz/pigz-2.3.3.tar.gz

tar zxvf pigz-2.3.3.tar.gz
cd pigz-2.3.3
make
cp pigz /usr/local/bin/
cp unpigz /usr/local/bin/

#压缩：
#tar cvf - 目录名 | pigz -9 -p 24 > file.tgz
# -c 表示打印到标准输出std，如果没有-c选项，则会生成一个后缀为gz的压缩文件。
#pigz -c file > file.gz
# -k 表示压缩后不删除源文件
#pigz -k file

#–blocksize mmm 设置压缩块block的大小，默认为128kb
#-0 to -9, -11 : 压缩级别，值越大，压缩率越高，当然耗费的时间也就越长
#-p n : 指定压缩核心数，默认8个
#-k :压缩后保留原文件

#pigz -6 -p 10 -k filename
#压缩后生成 filename.gz文件

#压缩目录
#tar cv filename | pigz -6 -p 10 -k > filename.tar.gz

#解压:
#Usage: pigz [options] [files ...]

#解压文件
#gzip -d filename.gz
#或者
#pigz -d filename.gz

#解压目录
#tar xvf filename.tar.gz
#或者
#pigz -d filename.tar.gz