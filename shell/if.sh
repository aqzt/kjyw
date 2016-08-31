#!/bin/bash
## if  2016-07-21
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

if [ $b -gt 0 -o $c -gt 0 -a $a -gt 0 ]; then
echo test
fi
#对shell中的关系运算符说明如下：
#-gt 表示greater than,大于
#-lt 表示less than,小于
#-eq 表示 equal,等于
#对shell中的连接符说明如下：
#-a 表示 and,且
#-o 表示 or,或 
#也可以写成这样：
if [ $b -gt 0 ] || [ $c -gt 0 ] && [ $a -gt 0 ]; then
echo test
fi
#其中,&&表示and,||表示or


#文件表达式
if [ -f  file ]    #如果文件存在
if [ -d ...   ]    #如果目录存在
if [ -s file  ]    #如果文件存在且非空 
if [ -r file  ]    #如果文件存在且可读
if [ -w file  ]    #如果文件存在且可写
if [ -x file  ]    #如果文件存在且可执行   

#整数变量表达式
if [ int1 -eq int2 ]    #如果int1等于int2   
if [ int1 -ne int2 ]    #如果不等于    
if [ int1 -ge int2 ]      # 如果>=
if [ int1 -gt int2 ]      # 如果>
if [ int1 -le int2 ]      # 如果<=
if [ int1 -lt int2 ]      # 如果<

if [ "$check" == "" ];then
    echo ${line}
else
    echo 111
fi