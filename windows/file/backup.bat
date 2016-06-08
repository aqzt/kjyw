::WIN 文件 备份 脚本
::## http://www.aqzt.com
::##email: ppabc@qq.com
::##robert yu
@title MySQL
@echo off
@@echo off
set d=%date:~0,4%%date:~5,2%%date:~8,2%
cd C:\Windows\SysWOW64
::把本地D:\test文件复制备份到\\192.168.10.111\test目录
RoboCopy.exe /E D:\test \\192.168.10.111\test
echo %d% test copy finish >>  D:\copy_log.txt
