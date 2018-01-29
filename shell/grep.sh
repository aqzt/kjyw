#!/bin/bash
## grep  2016-12-19
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6

##cat是用于查看普通文件的。
cat /etc/passwd

##zcat 是用于查看压缩的文件 
##gzip 套件包含许多可以 “在原地” 处理压缩文件的实用程序。zcat、zgrep、zless、zdiff 等实用程序的作用分别与 cat、grep、less 和 diff 相同，但是它们操作压缩的文件。
zcat web.log.gz | grep aqzt.com | head
 
###Grep 'OR' 或操作
grep "pattern1\|pattern2" file.txt
grep -E "pattern1|pattern2" file.txt
grep -e pattern1 -e pattern2 file.txt
egrep "pattern1|pattern2" file.txt

awk '/pattern1|pattern2/' file.txt
sed -e '/pattern1/b' -e '/pattern2/b' -e d file.txt

#找出文件（filename）中包含123或者包含abc的行
grep -E '123|abc' filename 
#用egrep同样可以实现
egrep '123|abc' filename 
#awk 的实现方式
awk '/123|abc/' filename 

###Grep 'AND'  与操作
grep -E 'pattern1.*pattern2' file.txt # in that order
grep -E 'pattern1.*pattern2|pattern2.*pattern1' file.txt # in any order
grep 'pattern1' file.txt | grep 'pattern2' # in any order

awk '/pattern1.*pattern2/' file.txt # in that order
awk '/pattern1/ && /pattern2/' file.txt # in any order
sed '/pattern1.*pattern2/!d' file.txt # in that order
sed '/pattern1/!d; /pattern2/!d' file.txt # in any order

#显示既匹配 pattern1 又匹配 pattern2 的行。
grep pattern1 files | grep pattern2 

###Grep 'NOT' 
grep -v 'pattern1' file.txt
awk '!/pattern1/' file.txt
sed -n '/pattern1/!p' file.txt

##删除两个文件相同部分
grep -v -f file1 file2 && grep -v -f file2 file1 

##计算并集
sort -u a.txt b.txt

##计算交集
grep -F -f a.txt b.txt | sort | uniq

##计算差集
grep -F -v -f b.txt a.txt | sort | uniq

sort a b b | uniq -u  
#a b 排序，两个的交集出现次就是2 了，a b b 再排序。b里面的次数，最少是2了，交集里面的是3
然后再uniq -u 取出现一次的，就是想要的结果了

##删除两个文件相同部分  实用comm
comm -3 file1 file2

##删除两个文件相同部分  使用awk
awk '{print NR, $0}' file1 file2 |sort -k2|uniq -u -f 1|sort -k1|awk '{print $2}'
##或者：
awk '{print $0}' file1 file2 |sort|uniq -u

##其他操作
#不区分大小写地搜索。默认情况区分大小写，
grep -i pattern files 
#只列出匹配的文件名，
grep -l pattern files 
#列出不匹配的文件名，
grep -L pattern files 
#只匹配整个单词，而不是字符串的一部分（如匹配‘magic’，而不是‘magical’），
grep -w pattern files 
#匹配的上下文分别显示[number]行，
grep -C number pattern files 

#grep -A ：显示匹配行和之后的几行
#-A -B -C 后面都跟阿拉伯数字，-A是显示匹配后和它后面的n行。-B是显示匹配行和它前面的n行。-C是匹配行和它前后各n行。总体来说，-C覆盖面最大。
grep -A 5 wikipedia files.txt
















