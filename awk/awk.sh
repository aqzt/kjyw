#!/bin/bash
## gitlab_rpm 2016-05-16
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

##提取两个文件第一列相同的行
awk -F',' 'NR==FNR{a[$1]=$0;next}NR>FNR{if($1 in a)print $0"\n"a[$1]}' 1.log 2.log

awk 'NR==FNR{a[$1]++}NR>FNR&&a[$1]>1' 111.txt 111.txt

awk 'a[$1]++==1' 

cat 111.txt | awk -F '[:|]' '{print $2}' > 111.txt
