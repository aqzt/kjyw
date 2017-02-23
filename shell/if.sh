#!/bin/bash
## if  2016-07-21
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

#–b 当file存在并且是块文件时返回真
#-c 当file存在并且是字符文件时返回真
#-d 当pathname存在并且是一个目录时返回真
#-e 当pathname指定的文件或目录存在时返回真
#-f 当file存在并且是正规文件时返回真
#-g 当由pathname指定的文件或目录存在并且设置了SGID位时返回为真
#-h 当file存在并且是符号链接文件时返回真，该选项在一些老系统上无效
#-k 当由pathname指定的文件或目录存在并且设置了“粘滞”位时返回真
#-p 当file存在并且是命令管道时返回为真
#-r 当由pathname指定的文件或目录存在并且可读时返回为真
#-s 当file存在文件大小大于0时返回真
#-u 当由pathname指定的文件或目录存在并且设置了SUID位时返回真
#-w 当由pathname指定的文件或目录存在并且可执行时返回真。一个目录为了它的内容被访问必然是可执行的。
#-o 当由pathname指定的文件或目录存在并且被子当前进程的有效用户ID所指定的用户拥有时返回真。

#Bash Shell 里面比较字符写法：
#-eq 等于
#-ne 不等于
#-gt 大于
#-lt 小于
#-le 小于等于
#-ge 大于等于
#-z 空串
#= 两个字符相等
#!= 两个字符不等
#-n 非空串

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

##注释多行方法
if false; then
 echo "ni"
 echo "ni"
 echo "ni"
fi

##判断进程是否运行，运行就KILL掉，注意grep -v sh| grep -v grep
var=`ps -aef | grep $1 | grep -v sh| grep -v grep| awk '{print $2}'`
if [ !-z "$var"]
then
  echo $1 process is not running 
else
  kill -9 $var
  echo $1 process killed forcefully, process id $var.
fi


#查看指定进程是否存在
#在获取到 pid 之后，还可以根据 pid 查看对应的进程是否存在（运行），这个方法也可以用于 kill 指定的进程。
if ps -p $PID > /dev/null
then
   echo "$PID is running"
   # Do something knowing the pid exists, i.e. the process with $PID is running
fi

#查pid循环KILL
pids=( $(pgrep -f resque) )
for pid in "${pids[@]}"; do
  if [[ $pid != $$ ]]; then
    kill "$pid"
  fi
done
