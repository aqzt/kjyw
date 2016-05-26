#!/bin/bash
## gitlab_rpm 2016-05-16
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

##sed去除注释行
sed -i -c -e '/^#/d' config_file

##sed去除空行
sed -i -c -e '/^$/d' config_file

##sed去空行和注释行
sed -i -c -e '/^$/d;/^#/' config_file

##在某字符串下面一行增加一字符串
sed -i '/fastcgi_path_info/a\fastcgi_param ENV_VAR_MY test;' test*.conf



##替换某些后缀文件中的字符
sed -i "s/text_to_replace/replacement/g" `find . -type f -name <filename>`
sed -i "s/10.0.0.75/10.0.0.76/g" `find . -type f -name "*.properties"`
sed -i "s/10.0.0.18/10.0.0.17/g" `find . -type f -name "*.properties"`
sed -i "s/10.0.0.16/10.0.0.17/g" `find . -type f -name "*.php"`
sed -i "s/d12/111222/g" `find . -type f -name "*.properties"`