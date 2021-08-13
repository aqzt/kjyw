#!/bin/bash
## gitlab_rpm 2016-05-16
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

##查文件从32994到34871行内容
sed -n '32994,34871p'  config_file

##删除文件从32994到34871行内容
sed '32994,34871 d' config_file

##替换文件中performance_schema改为performance_schema_bak
sed -i "s/performance_schema/performance_schema_bak/g" config_file

##sed去除注释行
sed -i -c -e '/^#/d' config_file

##sed去除空行
sed -i -c -e '/^$/d' config_file

##sed去空行和注释行
sed -i -c -e '/^$/d;/^#/' config_file

##在某字符串下面一行增加一字符串
sed -i '/fastcgi_path_info/a\fastcgi_param ENV_VAR_MY test;' test*.conf

#假设处理的文本为test.file
#在每行的头添加字符，比如"HEAD"，命令如下：
sed 's/^/HEAD&/g' test.file

#在每行的行尾添加字符，比如“TAIL”，命令如下：
sed 's/$/&TAIL/g' test.file

##替换某些后缀文件中的字符
sed -i "s/text_to_replace/replacement/g" `find . -type f -name <filename>`
sed -i "s/10.0.0.75/10.0.0.76/g" `find . -type f -name "*.properties"`
sed -i "s/10.0.0.18/10.0.0.17/g" `find . -type f -name "*.properties"`
sed -i "s/10.0.0.16/10.0.0.17/g" `find . -type f -name "*.php"`
sed -i "s/d12/111222/g" `find . -type f -name "*.properties"`

#sed删除文件倒数10行
#把文件倒序
sed -i '1!G;$!h;$!d' filename  
#删除10行
sed -i '1,10d' filename     
#把文件倒序回来  
sed -i '1!G;$!h;$!d' filename  

nl file | tail -n 10 | awk 'NR == 1 '{print $1}' 

awk 'BEGIN{CMD="wc -l file";CMD|getline i}NR<=(i-10)' file
sed -n ':a;1,10!{P;N;D;};N;ba' file

