#!/bin/bash
## 内存排查命令
## http://www.aqzt.com
## 有问题可以反馈 https://aq2.cn/ 
## centos 6和centos 7

# 查内存占用情况
ps -e -o 'pid,comm,args,pcpu,rsz,vsz,stime,user,uid'
# 其中rsz是是实际内存
ps -e -o 'pid,comm,args,pcpu,rsz,vsz,stime,user,uid' | grep java | sort -nrk5
# 其中rsz为实际内存，上例实现按内存排序，由大到小

# 查内存占用情况
ps -aux | sort -k4nr | head -n 10

# 使用指令查看占用的物理内存，
ps aux|awk '{sum+=$6} END {print sum/1024}'

# 使用指令，核实进程的最大使用内存量
ps -eo pid,rss,pmem,pcpu,vsz,args --sort=rss

# 查内存命令
ps p 916 -L -o pcpu,pmem,pid,tid,time,tname,cmd

# 排查高CPU占用介绍的PS命令
ps -mp 9004 -o THREAD,tid,time,rss,size,%mem

# 分析具体的对象数目和占用内存大小
jmap -histo:live [pid]

# 利用MAT工具分析是否存在内存泄漏等等。
jmap -dump:live,format=b,file=xxx.xxx [pid]

# 可以根据进程查看进程相关信息占用的内存情况：
pmap -d 14596

# 常用
free -m