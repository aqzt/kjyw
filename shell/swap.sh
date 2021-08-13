#!/bin/sh

#注释：of=/home/swap,放置swap的空间; count的大小就是增加的swap空间的大小，1024就是块大小，这里是1K，所以总共空间就是bs*count=1000M
dd if=/dev/zero of=/root/swap bs=1024 count=1000000

#注释：把刚才空间格式化成swap各式
mkswap /root/swap

#注释：使刚才创建的swap空间
swapon /root/swap

#关闭swap
#swapoff