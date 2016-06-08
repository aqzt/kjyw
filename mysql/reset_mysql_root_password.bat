::WIN MYSQL  密码重置脚本
::## http://www.aqzt.com
::##email: ppabc@qq.com
::##robert yu
@title MySQL
@echo off
@color 0a
set passwd=%RANDOM%@%RANDOM%
echo %passwd%>C:\mysqlpass.txt
echo use MySQL;>C:\mysql.txt
echo update user set password=password('%passwd%') where user="root";>>C:\mysql.txt
echo flush privileges; >>C:\mysql.txt
net stop MySQL >nul
cd /d "C:\webserver\MYSQL\bin\"
start mysqld.exe --skip-grant-tables
mysql.exe <C:\mysql.txt
del C:\mysql.txt /f
taskkill /f /im mysqld.exe >nul
net start MySQL >nul
del %0
